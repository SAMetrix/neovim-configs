-- LSP configuration using the native vim.lsp API introduced in Neovim 0.11.
-- No lspconfig or mason — each server is declared with vim.lsp.config and
-- enabled with vim.lsp.enable. Root detection uses .git as a universal fallback.
--
-- Configured servers:
--   luals        lua-language-server    (Lua)
--   cssls        vscode-css-ls          (CSS / SCSS / Less)
--   pyls         pyright                (Python)
--   phpls        intelephense           (PHP)
--   ts_ls        typescript-ls          (JS / TS / JSX / TSX)
--   zls          zls                    (Zig)
--   nil_ls       nil + alejandra        (Nix)
--   rust_analyzer                       (Rust)
--   clangd                              (C / C++ / ObjC)
--   c3lsp        c3-lsp                 (C3)
--   serve_d      serve-d                (D)
--   jsonls       vscode-json-ls         (JSON / JSONC)
--   hls          haskell-ls             (Haskell)
--   gopls                               (Go / gomod / templ)
--   templ        templ lsp              (Templ)
--
-- Buffer-local LSP keybindings (active only when an LSP client is attached):
--   K        hover documentation
--   gd       go to definition
--   gD       go to declaration
--   gi       go to implementation
--   go       go to type definition
--   gr       list references
--   gs       signature help
--   gl       open diagnostic float
--   <F2>     rename symbol
--   <F3>     format buffer (async)
--   <F4>     code actions

-- Use .git as the universal root marker so single-file projects still work.
vim.lsp.config('*', {
    root_markers = { '.git' },
})

-- Diagnostic display: inline virtual text, severity-sorted, rounded float.
vim.diagnostic.config({
    virtual_text  = true,
    severity_sort = true,
    float         = {
        style  = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
    signs         = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN]  = '▲',
            [vim.diagnostic.severity.HINT]  = '⚑',
            [vim.diagnostic.severity.INFO]  = '»',
        },
    },
})

-- Patch all floating previews (hover, signature help) to have consistent borders
-- and sane size limits.
local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts            = opts or {}
    opts.border     = opts.border or 'rounded'
    opts.max_width  = opts.max_width or 80
    opts.max_height = opts.max_height or 24
    opts.wrap       = opts.wrap ~= false
    return orig(contents, syntax, opts, ...)
end

-- Set up buffer-local keybindings and auto-formatting when an LSP client attaches.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local buf    = args.buf
        local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

        map('n', 'K',    vim.lsp.buf.hover)
        map('n', 'gd',   vim.lsp.buf.definition)
        map('n', 'gD',   vim.lsp.buf.declaration)
        map('n', 'gi',   vim.lsp.buf.implementation)
        map('n', 'go',   vim.lsp.buf.type_definition)
        map('n', 'gr',   vim.lsp.buf.references)
        map('n', 'gs',   vim.lsp.buf.signature_help)
        map('n', 'gl',   vim.diagnostic.open_float)
        map('n', '<F2>', vim.lsp.buf.rename)
        map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
        map('n', '<F4>', vim.lsp.buf.code_action)

        -- Highlight all occurrences of the symbol under the cursor while it is held.
        if client:supports_method('textDocument/documentHighlight') then
            local highlight_augroup = vim.api.nvim_create_augroup('my.lsp.highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer   = buf,
                group    = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer   = buf,
                group    = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Auto-format on save for servers that support it, except for filetypes
        -- that have their own dedicated formatters (php-cs-fixer, clang-format).
        local excluded_filetypes = { php = true, c = true, cpp = true }
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting')
            and not excluded_filetypes[vim.bo[buf].filetype]
        then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group    = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
                buffer   = buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

-- Share nvim-cmp LSP capabilities with every server so completion works.
local caps = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config['luals'] = {
    cmd          = { 'lua-language-server' },
    filetypes    = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    capabilities = caps,
    settings     = {
        Lua = {
            runtime     = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace   = {
                checkThirdParty = false,
                library = vim.list_extend(
                    vim.api.nvim_get_runtime_file('', true),
                    { '/home/tony/repos/oxwm/templates' }
                ),
            },
            telemetry = { enable = false },
        },
    },
}

vim.lsp.config['cssls'] = {
    cmd          = { 'vscode-css-language-server', '--stdio' },
    filetypes    = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },
    capabilities = caps,
    settings     = {
        css  = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}

vim.lsp.config['pyls'] = {
    cmd          = { "pyright-langserver", "--stdio" },
    filetypes    = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    capabilities = caps,
    settings     = {
        python = {
            analysis = {
                autoSearchPaths    = true,
                useLibraryCodeForTypes = true,
                diagnosticMode     = "workspace",
            },
        },
    },
}

vim.lsp.config['phpls'] = {
    cmd          = { 'intelephense', '--stdio' },
    filetypes    = { 'php' },
    root_markers = { 'composer.json', '.git' },
    capabilities = caps,
    settings     = {
        intelephense = {
            files = {
                maxSize = 5000000,  -- 5 MB; raise for large legacy codebases
            },
        },
    },
}

vim.lsp.config['ts_ls'] = {
    cmd          = { 'typescript-language-server', '--stdio' },
    filetypes    = {
        'javascript', 'javascriptreact', 'javascript.jsx',
        'typescript', 'typescriptreact', 'typescript.tsx',
    },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    capabilities = caps,
    settings     = {
        completions = { completeFunctionCalls = true },
    },
}

vim.lsp.config['zls'] = {
    cmd          = { 'zls' },
    filetypes    = { 'zig', 'zir' },
    root_markers = { 'zls.json', 'build.zig', '.git' },
    capabilities = caps,
    settings     = {
        zls = {
            enable_build_on_save = true,
            build_on_save_step   = "install",
            warn_style           = false,
            enable_snippets      = true,
        }
    }
}

vim.lsp.config['nil_ls'] = {
    cmd          = { 'nil' },
    filetypes    = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
    capabilities = caps,
    settings     = {
        ['nil'] = {
            formatting = { command = { "alejandra" } }
        }
    }
}

vim.lsp.config['rust_analyzer'] = {
    cmd          = { 'rust-analyzer' },
    filetypes    = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    capabilities = caps,
    settings     = {
        ['rust-analyzer'] = {
            cargo      = { allFeatures = true },
            formatting = { command = { "rustfmt" } },
        },
    },
}

vim.lsp.config['clangd'] = {
    cmd          = { 'clangd' },
    filetypes    = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git' },
    capabilities = caps,
}

vim.lsp.config['c3lsp'] = {
    cmd          = { 'c3-lsp' },
    filetypes    = { 'c3' },
    root_markers = { 'project.json', '.git' },
    capabilities = caps,
}

vim.lsp.config['serve_d'] = {
    cmd          = { 'serve-d' },
    filetypes    = { 'd' },
    root_markers = { 'dub.sdl', 'dub.json', '.git' },
    capabilities = caps,
}

vim.lsp.config['jsonls'] = {
    cmd          = { 'vscode-json-language-server', '--stdio' },
    filetypes    = { 'json', 'jsonc' },
    root_markers = { 'package.json', '.git', 'config.jsonc' },
    capabilities = caps,
}

vim.lsp.config['hls'] = {
    cmd          = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes    = { 'haskell', 'lhaskell' },
    root_markers = { 'stack.yaml', 'cabal.project', 'package.yaml', '*.cabal', 'hie.yaml', '.git' },
    capabilities = caps,
    settings     = {
        haskell = {
            formattingProvider = 'fourmolu',
            plugin = { semanticTokens = { globalOn = false } },
        },
    },
}

vim.lsp.config['gopls'] = {
    cmd          = { 'gopls' },
    filetypes    = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.mod', 'go.work', '.git' },
    capabilities = caps,
    settings     = {
        gopls = {
            analyses    = { unusedparams = false, ST1003 = false, ST1000 = false },
            staticcheck = true,
        },
    },
}

vim.lsp.config['templ'] = {
    cmd          = { 'templ', 'lsp' },
    filetypes    = { 'templ' },
    root_markers = { 'go.mod', '.git' },
    capabilities = caps,
}

vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        formatterMode = "typstyle", -- or "typstfmt"
        formatterProseWrap = true, -- wrap lines in content mode
        -- formatterPrintWidth = 80,  -- limit line length to 80 if possible
        formatterIndentSize = 4,   -- indentation width
    }
}

-- Register custom file extensions so Neovim picks the right filetype (and LSP).
vim.filetype.add({
    extension = {
        h    = 'c',      -- treat .h as C (not cpp)
        c3   = 'c3',
        d    = 'd',
        templ = 'templ',
    },
})

-- Enable every configured server automatically.
---@diagnostic disable-next-line: invisible
for name, _ in pairs(vim.lsp.config._configs) do
    if name ~= '*' then
        vim.lsp.enable(name)
    end
end
