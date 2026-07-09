;; extends

((interval) @string)

; TODO: Add all keywords from Vim syntax file:
;   https://github.com/neovim/neovim/blob/master/runtime/syntax/plsql.vim
((identifier) @function.call
  (#any-of? @function.call "current_date" "CURRENT_DATE")
)
