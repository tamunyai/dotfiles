let mapleader = " "													" set global leader key to space
let maplocalleader = " "										" set local leader key to space
let g:markdown_recommended_style = 0				" disable automatic markdown formatting recommendations

set number																	" show absolute line numbers
set relativenumber													" show relative line numbers
set ignorecase															" ignore case when searching
set smartcase																" override 'ignorecase' if search contains uppercase letters
set incsearch																" show search matches while typing
set hlsearch																" highlight all matches from last search
set signcolumn=yes													" always show the sign column
set termguicolors														" enable true color support in terminal
set encoding=utf-8													" set internal encoding to UTF-8
set fileencoding=utf-8											" set default file encoding to UTF-8
set mouse=a																	" enable mouse support in all modes
set tabstop=2																" number of spaces that a <Tab> counts for
set softtabstop=2														" number of spaces when hitting <Tab> in insert mode
set shiftwidth=2														" number of spaces for auto-indent
set expandtab																" convert tabs to spaces
set nowrap																	" do not wrap long lines
set breakindent															" wrap lines with indentation preserved
set autoindent															" copy indent from current line when starting a new line
set smartindent															" smart auto-indenting for programming
set noerrorbells														" disable error bells
set hidden																	" allow switching buffers without saving
set nobackup																" disable backup files
set noswapfile															" disable swap files
set autowrite																" automatically save before certain commands
set undofile																" enable persistent undo
set title																		" show file name in terminal title
set cmdheight=1															" height of command line
set foldlevel=99														" open all folds by default
" set confirm																	" ask for confirmation when closing unsaved files
set undodir=~/.vim/undodir									" set directory for undo files
" set backspace=indent,eol,start							" make backspace more powerful in insert mode
set cursorline															" highlight the current line
set conceallevel=3													" hide markup in certain filetypes (e.g., Markdown)
set wildignore+=*/node_modules/*						" ignore in file completion
syntax on																		" enable syntax highlighting

set showmatch              									" highlight matching brackets
set scrolloff=8            									" keep 8 lines visible when scrolling
set sidescrolloff=8        									" keep horizontal margin when scrolling
set splitbelow             									" open horizontal splits below
set splitright             									" open vertical splits to the right
" set switchbuf=useopen,usetab,newtab 				" smooth buffer switching
set wildmenu               									" enhanced command-line completion menu
" set pumheight=15														" maximum height for popup menu
set completeopt=menuone,noinsert,noselect		" better completion experience
set showmode																" display the current mode in command line

set laststatus=2 														" always display a status line
" set statusline=%f%=%l/%L										" custom statusline

" --- use system clipboard for all operations ---------------------------------
if exists('$SSH_TTY')
	set clipboard=
else
	set clipboard=unnamedplus
endif
