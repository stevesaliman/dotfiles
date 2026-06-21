setlocal ts=2
setlocal shiftwidth=2
" Tabs are bad news in in Markdown files
setlocal softtabstop=2
setlocal expandtab
setlocal smarttab
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['bash=sh', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml']
let g:markdown_syntax_conceal = 0
" Set code (single `) and code blocks (triple ```) to red
hi markdownCode ctermfg=Red guifg=Red
hi markdownCodeBlock ctermfg=Red guifg=Red

