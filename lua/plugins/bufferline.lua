	return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = "Bdelete! %d",
				right_mouse_command = "Bdelete! %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,
				buffer_close_icon = "✗",
				close_icon = "",
				path_components = 1,
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30,
				tab_size = 21,
				diagnostics = false,
				diagnostics_update_in_insert = false,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = true,
				persist_buffer_sort = true,
				separator_style = { "│", "│" },
				enforce_regular_tabs = true,
				always_show_bufferline = false,
				show_tab_indicators = false,
				indicator = {
					style = "none",
				},
				icon_pinned = "󰐃",
				minimum_padding = 1,
				maximum_padding = 5,
				maximum_length = 15,
			sort_by = "insert_at_end",
			},
			highlights = {
				separator = {
					fg = "#434C5E",
				},
				buffer_selected = {
					bold = true,
					italic = false,
				},
				-- separator_selected = {},
				-- tab_selected = {},
				-- background = {},
				-- indicator_selected = {},
				-- fill = {},
			},
		})

		-- Keymaps
		local opts = { noremap = true, silent = true, desc = "Go to Buffer" }
		-- vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
		-- vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
		-- vim.keymap.set('n', '<leader>1', "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", opts)
		-- vim.keymap.set('n', '<leader>2', "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", opts)
		-- vim.keymap.set('n', '<leader>3', "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", opts)
		-- vim.keymap.set('n', '<leader>4', "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", opts)
		-- vim.keymap.set('n', '<leader>5', "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", opts)
		-- vim.keymap.set('n', '<leader>6', "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", opts)
		-- vim.keymap.set('n', '<leader>7', "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", opts)
		-- vim.keymap.set('n', '<leader>8', "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", opts)
		-- vim.keymap.set('n', '<leader>9', "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", opts)
	end,
}
