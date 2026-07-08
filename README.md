# Neovim Configuration

A lightweight, dependency-minimal Neovim setup built on Neovim 0.11+.  
No plugin manager framework — plugins are git-cloned by a small custom bootstrapper (`lua/manage.lua`).  
No mason — LSP servers are installed manually and configured via the native `vim.lsp` API.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                   # Entry point: loads options, keybinds, and plugins
├── lua/
│   ├── manage.lua             # Lightweight plugin bootstrapper (git clone + rtp)
│   ├── plugin-list.lua        # List of all plugins to install
│   └── config/
│       ├── options.lua        # Editor options (tabs, search, appearance, undo, …)
│       └── keybinds.lua       # Global keybindings
├── plugin/                    # Custom plugins loaded at startup (before after/)
│   ├── lsp.lua                # Native LSP server configs + on-attach keybindings
│   ├── docgen.lua             # Doc comment generator (<leader>dg)
│   ├── flterm.lua             # Custom floating terminal (<leader>ft)
│   ├── quickformat.lua        # Expand parenthesised args to multi-line (<leader>qq)
│   ├── tonycontext.lua        # Sticky context header (treesitter-context replacement)
│   └── tonysitter.lua         # Treesitter highlighting + af/if text objects
├── after/
│   ├── plugin/                # Third-party plugin configs (run after plugin/)
│   │   ├── autoread.lua       # Auto-reload buffers when files change on disk
│   │   ├── colors.lua         # Colorscheme + transparent background overrides
│   │   ├── completion.lua     # nvim-cmp completion setup
│   │   ├── harpoon.lua        # Harpoon v2 file bookmark keybindings
│   │   ├── nvim-tmux-navigator.lua  # Ctrl-H/J/K/L tmux pane navigation
│   │   ├── one-liners.lua     # lualine, highlight-colors, autopairs setup
│   │   ├── telescope.lua      # Telescope fuzzy-finder keybindings
│   │   ├── toggleterm.lua     # Floating terminal + language runner (<leader>rt)
│   │   ├── treesitter.lua     # Filetype mappings (goon extension)
│   │   ├── typst-preview.lua  # Typst live preview + watch pane (<leader>tw)
│   │   └── yazi.lua           # Yazi file manager integration
│   └── ftplugin/              # Per-filetype overrides
│       ├── goon.lua           # Goon: C-style comments
│       ├── hare.lua           # Hare: C-style comments, 4-space indent
│       ├── jsonc.lua          # JSONC: 2-space indent
│       ├── man.lua            # Man pages: wrap, no relative numbers
│       └── nix.lua            # Nix: 2-space indent (Nixpkgs style)
├── queries/                   # Vendored treesitter queries (highlight, textobjects, …)
│   └── <lang>/
└── parser.old/                # Old compiled treesitter parsers (.so)
```

---

## Plugins

| Plugin | Purpose |
|---|---|
| `nvim-lua/plenary.nvim` | Async utilities used by telescope, harpoon, etc. |
| `nvim-tree/nvim-web-devicons` | Nerd Font icon set for lualine, telescope |
| `hrsh7th/nvim-cmp` | Completion engine |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source |
| `hrsh7th/cmp-path` | Filesystem path completion source |
| `hrsh7th/cmp-buffer` | Current-buffer word completion source |
| `nvim-telescope/telescope.nvim` | Fuzzy finder / picker UI |
| `ThePrimeagen/harpoon` (harpoon2) | Quick-jump file bookmarks |
| `folke/tokyonight.nvim` | Colorscheme |
| `nvim-lualine/lualine.nvim` | Statusline |
| `brenoprata10/nvim-highlight-colors` | Inline color swatches (`#fff`, `rgb()`, …) |
| `tpope/vim-fugitive` | Git porcelain (`:Git`, `:Gdiffsplit`, …) |
| `mbbill/undotree` | Visual undo history tree |
| `ojroques/vim-oscyank` | Clipboard yank via OSC 52 (works over SSH) |
| `captbaritone/better-indent-support-for-php-with-html` | Mixed PHP/HTML indentation |
| `windwp/nvim-autopairs` | Auto-close brackets and quotes |
| `christoomey/vim-tmux-navigator` | Seamless Ctrl-H/J/K/L across nvim + tmux |
| `akinsho/toggleterm.nvim` | Managed floating terminals with a language runner |
| `MeanderingProgrammer/render-markdown.nvim` | Rendered Markdown preview inside nvim |
| `manuuurino/autoread.nvim` | Auto-reload buffers when files change on disk |
| `mikavilpas/yazi.nvim` | Yazi file manager floating window |
| `chomosuke/typst-preview.nvim` | Live Typst preview in browser (`:TypstPreview`) |

---

## Keybindings

**Leader key: `<Space>`**

### Navigation & Motion

| Mode | Key | Action |
|---|---|---|
| `n` | `<C-d>` | Scroll half-page down, keep cursor centered |
| `n` | `<C-u>` | Scroll half-page up, keep cursor centered |
| `n` | `n` | Next search match, screen centered |
| `n` | `N` | Previous search match, screen centered |
| `n` | `J` | Join line below onto current line, cursor stays put |
| `n` | `<C-h>` | Move to left window / tmux pane |
| `n` | `<C-j>` | Move to window below / tmux pane |
| `n` | `<C-k>` | Move to window above / tmux pane |
| `n` | `<C-l>` | Move to right window / tmux pane |
| `n` | `<leader>k` | Next location-list entry, centered |
| `n` | `<leader>j` | Previous location-list entry, centered |

### Editing

| Mode | Key | Action |
|---|---|---|
| `v` | `J` | Move selected block down (re-indents) |
| `v` | `K` | Move selected block up (re-indents) |
| `x` | `<leader>p` | Paste without overwriting clipboard |
| `n`, `v` | `<leader>d` | Delete to void register (clipboard unchanged) |
| `i` | `<C-c>` | Exit insert mode (identical to `<Esc>`) |
| `n` | `<leader>s` | Replace word under cursor on current line |
| `n` | `<leader>qq` | Expand parenthesised args to multi-line |

### File & Session

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>cd` | Open Yazi file manager |
| `n` | `<leader>x` | Make current file executable (`chmod +x`) |
| `n` | `<leader>y` | Yank to system clipboard (OSC 52 / SSH-safe) |
| `v` | `<leader>y` | Yank selection to system clipboard |
| `n` | `<leader>rl` | Reload Neovim config (`init.lua`) |
| `n` | `<leader><leader>` | Source current file |
| `n` | `<leader>u` | Toggle Undotree |
| `n` | `Q` | Disabled (no accidental Ex mode) |
| `n` | `<leader>mm` | Run `make` in the current working directory |

### Quickfix List

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>co` | Open quickfix list |
| `n` | `<leader>cl` | Close quickfix list |
| `n` | `<leader>cn` | Next quickfix entry, centered |
| `n` | `<leader>cp` | Previous quickfix entry, centered |

### Telescope (Fuzzy Finder)

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>ff` | Find files under cwd |
| `n` | `<leader>fo` | Recently opened files |
| `n` | `<leader>fg` | Grep string (prompts for input) |
| `n` | `<leader>fs` | Grep word under cursor |
| `n` | `<leader>fc` | Find current filename (stem) across project |
| `n` | `<leader>fb` | List open buffers |
| `n` | `<leader>fh` | Search `:help` tags |
| `n` | `<leader>fm` | Search man pages (all sections) |
| `n` | `<leader>fq` | Browse quickfix list in Telescope |
| `n` | `<leader>fi` | Find files inside `~/.config/nvim/` |
| `i` (in picker) | `<C-j>` | Move selection down |
| `i` (in picker) | `<C-k>` | Move selection up |
| `i` (in picker) | `<C-q>` | Send results to quickfix list |

### Harpoon (File Bookmarks)

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>a` | Add current file to Harpoon list |
| `n` | `<C-e>` | Toggle Harpoon quick menu |
| `n` | `<C-p>` | Jump to previous Harpoon file |
| `n` | `<C-n>` | Jump to next Harpoon file |
| `n` | `<leader>fl` | Browse Harpoon list in Telescope |

### Terminals

| Mode | Key | Action |
|---|---|---|
| `n` | `<C-\>` | Toggle ToggleTerm floating terminal |
| `n` | `<leader>ft` | Toggle Flterm custom floating terminal |
| `t` | `<Esc><Esc>` | Exit terminal mode (return to normal mode) |
| `n` | `<leader>rt` | Run current file with the appropriate runner |

The `<leader>rt` runner supports: `python` (uv), `javascript` (node), `typescript` (ts-node), `c` (gcc), `cpp` (clang++), `rust` (cargo run), `go` (go run).

### Typst

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>tw` | Toggle a vertical `typst watch` pane (live compile errors on save) |

`typst-preview.nvim` also provides `:TypstPreview` (live browser preview), `:TypstPreviewToggle`, and `:TypstPreviewStop`. First run requires `:TypstPreviewUpdate` to fetch its bundled `tinymist`/`websocat` binaries.

### Yazi (File Manager — inside the Yazi window)

| Key | Action |
|---|---|
| `<F1>` | Show help |
| `<C-v>` | Open file in vertical split |
| `<C-x>` | Open file in horizontal split |
| `<C-t>` | Open file in new tab |
| `<C-s>` | Grep in current directory |
| `<C-g>` | Replace in current directory |
| `<Tab>` | Cycle through open buffers |
| `<C-y>` | Copy relative path of selected file(s) |
| `<C-q>` | Send selected files to quickfix list |
| `<C-\>` | Change Neovim's cwd to yazi's directory |
| `<C-o>` | Open file and pick which window to use |

### LSP (active when a language server is attached)

| Mode | Key | Action |
|---|---|---|
| `n` | `K` | Hover documentation |
| `n` | `gd` | Go to definition |
| `n` | `gD` | Go to declaration |
| `n` | `gi` | Go to implementation |
| `n` | `go` | Go to type definition |
| `n` | `gr` | List references |
| `n` | `gs` | Signature help |
| `n` | `gl` | Open diagnostic float |
| `n` | `<F2>` | Rename symbol |
| `n`, `x` | `<F3>` | Format buffer (async) |
| `n` | `<F4>` | Code actions |
| `n` | `<leader>li` | Check LSP health (`:checkhealth vim.lsp`) |
| `n` | `<leader>cc` | Run `php-cs-fixer` on current PHP file |

### Completion (nvim-cmp — in insert mode)

| Key | Action |
|---|---|
| `<CR>` | Confirm selected completion item |
| `<C-e>` | Dismiss the completion menu |
| `<C-Space>` | Force-open the completion menu |
| `<C-n>` | Select next item |
| `<C-p>` | Select previous item |
| `<Tab>` | Select next item (also works in snippets) |
| `<S-Tab>` | Select previous item |
| `<C-f>` | Scroll documentation window down |
| `<C-u>` | Scroll documentation window up |

### Text Objects (Treesitter — Visual & Operator-pending)

| Mode | Key | Action |
|---|---|---|
| `x`, `o` | `af` | Select around enclosing function |
| `x`, `o` | `if` | Select inside enclosing function |

### Context Header (TonyContext)

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>th` | Hide sticky context header |
| `n` | `<leader>tu` | Show sticky context header |

### Doc Comment Generator (Docgen)

| Mode | Key | Action |
|---|---|---|
| `n` | `<leader>dg` | Generate doc comment stub above function |

Supported filetypes: `c`, `cpp`, `h` (kernel-doc), `go`, `rust`, `python`.

---

## LSP Servers

Servers are declared in `plugin/lsp.lua` using `vim.lsp.config` (Neovim 0.11+) and enabled automatically. Install the binaries through your system package manager or npm — no mason required.

| Server | Filetypes | Install |
|---|---|---|
| `lua-language-server` | Lua | `pacman -S lua-language-server` / brew |
| `vscode-css-language-server` | CSS, SCSS, Less | `npm i -g vscode-langservers-extracted` |
| `pyright-langserver` | Python | `npm i -g pyright` |
| `intelephense` | PHP | `npm i -g intelephense` |
| `typescript-language-server` | JS, TS, JSX, TSX | `npm i -g typescript-language-server typescript` |
| `zls` | Zig | `pacman -S zls` / build from source |
| `nil` + `alejandra` | Nix | `nix profile install nixpkgs#nil nixpkgs#alejandra` |
| `rust-analyzer` | Rust | `rustup component add rust-analyzer` |
| `clangd` | C, C++, ObjC | `pacman -S clang` / brew |
| `c3-lsp` | C3 | build from source |
| `serve-d` | D | `pacman -S serve-d` |
| `vscode-json-language-server` | JSON, JSONC | `npm i -g vscode-langservers-extracted` |
| `haskell-language-server-wrapper` | Haskell | `ghcup install hls` |
| `gopls` | Go, gomod, templ | `go install golang.org/x/tools/gopls@latest` |
| `templ` | Templ | `go install github.com/a-h/templ/cmd/templ@latest` |
| `tinymist` | Typst | `cargo install tinymist` / brew |

Auto-formatting on save is enabled for all servers that support it, **except** PHP (use `<leader>cc` for php-cs-fixer) and C/C++ (use clang-format manually or via `<F3>`).
