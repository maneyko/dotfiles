local posix_commands = {
  "alias", "ar", "at", "awk", "basename", "batch", "bc", "cat", "cd", "chgrp", "chmod", "chown", "cksum",
  "cmp", "comm", "command", "cp", "cron", "csplit", "cut", "date", "dd", "df", "diff", "dirname", "du",
  "echo", "ed", "env", "expand", "expr", "false", "file", "find", "fold", "gencat", "getconf", "getopts",
  "gettext", "grep", "hash", "head", "iconv", "id", "join", "kill", "ln", "locale", "localedef", "logger",
  "logname", "lp", "ls", "m4", "mailx", "man", "mesg", "mkdir", "mkfifo", "msgfmt", "mv", "newgrp", "ngettext",
  "nice", "nohup", "od", "paste", "patch", "pathchk", "pax", "pr", "printf", "ps", "pwd", "read", "readlink",
  "realpath", "renice", "rm", "rmdir", "sed", "sh", "sleep", "sort", "split", "strings", "stty", "tabs",
  "tail", "tee", "test", "time", "timeout", "touch", "tput", "tr", "true", "tsort", "tty", "umask", "unalias",
  "uname", "unexpand", "uniq", "uudecode", "uuencode", "wait", "wc", "write", "xargs",
}

local function is_posix_cmd(val)
  for _, value in ipairs(posix_commands) do
    if value == val then
      return true
    end
  end
  return false
end

vim.treesitter.query.add_predicate("is-posix?", function(match, _, bufnr, predicate)
  local capture_id = predicate[2]
  local node_or_nodes = match[capture_id]
  if not node_or_nodes then
    return false -- no match
  end

  local target_buf = bufnr or 0
  local nodes = type(node_or_nodes) == "table" and node_or_nodes or { node_or_nodes }

  for _, node in ipairs(nodes) do
    -- Extract the string text from the node boundaries [1, 2]
    local text = vim.treesitter.get_node_text(node, target_buf)

    if is_posix_cmd(text) then
      return true
    end

    -- Inspect the output directly to the Neovim messages console
    -- print(string.format("Captured text for ID %s: '%s'", capture_id, text))
  end

  return false

  -- Returns true if the capture exists in the current match array
  -- return true
end, { force = true })
