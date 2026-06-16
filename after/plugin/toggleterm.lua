-- Toggleterm configuration.
-- Opens a floating terminal that covers 80% of the editor area.
--
-- Keybindings:
--   <C-\>        toggle the floating terminal (global)
--   <leader>rt   run the current file using the appropriate language runner

require("toggleterm").setup {
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
        border = "curved",
        width  = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
    },
}

-- Language runner: detects filetype and runs the file in a new floating terminal.
-- Python uses `uv run` instead of python directly.
-- C++ uses clang++ rather than gcc.
vim.keymap.set("n", "<leader>rt", function()
    local ft   = vim.bo.filetype
    local file = vim.fn.expand("%")
    local cmd  = ({
        python     = "uv run " .. file,
        javascript = "node " .. file,
        typescript = "ts-node " .. file,
        c          = "gcc " .. file .. " -o out && ./out",
        cpp        = "clang++ " .. file .. " -o out && ./out",
        rust       = "cargo run",
        go         = "go run " .. file,
    })[ft]
    if cmd then
        require("toggleterm.terminal").Terminal:new({
            cmd          = cmd,
            close_on_exit = false,
            direction    = "float",
            float_opts   = {
                border = "curved",
                width  = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
            },
        }):toggle()
    else
        print("No runner defined for " .. ft)
    end
end, { desc = "Run file in ToggleTerm" })
