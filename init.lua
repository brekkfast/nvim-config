local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function () 
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query","javascript", "jsdoc", "typescript", "html" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
  },
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',  
  'neovim/nvim-lspconfig',
  -- {
  -- "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- },
  { 'junegunn/fzf', dir = '~/.fzf', build = './install --all' },
  'stevearc/overseer.nvim',
  'nvim-lua/plenary.nvim',
  'andythigpen/nvim-coverage',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine'
  },
  'folke/trouble.nvim',
  { 'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify'
    }
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      {
        "<Leader>w", mode = { "n" }, function()
          local Flash = require("flash")

          ---@param opts Flash.Format
          local function format(opts)
            -- always show first and second label
            return {
              { opts.match.label1, "FlashMatch" },
              { opts.match.label2, "FlashLabel" },
            }
          end

          Flash.jump({
            search = { mode = "search" },
            label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
            pattern = [[\<]],
            action = function(match, state)
              state:hide()
              Flash.jump({
                search = { max_length = 0 },
                highlight = { matches = false },
                label = { format = format },
                matcher = function(win)
            -- limit matches to the current label
            return vim.tbl_filter(function(m)
              return m.label == match.label and m.win == win
            end, state.results)
                end,
                labeler = function(matches)
            for _, m in ipairs(matches) do
              m.label = m.label2 -- use the second label
            end
                end,
              })
            end,
            labeler = function(matches, state)
              local labels = state:labels()
              for m, match in ipairs(matches) do
                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                match.label2 = labels[(m - 1) % #labels + 1]
                match.label = match.label1
              end
            end,
          })
        end,
        desc="Flash word"
      }
    }
  },
  {'stevearc/conform.nvim',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim'
    }
  },
  'norcalli/nvim-colorizer.lua',
  'madlib-lang/vim-madlib',
  {
    "folke/ts-comments.nvim",
    lang = {
      madlib = "// %s",
    },
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  'MunifTanjim/prettier.nvim',
  -- {
  --   name = 'vim-madlib',
  --   dir = '~/madness/vim-madlib',
  --   dev = true,
  --   branch = 'commentstring'
  -- }
  
  -- 'mfussenegger/nvim-lsp-compl'
  -- 'hrsh7th/cmp-vsnip',
  -- 'hrsh7th/nvim-cmp'
  -- 'deathbeam/autocomplete.nvim'
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3'
  }
})
require('brekk.settings')
require('brekk.plugins')
-- theme must be after plugins are set
require('brekk.theme')
require('brekk.mappings')
require('brekk.autocmd')

