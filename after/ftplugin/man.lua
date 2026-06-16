-- Filetype settings for man pages (:Man / vim.cmd.Man).
-- Disables relative line numbers (they're distracting in read-only docs),
-- enables word-wrap without breaking mid-word, and keeps conceallevel at 0
-- so all markup characters are visible.
local set = vim.opt_local
set.number         = true
set.relativenumber = false  -- absolute numbers only; relative unhelpful in docs
set.wrap           = true
set.linebreak      = true   -- wrap at word boundaries
set.conceallevel   = 0      -- show all characters unmodified
