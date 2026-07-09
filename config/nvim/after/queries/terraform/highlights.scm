;; extends

(get_attr
  (identifier) @variable.attribute
)

; ((identifier) @variable.builtin
;   (#any-of? @variable.builtin "module" "local" "var" )
; )
(expression
  (variable_expr
    (identifier) @variable.builtin2
    (#any-of? @variable.builtin2 "data" "var" "local" "module" "output"))
  (get_attr
    (identifier) @variable.member2))
