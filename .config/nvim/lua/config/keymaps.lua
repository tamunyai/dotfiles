local map = vim.keymap.set

-- Escape clears search highlight in insert and normal modes
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear search highlight" })

-- Smart navigation in visual and normal modes using j and k
local smart_nav = "v:count == 0 ? 'g%s' : '%s'"
map({ "n", "x" }, "j", smart_nav:format("j", "j"), { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", smart_nav:format("k", "k"), { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", smart_nav:format("j", "j"), { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", smart_nav:format("k", "k"), { desc = "Up", expr = true, silent = true })

-- Move lines up and down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Search result navigation
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

-- Indent and outdent in visual mode
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle Comment", remap = true })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "[Q]uit All" })

-- Execute code files
map("n", "<leader>ef", function()
  local file_name = vim.api.nvim_buf_get_name(0)
  local file_type = vim.bo.filetype
  local file_base_name = file_name:gsub("%.[^.]+$", "")

  -- Define commands for different file types
  local run_commands = {
    python = "python3 " .. file_name,
    javascript = "node " .. file_name,
    sh = "bash " .. file_name,
    cpp = "g++ " .. file_name .. " -o " .. file_base_name .. " && " .. file_base_name .. " && rm -f " .. file_base_name,
    c = "gcc " .. file_name .. " -o " .. file_base_name .. " && " .. file_base_name .. " && rm -f " .. file_base_name,
  }

  -- Check if the file type is supported and run the command
  if run_commands[file_type] then
    vim.cmd(":botright sp | terminal " .. run_commands[file_type])
    vim.cmd("startinsert") -- Automatically enter insert mode in the terminal
  else
    print("This file type is not supported for execution: " .. file_type)
  end
end, { noremap = true, silent = true, desc = "[E]xecute [F]ile" })
