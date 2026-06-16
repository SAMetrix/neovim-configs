-- Single-line plugin setups that don't need their own config file.

-- Statusline using the tokyonight theme.
require("lualine").setup({ options = { theme = "tokyonight" } })

-- Highlight color literals (#hex, rgb(), hsl(), etc.) inline in every buffer.
require("nvim-highlight-colors").setup({})

-- Auto-close brackets and quotes, with smart handling of already-closed pairs.
require("nvim-autopairs").setup({})
