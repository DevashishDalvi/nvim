-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore last cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Cursorline only in active window
local cursorGrp = vim.api.nvim_create_augroup('CursorLine', { clear = true })

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = cursorGrp,
  command = 'set cursorline',
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = cursorGrp,
  command = 'set nocursorline',
})

-- Spell checking for certain files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us', 'en' }
  end,
})

-- Autosave buffer on leaving insert mode (safe)
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  callback = function()
    if vim.bo.modified and vim.fn.expand '%' ~= '' then
      vim.cmd 'silent! write'
    end
  end,
})

-- Treesitter folding
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('mariasolos/treesitter_folding', { clear = true }),
  desc = 'Enable Treesitter folding',
  callback = function(args)
    local bufnr = args.buf

    if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.cmd 'normal zx'
      end)
    end
  end,
})

-- Auto-compile & run C/C++
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.c', '*.cpp' },
  callback = function()
    local file = vim.fn.shellescape(vim.fn.expand '%:p')
    local output = vim.fn.shellescape(vim.fn.expand '%:t:r')
    local compiler = vim.bo.filetype == 'cpp' and 'g++' or 'gcc'

    -- Safer compile+run command
    local cmd = string.format('%s %s -o %s && %s; rm -f %s', compiler, file, output, output, output)

    -- Open terminal window
    vim.cmd 'botright split | resize 10'
    vim.cmd('terminal ' .. cmd)
    vim.cmd 'startinsert'
  end,
})

-- configuration for davinci resolve dctl dev
-- 1. Enable autoread locally for .dctl files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dctl",
  callback = function()
    vim.opt_local.autoread = true
  end,
})

-- 2. Trigger a check for external changes when focusing Neovim
-- This ensures that if you edit in Resolve, Neovim catches it immediately
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*.dctl",
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd("checktime")
    end
  end,
})
