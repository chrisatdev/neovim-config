return {
	"chrisatdev/toggle-vterm",
	keys = {
		-- Toggle horizontal terminal
		{
			"<leader>th",
			function()
				require("toggle-vterm").toggle_terminal("horizontal")
			end,
			desc = "Toggle horizontal terminal",
			mode = "n", -- Normal mode
		},
		-- Toggle vertical terminal
		{
			"<leader>tv",
			function()
				require("toggle-vterm").toggle_terminal("vertical")
			end,
			desc = "Toggle vertical terminal",
			mode = "n", -- Normal mode
		},
		-- Exit terminal mode
		{
			"<C-x>",
			"<C-\\><C-n>",
			desc = "Exit terminal mode",
			mode = "t", -- Terminal mode
		},
		-- Clear terminal screen
		{
			"<C-l>",
			"<cmd>clear<CR>",
			desc = "Clear terminal screen",
			mode = "t", -- Terminal mode
		},
	},
}
