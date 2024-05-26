require('nvim-web-devicons').setup()
require('nvim-tree').setup()
require('trouble').setup()
require('lualine').setup()
require('Comment').setup()
require('conform').setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { { "prettierd", "prettier" } }
  },
  format_on_save = {timeout_ms = 500, lsp_fallback = true},
})

local ft = require('Comment.ft')
ft.javascript = {'// %s', '/* %s */'}
ft.madlib = {'// %s', '/* %s */'}

require('noice').setup({
  cmdline = {
    view = "cmdline_popup",
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
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
  mini = {
    timeout = 4000
  }
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
    }
  }
})
