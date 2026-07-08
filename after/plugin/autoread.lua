-- Configures autoread.nvim to poll for external file changes every 500 ms
-- and notify when a buffer is reloaded. Useful when files are modified by
-- build tools, formatters, or other processes while Neovim is open.
--
-- `checktime` (what this plugin calls on its timer) only reloads silently
-- when the built-in 'autoread' option is on; otherwise it just warns.
vim.o.autoread = true

require("autoread").setup({
    interval = 500,          -- polling interval in milliseconds
    notify_on_change = true, -- show a notification when a buffer is reloaded
    -- "preserve" keeps the cursor where it was; alternatives: "scroll_down", "none"
    cursor_behavior = "preserve",
})

-- Enable autoread for every buffer as it's opened, not just the one active
-- at startup (VimEnter only fires once, for a single buffer).
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function(args)
        require("autoread").enable(500, args.buf)
    end,
})
