" Local overides for all languages

" If we're on a mac (vim 9.x), set the background here to fix color issues.  If we're on Linux (vim
" 8.x), we're fine setting it in .vimrc
if version >= 900
    if &bg != "light"
        set bg=light
    endif
endif

hi Statement    term=bold cterm=NONE ctermfg=Yellow ctermbg=NONE gui=bold guifg=Yellow guibg=NONE
hi Comment term=bold ctermfg=63 guifg=#5454ff


