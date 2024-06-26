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
  print("Installing packer close and reopen Neovim...")
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

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  use({ "wbthomason/packer.nvim" })
  use({ "nvim-lua/plenary.nvim" }) -- Common utilities

  -- Colorschemes
  use({ "EdenEast/nightfox.nvim" })       -- Color scheme

  use({ "nvim-lualine/lualine.nvim" })    -- Statusline
  use({ "windwp/nvim-autopairs" })        -- Autopairs, integrates with both cmp and treesitter
  use({ "kyazdani42/nvim-web-devicons" }) -- File icons
  use({ "akinsho/bufferline.nvim" })

  -- cmp plugins
  use({ "hrsh7th/nvim-cmp" })         -- The completion plugin
  use({ "hrsh7th/cmp-buffer" })       -- buffer completions
  use({ "hrsh7th/cmp-path" })         -- path completions
  use({ "hrsh7th/cmp-cmdline" })      -- cmdline completions
  use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "onsails/lspkind-nvim" })

  -- snippets
  use({ "L3MON4D3/LuaSnip" }) --snippet engine

  -- LSP
  -- obsolete. Use mason-lspconfig.nvim instead of nvim-lspconfig
  use({ "neovim/nvim-lspconfig" }) -- enable LSP
  use({ "williamboman/mason-lspconfig.nvim" })
  -- obsolete. Use mason.nvim instead of nvim-lsp-installer
  -- use({ "williamboman/nvim-lsp-installer" }) -- simple to use language server installer
  use({ "williamboman/mason.nvim" })
  use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use({ "glepnir/lspsaga.nvim" })            -- LSP UIs

  -- Formatter
  use({ "MunifTanjim/prettier.nvim" })

  -- Telescope
  use({ "nvim-telescope/telescope.nvim" })

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" } })
  use({ "nvim-telescope/telescope-file-browser.nvim" })

  use({ "windwp/nvim-ts-autotag" })

  -- Comment
  use({ "numToStr/Comment.nvim" })

  -- File Explorler FIXME: failed to install
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }

  -- Rails
  use({ 'tpope/vim-rails', ft = 'ruby' })
  use({ 'BlakeWilliams/vim-pry' })

  use({ 'github/copilot.vim' })
  -- Copilot Chat for Neovim
  use({
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = "canary",
    dependencies = { { "zbirenaum/copilot.lua" }, { "nvim-lua/plenary.nvim" } },
    opts = {
      debug = true,
    },
  })
  -- Git
  use({ 'lewis6991/gitsigns.nvim' })
  use { 'dinhhuy258/git.nvim' }
  -- surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })

	use({
	    "iamcco/markdown-preview.nvim",
	    run = function() vim.fn["mkdp#util#install"]() end,
	})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

  -- chatgpt
  -- use({
  --   "jackMort/ChatGPT.nvim",
  --   config = function() require("chatgpt").setup({}) end,
  --   requires = {
  --       "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim",
  --       "nvim-telescope/telescope.nvim"
  --   }
  -- })
end)
-- install without yarn or npm

