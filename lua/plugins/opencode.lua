return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", optional = true, opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {}

		vim.o.autoread = true

		vim.api.nvim_create_autocmd("BufAdd", {
			callback = function(args)
				local buf = args.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				local name = vim.api.nvim_buf_get_name(buf)
				local name_lower = name:lower()
				if name_lower:find("opencode") and name_lower:find("port") then
					vim.bo[buf].buflisted = false
				end
			end,
		})

		-- Opencode keymaps using <leader>o prefix to avoid conflicts
		-- Main toggle: <leader>oo for easy open/close
		vim.keymap.set({ "n", "t" }, "<leader>oo", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode…" })

		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })

		vim.keymap.set({ "n", "x" }, "<leader>or", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		vim.keymap.set("n", "<leader>ol", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		vim.keymap.set("n", "<leader>ou", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<leader>od", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
