---
name: bash-style-guide
description: Bash/shell script style rules. Covers shebang choice and max Bash version (3.x for #!/bin/bash, 4.x for CI/AWS, 5.x for laptop-only), set -e usage, main() entrypoint layout, $var vs ${var}, the [[ ]] test operator and quoting rules, awk/sed/jq/python portability between macOS and Linux, and argparse.sh vs getopts argument parsing. Use before writing or modifying any shell script (.sh files, bin/ scripts, CI shell steps, heredocs of shell code).
---

# Bash Style Guide

Read [bash-style-guide.md](bash-style-guide.md) in full before writing or modifying shell
scripts, then follow it. It is the authority on everything it covers.

For a question it does not answer, grep [shellguide.md](shellguide.md) (a local copy of the
Google Shell Style Guide) for the topic. Do not read it in full and do not fetch it from the
web.

## Precedence

1. The user's `AGENTS.md` — always wins, including over this guide.
2. `bash-style-guide.md` — wins over the Google guide on every point it addresses.
3. `shellguide.md` — fallback only, for topics `bash-style-guide.md` is silent on.

## Known overrides

The Google guide contradicts the rules above on these points. Follow the right-hand column;
do not go looking for a resolution in `shellguide.md`.

| Topic | Google says | Follow instead |
| --- | --- | --- |
| Comments | Every function gets a `Globals:/Arguments:/Outputs:/Returns:` header block; files get a header comment | `AGENTS.md`: comment only where the *why* is non-obvious from the code. No per-function doc blocks, no banner dividers. |
| Expansion | Brace-delimit all non-special variables: `"${var}"` | Prefer `$var`; use `${var}` only where required (array elements, adjacent text) |
| Tests | Quote variables inside test expressions | Always `[[ ]]`, and do not quote variables inside `[[ ]]` |
| Assignment | Quote the right-hand side, e.g. `var="$(cmd)"` | Do not quote right-hand sides that are plain variable or command substitutions |
| Bash features | Assumes a modern bash | `#!/bin/bash` means Bash 3.x max; `#!/usr/bin/env bash` means 4.x for CI/AWS, 5.x laptop-only |
