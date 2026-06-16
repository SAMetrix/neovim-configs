-- Global keybindings. Plugin-specific bindings live alongside their plugin configs
-- in after/plugin/ and plugin/. Leader is Space.
vim.g.mapleader = " "

-- <leader>cd is also mapped by yazi.nvim (after/plugin/yazi.lua) to open Yazi.
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- Move a visual selection up or down, re-indenting as it goes (mirrors VS Code Alt+Up/Down).
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join the line below onto the current line while keeping the cursor stationary.
vim.keymap.set("n", "J", "mzJ`z")

-- Half-page scroll keeping the cursor vertically centered.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep the current search match centered after n / N.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over a selection without replacing the clipboard with what was deleted.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Delete to the void register so the clipboard is never polluted by deletions.
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Ctrl-C in insert mode doesn't trigger InsertLeave autocmds the way Esc does;
-- this alias makes it behave identically.
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Quickfix navigation binds (Ctrl-J/K) kept here for reference but disabled
-- because those keys are used for window navigation below.
-- vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- Disable Ex mode — it's almost never intentional.
vim.keymap.set("n", "Q", "<nop>")

-- Location list navigation (different from the quickfix list).
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Run php-cs-fixer on the current file (LC/Laravel projects).
vim.keymap.set("n", "<leader>cc", "<cmd>!php-cs-fixer fix % --using-cache=no<cr>")

-- Substitute the word under the cursor everywhere on the current line.
-- Drops into command mode with the pattern pre-filled; add the replacement and press Enter.
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- Set the executable bit on the current file.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Yank into the system clipboard using OSC 52 escape codes so it works over SSH.
vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator')
vim.keymap.set('v', '<leader>y', '<Plug>OSCYankVisual')

-- Re-source init.lua without restarting Neovim.
vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

-- Toggle Undotree sidebar.
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Quickfix list controls.
vim.keymap.set("n", "<leader>cl", ":cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz")
vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz")

-- Open :checkhealth for the built-in LSP client.
vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP Info" })

-- Run the project Makefile in the current working directory.
vim.keymap.set("n", "<leader>mm", "<cmd>make<CR>")

-- Source the current file (useful when editing Lua plugin configs in-place).
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Window navigation — same keys as tmux-navigator so Ctrl-H/J/K/L move between
-- both Neovim splits and tmux panes seamlessly.
vim.keymap.set("n", "<C-k>", ":windcmd k<CR>")
vim.keymap.set("n", "<C-j>", ":windcmd j<CR>")
vim.keymap.set("n", "<C-h>", ":windcmd h<CR>")
vim.keymap.set("n", "<C-l>", ":windcmd l<CR>")
