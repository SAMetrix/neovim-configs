-- Quickformat: expand a single-line function call into multi-line form.
-- Place the cursor on a line containing a parenthesised argument list and
-- press <leader>qq. The content inside the first pair of parentheses is split
-- on commas and re-indented with 8-space indent per argument.
--
-- Example:
--   foo(bar, baz, qux)
-- becomes:
--   foo(
--           bar,
--           baz,
--           qux
--   )
--
-- Keybinding:  <leader>qq

local function reformat_parenthesized_content()
    local bufnr = vim.api.nvim_get_current_buf()
    local row   = vim.api.nvim_win_get_cursor(0)[1]
    local line  = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

    local inside = line:match("%((.-)%)")
    if not inside then
        vim.notify("No content found inside parentheses", vim.log.levels.ERROR)
        return
    end

    local prefix = line:match("^(.-)%(") or ""
    local suffix = line:match("%)(.*)$") or ""

    local parts = vim.split(inside, ",%s*")
    if #parts == 0 then
        vim.notify("No comma-separated content found", vim.log.levels.ERROR)
        return
    end

    local new_lines = {}
    table.insert(new_lines, prefix .. "(")
    for i, part in ipairs(parts) do
        if i < #parts then
            table.insert(new_lines, "        " .. part .. ",")
        else
            table.insert(new_lines, "        " .. part)
        end
    end
    table.insert(new_lines, "    )" .. suffix)

    vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, new_lines)
end

vim.keymap.set("n", "<leader>qq", function()
    reformat_parenthesized_content()
end)
