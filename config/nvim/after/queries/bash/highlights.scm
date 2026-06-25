; extends
(simple_expansion
  (variable_name) @string.variable
  (#set! priority 110))

(expansion
  (variable_name) @string.interpolation
  (#set! priority 110))

((simple_expansion) @string.interpolation
  (#set! priority 120))

(command_substitution
  (command
    (command_name) @string.command
    (#set! priority 120)))

;; Target double-quote delimiters: "
(string
  "\"" @punctuation.string.delimiter
  "\"" @punctuation.string.delimiter)

(array
  "(" @punctuation.array.delimiter
  ")" @punctuation.array.delimiter)

(command_substitution
  (command
    (command_name) @command_substitution.function.call))

(command
  argument: (word) @function.arg.flag
  (#lua-match? @function.arg.flag "^[-]")
  (#set! priority 105))

(command
  argument: (word) @function.arg.positional
  (#lua-match? @function.arg.positional "^[^-]")
  (#set! priority 105))

; Special highlighting for POSIX commands and their flags
(command
  name: (command_name (word) @function.posix
    (#is-posix? @function.posix)
    (#set! priority 110)))

(command
  name: (command_name (word) @function.posix
    (#is-posix? @function.posix)
    (#set! priority 110))
  argument: (word) @function.posix.flag
  (#lua-match? @function.posix.flag "^[-]"))

(variable_assignment
  name: (_)
  "=" @operator.assignment
  value: (_)
)

(pipeline
  (command)
  "|" @operator.pipeline
  (command)
)

; Highlight positional args as strings for `echo` and `printf
(command
  name: (command_name (word) @__cmd_name)
  argument: (word) @string.echo
  (#lua-match? @string.echo "^[^-]")
  (#any-of? @__cmd_name "echo" "printf")
  (#set! priority 110)
)

"\;" @semicolon
[
 "&&"
 "||"
] @operator.logical
