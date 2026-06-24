; extends

; Increase priority of constructor
; ((call
;   function: (identifier) @constructor)
;   (#lua-match? @constructor "^%u") (#set! priority 105))
; ((call
;   function: (attribute
;     attribute: (identifier) @constructor))
;   (#lua-match? @constructor "^%u") (#set! priority 105))
