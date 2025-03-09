return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "moon",
			transparent = false,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
			},
		})

		vim.cmd("colorscheme tokyonight-moon")
	end,
	opts = {},
}
