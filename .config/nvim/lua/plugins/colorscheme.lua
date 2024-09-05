return {
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "darker",
		transparent = true,
		lualine = { transparent = true },
		diagnostics = { darker = true, undercurl = true },
	},
	config = function(_, opts)
		require("onedark").setup(opts)
		vim.cmd.colorscheme("onedark")
	end,
}
