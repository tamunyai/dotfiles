-- lualine.nvim ---------------------------------------------------------------
local lualine = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
}

lualine.dependencies = {
  "nvim-tree/nvim-web-devicons",
}

lualine.init = function()
  vim.g.lualine_laststatus = vim.o.laststatus
  if vim.fn.argc(-1) > 0 then
    -- set an empty statusline till lualine loads
    vim.o.statusline = " "
  else
    -- hide the statusline on the starter page
    vim.o.laststatus = 0
  end
end

lualine.opts = function()
  vim.o.laststatus = vim.g.lualine_laststatus

  return {
    options = {
      theme = "auto",
      icons_enabled = true,
      component_separators = "|",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      section_separators = { left = "", right = "" },
      always_divide_middle = true,
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch", icon = "" },
      },
      lualine_c = {
        "filename",
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            hint = " ",
            info = " ",
          },
        },
      },

      lualine_x = {
        {
          "diff",
          symbols = {
            added = " ",
            modified = " ",
            removed = " ",
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict

            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.modified,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        "encoding",
        "filetype",
      },
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return "  " .. os.date("%R")
        end,
      },
    },

    extensions = { "neo-tree", "lazy" },
  }
end

-- indent.blankline.nvim ------------------------------------------------------
local indent_blankline = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
}

indent_blankline.exclude_filetypes = {
  "help",
  "alpha",
  "dashboard",
  "neo-tree",
  "Trouble",
  "trouble",
  "lazy",
  "mason",
  "notify",
  "toggleterm",
  "lazyterm",
  "terminal",
  "lspinfo",
  "TelescopePrompt",
  "TelescopeResults",
}

indent_blankline.opts = {
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = { enabled = false },
  exclude = { filetypes = indent_blankline.exclude_filetypes },
}

-- mini.indentscope -----------------------------------------------------------
local mini_indentscope = {
  "echasnovski/mini.indentscope",
  version = false,
}

mini_indentscope.event = {
  "BufReadPost",
  "BufWritePost",
  "BufNewFile",
}

mini_indentscope.opts = {
  symbol = "│",
  options = { try_as_border = true },
}

mini_indentscope.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = indent_blankline.exclude_filetypes,
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end

return { lualine, indent_blankline, mini_indentscope }
