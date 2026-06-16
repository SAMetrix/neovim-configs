-- Flterm: a lightweight custom floating terminal.
-- Unlike toggleterm.nvim this is a hand-rolled implementation that reuses the
-- same buffer between toggles, so the terminal session is preserved.
--
-- Keybindings:
--   <Esc><Esc>   exit terminal mode (return to normal mode)
--   <leader>ft   toggle the floating terminal

-- Double-tap Escape to leave terminal mode; single Esc passes through to the
-- shell (e.g. readline, vim-in-terminal, etc.).
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Persistent state: the buffer and window handles for the floating terminal.
local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

-- Opens a new floating window centred in the editor.
-- Reuses `opts.buf` if it is still valid; otherwise creates a fresh buffer.
local function open_floating_terminal(opts)
    opts = opts or {}
    local width  = opts.width  or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local row = math.floor((vim.o.lines   - height) / 2)
    local col = math.floor((vim.o.columns - width)  / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end
    if not buf then error("Failed to create buffer") end

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width    = width,
        height   = height,
        row      = row,
        col      = col,
        style    = 'minimal',
        border   = 'rounded',
    })

    return { buf = buf, win = win }
end

-- Toggle the floating terminal: open it if it is not visible, hide it if it is.
-- On first open a shell is started inside the buffer.
local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = open_floating_terminal({ buf = state.floating.buf });
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
            vim.cmd("startinsert!")
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Flterm", toggle_terminal, {})
vim.api.nvim_set_keymap('n', '<leader>ft', [[:Flterm<CR>]], { noremap = true, silent = true })
