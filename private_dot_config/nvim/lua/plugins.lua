local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.notify("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  -- Need to load first
  use({ "lewis6991/impatient.nvim" })
  use({ "nathom/filetype.nvim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "nvim-lua/popup.nvim" })
  use({ "kyazdani42/nvim-web-devicons" })

  -- Color
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("plugins/catppuccin")
    end,
  })

  -- LSP
  use({ "williamboman/mason.nvim" }) -- An LSP installer
  use({ "williamboman/mason-lspconfig.nvim" }) -- Bridge between lspconfig and mason
  use({
    "neovim/nvim-lspconfig", -- A collection of common configurations for Neovim's built-in language server client.
    config = function()
      require("plugins/mason")
      require("lsp")
    end
  })

  -- Illuminate
  use({
    "RRethy/vim-illuminate",
    config = function()
      require("plugins/vim-illuminate")
    end,
  }) -- Illuminates current word in the document

  -- Fuzzy finder
  use({ "junegunn/fzf", run = "./install --all" })
  use({
    "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins/fzf")
    end,
  })

  -- Autocomplete
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins/nvim-cmp")
    end,
  })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "onsails/lspkind-nvim" })
  use({ "L3MON4D3/LuaSnip" }) -- Luasnip: Only for expansion of nvim-cmp

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("plugins/nvim-treesitter")
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })

  -- Gitsigns
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins/gitsigns")
    end,
  })

  -- Whichkey
  use({
    "folke/which-key.nvim",
    config = function()
      require("plugins/which-key")
    end,
  })

  -- Comments
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- Show indent lines
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins/indent-blankline")
    end,
  })

  -- Better quickfix
  use({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  })

  -- LSP addons
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
  use({ "jose-elias-alvarez/null-ls.nvim" })

  -- Prettier
  use('MunifTanjim/prettier.nvim')

  -- Explorer
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icon
    },
    config = function()
      require("plugins/nvim-tree")
    end,
  })

  -- Colorize hex values
  use("ap/vim-css-color")

  -- Modify faster (){}[] contents
  use("wellle/targets.vim")

  -- Find and replace
  use("nvim-pack/nvim-spectre")

  -- Status Line
  use({
    "hoob3rt/lualine.nvim",
    config = function()
      require("plugins/lualine")
    end,
  })

  -- Copilot
  use({
    "github/copilot.vim",
    config = function()
      require("plugins/copilot")
    end,
  })

  -- Git
  use("tpope/vim-fugitive")

  -- Add gS and gJ keymaps for smart split/join operations
  -- TODO: Port to Lua
  use("AndrewRadev/splitjoin.vim")

  -- Others
  use("tommcdo/vim-exchange")
  use("p00f/nvim-ts-rainbow")
  use("vim-test/vim-test")
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  }) -- TODO: Use more
  use("tpope/vim-repeat")
  use({
    "christoomey/vim-tmux-navigator",
    config = function()
      require("plugins/tmux-navigator")
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
