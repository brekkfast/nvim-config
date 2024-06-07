-- MADLIB
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

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.mad" },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[silent %! madlib format -i %]])
    if vim.v.shell_error ~= 0 then
      vim.cmd.u()
    else
      vim.cmd.w()
    end
    vim.fn.winrestview(view)
  end,
  group = madlib_lsp_group
})
