-- Default configuration
require("autoread").setup({
    -- Check interval in milliseconds
    interval = 500,
    -- Show notifications when files change
    notify_on_change = true,
    -- How to handle cursor position after reload: "preserve", "scroll_down", or "none"
    cursor_behavior = "preserve",
})

-- Auto-enable autoread for all buffers at startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("AutoreadOn 500")  -- or just "AutoreadOn"
  end,
})
