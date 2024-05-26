vim.api.nvim_create_autocmd('User', { pattern = 'LeapEnter',
    callback = function()
      vim.cmd.hi('Cursor', 'blend=100')
      vim.opt.guicursor:append { 'a:Cursor/lCursor' }
    end,
  }
)
vim.api.nvim_create_autocmd('User', { pattern = 'LeapLeave',
    callback = function()
      vim.cmd.hi('Cursor', 'blend=0')
      vim.opt.guicursor:remove { 'a:Cursor/lCursor' }
    end,
  }
)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.mad" },
  callback = function()
    vim.lsp.start({
      name = "madlib",
      cmd = { "madlib", "lsp" },
      root_dir = vim.fs.dirname(vim.fs.find({ "madlib.json" }, { upward = true })[1]),
    })
  end,
})

-- MADLIB

-- vim.api.nvim_create_autocmd("BufWritePre", {
  -- pattern = {"*.mad"},
  -- command = [[ !madlib format -i % ]]
  -- callback = function()
    -- local view = vim.fn.winsaveview()
    -- os.execute("%! xargs -J{} -o madlib format --text {}")
    -- vim.cmd('%! xargs -J{} -o madlib format --text {}')
    -- if vim.v.shell_error ~= 0 then

      -- vim.cmd('undo')
    -- else
      -- vim.cmd('edit')
    -- end
    -- vim.fn.winrestview(view)
  -- end
-- })

vim.cmd [[
  function! MadlibFormat()
    let l:view = winsaveview()
    exec "%! xargs -J{} -0 madlib format --text {}"
    if v:shell_error != 0
      undo
    endif
    call winrestview(l:view)
  endfunction

  autocmd BufWritePre *.mad call MadlibFormat()
]]
