-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local function map(mode, key, func, _desc, _noremap, _silent)
  local opts = { noremap = _noremap or true, silent = _silent or true, desc = _desc }
  -- local _mode = mode or 'n'
  vim.keymap.set(mode, key, func, opts)
end

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>e', '<cmd>Oil<CR>', 'Open [E]xplorer')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Move selected line / block of text in visual mode
map('v', '<M-j>', ":m '>+1<CR>gv=gv", 'Move Selection Down')
map('v', '<M-k>', ":m '<-2<CR>gv=gv", 'Move Selection Up')

-- Comment Keymap
map({ 'n', 'v' }, '<C-_>', 'gcc', 'Comment a line')
