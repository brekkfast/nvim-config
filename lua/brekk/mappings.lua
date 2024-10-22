-- mappings
-- vim.keymap.set("n", "<leader>xx", function()
-- 	require("trouble").toggle({ mode = "test", filter = { buf = 0 } })
-- 	-- require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
-- end)
-- vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
-- vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
-- vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
-- vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
-- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- turn off carriage-return for autocomplete porpoises
-- vim.keymap.set("i", "<CR>", function()
--     return vim.fn.pumvisible() ~= 0 and "<C-e><CR>" or "<CR>"
-- end, { expr = true, replace_keycodes = true })

-- function! PeelRange(file) range
--   let peel = a:firstline.",".a:lastline."w ".a:file
--   let core = a:firstline.",".a:lastline."d"
--   exec peel
--   exec core
--   echo "peeling and coring"
-- endfunction

-- local function commentary()
--     local phrase = vim.fn.input("Prompt for AI: ")
--     vim.cmd(":'<,'>AIEdit " .. phrase)
-- end
-- vim.keymap.set("v", "<space>ae", ai_edit_prompt)

-- vim.api.nvim_create_user_command('Pizzafy',
--   function(args)
--      if args.range > 0 then
--         -- visual mode, I think
--         print(args.line1 .. "-" .. args.line2 .. " pizzas")
--      else
--         -- normal or insert mode
--         print("normal amount of pizzas")
--      end
--   end,
--   { nargs = 0, range = true }
-- )

vim.api.nvim_create_user_command("Commentary", function(args)
  if args.range > 0 then
    print(args.line1 .. "->" .. args.line2 .. " ???")
  else
    print("non-range!")
    print(args)
  end
end, { nargs = 0, range = true })

vim.api.nvim_create_user_command("ESLint", function()
  require("lint").try_lint("eslint")
end, { nargs = 0 })
