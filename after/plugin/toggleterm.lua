-- ToggleTerm setup with 80% floating window size
require("toggleterm").setup {
    open_mapping = [[<C-\>]], -- open terminal with Ctrl-\
    direction = "float",
    float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.8), -- 80% of editor width
        height = math.floor(vim.o.lines * 0.8),  -- 80% of editor height
    },
}

-- Runner shortcut: <leader>rt
vim.keymap.set("n", "<leader>rt", function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")
    local cmd = ({
        python = "uv run " .. file, -- use uv for Python
        javascript = "node " .. file,
        typescript = "ts-node " .. file,
        c = "gcc " .. file .. " -o out && ./out",
        cpp = "clang++ " .. file .. " -o out && ./out", -- use clang++ for C++
        rust = "cargo run",
        go = "go run " .. file,
    })[ft]
    if cmd then
        require("toggleterm.terminal").Terminal:new({
            cmd = cmd,
            --hidden = true,
            close_on_exit = false,
            direction = "float",
            float_opts = {
                border = "curved",
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
            },
        }):toggle()
    else
        print("No runner defined for " .. ft)
    end
end, { desc = "Run file in ToggleTerm" })
