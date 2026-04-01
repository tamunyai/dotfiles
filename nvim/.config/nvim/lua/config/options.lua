local g = vim.g

g.mapleader = " " 													-- set global leader key to space
g.maplocalleader = " " 											-- set local leader key to space
g.markdown_recommended_style = 0 						-- disable automatic markdown formatting recommendations

local o = vim.opt

o.number = true 														-- show absolute line numbers
o.relativenumber = true 										-- show relative line numbers
o.ignorecase = true 												-- ignore case when searching
o.smartcase = true 													-- override 'ignorecase' if search contains uppercase letters
o.incsearch = true 													-- show search matches while typing
o.hlsearch = true 													-- highlight all matches from last search
-- o.signcolumn = "yes" 												-- always show the sign column
-- o.termguicolors = true 											-- enable true color support in terminal
o.encoding = "utf-8" 												-- set internal encoding to UTF-8
o.fileencoding = "utf-8" 										-- set default file encoding to UTF-8
o.mouse = "a" 															-- enable mouse support in all modes
o.tabstop = 2 															-- number of spaces that a <Tab> counts for
o.softtabstop = 2 													-- number of spaces when hitting <Tab> in insert mode
o.shiftwidth = 2 														-- number of spaces for auto-indent
o.expandtab = true 													-- convert tabs to spaces
o.wrap = false 															-- do not wrap long lines
o.breakindent = true 												-- wrap lines with indentation preserved
o.autoindent = true 												-- copy indent from current line when starting a new line
o.smartindent = true 												-- smart auto-indenting for programming
o.errorbells = false 												-- disable error bells
o.hidden = true 														-- allow switching buffers without saving
o.backup = false 														-- disable backup files
o.swapfile = false 													-- disable swap files
o.autowrite = true 													-- automatically save before certain commands
o.undofile = true 													-- enable persistent undo
o.title = true 															-- show file name in terminal title
o.cmdheight = 1 														-- height of the command line
o.foldlevel = 99 														-- open all folds by default
-- o.confirm = true 														-- ask for confirmation when closing unsaved files
o.undodir = vim.fn.expand("~/.vim/undodir") -- set directory for undo files
-- o.backspace = "indent,eol,start" 						-- make backspace more powerful in insert mode
o.cursorline = true 												-- highlight the current line
o.conceallevel = 3 													-- hide markup in certain filetypes (e.g., Markdown)
o.wildignore:append({ "*/node_modules/*" }) -- ignore in file completion
o.syntax = "on" 														-- enable syntax highlighting

-- o.autochdir = false 												-- Do not change working directory to that of the file
-- o.modifiable = true 												-- Allow modifications to the buffer

o.showmatch = true 													-- highlight matching brackets
o.scrolloff = 8 														-- keep 8 lines visible above/below the cursor when scrolling
o.sidescrolloff = 8 												-- keep 8 columns visible to the left/right when scrolling horizontally
o.splitbelow = true 												-- open horizontal splits below the current window
o.splitright = true 												-- open vertical splits to the right of the current window
-- o.switchbuf = { "useopen", "usetab", "newtab" }  -- smooth buffer switching
o.wildmenu = true 													-- enhanced command-line completion menu
-- o.pumheight = 15                      		-- maximum height for popup menu
o.completeopt = { "menuone", "noinsert", "noselect" } -- better completion experience
o.showmode = true 													-- display the current mode in the command line

o.laststatus = 2 														-- always display a status line
-- o.statusline = "%f%=%l/%L" 									-- custom statusline

-- use system clipboard for all operations ------------------------------------
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
