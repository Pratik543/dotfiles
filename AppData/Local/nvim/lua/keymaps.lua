vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "<C-g>", "<Esc>", { desc = "go to escape mode from insert mode" })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" }) --Normally, if you select text and paste (p/P), the deleted text goes into the default register, overwriting what you just pasted.
--This mapping avoids that by sending deleted text to the black hole register ("_).
vim.keymap.set("v", "p", '"_dp', opts)
--same as above for visual mode

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

-- Normal mode: Save file
vim.keymap.set("n", "<C-s>", ":w!<CR>", { noremap = true, silent = true })

-- Insert mode: Exit insert, save, and return to insert
vim.keymap.set("i", "<C-s>", "<Esc>:w!<CR>a", { noremap = true, silent = true })

-- Visual mode: Save file
vim.keymap.set("v", "<C-s>", "<Esc>:w!<CR>", { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>")
-- Next tab with Shift+Tab
vim.keymap.set("n", "<S-Tab>", "<cmd>tabn<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Go to start of line" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Go to end of line" })
