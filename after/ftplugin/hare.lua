-- Filetype settings for Hare (*.ha).
-- Uses C-style // and /* */ comment syntax with 4-space indentation.
local set = vim.opt_local

vim.bo.commentstring = "// %s"
vim.bo.comments = "s:/*,m: *,ex:*/,://"

set.shiftwidth    = 4
set.tabstop       = 4
set.softtabstop   = 4
set.expandtab     = true

set.number         = true
set.relativenumber = true
