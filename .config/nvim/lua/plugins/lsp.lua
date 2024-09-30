-- Mason ----------------------------------------------------------------------
local Mason = {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
}

Mason.keys = {
  { "<leader>m", "<cmd>Mason<cr>", desc = "[M]ason" },
}

Mason.tools = {
  "stylua",
  "shfmt",
  "prettierd",
  "black",
  "isort",
  "clang-format",
  "shellcheck",
  "beautysh",
  "markuplint",
  "stylelint",
}

Mason.opts = {
  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = "󰚌 ",
    },
  },
  ensure_installed = Mason.tools,
}

Mason.config = function(_, opts)
  require("mason").setup(opts)

  local mr = require("mason-registry")
  mr:on("package:install:success", function()
    vim.defer_fn(function()
      -- trigger FileType event to possibly load this newly installed LSP server
      require("lazy.core.handler.event").trigger({
        event = "FileType",
        buf = vim.api.nvim_get_current_buf(),
      })
    end, 100)
  end)

  mr.refresh(function()
    for _, tool in ipairs(opts.ensure_installed) do
      local package = mr.get_package(tool)
      if not package:is_installed() then
        package:install()
      end
    end
  end)
end

-- MasonLspConfig  ------------------------------------------------------------
local MasonLspConfig = {
  "williamboman/mason-lspconfig.nvim",
}

MasonLspConfig.servers = {

  cssls = {},

  css_variables = {},

  bashls = {},

  lua_ls = {
    single_file_support = true,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
        telemetry = { enable = false },
      },
    },
  },

  ts_ls = {
    root_dir = function(...)
      return require("lspconfig.util").root_pattern("package.json")(...)
    end,

    preferences = {
      disableSuggestions = true,
    },

    single_file_support = false,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "literal",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  clangd = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },

  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = false,
        analysis = {
          useLibraryCodeForTypes = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          autoImportCompletions = true,
        },
      },
    },
  },
}

MasonLspConfig.opts = {
  ensure_installed = vim.tbl_keys(MasonLspConfig.servers),
  automatic_installations = true,
}

MasonLspConfig.config = function(_, opts)
  require("mason-lspconfig").setup(opts)
end

-- NvimLspConfig --------------------------------------------------------------
local NvimLspConfig = {
  "neovim/nvim-lspconfig",
}

NvimLspConfig.opts = {
  diagnostics = {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = "󰠠 ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  },

  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },

    textDocument = {
      completion = {
        completionItem = {
          documentationFormat = { "markdown", "plaintext" },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  },

  automatic_installation = true,
}

NvimLspConfig.config = function(_, opts)
  local capabilities =
    vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), opts and opts.capabilities or {})

  vim.diagnostic.config(opts.diagnostics)

  for lsp, config in pairs(MasonLspConfig.servers) do
    require("lspconfig")[lsp].setup(vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, config))
  end

  local map = vim.keymap.set
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "D", vim.diagnostic.open_float, { desc = "Line [D]iagnostics" })
  map("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
  map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
end

-- NoneLs ---------------------------------------------------------------------
local NoneLS = {
  "nvimtools/none-ls.nvim",
}

NoneLS.config = function()
  local nls = require("null-ls")

  nls.setup({
    sources = {
      -- Formatting
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.shfmt,
      nls.builtins.formatting.prettierd,
      nls.builtins.formatting.black,
      nls.builtins.formatting.isort,
      nls.builtins.formatting.clang_format,
      nls.builtins.formatting.stylelint,

      -- Diagnostics
      nls.builtins.diagnostics.markuplint,
      -- nls.builtins.diagnostics.stylelint,

      -- Code Actions
      -- nls.builtins.code_actions.refactoring,
    },

    -- Auto-format and Organize imports on save
    on_attach = function(client, bufnr)
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- Organize imports if it's a TypeScript or JavaScript file
            if vim.bo.filetype == "typescript" or vim.bo.filetype == "javascript" then
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "",
              })
            end

            -- Format the file before saving
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,

    root_dir = require("null-ls.utils").root_pattern(
      ".neoconf.json", -- Neovim configuration marker
      "Makefile", -- Makefile used in many build systems
      ".git", -- Git repository marker
      "node_modules", -- Node.js project root
      "pyproject.toml", -- Python (PEP 518) configuration file
      "setup.py", -- Python project root for older setups
      "setup.cfg", -- Python setup configuration
      "Pipfile", -- Python Pipenv project root
      "poetry.lock", -- Poetry project root (Python)
      "Cargo.toml", -- Rust project root (Cargo package manager)
      "go.mod", -- Go module file (Go projects)
      "package.json", -- JavaScript/TypeScript project root (npm/yarn)
      "tsconfig.json", -- TypeScript configuration file
      ".eslintrc", -- ESLint configuration (JS/TS linting)
      "CMakeLists.txt", -- CMake project root (C/C++ projects)
      ".gcloudignore", -- Google Cloud specific marker
      "build.gradle", -- Gradle build file (Java projects)
      "pom.xml" -- Maven build file (Java projects)
    ),
  })

  vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "[G]lobal [F]ormat" })
end

return { Mason, MasonLspConfig, NvimLspConfig, NoneLS }
