" Sorbet single line signature shows as comment.
syn match   rubyComment	     "sig\s*{.*}" contains=@rubyCommentSpecial,rubySpaceError,@Spell

" Multiline Sorbet signature shows as comment.
syn region rubyDocumentation start="\<sig\s*do\>" skip="\<end:" end="\<end\>" contains=rubySpaceError,rubyTodo,@Spell fold
syn region rubyDocumentation start="sig\s*{" end="}" contains=rubySpaceError,rubyTodo,@Spell fold
