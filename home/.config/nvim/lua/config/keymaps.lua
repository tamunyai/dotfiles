local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save the current file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "[Q]uit the current window" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "[Q]uit All" })

-- indent and outdent in visual mode
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- paste without overwriting the unnamed register
map("v", "p", '"_dP', { desc = "[P]aste without overwriting unnamed register" })

-- buffer navigation
map("n", "<Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- clear search highlights when pressing <Esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear search highlight" })

-- use gj/gk instead of j/k if no count is provided
local smart_nav = "v:count == 0 ? 'g%s' : '%s'"
map({ "n", "x" }, "j", smart_nav:format("j", "j"), { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", smart_nav:format("k", "k"), { desc = "Up", expr = true, silent = true })

-- move lines up and down -----------------------------------------------------
map("n", "J", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "K", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- n/N follow search direction properly even after reverse search -------------
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

-- execute current file -------------------------------------------------------
map("n", "<leader>ef", function()
  local file_name = vim.api.nvim_buf_get_name(0)
  local file_type = vim.bo.filetype
  local file_base_name = file_name:gsub("%.[^.]+$", "")

  file_name = file_name:gsub('(["\\ ])', "\\%1")

  -- define commands for different file types
  local run_commands = {
    python = "python3 -u " .. file_name,
    javascript = "node " .. file_name,
    sh = "bash " .. file_name,
    cpp = "g++ " .. file_name .. " -o " .. file_base_name .. " && " .. file_base_name .. " && rm -f " .. file_base_name,
    c = "gcc " .. file_name .. " -o " .. file_base_name .. " && " .. file_base_name .. " && rm -f " .. file_base_name,
  }

  -- check if the file type is supported and run the command
  if run_commands[file_type] then
    vim.cmd(":botright sp | terminal " .. run_commands[file_type])
    vim.cmd("startinsert") -- automatically enter insert mode in the terminal
  else
    print("This file type is not supported for execution: " .. file_type)
  end
end, { noremap = true, silent = true, desc = "[E]xecute [F]ile" })
