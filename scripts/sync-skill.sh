#!/usr/bin/env bash
# Copies the build-app skill from cori-core (a maintainer's checkout: that repository is private) into the plugin, at the
# tag of a release of the command line, and gives the plugin that release's version. Run it at
# each release of `@cori-do/cli`, then validate (`claude plugin validate --strict plugins/cori` and `… .`).
#
#   scripts/sync-skill.sh <cori-core checkout> [<tag>]    # default: the checkout's latest v* tag
#   scripts/sync-skill.sh <cori-core checkout> --worktree # its working tree as it is, to try a change before a release
set -euo pipefail
cd "$(dirname "$0")/.."
CORE=${1:?usage: scripts/sync-skill.sh <cori-core checkout> [<tag> | --worktree]}
REF=${2:-$(git -C "$CORE" describe --tags --abbrev=0 --match 'v*')}
DEST=plugins/cori/skills/build-app
rm -rf "$DEST" && mkdir -p "$DEST"
if [ "$REF" = "--worktree" ]; then
  cp -R "$CORE/skills/build-app/." "$DEST/"
  find "$DEST" -name .DS_Store -delete   # a working tree's Finder files (git archive takes tracked files only)
  VERSION=$(sed -n 's/^version = "\(.*\)"/\1/p' "$CORE/Cargo.toml" | head -1)
  FROM="the working tree of $CORE"
else
  git -C "$CORE" archive "$REF" skills/build-app | tar -x -C "$DEST" --strip-components=2
  VERSION=${REF#v}
  FROM="cori-core $REF ($(git -C "$CORE" rev-parse --short "$REF^{commit}"))"
fi
# in the plugin, the skill is named after its folder: Claude lists it as `cori:build-app`
python3 - "$DEST/SKILL.md" <<'PY'
import re, sys
p = sys.argv[1]; s = open(p).read()
s2 = re.sub(r"(?m)^name: .*$", "name: build-app", s, count=1)
assert s2 != s or "name: build-app" in s, "SKILL.md has no `name:` line"
open(p, "w").write(s2)
PY
# the plugin's version (plugin.json; the marketplace entry carries none): an install keeps its version until this changes
python3 - "$VERSION" <<'PY'
import json, sys
p = "plugins/cori/.claude-plugin/plugin.json"
d = json.load(open(p)); d["version"] = sys.argv[1]
open(p, "w").write(json.dumps(d, indent=2, ensure_ascii=False) + "\n")
PY
echo "skill from $FROM → $DEST; plugin version $VERSION"
