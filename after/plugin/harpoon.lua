-- Harpoon v2 configuration.
-- Maintains a per-project list of pinned files for instant navigation.
-- The list persists across sessions automatically.
--
-- Keybindings:
--   <leader>a   add current file to the list
--   <C-e>       toggle the quick-menu (edit/reorder the list)
--   <C-p>       jump to the previous file in the list
--   <C-n>       jump to the next file in the list
--   <leader>fl  browse the list inside a Telescope Ivy picker

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

-- Open the Harpoon list in a Telescope Ivy window so it can be filtered/previewed.
vim.keymap.set("n", "<leader>fl", function()
    local conf = require("telescope.config").values
    local themes = require("telescope.themes")
    local file_paths = {}
    for _, item in ipairs(harpoon:list().items) do
        table.insert(file_paths, item.value)
    end
    require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Working List" }), {
        finder = require("telescope.finders").new_table({ results = file_paths }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end, { desc = "Open harpoon window" })
