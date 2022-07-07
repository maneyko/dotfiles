" https://github.com/neovim/neovim/blob/master/runtime/syntax/ruby.vim

" Sorbet single line signature shows as comment.
syn match   rubyComment	     "sig\s*{.*}" contains=@rubyCommentSpecial,rubySpaceError,@Spell fold

" Multiline Sorbet signature shows as comment.
syn region rubyComment start="\<sig\s*do\>" skip="\<end:" end="\<end\>" contains=rubySpaceError,rubyTodo,@Spell fold
" syn region rubyDocumentation start="\<sig\s*do\>" skip="\<end:" end="\<end\>" contains=rubySpaceError,rubyTodo,@Spell fold
