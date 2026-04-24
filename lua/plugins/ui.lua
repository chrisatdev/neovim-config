-- =============================================================================
-- ui.lua — Visual chrome: noice, bufferline, lualine, dashboard, which-key
-- =============================================================================

return {

	-- --------------------------------------------------------------------------
	-- nvim-notify — fancy notification popups
	-- --------------------------------------------------------------------------
	{
		"rcarriga/nvim-notify",
		lazy = true,
		opts = {
			timeout = 3000,
			stages = "fade",
			render = "wrapped-compact",
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			vim.notify = require("notify")
		end,
	},

	-- --------------------------------------------------------------------------
	-- noice.nvim — replaces cmdline, messages & popupmenu with fancy UI
	-- --------------------------------------------------------------------------
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { icon = "  " },
					search_down = { icon = "  ", lang = "regex" },
					search_up = { icon = "  ", lang = "regex" },
					filter = { icon = "  " },
					lua = { icon = "  " },
					help = { icon = "  " },
				},
			},
			messages = { enabled = true },
			lsp = {
				progress = {
					enabled = true,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30,
					view = "mini",
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
				},
				hover = { enabled = false }, -- handled by blink.cmp
			},
			presets = {
				bottom_search = true, -- search bar at the bottom
				command_palette = true, -- cmdline as floating palette
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
			views = {
				cmdline_popup = {
					position = { row = "35%", col = "50%" },
					size = { width = 64, height = "auto" },
					border = { style = "rounded", padding = { 0, 1 } },
				},
				popupmenu = {
					relative = "editor",
					position = { row = "40%", col = "50%" },
					size = { width = 64, height = 10 },
					border = { style = "rounded", padding = { 0, 1 } },
				},
				mini = {
					win_options = { winblend = 0 },
				},
			},
			routes = {
				-- Send "written" messages to mini view (bottom-right toast)
				{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
				-- Suppress common noise
				{ filter = { event = "msg_show", find = "%d+L, %d+B" }, opts = { skip = true } },
				{ filter = { event = "msg_show", find = "^Hunk " }, opts = { skip = true } },
			},
		},
		keys = {
			{
				"<leader>il",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice last message",
			},
			{
				"<leader>ih",
				function()
					require("noice").cmd("history")
				end,
				desc = "Noice history",
			},
			{
				"<leader>id",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss notifications",
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- bufferline.nvim — buffer tabs
	-- --------------------------------------------------------------------------
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin/unpin buffer" },
			{ "<leader>bc", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
			{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
			{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
		},
		opts = {
			options = {
				mode = "buffers",
				numbers = "none",
				close_command = function(n)
					local ok, br = pcall(require, "mini.bufremove")
					if ok then
						br.delete(n, false)
					else
						vim.cmd("bd " .. n)
					end
				end,
				indicator = { icon = "▎", style = "icon" },
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diag)
					local icons = { error = " ", warning = " " }
					return (diag.error and icons.error .. diag.error .. " " or "")
						.. (diag.warning and icons.warning .. diag.warning or "")
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = " File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				color_icons = true,
				separator_style = "slant",
				always_show_bufferline = false,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- lualine.nvim — statusline
	-- --------------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local icons = {
				diagnostics = { Error = " ", Warn = " ", Hint = " ", Info = " " },
				git = { added = " ", modified = " ", removed = " " },
			}
			return {
				options = {
					theme = "kanagawa",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard" } },
				},
				sections = {
					lualine_a = { { "mode", separator = { right = "" }, padding = { right = 1, left = 1 } } },
					lualine_b = {
						{ "branch", icon = "" },
					},
					lualine_c = {
						{
							"diagnostics",
							symbols = icons.diagnostics,
						},
						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							path = 1,
							symbols = { modified = "  ", readonly = "", unnamed = "" },
						},
					},
					lualine_x = {
						{
							"diff",
							symbols = icons.git,
							source = function()
								local gs = vim.b.gitsigns_status_dict
								if gs then
									return { added = gs.added, modified = gs.changed, removed = gs.removed }
								end
							end,
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						{
							function()
								return " " .. os.date("%R")
							end,
							separator = { left = "" },
						},
					},
				},
			}
		end,
	},

	-- --------------------------------------------------------------------------
	-- dashboard-nvim — startup screen
	-- --------------------------------------------------------------------------
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "echasnovski/mini.icons" },
		opts = function()
			local logo = [[

     ⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣶⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀
    ⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀
    ⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀
    ⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
    ⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⠀
    ⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⡟⠁⠀⠀⠀⠈⢻⣿⣿⣿⠀
    ⠀⣿⣿⣿⠛⠛⠛⠛⠛⠛⢛⣿⣮⣿⣿⣿⠀⠀⠀⠀⠀⠀⢈⣿⣿⡟⠀
    ⠀⠸⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⠃⠀
    ⠀⠀⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⠟⠉⠻⣿⣿⣿⣿⣶⣿⣿⣿⣿⣷⠀⠀
    ⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣠⣷⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀
    ⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠛⠋⠛⠙⠛⠙⠛⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀

      ]]
			logo = string.rep("\n", 6) .. logo .. "\n"

			local buttons = {
				{ action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
				{ action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
				{ action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
				{ action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
				{ action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
				{ action = "Lazy", desc = " Lazy plugins", icon = "󰒲 ", key = "l" },
				{ action = "Mason", desc = " Mason LSP", icon = " ", key = "m" },
				{ action = "qa", desc = " Quit", icon = " ", key = "q" },
			}

			for _, button in ipairs(buttons) do
				button.desc = button.desc .. string.rep(" ", 42 - #button.desc)
				button.key_format = "  %s"
			end

			return {
				theme = "doom",
				hide = { statusline = false },
				config = {
					header = vim.split(logo, "\n"),
					center = buttons,
					footer = function()
						local stats = require("lazy").stats()
						local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
						return {
							"⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
						}
					end,
				},
			}
		end,
	},

	-- --------------------------------------------------------------------------
	-- which-key.nvim — keybinding popup at the bottom (helix style)
	-- --------------------------------------------------------------------------
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern", -- bottom bar, like Helix editor
			delay = 300,
			icons = {
				mappings = true,
				keys = {},
			},
			spec = {
				-- Groups for <leader>
				{ "<leader>b", group = "buffers", icon = { icon = " ", color = "cyan" } },
				{ "<leader>c", desc = "Close buffer", icon = { icon = " ", color = "red" } },
				{ "<leader>f", group = "find", icon = { icon = " ", color = "blue" } },
				{ "<leader>g", group = "git", icon = { icon = " ", color = "green" } },
				{ "<leader>l", group = "lsp", icon = { icon = " ", color = "yellow" } },
				{ "<leader>m", group = "markdown", icon = { icon = " ", color = "purple" } },
				{ "<leader>i", group = "noice", icon = { icon = "󰍡 ", color = "grey" } },
				{ "<leader>o", group = "outline", icon = { icon = " ", color = "orange" } },
				{ "<leader>s", group = "splits", icon = { icon = " ", color = "cyan" } },
				{ "<leader>t", group = "terminal", icon = { icon = " ", color = "green" } },
				{ "<leader>x", group = "diagnostics", icon = { icon = "󱖫 ", color = "red" } },
				-- Standalone
				{ "<leader>e", desc = "File explorer (Oil)" },
				{ "<leader>r", desc = "Ranger file manager" },
				{ "<leader>n", desc = "New file" },
				{ "<leader>w", desc = "Save file" },
				{ "<leader>q", desc = "Quit nvim" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer keymaps (which-key)",
			},
		},
	},
}
