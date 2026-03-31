-- =============================================================================
-- options.lua — Neovim global settings
-- =============================================================================

local opt = vim.opt

-- ----------------------------------------------------------------------------
-- Line numbers
-- ----------------------------------------------------------------------------
opt.number = true -- absolute line number on current line
opt.relativenumber = true -- relative numbers for all other lines

-- ----------------------------------------------------------------------------
-- Indentation — spaces only, never tabs
-- ----------------------------------------------------------------------------
opt.expandtab = true -- <Tab> inserts spaces
opt.tabstop = 2 -- visual width of a tab character
opt.shiftwidth = 2 -- indent size for >> / << / autoindent
opt.softtabstop = 2 -- <BS> removes shiftwidth spaces at once
opt.autoindent = true -- copy indent from previous line
opt.smartindent = true -- smarter indent for C-like code

-- ----------------------------------------------------------------------------
-- Text display
-- ----------------------------------------------------------------------------
opt.linebreak = true -- wrap at word boundaries (no mid-word breaks)
opt.wrap = true -- enable line wrapping
opt.scrolloff = 8 -- keep N lines above/below cursor
opt.sidescrolloff = 8 -- keep N cols left/right of cursor
opt.showmode = false -- mode shown by lualine, not built-in
opt.cursorline = false -- highlight current line
opt.signcolumn = "yes" -- always show gutter (no layout shift)
opt.laststatus = 3 -- single global statusline

-- ----------------------------------------------------------------------------
-- Visual
-- ----------------------------------------------------------------------------
opt.termguicolors = true -- true-color support
opt.fillchars = {
	eob = " ", -- hide ~ for empty lines at EOF
	fold = " ",
	foldopen = "▾",
	foldclose = "▸",
	foldsep = " ",
	diff = "╱",
	vert = "▕",
}

-- ----------------------------------------------------------------------------
-- Clipboard — sync with the OS
-- ----------------------------------------------------------------------------
opt.clipboard = "unnamedplus"

-- ----------------------------------------------------------------------------
-- Files — no backup noise
-- ----------------------------------------------------------------------------
opt.backup = false -- no .bak files
opt.swapfile = false -- no .swp files
opt.writebackup = false -- no backup before overwrite
opt.undofile = true -- persistent undo across sessions
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- ----------------------------------------------------------------------------
-- Search
-- ----------------------------------------------------------------------------
opt.ignorecase = true -- case-insensitive search…
opt.smartcase = true -- …unless uppercase letters are used
opt.hlsearch = true -- highlight all matches
opt.incsearch = true -- show matches while typing

-- ----------------------------------------------------------------------------
-- Splits
-- ----------------------------------------------------------------------------
opt.splitbelow = true -- horizontal splits open below
opt.splitright = true -- vertical splits open to the right

-- ----------------------------------------------------------------------------
-- Completion
-- ----------------------------------------------------------------------------
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- max items in completion menu

-- ----------------------------------------------------------------------------
-- Performance
-- ----------------------------------------------------------------------------
opt.updatetime = 200 -- faster CursorHold events
opt.timeoutlen = 300 -- which-key popup delay

-- ----------------------------------------------------------------------------
-- Misc
-- ----------------------------------------------------------------------------
opt.mouse = "a" -- enable mouse in all modes
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.virtualedit = "block" -- free cursor in visual block
opt.inccommand = "nosplit" -- live preview of :substitute
opt.conceallevel = 2 -- hide markup in markdown etc.
opt.spelllang = { "en_us" }
opt.confirm = true -- ask before closing unsaved buffers
