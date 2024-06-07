-- show line numbers
vim.wo.number = true
-- tabby
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
-- indents
vim.o.autoindent = true
-- vim.o.nosmartindent = true
-- case
vim.o.ignorecase = true
-- status line
-- vim.go.lazyredraw = true
vim.o.signcolumn = "yes"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 10
vim.o.foldnestmax = 10
vim.o.backspace = [[indent,eol,start]]
vim.o.cmdheight = 2
vim.o.laststatus = 2
-- diagnostics
-- vim.diagnostic.config({
--   virtual_text = false
-- })

vim.o.commentstring = "// %s"
