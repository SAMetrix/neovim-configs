-- Applies the tokyonight colorscheme and clears backgrounds on several highlight
-- groups so the terminal's own background color shows through (useful with
-- transparent terminals or custom terminal themes).
vim.cmd.colorscheme("tokyonight")
vim.cmd("hi Directory guibg=NONE")     -- netrw/yazi directory entries
vim.cmd("hi SignColumn guibg=NONE")    -- gutter column (diagnostics, git signs)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })        -- main text area
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })   -- floating windows (hover, completion)
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })        -- line number column
