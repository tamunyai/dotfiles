return {
	{
		"Wansmer/treesj",
		keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
		opts = { use_default_keymaps = false, max_join_length = 150 },
	},

	{
		"nvim-pack/nvim-spectre",
		build = false,
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
		keys = {
			{
				"<leader>sr",
				function()
					require("spectre").open()
				end,
				desc = "Replace in Files (Spectre)",
			},
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
		},
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = true,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},

		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.5",
			cmd = "Telescope",
			dependencies = { "nvim-lua/plenary.nvim" },
			keys = {
				-- Telescope
				{ "<leader><space>", "<cmd>Telescope<cr>", desc = "Telescope" },
				{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
				{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
				{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
				{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },

				-- ToDo-comments
				{ "<leader>ft", "<cmd>Telescope todo-comments<cr>", desc = "Find Todo" },

				-- Diagnostics
				{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

				-- Git
				{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
				{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
				{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
				{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
			},
			opts = function()
				return {
					defaults = {
						vimgrep_arguments = {
							"rg",
							"-L",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
						},
						prompt_prefix = "   ",
						selection_caret = " ",
						entry_prefix = "  ",
						initial_mode = "insert",
						selection_strategy = "reset",
						sorting_strategy = "ascending",
						layout_strategy = "horizontal",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.55,
								results_width = 0.8,
							},
							vertical = {
								mirror = false,
							},
							width = 0.87,
							height = 0.80,
							preview_cutoff = 120,
						},
						file_sorter = require("telescope.sorters").get_fuzzy_file,
						file_ignore_patterns = { "node_modules" },
						generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
						path_display = { "truncate" },
						winblend = 0,
						border = {},
						borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						color_devicons = true,
						set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
						file_previewer = require("telescope.previewers").vim_buffer_cat.new,
						grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
						qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
						-- Developer configurations: Not meant for general override
						buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
						mappings = {
							i = {
								["<C-Down>"] = require("telescope.actions").cycle_history_next,
								["<C-Up>"] = require("telescope.actions").cycle_history_prev,
								["<C-j>"] = require("telescope.actions").preview_scrolling_down,
								["<C-k>"] = require("telescope.actions").preview_scrolling_up,
								["<Esc>"] = require("telescope.actions").close,
							},
							n = { ["q"] = require("telescope.actions").close },
						},
					},

					extensions_list = { "themes", "terms", "fzf" },
					extensions = {
						fzf = {
							fuzzy = true,
							override_generic_sorter = true,
							override_file_sorter = true,
							case_mode = "smart_case",
						},
					},
				}
			end,
		},
	},
}
