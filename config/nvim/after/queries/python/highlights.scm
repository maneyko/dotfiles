; extends

((call
  function: (identifier) @constructor.call)
  (#lua-match? @constructor.call "^%u")
  (#set! priority 105))

((call
  function: (attribute
    attribute: (identifier) @constructor.call))
  (#lua-match? @constructor.call "^%u")
  (#set! priority 105))

"." @punctuation.delimiter.period

(parameters
  (default_parameter
    name: (identifier) @variable.parameter.keyword
  ))

(parameters
  (typed_default_parameter
    name: (identifier) @variable.parameter.keyword
  ))

(interpolation
  "{" @punctuation.interpolation
  "}" @punctuation.interpolation)

((call
   arguments: (argument_list
    (keyword_argument
    name: (identifier) @variable.parameter.keyword.call))))

; Increase priority of constructor
; ((call
;   function: (identifier) @constructor)
;   (#lua-match? @constructor "^%u") (#set! priority 105))
; ((call
;   function: (attribute
;     attribute: (identifier) @constructor))
;   (#lua-match? @constructor "^%u") (#set! priority 105))
