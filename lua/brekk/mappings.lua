-- mappings
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- turn off carriage-return for autocomplete porpoises
-- vim.keymap.set("i", "<CR>", function()
--     return vim.fn.pumvisible() ~= 0 and "<C-e><CR>" or "<CR>"
-- end, { expr = true, replace_keycodes = true })
