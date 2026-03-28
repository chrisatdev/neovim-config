return {
	"coder/claudecode.nvim",
	-- dependencies = { "MunifTanjim/nui.nvim" },
	dependencies = { "folke/snacks.nvim" },
	config = function()
		require("claudecode").setup()
	end,
	opts = {
		terminal_cmd = "~/.local/bin/claude",
		-- Terminal Configuration
		terminal = {
			split_side = "right", -- "left" or "right"
			split_width_percentage = 0.30,
			provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
			auto_close = true,
		},
	},
	keys = {
		{ "<leader>m", nil, desc = "AI/Claude Code" },
		{ "<leader>mc", "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", desc = "Toggle Claude" },
		{
			"<leader>mf",
			"<cmd>ClaudeCodeFocus --dangerously-skip-permissions<cr>",
			desc = "Focus Claude",
		},
		{
			"<leader>mr",
			"<cmd>ClaudeCode --resume --dangerously-skip-permissions<cr>",
			desc = "Resume Claude",
		},
		{
			"<leader>mC",
			"<cmd>ClaudeCode --continue --dangerously-skip-permissions<cr>",
			desc = "Continue Claude",
		},
		{ "<leader>mm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>mb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{
			"<leader>ms",
			"<cmd>ClaudeCodeSend<cr>",
			mode = "v",
			desc = "Send to Claude",
		},
		{
			"<leader>,s",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>ma", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>md", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
