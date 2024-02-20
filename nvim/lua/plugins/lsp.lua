local servers = {
	-- bash
	bashls = {},

	-- lua
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
				telemetry = { enable = false },
			},
		},
	},

	-- c
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

	-- python
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

local config = function()
	local lspconfig = require("lspconfig")

	local diagnostic_signs = {
		Error = " ",
		Warn = " ",
		Hint = "󰠠 ",
		Info = " ",
	}

	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local capabilities = cmp_nvim_lsp.default_capabilities()

	for lsp, config in pairs(servers) do
		lspconfig[lsp].setup(vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, config))
	end

	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			-- bash, csh, ksh, sh, zsh
			null_ls.builtins.formatting.beautysh,

			-- lua, luau
			null_ls.builtins.formatting.stylua,

			-- python
			-- null_ls.builtins.diagnostics.pycodestyle,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.black,

			-- c, cpp, cs, java, cuda, proto
			-- null_ls.builtins.formatting.clang_format,

			-- javascript, javascriptreact, typescript, typescriptreact
			-- vue, css, scss, less, html, json, jsonc, yaml, markdown,
			-- markdown.mdx, graphql, handlebars
			null_ls.builtins.diagnostics.eslint_d,
			null_ls.builtins.formatting.prettierd,
		},
		on_attach = function(client, bufnr)
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"nvimtools/none-ls.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = config,
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		keys = {
			{ "<leader>m", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			mason.setup({
				ui = {
					icons = {
						package_pending = " ",
						package_installed = "󰄳 ",
						package_uninstalled = " 󰚌",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = true,
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"stylua",
					"shfmt",
					"isort",
					"black",
					"shellcheck",
					"beautysh",
					-- "prettierd",
					-- "eslint_d",
					-- "clang-format",
				},
			})
		end,
	},
}
