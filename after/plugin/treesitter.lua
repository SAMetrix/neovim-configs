-- Treesitter/filetype mappings that don't belong in plugin/tonysitter.lua.
-- Treesitter config (highlighting, text-objects) lives in plugin/tonysitter.lua.
-- Parsers are at ~/.local/share/nvim/site/parser/<lang>.so
-- Queries are at ~/.config/nvim/queries/<lang>/

-- Register the 'goon' extension so Neovim sets filetype=goon on *.goon files,
-- which in turn loads the custom parser and highlight queries.
vim.filetype.add({ extension = { goon = "goon" } })
