-- [[ Basic Keymaps ]]
local vim = vim
--  See `:help vim.keymap.set()`
local function map(mode, key, func, opts)
  local _opts = opts or { noremap = true, silent = true }
  -- local _mode = mode or 'n'
  vim.keymap.set(mode, key, func, _opts)
end

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'clear highlights on search' })
map('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Open [E]xplorer' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move selected line / block of text in visual mode
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })

-- Comment Keymap
map({ 'n', 'v', 't' }, '<C-_>', 'gcc', { desc = 'Comments line', remap = true })
map('v', '<C-_>', 'gc', { desc = 'Comments line block', remap = true })

-- Switch between windows.
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window', remap = true })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window', remap = true })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window', remap = true })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window', remap = true })

-- Show diagnostics automatically when navigating
vim.keymap.set('n', ']d', function()
  -- goto_next is depricated
  -- vim.diagnostic.goto_next()
  vim.diagnostic.jump { count = 1 }
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, { focus = false })
  end, 100)
end, { desc = 'Go to next diagnostic and show float' })

vim.keymap.set('n', '[d', function()
  -- goto_prev is depricated
  -- vim.diagnostic.goto_prev()
  vim.diagnostic.jump { count = -1 }
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, { focus = false })
  end, 100)
end, { desc = 'Go to previous diagnostic and show float' })
