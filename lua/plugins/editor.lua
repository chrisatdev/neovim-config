-- =============================================================================
-- editor.lua — File navigation & editing utilities
-- oil.nvim, telescope, toggleterm (with opencode), ts-autotag, illuminate, todo-comments
-- =============================================================================

return {

	-- --------------------------------------------------------------------------
	-- oil.nvim — edit the filesystem like a buffer
	-- --------------------------------------------------------------------------
	{
		"stevearc/oil.nvim",
		lazy = false, -- load immediately; replaces netrw
		dependencies = { "echasnovski/mini.icons" },
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>", desc = "File explorer (Oil)" },
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
			-- { "<leader>E", "<cmd>Oil --float<cr>", desc = "File explorer (float)" },
		},
		opts = {
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = false,
			columns = { "icon", "permissions", "size", "mtime" },
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = { "actions.select", opts = { vertical = true } },
				["<C-h>"] = { "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-p>"] = "actions.preview",
				["<Esc>"] = "actions.close",
				["q"] = "actions.close",
				["<C-r>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
			view_options = {
				show_hidden = false,
				natural_order = true,
				sort = { { "type", "asc" }, { "name", "asc" } },
			},
			float = {
				padding = 2,
				max_width = 90,
				border = "rounded",
				win_options = { winblend = 0 },
			},
			preview = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				max_height = 0.9,
				min_height = { 5, 0.1 },
				border = "rounded",
				win_options = { winblend = 0 },
				update_on_cursor_moved = true,
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- ranger.nvim — ranger file manager integration
	-- --------------------------------------------------------------------------
	{
		"kelly-lin/ranger.nvim",
		cmd = { "Ranger" },
		keys = {
			{ "<leader>r", "<cmd>Ranger<cr>", desc = "Ranger file manager" },
		},
		opts = {
			enable_cmds = true,
			replace_netrw = false,
		},
	},

	-- --------------------------------------------------------------------------
	-- telescope.nvim — fuzzy finder (borderless Kanagawa style)
	-- --------------------------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "LSP symbols" },
			{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter" },
			-- Git-related
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "   ",
					multi_icon = " ",
					-- Borderless Telescope (blends with Kanagawa theme overrides in colorscheme.lua)
					borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "bottom",
							preview_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					sorting_strategy = "ascending",
					winblend = 0,
					file_ignore_patterns = {
						"node_modules/",
						".git/",
						"vendor/",
						"dist/",
						"build/",
						".next/",
						".cache/",
						"%.lock",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<Esc>"] = actions.close,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob",
							"!**/.git/*",
							"--glob",
							"!**/node_modules/*",
						},
					},
					live_grep = {
						additional_args = { "--hidden", "--glob", "!**/.git/*" },
					},
					buffers = {
						show_all_buffers = true,
						sort_mru = true,
						mappings = {
							i = { ["<C-d>"] = actions.delete_buffer },
						},
					},
				},
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

	-- --------------------------------------------------------------------------
	-- toggleterm.nvim — floating terminals
	-- --------------------------------------------------------------------------
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
		},
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.38)
				end
			end,
			open_mapping = [[<C-\>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			float_opts = {
				border = "curved",
				winblend = 3,
			},
			winbar = {
				enabled = false,
				name_formatter = function(term)
					return term.name
				end,
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			function _G.set_terminal_keymaps()
				local kopts = { buffer = 0, silent = true }
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], kopts)
				vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], kopts)
				vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], kopts)
				vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], kopts)
				vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], kopts)
			end
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},

	-- --------------------------------------------------------------------------
	-- opencode.nvim — AI assistant integration
	-- --------------------------------------------------------------------------
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		cmd = { "Opencode" },
		keys = {
			{
				"<leader>to",
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle opencode",
			},
			{
				"<leader>ta",
				function()
					require("opencode").ask("@this: ", { submit = true })
				end,
				desc = "Ask opencode…",
			},
			{
				"<leader>ts",
				function()
					require("opencode").select()
				end,
				desc = "Execute opencode action…",
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- nvim-ts-autotag — auto-close HTML/JSX/Vue tags via treesitter
	-- --------------------------------------------------------------------------
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- vim-illuminate — highlight other occurrences of word under cursor
	-- --------------------------------------------------------------------------
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = { providers = { "lsp" } },
			filetypes_denylist = { "oil", "dashboard", "lazy", "mason", "trouble" },
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
			-- Keep same navigation keys for illuminate references
			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " reference", buffer = buffer })
			end
			map("]]", "next")
			map("[[", "prev")
		end,
	},

	-- --------------------------------------------------------------------------
	-- todo-comments.nvim — highlight TODO / FIXME / HACK / NOTE comments
	-- --------------------------------------------------------------------------
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
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
				desc = "Prev todo comment",
			},
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todos (trouble)" },
		},
		opts = {
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,
		main = "ibl",
		opts = {
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
				show_exact_scope = false,
			},
			exclude = {
				filetypes = {
					"help",
					"startify",
					"dashboard",
					"packer",
					"neogitstatus",
					"NvimTree",
					"Trouble",
				},
			},
		},
	},
}
