local g = vim.g

-- Set leader keys for shortcuts
g.mapleader = " " -- Space as the leader key
g.maplocalleader = " " -- Backslash as the local leader key

-- Markdown settings
g.markdown_recommended_style = 0 -- Disable recommended markdown style

local o = vim.opt

-- General encoding settings
o.encoding = "utf-8" -- Use UTF-8 encoding for files
o.fileencoding = "utf-8" -- Set the file encoding for files being edited

-- Search settings
o.hlsearch = true -- Highlight all matches on previous search
o.incsearch = true -- Show search matches as you type
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Override 'ignorecase' if search contains uppercase

-- Display settings
o.number = true -- Show line numbers
o.relativenumber = true -- Show relative line numbers
o.signcolumn = "yes" -- Always show the sign column for error indicators
o.termguicolors = true -- Enable 24-bit RGB color support

-- Mouse and clipboard settings
o.mouse = "a" -- Enable mouse support in all modes
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Use system clipboard for all operations

-- Indentation settings
o.tabstop = 2 -- Number of spaces that a <Tab> counts for
o.softtabstop = 2 -- Number of spaces a <Tab> counts in insert mode
o.shiftwidth = 2 -- Number of spaces to use for (auto)indent
o.breakindent = true -- Break lines at indent level
o.autoindent = true -- Copy indent from current line when starting a new line
o.smartindent = true -- Smartly indent new lines based on context

-- Wrapping and visual settings
o.wrap = false -- Do not wrap long lines
o.errorbells = false -- Disable error bells
o.title = true -- Set the terminal title to the current file name

-- Undo settings
o.undofile = true -- Enable persistent undo
o.undodir = vim.fn.expand("~/.vim/undodir") -- Directory for undo files
o.hidden = true -- Allow switching buffers without saving

-- File settings
o.backup = false -- Do not create backup files
o.swapfile = false -- Do not create swap files
o.autowrite = true -- Automatically write files when switching buffers
o.confirm = true -- Confirm before exiting if changes are unsaved
o.cmdheight = 1 -- Height of the command line
o.foldlevel = 99 -- Open all folds by default

-- Backspace settings
o.backspace = "indent,eol,start" -- Allow backspacing over indents, line breaks, and start of insert
o.autochdir = false -- Do not change working directory to that of the file

-- Additional settings
o.modifiable = true -- Allow modifications to the buffer

o.cursorline = true
o.expandtab = true

o.syntax = "on"

o.conceallevel = 3

o.wildignore:append({ "*/node_modules/*" })
