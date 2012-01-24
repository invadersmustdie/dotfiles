" ~/.vimrc
" by Rene Lengwinat, <rugek@dirtyhack.net>
"
" got some clever hints from the following people:
"   Christain Schneider,  http://strcat.de
"   Sven Guckes,  http://guckes.net
"   Michael Prokop, http://www.michael-prokop.at
"   Luc's Hermitte, http://hermitte.free.fr
"   David Rayner, http://www.rayninfo.co.uk

set autoindent          " auto-indenting on
set nocompatible        " not compatible with vi
set bs=2            " allow backspacing over everything in insert mode.
set mousehide           " hide the mouse pointer while typing
set ruler           " turn our ruler on
set history=75          " save 75 history commands
set makeprg=make        " gmake as make prog
set notitle         " don't set change terminal's title
set showmode            " always show command or insert mode
" set nowrap            " do not wrap long lines
set noerrorbells novisualbell   " go away! flash screen and ringing bell
set esckeys         " allow arrow keys in insert mode
set showmatch           " show matching brackets
set showmode                    " show the current mode
set incsearch           " do incremental searching
set ignorecase          " make searches case-insensitive
" set smarttab            " use shiftwidth spaces when inserting tab
set shiftround          " round indent to multiple of shiftwidth
set fileformat=unix     " set the fileformat unix or dos
set encoding=utf-8     " encoding
set fileencoding=utf-8     " encoding
set nowarn          " no warn
set display-=lastline       " no last line
set hlsearch            " switch on search pattern highlighting.
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set magic                       " voodoo
set wildmenu                    " completion on the commandline shows a menu
set completeopt=menu,preview

" set textwidth=70
" set expandtab
" set sw=2 smartindent softtabstop=2 et ts=4
set title

" show spaces,tabs,newlines
" set list
" set lcs=tab:»·
" set lcs+=trail:·
" set lcs+=eol:$
cab Wq wq

" enables folds
" set nofoldenable
" set foldmethod=indent
" set foldlevel=1
" set foldcolumn=1

" gui options
set guifont=Inconsolata\ 9
" set guifont=DejaVu\ Sans\ Mono\ 9
" set guifont=Consolas\ 9
" set guifont=Inconsolata\ 11
set guioptions+=M       " enable menus
set guioptions-=T       " turn off toolbar
set guioptions-=r       " turn off scrollbar

" backup options
" fast and ugly hack to create the common backup/swap directories
if !isdirectory(expand("~/.tmp/."))
  !mkdir -p ~/.tmp/vim/{backup,swap}
endif

if has("gui_running")
  colorscheme twilight
else
  colorscheme rless
endif

set backup          " turn backup files on
set backupdir=~/.tmp/vim/backup " set backup dir
set dir=~/.tmp/vim/swap         " set dir for swaping

" sometimes i really need to wrap :/
set whichwrap+=<,>,[,]

" manuals in splitview
if exists("$VIMRUNTIME/ftplugin/man.vim")
  source $VIMRUNTIME/ftplugin/man.vim
endif

" keymapping
map <F9> :w <CR> :make <CR>                   " let's get it on
map Q gq
noremap <F5> :silent!ks\|%s/\s\+$//e\|'s<CR>  " remove empty spaces
cmap ,ce g/^[<C-I> ]*$/d                      " remove empty lines
map <F2> :bp <CR>                             " makes live easy :)
map <F3> :bn <CR>

" shift+insert => paste
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

nmap tn :tabnext<CR>
nmap tp :tabprev<CR>
nmap to :tabnew<CR>

" map Q :call BufferList()<CR>
" map W :NERDTreeToggle<CR>
map T :Tlist<CR>

" cycle between last and current buffer
nnoremap <silent> <C-G> :buffer #<CR>

" set a max width of 78 for text files
autocmd FileType text setlocal textwidth=78

" turn of numbers on the left side of the screen
set nonumber

" set the ruler format
set rulerformat=%40(%t%y:\ %l,%c%V\ \(%o\)\ %p%%%)

" some setting to improve the work with c files
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent

"shameless copied from an unknown rc - but quite useful
" gzip and bzip2 compressed files editing
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "   read: set binary mode before reading the file
  "     uncompress text in buffer after reading
  "  write: compress file after writing
  " append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre    *.gz set bin
  autocmd BufReadPre,FileReadPre    *.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost  *.gz set nobin
  autocmd BufReadPost,FileReadPost  *.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost  *.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost    *.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.gz !gzip <afile>:r

  autocmd FileAppendPre         *.gz !gunzip <afile>
  autocmd FileAppendPre         *.gz !mv <afile>:r <afile>
  autocmd FileAppendPost        *.gz !mv <afile> <afile>:r
  autocmd FileAppendPost        *.gz !gzip <afile>:r
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
  autocmd BufReadPost,FileReadPost      *.bz2 |'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost      *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

augroup php4
  set syntax=php
augroup END

function! SwitchProject(pname)
  if match(a:pname, "middleware") == 1
    call "load_middleware"
  else
    execute "ls"
  endif
endfunction

function! EncodeHtmlUmlauts()
  if search("ä")  | :%s/ä/\&auml;/g |endif
  if search("Ä")  | :%s/Ä/\&Auml;/g | endif
  if search("ö")  | :%s/ö/\&ouml;/g | endif
  if search("Ö")  | :%s/Ö/\&Ouml;/g | endif
  if search("ü")  | :%s/ü/\&uuml;/g | endif
  if search("Ü")  | :%s/Ü/\&Uuml;/g | endif
  if search("ß")  | :%s/ß/\&szlig;/g | endif
endfunction

" remove my own signature
map <C-z> :/^-- $/,$d "\<CR>"
" map <M-o> :FuzzyFinderTextMate<CR>

" rake support
au BufNewFile,BufRead *.rake         setf ruby
au BufNewFile,BufRead *.rjs         setf ruby
au BufNewFile,BufRead *.erb         setf ruby
au BufNewFile,BufRead *.cap         setf ruby
au BufNewFile,BufRead *.ru         setf ruby
au BufNewFile,BufRead *.xpain         setf ruby

au Filetype ruby let b:simplefold_expr = 
   \'\v(^\s*(def|class|module|attr_reader|attr_accessor|alias_method|' .
             \   'attr|module_function' . ')\s' . 
       \ '\v^\s*(public|private|protected)>' .
   \ '|^\s*\w+attr_(reader|accessor)\s|^\s*[#%"0-9]{0,4}\s*\{\{\{[^{])' .
   \ '|^\s*[A-Z]\w+\s*\=[^=]'
au Filetype ruby let b:simplefold_nestable_start_expr = 
   \ '\v^\s*(def>|if>|unless>|while>.*(<do>)?|' . 
            \         'until>.*(<do>)?|case>|for>|begin>)' .
            \ '|^[^#]*.*<do>\s*(\|.*\|)?'
au Filetype ruby let b:simplefold_nestable_end_expr = 
   \ '\v^\s*end'


" set cursorlinie
" set foldmethod=marker
" set foldenable

" syntax always on
syntax enable

function! CheckRubySyntax()
  execute "!ruby -c %"
endfunction

" enables ruby syntax check on every save method
" autocmd BufWritePost *.rb call CheckRubySyntax()
