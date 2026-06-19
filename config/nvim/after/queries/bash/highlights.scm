; extends
(simple_expansion
  (variable_name) @string.variable
  (#set! priority 110))

((simple_expansion) @string.interpolation
  (#set! priority 120))

(command_substitution
  (command
    (command_name) @string.command
    (#set! priority 120)))
