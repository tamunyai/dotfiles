-- onedark.nvim ---------------------------------------------------------------
local onedark = {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
}

onedark.opts = {
  style = "darker",
  transparent = true,
  lualine = { transparent = true },
  diagnostics = { darker = true, undercurl = true },
}

onedark.config = function(_, opts)
  require("onedark").setup(opts)
  vim.cmd.colorscheme("onedark")
end

return onedark
