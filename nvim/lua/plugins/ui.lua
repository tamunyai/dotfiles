local exclude_filetypes = {
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
	"mason",
	"",
}

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return {
				options = {
					component_separators = "|",
					section_separators = { left = "", right = "" },
					globalstatus = true,
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
						-- "fileformat",
						"filetype",
					},
					lualine_y = {
						-- { "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
			}
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = { filetypes = exclude_filetypes },
		},
		main = "ibl",
	},

	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = exclude_filetypes,
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	{ "folke/which-key.nvim", opts = {} },

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				-- 				filter = {
				-- 					event = "msg_show",
				-- 					any = {
				-- 						{ find = "%d+L, %d+B" },
				-- 						{ find = "; after #%d+" },
				-- 						{ find = "; before #%d+" },
				-- 					},
				-- 				},
				view = "mini",
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
		dependencies = { "MunifTanjim/nui.nvim" },
	},
}
