local function create_augroup(name)
	return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Refresh the file when Vim gains focus, closes a terminal, or leaves a terminal
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = create_augroup("checktime"),
	command = "checktime",
})

-- Highlight yanked text after pasting
vim.api.nvim_create_autocmd("TextYankPost", {
	group = create_augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Adjust window sizes when Vim is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = create_augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()

		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Jump to the last cursor position after opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = create_augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf

		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end

		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)

		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close specific file types with 'q' and hide them from the buffer list
vim.api.nvim_create_autocmd("FileType", {
	group = create_augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Enable word wrapping and spell check for specific file types
vim.api.nvim_create_autocmd("FileType", {
	group = create_augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto-create directories before saving a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = create_augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end

		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Map the following keys after the language server attaches to the
-- current buffer
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = create_augroup("lsp"),
-- 	callback = function(ev)
-- 		-- Enable completion triggered by <c-x><c-o>
-- 		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

-- 		-- Buffer local mappings.
-- 		local map = vim.keymap.set
-- 		local opts = { buffer = ev.buf, silent = true }

-- 		opts.desc = "Show documentation for what is under cursor"
-- 		map("n", "K", vim.lsp.buf.hover, opts)

-- 		opts.desc = "Smart Rename"
-- 		map("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- 		opts.desc = "Show Line Diagnostics"
-- 		map("n", "D", vim.diagnostic.open_float, opts)

-- 		opts.desc = "Previous Diagnostic"
-- 		map("n", "[d", vim.diagnostic.goto_prev, opts)

-- 		opts.desc = "Next Diagnostic"
-- 		map("n", "]d", vim.diagnostic.goto_next, opts)

-- 		opts.desc = "See available Code Actions"
-- 		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
-- 	end,
-- })
