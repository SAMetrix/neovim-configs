-- Minimal plugin manager.
-- On first run it git-clones any plugin that is not yet present on disk, then
-- prepends every plugin's path to &rtp so Neovim can find its files.
-- No lock file, no lazy-loading — everything loads at startup in the order
-- listed in lua/plugin-list.lua.
-- Plugin data directory: stdpath("data") .. "/plugins"  (~/.local/share/nvim/plugins)

local M = {}
local plug_dir = vim.fn.stdpath("data") .. "/plugins"

-- Ensure a plugin is present on disk, cloning it from GitHub if needed,
-- then add it to the runtime path.
-- @param spec string|table  Either "owner/repo" or { "owner/repo", branch = "..." }
local function ensure(spec)
    local repo = type(spec) == "string" and spec or spec[1]
    local name = repo:match(".+/(.+)$")
    local path = plug_dir .. "/" .. name

    if not vim.uv.fs_stat(path) then
        vim.fn.mkdir(plug_dir, "p")
        local cmd = { "git", "clone", "--depth=1" }
        if spec.branch then
            table.insert(cmd, "-b")
            table.insert(cmd, spec.branch)
        end
        table.insert(cmd, "https://github.com/" .. repo)
        table.insert(cmd, path)
        print("Installing " .. name .. "...")
        vim.fn.system(cmd)
    end

    -- Add both the root and the after/ subdirectory to the runtime path.
    vim.opt.rtp:prepend(path)
    vim.opt.rtp:append(path .. "/after")

    -- Extend package.path so require() can find Lua modules inside the plugin.
    local lua_path = path .. "/lua"
    if vim.uv.fs_stat(lua_path) then
        package.path = package.path .. ";" .. lua_path .. "/?.lua;" .. lua_path .. "/?/init.lua"
    end
end

-- Bootstrap all plugins from the plugin list.
function M.setup()
    for _, spec in ipairs(require("plugin-list")) do
        ensure(spec)
    end
end

return M
