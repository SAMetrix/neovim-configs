-- Docgen: generate language-appropriate doc comment stubs above a function.
-- Place the cursor on a function signature line and press <leader>dg.
-- Supported filetypes: c, cpp, h  →  kernel-doc /** ... */
--                      go          →  // FuncName ...
--                      rust        →  /// ...
--                      python      →  """..."""

local M = {}

-- Generates a kernel-doc / C-style /** */ block for the function on `line`.
-- Strips static/inline/extern prefixes before parsing the signature.
local function generate_c_doc(bufnr, row, line)
    local stripped = line:gsub("^%s*static%s+", ""):gsub("^%s*inline%s+", ""):gsub("^%s*extern%s+", "")
    local ret, name, params = stripped:match("^%s*([%w_]+%s*%**)%s*([%w_]+)%s*%((.*)%)%s*{?%s*$")
    if not name then
        return nil, "No C function signature found on current line"
    end

    local doc = { "/**", " * " .. name .. "() - " }

    if params and params:match("%S") and not params:match("^%s*void%s*$") then
        for param in params:gmatch("([^,]+)") do
            local pname = param:match("([%w_]+)%s*$")
                or param:match("%*%s*([%w_]+)")
                or param:match("([%w_]+)%s*%[")
            if pname then
                table.insert(doc, " * @" .. pname .. ": ")
            end
        end
    end

    table.insert(doc, " *")

    ret = ret and ret:gsub("%s+", " "):gsub("^%s*", ""):gsub("%s*$", "") or ""
    if ret ~= "void" and ret ~= "" then
        table.insert(doc, " * Return: ")
    end

    table.insert(doc, " */")
    return doc, nil
end

-- Generates a Go-style // comment block for the function on `line`.
-- Handles both plain functions and methods with receivers.
local function generate_go_doc(bufnr, row, line)
    local name, params, ret

    -- method with receiver: func (r *Receiver) Name(params) return
    name, params, ret = line:match("^%s*func%s+%([^)]+%)%s+([%w_]+)%s*%((.-)%)%s*(.-)%s*{?%s*$")

    -- plain function
    if not name then
        name, params, ret = line:match("^%s*func%s+([%w_]+)%s*%((.-)%)%s*(.-)%s*{?%s*$")
    end

    if not name then
        return nil, "No Go function signature found on current line"
    end

    local doc = { "// " .. name .. " " }

    if params and params:match("%S") then
        local param_names = {}
        for param in params:gmatch("([^,]+)") do
            local pname = param:match("^%s*([%w_]+)")
            if pname then table.insert(param_names, pname) end
        end
        if #param_names > 0 then
            table.insert(doc, "//")
            table.insert(doc, "// Parameters:")
            for _, pname in ipairs(param_names) do
                table.insert(doc, "//   - " .. pname .. ": ")
            end
        end
    end

    ret = ret and ret:gsub("^%s*", ""):gsub("%s*$", "") or ""
    if ret ~= "" and ret ~= "error" then
        table.insert(doc, "//")
        table.insert(doc, "// Returns: ")
    end

    return doc, nil
end

-- Generates a Rust-style /// doc comment block for the function on `line`.
-- Handles pub fn, fn, with or without a return type.
local function generate_rust_doc(bufnr, row, line)
    local name, params, ret
    name, params, ret = line:match("^%s*pub%s+fn%s+([%w_]+)%s*%((.-)%)%s*%->%s*(.-)%s*{?%s*$")
    if not name then
        name, params, ret = line:match("^%s*fn%s+([%w_]+)%s*%((.-)%)%s*%->%s*(.-)%s*{?%s*$")
    end
    if not name then
        name, params = line:match("^%s*pub%s+fn%s+([%w_]+)%s*%((.-)%)%s*{?%s*$")
    end
    if not name then
        name, params = line:match("^%s*fn%s+([%w_]+)%s*%((.-)%)%s*{?%s*$")
    end

    if not name then
        return nil, "No Rust function signature found on current line"
    end

    local doc = { "/// " }

    if params and params:match("%S") then
        local param_names = {}
        for param in params:gmatch("([^,]+)") do
            local pname = param:match("^%s*([%w_]+)%s*:")
            -- skip self / &self / &mut self
            if pname and pname ~= "self" and pname ~= "&self" and pname ~= "&mut" then
                table.insert(param_names, pname)
            end
        end
        if #param_names > 0 then
            table.insert(doc, "///")
            table.insert(doc, "/// # Arguments")
            table.insert(doc, "///")
            for _, pname in ipairs(param_names) do
                table.insert(doc, "/// * `" .. pname .. "` - ")
            end
        end
    end

    ret = ret and ret:gsub("^%s*", ""):gsub("%s*$", "") or ""
    if ret ~= "" then
        table.insert(doc, "///")
        table.insert(doc, "/// # Returns")
        table.insert(doc, "///")
        table.insert(doc, "/// ")
    end

    return doc, nil
end

-- Generates a Python """docstring""" for the function on `line`.
-- Handles both def and async def, skips self/cls parameters.
local function generate_python_doc(bufnr, row, line)
    local name, params = line:match("^%s*def%s+([%w_]+)%s*%((.-)%)%s*:?%s*$")
    if not name then
        name, params = line:match("^%s*async%s+def%s+([%w_]+)%s*%((.-)%)%s*:?%s*$")
    end

    if not name then
        return nil, "No Python function signature found on current line"
    end

    local indent = line:match("^(%s*)") or ""
    local doc = { indent .. '    """' }

    if params and params:match("%S") then
        local param_names = {}
        for param in params:gmatch("([^,]+)") do
            local pname = param:match("^%s*([%w_]+)")
            if pname and pname ~= "self" and pname ~= "cls" then
                table.insert(param_names, pname)
            end
        end
        if #param_names > 0 then
            table.insert(doc, indent .. "")
            table.insert(doc, indent .. "    Args:")
            for _, pname in ipairs(param_names) do
                table.insert(doc, indent .. "        " .. pname .. ": ")
            end
        end
    end

    table.insert(doc, indent .. "")
    table.insert(doc, indent .. "    Returns:")
    table.insert(doc, indent .. "        ")
    table.insert(doc, indent .. '    """')

    return doc, nil
end

-- Map filetypes to their generator functions.
local generators = {
    c      = generate_c_doc,
    cpp    = generate_c_doc,
    h      = generate_c_doc,
    go     = generate_go_doc,
    rust   = generate_rust_doc,
    python = generate_python_doc,
}

-- Insert a doc comment stub above the current line.
-- Reads the current line, dispatches to the appropriate generator, inserts
-- the lines, then places the cursor at the first blank description field.
function M.generate_doc()
    local bufnr = vim.api.nvim_get_current_buf()
    local row   = vim.api.nvim_win_get_cursor(0)[1]
    local line  = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
    local ft    = vim.bo[bufnr].filetype

    local generator = generators[ft]
    if not generator then
        vim.notify("No doc generator for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    local doc, err = generator(bufnr, row, line)
    if err then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, doc)

    -- Move the cursor to the first empty slot in the generated stub.
    local cursor_row = row
    local cursor_col = #doc[1]
    for i, docline in ipairs(doc) do
        if docline:match("%s$") or docline:match(":%s*$") or docline:match("%-%s*$") then
            cursor_row = row + i - 1
            cursor_col = #docline
            break
        end
    end

    vim.api.nvim_win_set_cursor(0, { cursor_row, cursor_col })
    vim.cmd("startinsert!")
end

-- <leader>dg  generate a doc comment for the function under the cursor
vim.keymap.set("n", "<leader>dg", M.generate_doc)
