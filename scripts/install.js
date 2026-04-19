#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const https = require("https");

const REPO = "msdakot/ai-foundary";
const BRANCH = "main";
const RAW_BASE = `https://raw.githubusercontent.com/${REPO}/${BRANCH}`;
const API_BASE = `https://api.github.com/repos/${REPO}/contents`;

const registry = require("./registry.json");

const [, , command, type, name] = process.argv;

function usage() {
  console.log(`
Usage:
  npx ai-foundry list
  npx ai-foundry add <type> <name>

Types: skill, agent, plugin, context

Examples:
  npx ai-foundry list
  npx ai-foundry add skill codeassist-guardrails
`);
  process.exit(1);
}

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, { headers: { "User-Agent": "ai-foundry-installer" } }, (res) => {
        let data = "";
        res.on("data", (chunk) => (data += chunk));
        res.on("end", () => {
          try {
            resolve(JSON.parse(data));
          } catch {
            reject(new Error(`Failed to parse response from ${url}`));
          }
        });
      })
      .on("error", reject);
  });
}

function fetchFile(url, dest) {
  return new Promise((resolve, reject) => {
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    const file = fs.createWriteStream(dest);
    https
      .get(url, { headers: { "User-Agent": "ai-foundry-installer" } }, (res) => {
        res.pipe(file);
        file.on("finish", () => file.close(resolve));
      })
      .on("error", reject);
  });
}

async function downloadDir(apiPath, localDir) {
  const items = await fetchJson(`${API_BASE}/${apiPath}?ref=${BRANCH}`);
  if (!Array.isArray(items)) throw new Error(`Unexpected response for ${apiPath}`);
  for (const item of items) {
    const dest = path.join(localDir, item.name);
    if (item.type === "dir") {
      await downloadDir(item.path, dest);
    } else {
      await fetchFile(`${RAW_BASE}/${item.path}`, dest);
    }
  }
}

function updateSettings(installPath) {
  const settingsPath = path.join(process.cwd(), ".claude", "settings.json");
  let settings = {};
  if (fs.existsSync(settingsPath)) {
    try {
      settings = JSON.parse(fs.readFileSync(settingsPath, "utf8"));
    } catch {}
  }
  if (!settings.skills) settings.skills = [];
  if (!settings.skills.includes(installPath)) {
    settings.skills.push(installPath);
    fs.mkdirSync(path.dirname(settingsPath), { recursive: true });
    fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
    console.log(`  Updated .claude/settings.json`);
  }
}

async function cmdList() {
  console.log("\nAvailable components:\n");
  for (const [t, items] of Object.entries(registry)) {
    const keys = Object.keys(items);
    if (keys.length) {
      console.log(`  ${t}:`);
      keys.forEach((k) => console.log(`    - ${k}`));
    }
  }
  console.log();
}

async function cmdAdd(type, name) {
  const pluralType = type.endsWith("s") ? type : type + "s";
  const bucket = registry[pluralType];
  if (!bucket) {
    console.error(`Unknown type: ${type}. Valid types: skill, agent, plugin, context`);
    process.exit(1);
  }
  if (!bucket[name]) {
    console.error(`Unknown ${type}: ${name}`);
    console.error(`Run \`npx ai-foundry list\` to see available components.`);
    process.exit(1);
  }

  const repoPath = bucket[name];
  const installDir = path.join(".claude", ".agents", pluralType, name);

  console.log(`\nInstalling ${type}/${name} → ${installDir} ...`);
  await downloadDir(repoPath, path.join(process.cwd(), installDir));

  if (type === "skill" || pluralType === "skills") {
    updateSettings(installDir);
  }

  console.log(`Done. ${type} "${name}" installed.\n`);
}

(async () => {
  if (command === "list") {
    await cmdList();
  } else if (command === "add" && type && name) {
    await cmdAdd(type, name);
  } else {
    usage();
  }
})().catch((err) => {
  console.error("Error:", err.message);
  process.exit(1);
});
