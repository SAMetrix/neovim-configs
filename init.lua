-- Entry point for the Neovim configuration.
-- Loads editor options, global keybindings, then bootstraps plugins
-- by cloning any missing repos from the list in lua/plugin-list.lua.
require("config.options")
require("config.keybinds")
require("manage").setup()
