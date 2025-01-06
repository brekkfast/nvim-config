require("nvim-web-devicons").setup()
require("nvim-tree").setup()
require("lualine").setup()
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    astro = { "prettierd", "prettier" },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

require("overseer").setup({
  templates = { "builtin", "user.madlib_test" },
})

require("noice").setup({
  cmdline = {
    view = "cmdline_popup",
    -- view = "cmdline"
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  messages = {
    enabled = true,
    -- view = "notify",
    view = "mini",
    -- view_error = "messages"
    view_error = "mini",
  },
  mini = {
    timeout = 1750,
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})
require("coverage").setup({
  commands = true,
  auto_reload = true,
  highlights = {
    covered = { fg = "#C3E88D" },
    uncovered = { fg = "#DD0000" },
  },
  signs = {
    covered = { hl = "CoverageCovered", text = "❤" },
    uncovered = { hl = "CoverageUncovered", text = "∅" },
    partial = { hl = "CoveragePartial", text = "∂" },
  },
  summary = {
    min_coverage = 80.0,
  },
  lang = {
    madlib = {
      coverage_file = ".coverage/lcov.info",
      coverage_command = "madlib test --coverage",
    },
  },
})
vim.opt.termguicolors = true
require("colorizer").setup()

local prettier = require("prettier")

prettier.setup({
  bin = "prettierd", -- or `'prettierd'` (v0.23.3+)
  cli_options = {
    use_tabs = false,
    tab_width = 2,
  },
  filetypes = {
    "css",
    "graphql",
    "html",
    "astro",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

-- local cmp = require('cmp')
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.snippet.expand(args.body)
--     end,
--   },
--   window = {
--     completion = cmp.config.window.bordered(),
--     -- documentation = cmp.config.window.bordered(),
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--   }),
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- LSP signature help
-- require("autocomplete.signature").setup {
--     border = nil, -- Signature help border style
--     width = 80, -- Max width of signature window
--     height = 25, -- Max height of signature window
--     debounce_delay = 100
-- }

-- buffer autocompletion with LSP and Tree-sitter
-- require("autocomplete.buffer").setup {
--     entry_mapper = nil, -- Custom completion entry mapper
--     debounce_delay = 100
-- }

-- cmdline autocompletion
-- require("autocomplete.cmd").setup {
--     mappings = {
--         accept = '<C-y>',
--         reject = '<C-e>',
--         complete = '<C-space>',
--         next = '<C-n>',
--         previous = '<C-p>',
--     },
--     border = nil, -- Cmdline completion border style
--     columns = 5, -- Number of columns per row
--     rows = 0.3, -- Number of rows, if < 1 then its fraction of total vim lines, if > 1 then its absolute number
--     close_on_done = true, -- Close completion window when done (accept/reject)
--     debounce_delay = 100,
-- }

-- Here we grab default Neovim capabilities and extend them with ones we want on top
-- local capabilities = vim.tbl_deep_extend('force',
--     vim.lsp.protocol.make_client_capabilities(),
--     require('autocomplete.capabilities'))

-- Now set capabilities on your LSP servers
require("lspconfig")["madlib"].setup({
  capabilities = capabilities,
})

require("lspconfig")["hls"].setup({
  filetypes = { "haskell", "lhaskell", "cabal" },
})

local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
  return
end

local protocol = require("vim.lsp.protocol")

-- local on_attach = function(client, bufnr)
-- format on save
-- if client.server_capabilities.documentFormattingProvider then
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- group = vim.api.nvim_create_augroup("Format", { clear = true }),
-- buffer = bufnr,
-- callback = function() vim.lsp.buf.formatting_seq_sync() end
-- })
-- end
-- end

-- TypeScript
nvim_lsp.tsserver.setup({
  -- on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
})

local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

ts.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "toml",
    "fish",
    "php",
    "json",
    "yaml",
    "swift",
    "css",
    "html",
    "lua",
    "astro",
  },
  autotag = {
    enable = true,
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

require("nvim-px-to-rem").setup({
  root_font_size = 16,
  decimal_count = 4,
  show_virtual_text = true,
  add_cmp_source = false,
  filetypes = {
    "css",
    "scss",
    "sass",
  },
})
-- require("nvim-cmp").setup({
-- other config
-- sources = cmp.config.sources({
-- { name = "nvim_px_to_rem" },
-- other sources
-- }),
-- })
