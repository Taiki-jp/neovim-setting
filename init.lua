require("plugins")
require("base")
require("autocmds")
require("options")
require("keymaps")
require("colorscheme")

require("mason").setup()

-- Setup nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup({
  view = {
    width = 30,
  },
})

-- Setup nvim-treesitter
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
  auto_install = true,
  sync_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Default options
require 'nightfox'.setup({
  options = {
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled",
    transparent = true,
    terminal_colors = true,
    dim_inactive = false,
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic, bold",
    }
  }
})

vim.cmd("colorscheme nightfox")

-- Setup nvim-cmp.
local cmp = require 'cmp'
local map = cmp.mapping

cmp.setup({
  mapping = map.preset.insert {
    ['<C-d>'] = map.scroll_docs(-4),
    ['<C-f>'] = map.scroll_docs(4),
    ['<C-Space>'] = map.complete(),
    ['<C-e>'] = map.abort(),
    ['<CR>'] = map.confirm { select = false },
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

-- Setup language servers.
local nvim_lsp = require('lspconfig')
nvim_lsp.pyright.setup {}
-- nvim_lsp.tsserver.setup {}
--
-- nvim_lsp.solargraph.setup {
--   cmd = { "/home/titan/.gem/bin/solargraph", "stdio" },
--   filetypes = {
--     "ruby"
--   },
--   flags = {
--     debounce_text_changes = 150
--   },
--   root_dir = nvim_lsp.util.root_pattern("Gemfile",  ".git",  "."),
--   capabilities = capabilities,
--   handlers = handlers,
--   settings = {
--     solargraph = {
--       completion = true,
--       autoformat = false,
--       formatting = true,
--       symbols = true,
--       definitions = true,
--       references = true,
--       folding = true,
--       highlights = true,
--       diagnostics = true,
--       rename = true,
--     }
--   }
-- }


-- nvim_lsp.rubocop.setup{}
vim.opt.signcolumn = 'yes'
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.lsp.start {
      name = "rubocop",
      cmd = { "bundle", "exec", "rubocop", "--lsp" },
    }
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format()
  end,
})

nvim_lsp.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        checkThirdParty = "Disable",
      },
      format = {
        enable = true,
        provider = "lua-format",
        config = {
          indent_style = "space",
          indent_size = 2,
        },
      },
    },
  },
})

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({ function(server_name)
  local opts = {}
  opts.on_attach = function(_, bufnr)
    local bufopts = { silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'grg', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>p', vim.lsp.buf.format, bufopts)
  end
  nvim_lsp[server_name].setup(opts)
end
})

-- Setup for rubyfmt
-- local null_ls = require('null-ls')
-- null_ls.setup({
--   sources = {
--     null_ls.builtins.formatting.rubyfmt,
--     null_ls.builtins.diagnostics.eslint,
--     null_ls.builtins.completion.spell,
--   },
-- })

-- Setup Comment.nvim
local comment = require('Comment')
comment.setup()

-- Setup rails.vim
-- require('vim-rails').setup()

function insert_pry()
  local filetype = vim.bo.filetype
  if filetype == 'ruby' then
    vim.api.nvim_put({ 'binding.pry' }, 'l', true, true)
  elseif filetype == 'eruby' then
    vim.api.nvim_put({ '<% binding.pry %>' }, 'l', true, true)
  end
end

vim.api.nvim_set_keymap('n', '<leader>d', ':lua insert_pry()<CR>', { noremap = true, silent = true })

-- Setup gitsigns
require('gitsigns').setup {
  signs                        = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  auto_attach                  = true,
  attach_to_untracked          = false,
  current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}

-- Setup git.nvim
require('git').setup({
  default_mappings = true,
  keymaps = {
    -- Open blame window
    blame = "<Leader>gb",
    -- Close blame window
    quit_blame = "q",
    -- Open blame commit
    blame_commit = "<CR>",
    -- Open file/folder in git repository
    browse = "<Leader>go",
    -- Open pull request of the current branch
    open_pull_request = "<Leader>gp",
    -- Create a pull request with the target branch is set in the `target_branch` option
    create_pull_request = "<Leader>gn",
    -- Opens a new diff that compares against the current index
    diff = "<Leader>gd",
    -- Close git diff
    diff_close = "<Leader>gD",
    -- Revert to the specific commit
    revert = "<Leader>gr",
    -- Revert the current file to the specific commit
    revert_file = "<Leader>gR",
  },
  -- Default target branch when create a pull request
  target_branch = "master",
  -- Private gitlab hosts, if you use a private gitlab, put your private gitlab host here
  private_gitlabs = { "https://xxx.git.com" },
  -- Enable winbar in all windows created by this plugin
  winbar = false,
})
