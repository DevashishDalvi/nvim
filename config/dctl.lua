vim.filetype.add({
  extension = {
    dctl = "dctl",
  },
})

-- Treat DCTL as C for indentation + treesitter fallback
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dctl",
  callback = function()
    vim.bo.commentstring = "// %s"
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})
