-- nvim-treesitter ------------------------------------------------------------
local nvim_treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
}

nvim_treesitter.event = { "BufReadPost", "BufWritePost", "BufNewFile" }

nvim_treesitter.dependencies = {
  {
    "windwp/nvim-ts-autotag", -- Automatically add closing tags for HTML and JSX
    opts = {},
  },
}

nvim_treesitter.opts = {
  auto_install = true,
  ignore_install = { "gitcommit" },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

nvim_treesitter.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
end

return nvim_treesitter
