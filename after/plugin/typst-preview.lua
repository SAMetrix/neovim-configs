require("typst-preview").setup({})

-- Typst watch pane: runs `typst watch` on the current file in a persistent
-- vertical terminal split, so compile errors/warnings show live on save.
-- <leader>tw toggles the pane; the watcher keeps running in the background
-- (and keeps recompiling) while the pane is hidden.
local typst_watch_term
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    group = vim.api.nvim_create_augroup("my.typst-watch", { clear = true }),
    callback = function(args)
        vim.keymap.set("n", "<leader>tw", function()
            if not typst_watch_term then
                typst_watch_term = require("toggleterm.terminal").Terminal:new({
                    cmd           = "typst watch " .. vim.fn.expand("%"),
                    direction     = "vertical",
                    size          = function() return math.floor(vim.o.columns * 0.35) end,
                    close_on_exit = false,
                })
            end
            typst_watch_term:toggle()
        end, { buffer = args.buf, desc = "Toggle Typst watch pane" })
    end,
})
