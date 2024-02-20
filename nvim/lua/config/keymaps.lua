local map = vim.keymap.set

-- Escape clears search highlight in insert and normal modes
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search highlight" })

-- Smart navigation in visual and select modes using j and k
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
