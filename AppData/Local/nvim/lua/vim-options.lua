-- ============================================================================
-- FILE: ~/.config/nvim/lua/vim-options.lua
-- ============================================================================
-- Basic settings
-- vim.o.shell = "pwsh.exe"
if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh.exe"
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.o.shellredir = "-RedirectStandardOutput %s -NewWindow -Wait"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
else
	vim.o.shell = "/bin/bash"
end

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Options
vim.opt.cmdheight = 0
vim.opt.equalalways = false
vim.opt.fillchars:append({ eob = " " })

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Highligt yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })

-- Terminal keybind
vim.keymap.set("n", "<leader>t", function()
	if vim.bo.buftype == "terminal" then
		vim.cmd("close")
	else
		vim.cmd("botright split | resize 12 | terminal pwsh")
		vim.cmd("startinsert")
	end
end, { silent = true })

vim.keymap.set("t", "<Esc>", function()
	vim.cmd("close")
end, { silent = true, desc = "Toggle terminal (PowerShell)" })

-- Close floating windows with q (safe for macros)
vim.keymap.set("n", "q", function()
	if vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative ~= "" then
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
	end
end, { desc = "Close floating window", silent = true })

-- Smart <Esc>: close floats, quickfix, clear highlights
vim.keymap.set("n", "<Esc>", function()
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)

	if cfg.relative and cfg.relative ~= "" then
		vim.api.nvim_win_close(win, false)
		return
	end

	-- Close quickfix or location list if open
	if vim.bo.filetype == "qf" or vim.fn.getwininfo(win)[1].loclist == 1 then
		vim.cmd("cclose | lclose")
		return
	end

	-- Clear search highlights
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Smart Esc: close float/qf or clear hlsearch", silent = true })
