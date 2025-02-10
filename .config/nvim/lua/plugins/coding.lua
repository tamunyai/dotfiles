-- nvim-cmp -------------------------------------------------------------------
local nvim_cmp = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
}

nvim_cmp.dependencies = {
  {
    -- snippet plugin
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    opts = { history = true, updateevents = "TextChanged,TextChangedI" },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)
    end,
  },

  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- cmp sources plugins
  {
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
  },

  -- {
  --   "Exafunction/codeium.nvim",
  --   cmd = "Codeium",
  --   build = ":Codeium Auth",
  --   opts = {},
  -- },

  "onsails/lspkind.nvim",
}

nvim_cmp.opts = {
  completion = {
    completeopt = "menu,menuone",
  },

  -- window = {
  -- 	completion = {
  -- 		side_padding = 1,
  -- 		winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
  -- 		scrollbar = false,
  -- 	},
  -- 	documentation = {
  -- 		winhighlight = "Normal:CmpDoc",
  -- 	},
  -- },

  experimental = {
    ghost_text = false,
    git = {
      async = true,
    },
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  sources = {
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "luasnip",  keyword_length = 2 },
    { name = "buffer",   keyword_length = 3 },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

nvim_cmp.config = function(_, opts)
  local cmp = require("cmp")

  for _, source in ipairs(opts.sources) do
    source.group_index = source.group_index or 1
  end

  opts.formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
      symbol_map = { Codeium = "" },

      before = function(_, vim_item)
        return vim_item
      end,
    }),
  }

  opts.mapping = {
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),

    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }

  cmp.setup(opts)

  -- Set configuration for specific filetype.
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = "buffer" },
    }),
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return nvim_cmp
