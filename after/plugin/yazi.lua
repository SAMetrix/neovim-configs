-- Yazi file manager integration.
-- Opens yazi in a floating window; replaces netrw for directory browsing.
-- netrw is intentionally disabled to prevent conflicts with open_for_directories.
--
-- Keybinding:
--   <leader>cd   open yazi at the current file's location
--
-- Inside the yazi window:
--   <F1>     show help
--   <C-v>    open selected file in a vertical split
--   <C-x>    open selected file in a horizontal split
--   <C-t>    open selected file in a new tab
--   <C-s>    grep in the current directory
--   <C-g>    replace in the current directory
--   <Tab>    cycle through open buffers
--   <C-y>    copy relative path of selected file(s)
--   <C-q>    send selected files to the quickfix list
--   <C-\>    change Neovim's working directory to yazi's current directory
--   <C-o>    open file and pick which window to place it in

vim.keymap.set("n", "<leader>cd", function()
  require("yazi").yazi()
end)

-- Prevent netrw from loading so yazi handles directory arguments instead.
vim.g.loaded_netrwPlugin = 1

-- Set up yazi to open automatically when Neovim is given a directory argument.
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_for_directories = true,
    })
  end,
})

require("yazi").setup({
  open_for_directories  = false,  -- handled by the UIEnter autocmd above
  open_multiple_tabs    = false,
  change_neovim_cwd_on_close = false,

  highlight_groups = {
    hovered_buffer = nil,
    hovered_buffer_in_same_directory = nil,
  },

  floating_window_scaling_factor   = 0.9,
  yazi_floating_window_winblend    = 0,
  yazi_floating_window_border      = "rounded",
  yazi_floating_window_zindex      = nil,

  log_level = vim.log.levels.OFF,

  keymaps = {
    show_help                          = "<f1>",
    open_file_in_vertical_split        = "<c-v>",
    open_file_in_horizontal_split      = "<c-x>",
    open_file_in_tab                   = "<c-t>",
    grep_in_directory                  = "<c-s>",
    replace_in_directory               = "<c-g>",
    cycle_open_buffers                 = "<tab>",
    copy_relative_path_to_selected_files = "<c-y>",
    send_to_quickfix_list              = "<c-q>",
    change_working_directory           = "<c-\\>",
    open_and_pick_window               = "<c-o>",
  },

  set_keymappings_function = function(yazi_buffer_id, config, context) end,
  clipboard_register = "*",

  hooks = {
    yazi_opened             = function(preselected_path, yazi_buffer_id, config) end,
    yazi_closed_successfully = function(chosen_file, config, state) end,
    yazi_opened_multiple_files = function(chosen_files, config, state) end,
    on_yazi_ready           = function(buffer, config, process_api) end,
    before_opening_window   = function(window_options) end,
  },

  highlight_hovered_buffers_in_same_directory = true,

  integrations = {
    grep_in_directory          = function(directory) end,
    grep_in_selected_files     = function(selected_files) end,
    replace_in_directory       = function(directory) end,
    replace_in_selected_files  = function(selected_files) end,
    resolve_relative_path_application = "",
    resolve_relative_path_implementation = function(args, get_relative_path) end,
    bufdelete_implementation   = "bundled-snacks",
    picker_add_copy_relative_path_action = nil,
  },

  future_features = {
    use_cwd_file = true,
  },
})
