-- Editor options applied at startup.
-- Uses vim.opt shorthand via the `set` alias for brevity.
local set = vim.opt

-- Show absolute line number on the current line and relative numbers above/below.
set.relativenumber = true
set.number = true

-- Indentation: 4-space soft tabs with automatic indenting on new lines.
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- Case-insensitive search unless the pattern contains an uppercase letter.
set.ignorecase = true
set.smartcase = true

-- Enable 24-bit color, dark background assumption, always show the sign column
-- so the gutter width never shifts when diagnostics appear.
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- Highlight the line the cursor is on.
set.cursorline = true

-- 80-column ruler (disabled; uncomment to re-enable).
-- set.colorcolumn = "80"

-- Sync unnamed register with the system clipboard.
set.clipboard:append("unnamedplus")

-- Allow backspace to delete over auto-indent, end-of-line, and the start of insert.
set.backspace = "indent,eol,start"

-- Open horizontal splits below and vertical splits to the right.
set.splitbelow = true
set.splitright = true

-- Treat hyphen as part of a word so dw/diw/ciw operate on kebab-case identifiers.
set.iskeyword:append("-")

-- Keep at least 8 lines of context visible above and below the cursor.
set.scrolloff = 8

-- Persistent undo stored in ~/.vim/undodir; no swap or backup files.
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- Show search matches incrementally as you type.
set.incsearch = true

-- Reduce the delay before CursorHold fires (affects LSP document highlights).
set.updatetime = 50
