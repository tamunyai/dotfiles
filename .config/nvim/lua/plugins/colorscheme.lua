-- OneDark --------------------------------------------------------------------
local OneDark = {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
}

OneDark.opts = {
  style = "darker",
  transparent = true,
  lualine = { transparent = true },
  diagnostics = { darker = true, undercurl = true },
}

OneDark.config = function(_, opts)
  require("onedark").setup(opts)
  vim.cmd.colorscheme("onedark")
end

return OneDark
