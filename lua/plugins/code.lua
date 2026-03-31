-- =============================================================================
-- code.lua — Code quality: formatters, diagnostics panel, symbols outline
-- conform.nvim (format) + trouble.nvim (diagnostics) + outline.nvim (symbols)
-- Note: symbols-outline.nvim is unmaintained; outline.nvim is the successor
-- =============================================================================

return {

	-- --------------------------------------------------------------------------
	-- conform.nvim — formatter dispatcher
	-- Runs formatters in order; falls back to LSP formatting if none configured
	-- --------------------------------------------------------------------------
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer / selection",
			},
		},
		opts = {
			formatters_by_ft = {
				-- Web
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				-- Backend
				php = { "php_cs_fixer" },
				python = { "isort", "black" },
				go = { "goimports", "gofumpt" },
				rust = { "rustfmt" },
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				sql = { "sql_formatter" },
				toml = { "taplo" },
				-- Config
				dockerfile = { "prettier" },
			},
			-- Format on save (fast timeout; if too slow, remove this block)
			format_on_save = function(bufnr)
				-- Disable auto-format on certain files
				local disable_filetypes = { "sql", "gitcommit" }
				if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
			-- Formatter-specific options
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci" }, -- 2-space indent, case indent
				},
				sql_formatter = {
					prepend_args = { "--language", "sql" },
				},
				prettier = {
					prepend_args = {
						"--print-width",
						"100",
						"--single-quote",
						"--trailing-comma",
						"es5",
					},
				},
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- trouble.nvim v3 — diagnostics, references, quickfix panel
	-- --------------------------------------------------------------------------
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		dependencies = { "echasnovski/mini.icons" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
			{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (trouble)" },
			{ "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP refs/defs" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
			-- Navigate trouble items with [q / ]q (falls back to qf navigation)
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Prev trouble / quickfix",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next trouble / quickfix",
			},
		},
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
				diagnostics = {
					win = { size = { height = 12 } },
				},
			},
		},
	},

	-- --------------------------------------------------------------------------
	-- outline.nvim — symbols outline panel (successor to symbols-outline.nvim)
	-- --------------------------------------------------------------------------
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle outline" },
			{ "<leader>lo", "<cmd>OutlineFocus<cr>", desc = "Focus outline" },
		},
		opts = {
			outline_window = {
				position = "right",
				width = 25,
				relative_width = true,
				auto_close = false,
				auto_jump = false,
				show_numbers = false,
				show_relative_numbers = false,
				wrap = false,
				show_cursorline = true,
				hide_cursor = true,
				winhl = "NormalFloat:",
			},
			outline_items = {
				show_symbol_details = true,
				show_symbol_lineno = false,
				highlight_hovered_item = true,
				auto_set_cursor = true,
			},
			guides = { enabled = true },
			symbol_folding = {
				autofold_depth = 1,
				auto_unfold = {
					hovered = true,
					only = true,
				},
			},
			symbols = {
				icons = {
					File = { icon = "󰈙", hl = "Identifier" },
					Module = { icon = "󰆧", hl = "Include" },
					Namespace = { icon = "󰅪", hl = "Include" },
					Package = { icon = "󰏗", hl = "Include" },
					Class = { icon = "󰠱", hl = "Type" },
					Method = { icon = "󰊕", hl = "Function" },
					Property = { icon = "󰜢", hl = "Identifier" },
					Field = { icon = "󰇽", hl = "Identifier" },
					Constructor = { icon = "", hl = "Special" },
					Enum = { icon = "", hl = "Type" },
					Interface = { icon = "", hl = "Type" },
					Function = { icon = "󰊕", hl = "Function" },
					Variable = { icon = "󰀫", hl = "Constant" },
					Constant = { icon = "󰏿", hl = "Constant" },
					String = { icon = "󰀬", hl = "String" },
					Number = { icon = "󰎠", hl = "Number" },
					Boolean = { icon = "◩", hl = "Boolean" },
					Array = { icon = "󰅪", hl = "Constant" },
					Object = { icon = "󰅩", hl = "Type" },
					Key = { icon = "󰌋", hl = "Type" },
					Null = { icon = "󰟢", hl = "Type" },
					EnumMember = { icon = "", hl = "Identifier" },
					Struct = { icon = "󰙅", hl = "Type" },
					Event = { icon = "", hl = "Type" },
					Operator = { icon = "󰆕", hl = "Identifier" },
					TypeParameter = { icon = "󰊄", hl = "Identifier" },
					Component = { icon = "󰅴", hl = "Function" },
					Fragment = { icon = "󰅴", hl = "Constant" },
				},
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
		config = function()
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-/", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set(
				"v",
				"<C-_>",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-c>",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-/>",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
		end,
	},
}
