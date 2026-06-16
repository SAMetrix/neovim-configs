-- Telescope fuzzy-finder configuration and keybindings.
--
-- Inside any Telescope picker:
--   <C-j> / <C-k>  move selection down / up
--   <C-q>          send all results to the quickfix list and open it
--
-- Normal-mode pickers (all prefixed with <leader>f):
--   <leader>ff   find files under cwd
--   <leader>fo   recently opened files
--   <leader>fq   browse the quickfix list
--   <leader>fh   search :help tags
--   <leader>fm   search man pages (all sections)
--   <leader>fb   list open buffers
--   <leader>fg   grep for a string (prompts for input)
--   <leader>fc   grep for the current filename (without extension) across the project
--   <leader>fs   grep for the word currently under the cursor
--   <leader>fi   find files inside ~/.config/nvim/

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<leader>fq", builtin.quickfix)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fm", function()
    builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Telescope man pages" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
-- Grep for the current filename (stem only) — useful for finding all references
-- to a class or module that shares its name with the file.
vim.keymap.set("n", "<leader>fc", function()
    builtin.grep_string({ search = vim.fn.expand("%:t:r") })
end, { desc = "Find current file" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({})
end, { desc = "Find current string" })
vim.keymap.set("n", "<leader>fi", function()
    builtin.find_files({ cwd = "~/.config/nvim/" })
end)
