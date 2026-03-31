-- =============================================================================
-- keymaps.lua — Core key mappings (plugin keymaps live in their own files)
-- =============================================================================

local map = function(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { silent = true, noremap = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- ----------------------------------------------------------------------------
-- Escape
-- ----------------------------------------------------------------------------
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ----------------------------------------------------------------------------
-- File operations
-- ----------------------------------------------------------------------------
map({ "n", "i" }, "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit nvim" })
map("n", "<leader>n", "<cmd>ene | startinsert<cr>", { desc = "New file" })

-- Close buffer (uses mini.bufremove when available, fallback to :bd)
map("n", "<leader>c", function()
	local ok, bufremove = pcall(require, "mini.bufremove")
	if ok then
		bufremove.delete(0, false)
	else
		vim.cmd("bd")
	end
end, { desc = "Close buffer" })

-- ----------------------------------------------------------------------------
-- Buffer navigation — Shift+H / Shift+L
-- ----------------------------------------------------------------------------
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- ----------------------------------------------------------------------------
-- Split management
-- <leader>s group defined in which-key
-- ----------------------------------------------------------------------------
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>sc", "<cmd>close<cr>", { desc = "Close split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })

-- Navigate between splits — Ctrl+hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- Resize splits — Ctrl+Arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- ----------------------------------------------------------------------------
-- Better editing experience
-- ----------------------------------------------------------------------------

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Keep cursor centered on search jumps
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Indent without losing visual selection
map("v", "<", "<gv", { desc = "Indent left (stay in visual)" })
map("v", ">", ">gv", { desc = "Indent right (stay in visual)" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without overwriting the unnamed register
map("x", "<leader>p", [["_dP]], { desc = "Paste (preserve register)" })

-- Delete to void register (don't pollute clipboard)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines (cursor stays)" })

-- ----------------------------------------------------------------------------
-- File explorer
-- ----------------------------------------------------------------------------
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent dir" })

-- ----------------------------------------------------------------------------
-- Quick config access
-- ----------------------------------------------------------------------------
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
