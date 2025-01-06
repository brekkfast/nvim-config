local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "jsdoc", "typescript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "neovim/nvim-lspconfig",
  "jsongerber/nvim-px-to-rem",
  -- {
  -- "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- },
  "kikito/inspect.lua",
  "ibhagwan/fzf-lua",
  "stevearc/overseer.nvim",
  "nvim-lua/plenary.nvim",
  "andythigpen/nvim-coverage",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  -- {
  -- "folke/trouble.nvim",
  -- version = "2.1.0",
  -- },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        test = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
          filter = {
            any = {
              buf = 0, -- current buffer
              {
                -- severity = vim.diagnostic.severity.ERROR, -- errors only
                -- limit to files in the current project
                function(item)
                  return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                end,
              },
            },
          },
        },
      },
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble test toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
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
        "<Leader>w",
        mode = { "n" },
        function()
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
        desc = "Flash word",
      },
    },
  },
  { "stevearc/conform.nvim", dependencies = {
    "jose-elias-alvarez/null-ls.nvim",
  } },
  "mfussenegger/nvim-lint",
  -- { "mfussenegger/nvim-lint", opts = {
  --   linters_by_ft = {
  --     js = { "eslint" },
  --   },
  -- } },
  "norcalli/nvim-colorizer.lua",
  "madlib-lang/vim-madlib",
  {
    "folke/ts-comments.nvim",
    lang = {
      madlib = "// %s",
    },
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  "MunifTanjim/prettier.nvim",
  -- {
  --   name = 'vim-madlib',
  --   dir = '~/madness/vim-madlib',
  --   dev = true,
  --   branch = 'commentstring'
  -- }

  -- 'mfussenegger/nvim-lsp-compl'
  -- 'hrsh7th/cmp-vsnip',
  "hrsh7th/nvim-cmp",
  -- 'deathbeam/autocomplete.nvim'
  -- {
  --  'mrcjkb/haskell-tools.nvim',
  --  version = '^4',
  --  lazy= false,
  -- },
  "wuelnerdotexe/vim-astro",
  {
    "isak102/ghostty.nvim",
    config = function()
      require("ghostty").setup({
        file_pattern = "*/com.mitchellh.ghostty/config",
      })
    end,
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
    ft = "ghostty",
  },
})
require("brekk.settings")
require("brekk.plugins")
-- theme must be after plugins are set
require("brekk.theme")
require("brekk.mappings")
require("brekk.autocmd")
