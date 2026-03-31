-- =============================================================================
-- autocmds.lua — Autocommands
-- =============================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- ----------------------------------------------------------------------------
-- Highlight yanked text briefly
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ----------------------------------------------------------------------------
-- Equalize splits on window resize
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group    = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ----------------------------------------------------------------------------
-- Restore cursor to last known position on file open
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  group    = augroup("last_position"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then
      return
    end
    local mark  = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ----------------------------------------------------------------------------
-- Close utility windows with <q>
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("close_with_q"),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf",
    "checkhealth", "trouble", "oil_preview",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ----------------------------------------------------------------------------
-- Strip trailing whitespace on save (preserve cursor position)
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("trailing_whitespace"),
  pattern  = { "*.lua", "*.php", "*.py", "*.go", "*.rs", "*.js", "*.ts", "*.tsx", "*.html", "*.css", "*.sh", "*.sql" },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- ----------------------------------------------------------------------------
-- Set .env files as shell syntax (bash-language-server compatible)
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group   = augroup("env_filetype"),
  pattern = { ".env", ".env.*", "*.env" },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

-- ----------------------------------------------------------------------------
-- Disable indentscope in certain file types (prevents visual noise)
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("no_indentscope"),
  pattern = { "dashboard", "help", "lazy", "mason", "oil", "toggleterm", "trouble" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- ----------------------------------------------------------------------------
-- Auto-create parent directories on save (useful for new files)
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ----------------------------------------------------------------------------
-- Terminal keymaps: exit to normal
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
  group   = augroup("terminal_keymaps"),
  callback = function()
    vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { buffer = 0, noremap = true, silent = true, desc = "Exit to normal mode" })
  end,
})
