; extends

; ((method (identifier) @function.builtin) (#set! "priority" 110))
; ((method (identifier) @keyword.modifier) (#set! "priority" 110))

(call
  receiver: (identifier)
  method: (identifier) @attribute.single)

(call
  receiver: (instance_variable)
  method: (identifier) @attribute.single)

(call
  receiver: (call)
  method: (identifier) @method.chained)

(interpolation
  "#{" @punctuation.interpolation
  "}" @punctuation.interpolation)

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

; Make method calls at the class-level highlight as aqua. Ex: `delegate`, `alias_method`, etc.
(class
  body: (body_statement
    (call
      method: (identifier) @keyword.macro)))

"alias" @macro (#set! priority 130)

((global_variable) @variable.global)

; Highlight these as red
(call
  method: (identifier) @keyword
  (#any-of? @keyword
  "raise"
))

; Highlight as red
((super) @keyword)

(keyword_parameter name: (identifier) @variable.parameter.keyword)

("rescue" @keyword.exception.rescue)

; Highlight these as blue
((constant) @constant.predefined
  (#any-of? @constant.predefined
  "ARGF"
  "ARGV"
  "DATA"
  "ENV"
  "STDIN"
  "TOPLEVEL_BINDING"
  "STDERR"
  "STDOUT"
  "RUBY_VERSION"
  "RUBY_PLATFORM"
  "RUBY_RELEASE_DATE"
  "RUBY_PATCHLEVEL"
  "RUBY_REVISION"
  "RUBY_DESCRIPTION"
  "RUBY_COPYRIGHT"
  "RUBY_ENGINE"
))

; Make 'module' have the same highlighting category as 'class
"module" @keyword.type

; Target the delimiters of a regex expression
(regex
  "/" @punctuation.regex
  "/" @punctuation.regex)

; Make `rescue` for blocks highlight as red
(begin (rescue "rescue" @keyword.exception.block))
(do_block
  (body_statement
    (rescue "rescue" @keyword.exception.block)))


; ------------------------------------------------------------------------
; Filetype specifics
; ------------------------------------------------------------------------

(call
  method: (identifier) @macro.keyword
  (#any-of? @macro.keyword
    ; RSpec
    "expect"
    "allow"
    "allow_any_instance_of"
    "expect_any_instance_of"
    "get"
    "post"
    "put"
    "patch"
    "delete"
  )
  (#is-rspec?))

; Highlight these as aqua
(call
  method: (identifier) @macro
  (#any-of? @macro
  "alias_method"
  "autoload"
  "define_method"

  ; Rake task
  "desc"
  "file"
  "gem"
  "namespace"
  "task"

  ; ActiveRecord
  "belongs_to"
  "validates"
  "has_one"
  "has_many"
  "has_and_belongs_to_many"
  "scope"

  ; Rails
  "delegate"

  "def_delegators"

  ; RSpec
  "context"
  "before"
  "around"
  "after"
  "it"
  "let"
  "describe"

  ; Custom
  "private_attr_reader"
))

; Highlight these as red
(call
  method: (identifier) @macro.keyword
  (#any-of? @macro.keyword
   ; rubyControl
  "abort"
  "at_exit"
  "exit"
  "fork"
  "loop"
  "trap"

  "proc"

  ; Controllers
  "head"
  "render"
))

((identifier) @test.helper
  (#any-of? @test.helper
  "described_class"
  "double"
  "instance_double"
  "class_double"
  "object_double"
  "stub_const"
  "hide_const"
))
