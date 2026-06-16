-- Configures autoread.nvim to poll for external file changes every 500 ms
-- and notify when a buffer is reloaded. Useful when files are modified by
-- build tools, formatters, or other processes while Neovim is open.
require("autoread").setup({
    interval = 500,           -- polling interval in milliseconds
    notify_on_change = true,  -- show a notification when a buffer is reloaded
    -- "preserve" keeps the cursor where it was; alternatives: "scroll_down", "none"
    cursor_behavior = "preserve",
})

-- Enable autoread for all buffers as soon as the UI is ready.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("AutoreadOn 500")
  end,
})
