# Bash Style Guide

For all things not covered in this guide, reference the Google Shell Scripting Style Guide: https://google.github.io/styleguide/shellguide.html

## Which Bash

- `#!/bin/bash` scripts must assume a maximum of **Bash 3.x** and may not use any features from Bash 4, 5, or beyond
    - `#!/bin/bash` will forever be Bash 3.x on macOS, due to licensing incompatibilities with the GPLv2 license
- `#!/usr/bin/env bash` scripts intended for running locally on people’s laptops may assume a maximum
  of **Bash 5.x** (the most recent major version of Bash)
- `#!/usr/bin/env bash` scripts intended to run in CI or in remote locations directly on AWS servers must
  assume a maximum of **Bash 4.x**
    - Amazon Linux 2 (AL2) is the only relevant modern OS that does not provide Bash 5.x even through
    its package manager, all other modern OSs yield Bash 5.x via `{apt,yum,brew} install bash`

## Script Layout

### Shell Options

As a sensible default, always start your scripts with `set -e`. Rarely do you want to proceed in your
script if one of the commands exit with a non-zero exit code. It’s better to explicitly *allow* non-zero
exit codes rather than continue on with your script no matter what.

Good:

```bash
#!/bin/bash

set -e

stat Dockerfile
# Dockerfile exists, since script is continuing after `stat`

# We want to handle a non-zero exit code ourselves for `docker run ...`
set +e
docker run hello-world
status=$?
set -e

if [[ $status -ne 0 ]]; then
  echo "Docker may not be running, please start Docker"
fi
```

Bad (entire script is working with a file that does not actually exist):

```bash
#!/bin/bash

stat Dockerfile
# file does not exist, `stat` returned an exit code of 1

scp Dockerfile remote-server:~/

aws secretsmanager update-secret --secret-id=my-secret --secret-string="$PWD/Dockerfile"

docker build -f Dockerfile .
```

### Componentized Scripts

For scripts that start to reach an unwieldy size for simple sequential procedural code, strongly consider
breaking down the script in to functions with a `main` entrypoint function:

```bash
#!/bin/bash

set -e

 main() {
   setup_env
   sync_repo
   update_image
   cleanup_artifacts
   report_results
 }

 setup_env() {
   # ...
 }

 # Other function definitions ...

 main
```

## Bash Syntax and Style

### Variable Expansion

Only expand variables that _need_ to be expanded. Always prefer `$var` over `${var}`. Using variable expansion
adds unneeded line noise to shell scripts that make the script look much more messy from a high-level.

#### Example: Variable expansion is not needed

Good: Properly formatted function where variable expansion is used only where needed (like for accessing
array elements: `${POSITIONAL[0]}`)

<details>
<summary>Click to expand</summary>

```bash
file="Dockerfile"
user_dir=$PWD

docker build -f "$file" "$user_dir"
```
</details>

Bad: Variable expansion were used everywhere

<details>
<summary>Click to expand</summary>

```bash
file="Dockerfile"
user_dir=${PWD}

docker build -f "${file}" "${user_dir}"
```
</details>

#### Example: Variable expansion is needed

```bash
date="2025-06-03"

timestamp="${date}T12:00:00-05:00"
```

### Setting Variables

Setting variables based on other Bash variables never require quotes. Examples:

```bash
# Good, can use quotes for easier readibility
a="hello"

# Good
b=$a

# Bad -- unnecessary quoting
b="$a"

# Good
c=${a//l/x}

# Bad
c="${a//l/x}"

# Good -- notice the quotes around "$a" are required for proper `echo` output
d=$(echo "$a" | awk 'gsub("ll", "")')

# Bad
d="$(echo "$a" | awk 'gsub("ll", "")')"

# Good -- hopefully this one is obvious -- strings with spaces need to be quoted
e="This variable needs to be set using quotes: $(date)"

# Good
f=$(date)

# Bad
f="$(date)"
```

### Test Operator

Always use the Bash extended test operator: `[[`
Never use `[` or `test`.

Rationale:

<details>
<summary>Click to expand</summary>

- `[[` executes faster

    - Test: `time for i in {1..100000}; do [[ "hello" = "world" ]]; done`
- Variables in `[[` do not need to be quoted

    - If a variable in `[` is not quoted, it can lead to syntax errors (`[ $n -eq 0 ]` is a syntax error
    if `$n` is blank — this is why people get in the habit of quoting variables in brackets in shell scripts)
</details>

Good:

```bash
[[ $my_var == hello ]]
```

Bad:

```bash
[ "$my_var" = "hello" ]
```

Bad:

```bash
test "$myvar" = "hello"
```

#### Quoting

Variables used in the `[[` operator never require quotes. String literals *do* require spaces in `[[`.
Don’t use quotes for variables in the `[[` operator unless you need to — it creates line noise. String
literals *can* have quotes in the `[[`, but please be consistent.

Good:

```bash
[[ $my_var == foo || $my_var == bar || $my_var == "foo bar" ]]
```

Good (string literals are consistently quoted):

```bash
[[ $my_var == "foo" || $my_var == "bar" || $my_var == "foo bar" ]]
```

Bad (unnecessary quoting of `my_var`):

```bash
[[ "$my_var" == "foo" || "$my_var" == "bar" || "$my_var" == "foo bar" ]]
```

## Piping to External Commands

Sometimes additional text-processing commands are needed to parse information that Bash is not able to
idiomatically handle. Using external commands can be tricky, because versions and implementations differ
across platforms. For that reason, there is a heavy preference to utilize commands that have consistent
implementations across platforms and a consistent set of features within the “current” version range across platforms.

### Text Processing

`awk` should be used whenever possible. If you need to use PCRE regular expressions, access to low-level
C-libraries, or complexity beyond the capabilities of `awk`, you can use `perl`, `jq`, or `python3`.

Notes on individual commands:

`sed`

Beware of using `sed`, as its implementation differs between macOS and Linux. Due to this, `awk` is stronly
preferred for all use cases.

`awk`

The implementations of `awk` on macOS and Linux differ as well, but these are less noticeable for typical
`awk` usage. Always use `awk` patterns that are compatible in both macOS _and_ Linux -- if you find there
is a `gawk` pattern you need to use, you should use a different CLI tool.

#### `sed`: GNU (Linux) vs BSD (macOS)

<details>
<summary>Click to expand</summary>

| Feature | GNU `sed` | BSD `sed` (macOS) | Notes |
| --- | --- | --- | --- |
| `-i` in-place edit | ✅ Suffix optional, must be attached: `-i` or `-i.bak` | ✅ Suffix mandatory: `-i ''` or `-i.bak` | The single worst trap. `-i` alone fails on macOS; `-i ''` on GNU consumes the script argument. `-i.bak` is the only spelling that works on both. |
| `\n` in the replacement | ✅ Emits a newline | ⚠️ Works on macOS 26; emits a literal `n` on older releases | Pattern-side `\n` is fine everywhere. To be safe on macOS use `$'...'` with a real newline. |
| `-E` (ERE) | ✅ (also `-r`) | ✅ | Portable since GNU sed 4.2 / macOS 10.4. `-r` is GNU-only. |
| `\+`, `\?`, alternation in default BRE mode | ✅ GNU extension | ❌ | Use `-E` on both rather than relying on the GNU extension. |
| Non-greedy `.+?` | ❌ | ❌ | `sed` has no PCRE mode anywhere. Use `perl -pe`. |
| `\s`, `\w`, `\b` | ✅ GNU extension | ❌ | Use `[[:space:]]`, `[[:alnum:]_]`. |
| `\t` in the replacement | ✅ | ⚠️ Works on macOS 26; literal `t` on older releases | Use `$'\t'` or a real tab to be safe. |
| `\xNN` hex escapes | ✅ | ❌ | |
| `\U`, `\L`, `\E` case conversion | ✅ | ❌ | Use `awk`'s `toupper()` / `tolower()`. |
| `a`, `i`, `c` commands | ✅ One-liner: `a text` | ❌ Requires `a\` + newline | Second-worst trap. Prefer `awk` for insertions. |
| `-z` (NUL-separated) | ✅ | ❌ | |
| Offset addressing (`3,+2`, `1~3`) | ✅ | ❌ | |
| `--version` | ✅ | ❌ Usage error | `sed --version >/dev/null 2>&1` detects GNU. |

</details>

#### `awk`: GNU (`gawk`) vs macOS (BSD `awk`)

<details>
<summary>Click to expand</summary>

| Feature | GNU `awk` (`gawk`) | macOS `awk` | Notes |
| --- | --- | --- | --- |
| `sub`, `gsub`, `match`, `split`, `substr`, `index`, `toupper` | ✅ | ✅ | The portable core. Stay here. |
| `ENVIRON`, `NR`/`NF`/`FS`/`OFS`, regex `FS` | ✅ | ✅ | POSIX. |
| `for (k in arr)` order | ❌ Unspecified | ❌ Unspecified | Never rely on it. `gawk` alone can force order via `PROCINFO["sorted_in"]`. |
| `gensub()` | ✅ | ❌ | `gawk`-only. Use `gsub()`, or `match()` + `substr()`. |
| `asort()` / `asorti()` | ✅ | ❌ | Pipe to `sort` instead. |
| `systime()`, `strftime()`, `mktime()` | ✅ | ❌ | `gawk`-only. Shell out to `date`. |
| `\s`, `\w`, `\y` in regex | ✅ (no `\d`) | ❌ | Use `[[:space:]]`, `[[:alnum:]_]`. |
| Multi-dimensional arrays | ✅ `a[i,j]` and true `a[i][j]` | ✅ `a[i,j]` only | `a[i,j]` (SUBSEP) is portable; arrays-of-arrays are not. |
| Named capture groups | ❌ | ❌ | Neither supports them. Use `perl` or `python3`. |
| Multi-character / regex `RS` | ✅ | ⚠️ Varies by macOS version | Don't rely on it. |
| `RS = "\0"` | ✅ | ⚠️ Unreliable | Use `gawk`, or restructure the input. |
| `length(arr)` | ✅ | ⚠️ Varies by macOS version | Count in a loop if it must be portable. |
| `--csv` | ✅ 5.3+ | ❌ | |
| `@include`, `/inet/` sockets, `--lint` | ✅ | ❌ | |
| `--version` | ✅ | ⚠️ Recent builds print a BWK version; older ones error | Only `gawk` mentions GNU in `awk --version` output. |

</details>

The portable subset is small on purpose: pattern-action rules, the POSIX string functions, POSIX character
classes, and a regex `FS`. If a task needs anything outside it, reach for `perl`, `jq`, or `python3` rather
than a `gawk`-only feature.

#### Text Substitution

Best:

```bash
echo 'refs/heads/master' | awk 'gsub(/^refs\/heads\//, "")'

# => master
```

Acceptable:

```bash
echo 'refs/heads/master' | sed 's|^refs/heads/||'

# => master
```

Acceptable:

```bash
echo 'refs/heads/master' | perl -pe 's|^refs/heads/||'

# => master
```

#### Example of Using low-level C-libaries

Perl:

```bash
username=$(perl -MPOSIX -e 'print((getpwnam($ENV{"USER"}))[6])')

echo "$username"
# => Peter Maneykowski
```

Python:

```bash
username=$(python3 -c 'import os, pwd; print(pwd.getpwnam(os.environ["USER"]).pw_gecos)')

echo "$username"
# => Peter Maneykowski
```

### JSON Processing

Always use `jq` for JSON processing (unless the processing you are doing is sufficiently complex, in which
case you should create a separate Python script). If your script is doing JSON processing, it is already
assumed that a relatively modern OS is being used, and almost all modern OSs (CI pipelines, laptops, servers,
etc.) will have `jq` installed. You don't need to do a check at the beginning of the script to see if
`jq` is installed, doing `set -e` and then failing is fine (it will seldom _not_ be installed, and checking
to see if CLI tools are installed creates unnecessary noise in scripts).

`jq` is a powerful Turing-complete JSON processing programming language. The `jq` manual is very useful
for both beginners and experts: https://jqlang.org/manual/
It is highly recommended that you look through it for a bit if you expect to be working with `jq` a lot.

#### YAML Processing

If you are extracting data from a YAML file, you must first convert it to JSON and then use `jq`. This is the only acceptable way to convert YAML to JSON:
```bash
yq --output-format=json .
```

This is because that combination of flags and arguments works for both Mike Farah's `yq` _and_ Andrey Kislyuk's `yq` (default on Debian).

Examples:
```bash
cat file.yaml | yq --output-format=json . | jq '.my_field'

yq --output-format=json . file.yaml | jq '.my_field'
```

### Parsing Arguments

For global scripts that are *only* meant to run locally on people’s laptops, `argparse.sh` should be
used for Bash script argument parsing. Conversely, scripts that are meant
to run in CI, or that run in places where it can’t be assumed that `argparse.sh` is in the `$PATH`, `getopts`
should be used for argument parsing. Here is some boilerplate code to get you started with each one in your script:

`argparse.sh`:

<details>
<summary>Click to expand</summary>

```bash
#!/bin/bash

source "argparse.sh"

# Set default value.
ARG_DELIMITER=","

arg_help       "[This script is for processing a text file]"
arg_positional "[input-file]     [Input text file to process]"
arg_boolean    "[verbose]    [v] [Print information about operations being performed]"
arg_optional   "[delimiter]  [d] [Input file field separator. Default: '$ARG_DELIMITER']"
arg_optional   "[expression] [e] [Expression passed directly to \`awk '{print ...}'\`]"
parse_args

echo $ARG_INPUT_FILE
# => input-data.txt

echo $ARG_DELIMITER
# => ,

echo $ARG_VERBOSE
# => true

if [[ -n $ARG_VERBOSE ]]; then
  echo "Beginning processing..."
fi

awk -F "$ARG_DELIMITER" "{print $ARG_EXPRESSION}" "$ARG_INPUT_FILE"
```
</details>

`getopts`:

<details>
<summary>Click to expand</summary>

```bash
#!/bin/bash

ARG_DELIMITER=","

usage() {
  cat << USAGE
Usage: $0 [-hv] [-d DELIMITER] [-e EXPRESSION] [INPUT-FILE]
This script is for processing a text file.

Options:
  -d: Input file field separator. Default: '$ARG_DELIMITER'
  -e: Expression passed directly to \`awk '{print ...}'\`
  -h: Print this help message
  -v: Print information about operations being performed
USAGE
}

while getopts ":hvd:e:" options; do
  case "$options" in
    h)
      usage ; exit
      ;;

    v)
      ARG_VERBOSE=true
      ;;

    d)
      ARG_DELIMITER=$OPTARG
      ;;

    e)
      ARG_EXPRESSION=$OPTARG
      ;;

  esac
done
shift $((OPTIND-1))

ARG_INPUT_FILE=$1

echo $ARG_INPUT_FILE
# => input-data.txt

echo $ARG_DELIMITER
# => ,

echo $ARG_VERBOSE
# => true

if [[ -n $ARG_VERBOSE ]]; then
  echo "Beginning processing..."
fi

awk -F "$ARG_DELIMITER" "{print $ARG_EXPRESSION}" "$ARG_INPUT_FILE"
```
</details>
