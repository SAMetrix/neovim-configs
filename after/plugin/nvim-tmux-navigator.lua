-- Bindings for vim-tmux-navigator.
-- These let Ctrl-H/J/K/L move between Neovim splits and adjacent tmux panes
-- using the same keystrokes. The tmux side requires the corresponding plugin
-- or key-bindings in ~/.tmux.conf.
vim.keymap.set("n", "C-h", "TmuxNavigateLeft<CR>")
vim.keymap.set("n", "C-j", "TmuxNavigateDown<CR>")
vim.keymap.set("n", "C-k", "TmuxNavigateUp<CR>")
vim.keymap.set("n", "C-l", "TmuxNavigateRight<CR>")
