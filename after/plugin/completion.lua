-- Configures nvim-cmp for auto-completion.
-- Sources (in priority order): LSP → filesystem paths → buffer words (≥3 chars).
-- Completion triggers automatically on text change; the menu does not pre-select
-- an item, so Enter confirms only when the user has explicitly selected one.

local cmp = require("cmp")
require("cmp_nvim_lsp").setup()
cmp.register_source("path", require("cmp_path").new())
cmp.register_source("buffer", require("cmp_buffer"))

cmp.setup({
    preselect = cmp.PreselectMode.Item,
    completion = {
        completeopt = "menu,menuone,noinsert",
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    window = { documentation = cmp.config.window.bordered() },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),  -- confirm selected item
        ["<C-e>"]     = cmp.mapping.abort(),                      -- dismiss the menu
        ["<C-Space>"] = cmp.mapping.complete(),                   -- force-open the menu
        ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),               -- scroll docs window down
        ["<C-u>"]     = cmp.mapping.scroll_docs(-4),              -- scroll docs window up
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then cmp.select_prev_item() end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },  -- only trigger buffer source after 3 chars
    },
})
