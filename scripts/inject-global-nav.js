#!/usr/bin/env node

/**
 * 1. Writes $OUT/modules/ROOT/nav.adoc with "include::ROOT::partial$nav.adoc[]"
 * 2. Reads and modifies $OUT/antora.yml:
 *    - Parses it as YAML
 *    - Replaces or adds the 'nav' field
 *    - Writes the updated YAML back to disk
 */

import fs from "fs";
import path from "path";
import yaml from "js-yaml";

// --- 0. Resolve OUT ---
const OUT = process.env.OUT;

if (!OUT) {
  console.error("❌ Environment variable OUT is not set.");
  process.exit(1);
}

// --- 1. Ensure $OUT/modules/ROOT/nav.adoc exists ---
const navAdocPath = path.join(OUT, "modules", "ROOT", "nav.adoc");
const navAdocDir = path.dirname(navAdocPath);

try {
  fs.mkdirSync(navAdocDir, { recursive: true });
  fs.writeFileSync(navAdocPath, "include::ROOT::partial$nav.adoc[]\n", "utf8");
  console.log(`✅ Wrote nav.adoc to ${navAdocPath}`);
} catch (err) {
  console.error(`❌ Failed to write nav.adoc: ${navAdocPath}`);
  console.error(err);
  process.exit(1);
}

// --- 2. Read and parse $OUT/antora.yml ---
const yamlPath = path.join(OUT, "antora.yml");

let doc;
try {
  const fileContent = fs.readFileSync(yamlPath, "utf8");
  doc = yaml.load(fileContent) || {};
} catch (err) {
  console.error(`❌ Failed to read or parse YAML file: ${yamlPath}`);
  console.error(err);
  process.exit(1);
}

// --- 3. Modify YAML object ---
doc.nav = [
  "modules/ROOT/nav.adoc"
]; // Replace or add 'nav'
delete doc.version

// --- 4. Write YAML file back to disk ---
try {
  const newYaml = yaml.dump(doc, { lineWidth: -1 });
  fs.writeFileSync(yamlPath, newYaml, "utf8");
  console.log(`✅ Updated ${yamlPath}`);
} catch (err) {
  console.error(`❌ Failed to write YAML file: ${yamlPath}`);
  console.error(err);
  process.exit(1);
}
