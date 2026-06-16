-- TonyContext: minimal sticky context header.
-- Replaces nvim-treesitter-context with a zero-dependency implementation.
-- When the opening line of the enclosing function/class has scrolled above the
-- top of the window, it is pinned there as a 1-line floating overlay so you
-- always know which scope you are inside.
--
-- Only the innermost enclosing node is shown (one level of context).
-- Add node type strings to CONTEXT_TYPES to support additional languages.
--
-- Keybindings:
--   <leader>th   hide the context header
--   <leader>tu   show the context header

local M = { enabled = true }
local ctx_buf, ctx_win

-- Tree-sitter node types that qualify as "context" nodes.
-- Extend this table to support more languages or node kinds.
local CONTEXT_TYPES = {
    -- C / PHP
    function_definition = true,
    method_declaration  = true,
    class_declaration   = true,
    -- Lua
    function_declaration = true,
    -- Rust
    function_item  = true,
    impl_item      = true,
    trait_item     = true,
    -- Go (shares function_declaration with Lua)
    -- JS / TS
    method_definition = true,
    arrow_function    = true,
    -- Zig
    fn_proto = true,
    -- Nix
    function_expression = true,
}

local function close_ctx()
    if ctx_win and vim.api.nvim_win_is_valid(ctx_win) then
        vim.api.nvim_win_close(ctx_win, true)
    end
    ctx_win = nil
end

-- Recompute and redraw the context header for the current window.
-- Walks the treesitter node under the cursor up to the nearest context node,
-- then shows its first line pinned to the top of the window if it has scrolled
-- above the visible area.
local function update_ctx()
    if not M.enabled then close_ctx() return end

    local bufnr = vim.api.nvim_get_current_buf()
    local node  = vim.treesitter.get_node()
    if not node then close_ctx() return end

    -- Walk up the syntax tree until we find a context node.
    while node and not CONTEXT_TYPES[node:type()] do
        node = node:parent()
    end
    if not node then close_ctx() return end

    local sr          = node:start()
    local top_visible = vim.fn.line("w0") - 1
    -- If the context line is already visible, no overlay is needed.
    if sr >= top_visible then close_ctx() return end

    local lines = vim.api.nvim_buf_get_lines(bufnr, sr, sr + 1, false)
    if #lines == 0 then close_ctx() return end

    -- Reuse the scratch buffer between updates to avoid flicker.
    if not ctx_buf or not vim.api.nvim_buf_is_valid(ctx_buf) then
        ctx_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[ctx_buf].buftype = "nofile"
    end
    vim.api.nvim_buf_set_lines(ctx_buf, 0, -1, false, lines)
    vim.bo[ctx_buf].filetype = vim.bo[bufnr].filetype  -- inherit syntax highlighting

    local config = {
        relative  = "win",
        win       = vim.api.nvim_get_current_win(),
        row       = 0,
        col       = 0,
        width     = vim.api.nvim_win_get_width(0),
        height    = 1,
        focusable = false,
        style     = "minimal",
        zindex    = 20,
    }
    if ctx_win and vim.api.nvim_win_is_valid(ctx_win) then
        vim.api.nvim_win_set_config(ctx_win, config)
    else
        ctx_win = vim.api.nvim_open_win(ctx_buf, false, config)
        vim.wo[ctx_win].winhighlight = "Normal:TonyContext,NormalFloat:TonyContext"
    end
end

-- Default highlight: same as NormalFloat (usually a slightly dimmed background).
vim.api.nvim_set_hl(0, "TonyContext", { link = "NormalFloat", default = true })

local group = vim.api.nvim_create_augroup("TonyContext", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled", "BufEnter" }, {
    group    = group,
    callback = update_ctx,
})
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    group    = group,
    callback = close_ctx,
})

vim.keymap.set("n", "<leader>th", function()
    M.enabled = false
    close_ctx()
end, { desc = "Hide context header" })

vim.keymap.set("n", "<leader>tu", function()
    M.enabled = true
    update_ctx()
end, { desc = "Unhide context header" })

return M
