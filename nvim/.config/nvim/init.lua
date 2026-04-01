local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require("config.options") -- Load options configuration
require("config.autocmds") -- Load autocmd (autocommand) configuration
require("config.keymaps") -- Load keymaps configuration

-- Set up lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Import plugin configurations
  },
  defaults = { lazy = false }, -- Load plugins immediately by default
  change_detection = { notify = false }, -- Disable notifications when a change is detected in plugin settings
  checker = {
    enabled = true, -- Enable plugin checker
    notify = false, -- Do not notify on updates
  },
  performance = {
    rtp = {
      disabled_plugins = { -- List of disabled default plugins
        "gzip", -- Disable gzip support
        -- "matchit", -- Disable matchit plugin
        -- "matchparen", -- Disable matchparen plugin
        -- "netrwPlugin", -- Disable netrw plugin
        "tarPlugin", -- Disable tar plugin
        "tohtml", -- Disable tohtml plugin
        "tutor", -- Disable tutor plugin
        "zipPlugin", -- Disable zip plugin
      },
    },
  },
})
