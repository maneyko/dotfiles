
augroup endwise
  autocmd FileType ruby
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'module,class,def,if,unless,case,while,until,begin,do' |
        \ let b:endwise_pattern = '^\(.*=\)\?\s*\%(private\s\+\|protected\s\+\|public\s\+\|module_function\s\+\)*\zs\%(def\s\+[^[:space:]()]\+\s*\%(([^()]*)\)\=\s*=\)\@!\%(module\|class\|def\|if\|unless\|case\|while\|until\|for\|\|begin\)\>\%([^#]*[^.:@$#]\<end\>\)\@!\|\<do\ze\%(\s*|.*|\)\=\s*$' |
        \ let b:endwise_syngroups = 'rubyModule,rubyClass,rubyDefine,rubyControl,rubyConditional,rubyRepeat,rubyDocumentation,rubyComment'
augroup END
