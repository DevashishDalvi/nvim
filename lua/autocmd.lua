local vim = vim
local api = vim.api
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup('CursorLine', { clear = true })
api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  pattern = '*',
  command = 'set cursorline',
  group = cursorGrp,
})
api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, { pattern = '*', command = 'set nocursorline', group = cursorGrp })

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { 'BufRead', 'BufNewFile' },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { '*.txt', '*.md', '*.tex' },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = 'en'
    end,
  }
)

api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  pattern = '*',
  callback = function()
    if vim.bo.modified then
      vim.cmd 'silent! write'
    end
  end,
})

api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('mariasolos/treesitter_folding', { clear = true }),
  desc = 'Enable Treesitter folding',
  callback = function(args)
    local bufnr = args.buf

    -- Enable Treesitter folding when not in huge files and when Treesitter
    -- is working.
    if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.cmd.normal 'zx'
      end)
    end
  end,
})

-- NOTE: self explanatory:
-- this autocmd just shows the diagnostics float window for the current line where cursor is,
-- hence CursorHold
-- WARN: works even not needed
-- it will show window when cursor on diagnostic suggestion
--
-- vim.o.updatetime = 500  -- Adjust delay (ms)
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focus = false })
--   end,
-- })
--
--

-- Auto-compile & run C/C++ files on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.c', '*.cpp' },
  callback = function()
    -- Close any existing terminal window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == 'terminal' then
        vim.api.nvim_win_close(win, true)
      end
    end

    -- Get current file info
    local file = vim.fn.expand '%:p' -- full path
    local output = vim.fn.expand '%:t:r' -- filename without extension
    local ft = vim.bo.filetype -- c or cpp
    local compiler = ft == 'cpp' and 'g++' or 'gcc'

    -- Build command: compile and run
    local cmd = string.format("%s '%s' -o '%s' && './%s'; rm -f '%s'", compiler, file, output, output, output)

    vim.cmd('belowright split | resize 10 | terminal ' .. cmd)
    vim.cmd 'startinsert'
  end,
})
