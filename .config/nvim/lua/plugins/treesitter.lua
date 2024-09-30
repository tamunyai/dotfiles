-- Treesitter -----------------------------------------------------------------
local Treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
}

Treesitter.event = { "BufReadPost", "BufWritePost", "BufNewFile" }

Treesitter.dependencies = {
  {
    "windwp/nvim-ts-autotag", -- Automatically add closing tags for HTML and JSX
    opts = {},
  },
}

Treesitter.opts = {
  auto_install = true,
  ignore_install = { "gitcommit" },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

Treesitter.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
end

return Treesitter
