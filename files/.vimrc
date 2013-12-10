"Steve's custom stuff
set term=xterm-vt220
set autoindent
set showmatch
"set mouse=a
" Set the devault tabstop to 4, override it in language plugins.
set ts=4
set shiftwidth=4

" Allow spaces in filenames
set isfname+=32
if has("terminfo")
  set t_Co=8
  set t_Sf=[3%p1%dm
  set t_Sb=[4%p1%dm
else
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Load the puppet plugin
call pathogen#infect()
filetype plugin indent on
""Linux-Mandrake configuration.
"Chmouel Boudjnah <chmouel@mandrakesoft.com>

"Syntax highlighting only for enhanced-vi
"if has("terminfo") && filereadable("/usr/local/share/vim/syntax/syntax.vim")
  syntax on
"endif

"Set a statusbar
"set statusline=~
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

"I know it's horrible for a vi master but useful for newbies.
imap <C-a> <Esc>I
imap <C-e> <ESC>A
map <C-Tab> <C-W>w
imap <C-Tab> <C-O><C-W>w
cmap <C-Tab> <C-C><C-Tab>

"Some macros to manage the buffer of vim
map <F5> :bp<C-M>
map <F6> :bn<C-M>
map <F7> :bd<C-M>

"Default backspace like normal
set bs=2

"Terminal for 80 char ? so vim can play till 79 char.
"set textwidth=79

"Some option desactivate by default (remove the no).
set nobackup
set nohlsearch
" set noincsearch
set incsearch "Highlight searches as you type

"Display a status-bar.
"set laststatus=2

"Show the position of the cursor.
set ruler

"no wrap
"set nowrap

"Show matching parenthese.
set showmatch

"" Gzip and Bzip2 files support
" Take from the Debian package and the exemple on $VIM/vim_exemples
if has("autocmd")

" Set some sensible defaults for editing C-files
augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPre,FileReadPre	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . %:r

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=2|'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=1 nobin|execute ":doautocmd BufReadPost " . %:r
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

endif " has ("autocmd")
"highlight Statement    term=bold cterm=NONE ctermfg=red ctermbg=NONE gui=bold guifg=Red guibg=NONE
" skeletons
"function! SKEL_spec()
        "0r /usr/share/vim/current/skeletons/skeleton.spec
        "language time en_US
        "if $USER != ''
            "let login = $USER
        "elseif $LOGNAME != ''
            "let login = $LOGNAME
        "else
            "let login = 'unknown'
        "endif
        "let newline = stridx(login, "\n")
        "if newline != -1
            "let login = strpart(login, 0, newline)
        "endif
        "if $HOSTNAME != ''
            "let hostname = $HOSTNAME
        "else
            "let hostname = system('hostname -f')
            "if v:shell_error
                "let hostname = 'localhost'
            "endif
        "endif
        "let newline = stridx(hostname, "\n")
        "if newline != -1
            "let hostname = strpart(hostname, 0, newline)
        "endif
        "exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
        "exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
        "exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
        "setf spec
"endfunction
"autocmd BufNewFile      *.spec  call SKEL_spec()
"" filetypes
"filetype plugin on
"filetype indent on
set bg=light
