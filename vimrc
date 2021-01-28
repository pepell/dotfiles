set encoding=utf-8

" Vim-plug se ha de instalar previamente de manera manual
" se podría hacer de manera automática. Ver por ejemplo:
" https://github.com/quiqueporta/dotfiles/blob/master/vimrc

call plug#begin("~/.vim/plugged")

" Color-scheme
Plug 'morhetz/gruvbox'

" File browser
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code and files fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Ack code search (requires ack or ag installed in the system)
Plug 'mileszs/ack.vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" VimWiki
Plug 'vimwiki/vimwiki'

" CtrlP
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

" no vi-compatible
set nocompatible

" Para evitar algunos problemas de seguridad ¿?
set modelines=0

" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" always show status bar
set ls=2

" syntax highlight on
syntax on

" flash screen instead of sounding a beep
set visualbell

" Work together to highlight search results
set incsearch
set showmatch
set hlsearch

" search
set incsearch " incremental search
set ignorecase " search is case insensitive but you can add \C to make it sensitive
set smartcase " will automatically switch to a case-sensitive search if you use any capital letters

" tabs and spaces handling
set expandtab " hitting Tab in insert mode will produce the appropriate number of spaces
set tabstop=4 " tell vim how many columns a tab counts for
set softtabstop=4 " control how many columns vim uses when you hit Tab in insert mode
set shiftwidth=4 " control how many columns text is indented with the reindent operations (<< and >>)

" swap, backup and undo files
set directory=~/.vim/dirs/tmp     " folder for swap files
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " folder for backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo " if you exit vim and later start, vim remembers information like, command line history, search history, marks, etc ...

" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" show
set ruler " show the line and column number of the cursor position
set number " precede each line with its line number

" show tabs, eol and spaces
set list
" chars to use to show the tabs, eol and spaces
set listchars=tab:▸\ ,eol:¬,trail:·

" show rule in colum 100
set colorcolumn=100

" Handle long lines correctly
set wrap
set formatoptions=qrn1

set backspace=indent,eol,start

" how to split windows
set splitbelow
set splitright

au VimResized *:wincmd = " resize splits when windows are reduced

" show cursor line
set cursorline

augroup cline
  " delete any old autocommand
  au!
  " remove cursor line on windows leave and when on insert mode
  au WinLeave,InsertEnter * set nocursorline
  " show cursor line on window enter or when exit from insert mode
  au WinEnter,InsertLeave * set cursorline
augroup END

" use 256 colors when possible
set background=dark
colorscheme gruvbox
set t_Co=256
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set wildmenu

" when scrolling, keep cursor 5 lines away from screen border
set scrolloff=5

if has("gui_running")
    set guioptions-=T
    set guifont=Noto\ Mono\ for\ Powerline\ 11
    "set guifont=JetBrainsMono\ Nerd\ Font\ Regular\ 11
    set columns=120
    set lines=45
endif

" ==============================
" filetype customization
" ==============================
autocmd FileType markdown set colorcolumn=80
autocmd Filetype markdown setlocal textwidth=80

autocmd Filetype rst set colorcolumn=80
autocmd Filetype rst setlocal textwidth=80

autocmd Filetype html setlocal ts=2 sts=2 sw=2

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" ==============================
" mappings
" ==============================

" :map and :noremap are recursive and non-recursive

let mapleader=","

" Clear out a search
nnoremap <leader><space> :noh<cr>

" key mapping for save file
nnoremap <F2> <esc>:w<CR>
inoremap <F2> <esc>:w<CR>
vnoremap <F2> <esc>:w<CR>

" Movimiento por los diferentes buffers
" Configuración tomada de http://statico.github.com/vim.html
" Volver al buffer previamente editado
nmap <C-e> :e#<CR>
" Moverse por todos los buffers abiertos
nmap <C-Tab> :bnext<CR>
nmap <C-S-Tab> :bprev<CR>

" Tab key match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" ============================
" Plugins configuration
" ============================

" NERDTree ------------------------------

" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap <F4> :NERDTreeFind<CR>
" dont show this files
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '__pycache__']
" show cursor line
let NERDTreeHighlightCursorline = 1

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" Airline -------------------------------
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
"let g:airline_symbols.linenr = '¶'
let g:airline_symbols.linenr = ''
"let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'
let g:airline_symbols.notexists = 'Ɇ'

" Fuzzy finder -------------------------
nnoremap <leader>e :GFiles<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>m :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>W :Windows<CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--preview', '--info=inline']}, <bang>0)

" Ack ----------------------------------
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
nnoremap <Leader>w :Ack! --py --ignore migrations --ignore tests<space>
let g:ackprg = "ag --vimgrep"
let g:ackhighlight = 1

" VimWiki ------------------------------
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [
    \{'path': '~/NextCloud/PIM/db', 'syntax': 'markdown', 'ext': '.md', 'index': 'index'},
    \{'path': '~/NextCloud/Notes', 'syntax': 'markdown', 'ext': '.md', 'index': 'index'}
    \]

" CtrlP --------------------------------
nnoremap ; :CtrlPBuffer<CR>
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

