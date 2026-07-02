; extends

; Ensure `end` has same highlighting as `module`, `class`, `def self.foo`, etc.
(class "end" @keyword.structure)
(module "end" @keyword.structure)
(method "end" @keyword.structure)
(singleton_method "end" @keyword.structure)

;; Target inline Sorbet blocks: sig { ... }
((call
  method: (identifier) @sig_name (#eq? @sig_name "sig")
  block: (block)) @comment (#set! "priority" 120))

;; Target multiline Sorbet blocks: sig do ... end
((call
  method: (identifier) @sig_name (#eq? @sig_name "sig")
  block: (do_block)) @comment (#set! "priority" 120))

; Force the entire %i[...] array container and its contents to use one group
(symbol_array (bare_symbol (string_content) @string.special.symbol (#set! priority 120)))
(string_array (bare_string (string_content) @string                (#set! priority 120)))
((string_array) @string                (#set! priority 130))
((symbol_array) @string.special.symbol (#set! priority 130))

; Handle `%I[]` and `%W[]` arrays
(string_array (bare_string (interpolation) @punctuation.interpolation (#set! priority 150)))
(symbol_array (bare_symbol (interpolation) @punctuation.interpolation (#set! priority 150)))
(string_array (bare_string (interpolation (identifier) @variable (#set! priority 151))))
(symbol_array (bare_symbol (interpolation (identifier) @variable (#set! priority 151))))

; ; Make method calls at the class-level highlight as aqua. Ex: `delegate`, `alias_method`, etc.
; (class
;   body: (body_statement
;     (call
;       .
;       method: (identifier) @keyword.macro)))

; Create target for keyword arguments
(keyword_parameter name: (identifier) @variable.parameter.keyword)

; Make `rescue` and `ensure` have the same highlight color as `def..end`
(method body: (body_statement (rescue "rescue" @keyword.function)))
(method body: (body_statement (ensure "ensure" @keyword.function)))
(singleton_method body: (body_statement (rescue "rescue" @keyword.function)))
(singleton_method body: (body_statement (ensure "ensure" @keyword.function)))

; (call
;   receiver: (identifier)
;   method: (identifier) @attribute.single)
; (call
;   receiver: (instance_variable)
;   method: (identifier) @attribute.single)
; (call
;   receiver: (call)
;   method: (identifier) @method.chained)
