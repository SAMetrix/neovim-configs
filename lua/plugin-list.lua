-- Declares every plugin managed by lua/manage.lua.
-- Each entry is either "owner/repo" (cloned from main) or
-- { "owner/repo", branch = "name" } for a specific branch.
-- Plugin configs live in after/plugin/<name>.lua or plugin/<name>.lua.
return {
    "nvim-lua/plenary.nvim",                                -- async utilities used by telescope, harpoon, etc.
    "nvim-tree/nvim-web-devicons",                          -- nerd-font icon set used by lualine and telescope
    "hrsh7th/nvim-cmp",                                     -- completion engine
    "hrsh7th/cmp-nvim-lsp",                                 -- LSP completion source for nvim-cmp
    "hrsh7th/cmp-path",                                     -- filesystem path completion source
    "hrsh7th/cmp-buffer",                                   -- current-buffer word completion source
    "nvim-telescope/telescope.nvim",                        -- fuzzy finder and picker UI
    { "ThePrimeagen/harpoon", branch = "harpoon2" },        -- quick-jump file bookmarks
    "folke/tokyonight.nvim",                                -- colorscheme
    "nvim-lualine/lualine.nvim",                            -- statusline
    "brenoprata10/nvim-highlight-colors",                   -- inline color swatches (#fff, rgb(), etc.)
    "tpope/vim-fugitive",                                   -- Git porcelain (:Git, :Gdiffsplit, etc.)
    "mbbill/undotree",                                      -- visual undo history tree
    "ojroques/vim-oscyank",                                 -- clipboard yank via OSC 52 (works over SSH)
    "captbaritone/better-indent-support-for-php-with-html", -- mixed PHP/HTML indent
    "windwp/nvim-autopairs",                                -- auto-close brackets, quotes, etc.
    "christoomey/vim-tmux-navigator",                       -- seamless Ctrl-H/J/K/L across nvim splits and tmux panes
    "akinsho/toggleterm.nvim",                              -- managed terminal windows with a language runner
    "MeanderingProgrammer/render-markdown.nvim",            -- rendered markdown preview inside nvim
    "manuuurino/autoread.nvim",                             -- auto-reload buffers when files change on disk
    "mikavilpas/yazi.nvim",                                 -- yazi file manager integration
    "chomosuke/typst-preview.nvim",                         -- typst-preview integration
    "lukas-reineke/indent-blankline.nvim"
}
