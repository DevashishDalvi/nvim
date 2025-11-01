local arrows = require('Icons').arrows
local vim = vim
--stylua: ignore start

-- General ====================================================================
vim.g.mapleader      = ' ' -- Use `<Space>` as a leader key
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

vim.o.mouse       = 'a'            -- Enable mouse
-- vim.o.mousescroll = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf   = 'usetab'       -- Use already opened buffers when switching
vim.o.undofile    = true           -- Enable persistent undo

-- vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
vim.o.breakindent    = true       -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
vim.o.colorcolumn    = '+1'       -- Draw column on the right of maximum width
vim.o.textwidth      = 80

-- For highlighting characters over 80 columns in all files
vim.api.nvim_set_hl(0, "OverLength", { ctermbg = "red", bg = "#592929" })
vim.fn.matchadd("OverLength", "\\%>80v.\\+")

vim.o.confirm        = true
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.inccommand     = 'split'    -- Preview substitutions live, as you type!
vim.o.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true       -- Show helpful text indicators
vim.o.number         = true       -- Show line numbers
vim.o.pumheight      = 10         -- Make popup menu smaller
vim.o.relativenumber = true       -- Make line number relative to current line
vim.o.ruler          = false      -- Don't show cursor coordinates
vim.o.scrolloff      = 10         -- Minimal number of screen lines to keep above and below the cursor.
vim.o.shortmess      = 'CFOSWaco' -- Disable some built-in completion messages
vim.o.showmode       = false      -- Don't show mode in command line
vim.o.signcolumn     = 'yes'      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitkeep      = 'screen'   -- Reduce scroll during window split
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.timeoutlen     = 300        -- Decrease mapped sequence wait time
vim.o.ttimeoutlen    = 10         -- Decrease mapped sequence wait time
vim.o.updatetime     = 250        -- Decrease update time
vim.o.wrap           = false      -- Don't visually wrap lines (toggle with \w)
vim.o.winborder      = 'rounded'

vim.o.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols
-- vim.o.foldlevelstart = 99
-- vim.wo.foldtext = ''
vim.opt.fillchars = {
    eob       = ' ',
    fold      = ' ',
    foldclose = arrows.right,
    foldopen  = arrows.down,
    foldsep   = ' ',
    -- foldinner = ' ',
    msgsep    = '─',
}
-- vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:» , trail=·'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '…', precedes = '…' }

-- Folds (default behavior; see `:h Folding`)
vim.o.foldlevel      = 1        -- Fold everything except top level
vim.o.foldlevelstart = 99
vim.o.foldcolumn     = '1'
vim.o.foldmethod     = 'indent' -- Fold based on indent level
vim.o.foldnestmax    = 10       -- Limit number of fold levels

-- Neovim version specific
if vim.fn.has('nvim-0.10') == 0 then
  vim.o.termguicolors = true
end

if vim.fn.has('nvim-0.10') == 1 then
  vim.o.foldtext = '' -- Show text under fold with its highlighting
end

-- if vim.fn.has('nvim-0.11') == 1 then
--   vim.o.winborder = 'double' -- Use border in floating windows
--
--   -- Disable "press-enter" for messages not from manually executing a command
--   vim.o.messagesopt = 'wait:500,history:500'
--   local make_set_messagesopt = function(value) return vim.schedule_wrap(function() vim.o.messagesopt = value end) end
--   _G.Config.new_autocmd('CmdlineEnter', '*', make_set_messagesopt('hit-enter,history:500'))
--   _G.Config.new_autocmd('CmdlineLeave', '*', make_set_messagesopt('wait:500,history:500'))
-- end

if vim.fn.has('nvim-0.12') == 1 then
  vim.o.pummaxwidth = 100 -- Limit maximum width of popup menu
  vim.o.completefuzzycollect = 'keyword,files,whole_line' -- Use fuzzy matching when collecting candidates
  vim.o.completetimeout = 100

  vim.o.pumborder = 'single'

  require('vim._extui').enable({ enable = true })

  -- -- Command line autocompletion
  -- vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
  -- vim.o.wildmode = 'noselect:lastused'
  -- vim.o.wildoptions = 'pum,fuzzy'
  -- vim.keymap.set('c', '<Up>', '<C-u><Up>')
  -- vim.keymap.set('c', '<Down>', '<C-u><Down>')
  -- -- TODO: Make this part of 'mini.keymap'
  -- vim.keymap.set('c', '<Tab>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
  -- vim.keymap.set('c', '<S-Tab>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
end

-- Editing ====================================================================
vim.o.autoindent    = true       -- Use auto indent
vim.o.expandtab     = true       -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j'   -- Improve comment editing
vim.o.ignorecase    = true       -- Ignore case during search
vim.o.incsearch     = true       -- Show search matches while typing
vim.o.infercase     = true       -- Infer case in built-in completion
vim.o.shiftwidth    = 2          -- Use this number of spaces for indentation
vim.o.smartcase     = true       -- Respect case if search pattern has upper case
vim.o.smartindent   = true       -- Make indenting smart
vim.o.spelllang     = 'en,uk,ru' -- Define spelling dictionaries
vim.o.spelloptions  = 'camel'    -- Treat camelCase word parts as separate words
vim.o.tabstop       = 2          -- Show tab as this number of spaces
vim.o.virtualedit   = 'block'    -- Allow going past end of line in blockwise mode

vim.o.iskeyword  = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt' -- Use specific dictionaries

-- Pattern for a start of 'numbered' list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete    = '.,w,b,kspell'     -- Use less sources
-- vim.o.completeopt = 'menuone,noselect' -- Use custom behavior

-- if vim.fn.has('nvim-0.11') == 1 then
--   vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
-- end

-- Cyrillic keyboard layout
local langmap_keys = {
  'ёЁ;`~', '№;#',
  'йЙ;qQ', 'цЦ;wW', 'уУ;eE', 'кК;rR', 'еЕ;tT', 'нН;yY', 'гГ;uU', 'шШ;iI', 'щЩ;oO', 'зЗ;pP', 'хХ;[{', 'ъЪ;]}',
  'фФ;aA', 'ыЫ;sS', 'вВ;dD', 'аА;fF', 'пП;gG', 'рР;hH', 'оО;jJ', 'лЛ;kK', 'дД;lL', [[жЖ;\;:]], [[эЭ;'\"]],
  'яЯ;zZ', 'чЧ;xX', 'сС;cC', 'мМ;vV', 'иИ;bB', 'тТ;nN', 'ьЬ;mM', [[бБ;\,<]], 'юЮ;.>',
}
vim.o.langmap = table.concat(langmap_keys, ',')

-- Autocommands ===============================================================
-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
-- local ensure_fo = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
-- _G.Config.new_autocmd('FileType', '*', ensure_fo, "Proper 'formatoptions'")

-- Diagnostics ================================================================
-- local diagnostic_opts = {
--   -- Show signs on top of any other sign, but only for warnings and errors
--   signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
--
--   -- Show all diagnostics as underline (for their meessages type `<Leader>ld`)
--   underline = { severity = { min = 'HINT', max = 'ERROR' } },
--
--   -- Show more details immediately only for errors at current line end
--   virtual_lines = false,
--   virtual_text = {
--     current_line = true,
--     severity = { min = 'ERROR', max = 'ERROR' },
--   },
--
--   -- Don't update diagnostics when typing
--   update_in_insert = false,
-- }

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
-- MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
--stylua: ignore end

------------------------------------------------------------------------------------------------------------

-- local vim = vim
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
--
-- vim.g.have_nerd_font = false
--
-- -- Make line numbers default
-- vim.o.number = true
-- -- You can also add relative line numbers, to help with jumping.
-- --  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true
--
-- -- Enable mouse mode, can be useful for resizing splits for example!
-- vim.o.mouse = 'a'
--
-- -- Don't show the mode, since it's already in the status line
-- vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- -- Enable break indent
-- vim.o.breakindent = true
--
-- -- Save undo history
-- vim.o.undofile = true
--
-- -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
--
-- -- Keep signcolumn on by default
-- vim.o.signcolumn = 'yes'
--
-- -- Decrease update time
-- vim.o.updatetime = 250
--
-- -- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300
--
-- -- Configure how new splits should be opened
-- vim.o.splitright = true
-- vim.o.splitbelow = true
--
-- -- Sets how neovim will display certain whitespace characters in the editor.
-- --  See `:help 'list'`
-- --  and `:help 'listchars'`
-- --
-- --  Notice listchars is set using `vim.opt` instead of `vim.o`.
-- --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
-- --   See `:help lua-options`
-- --   and `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
--
-- -- Preview substitutions live, as you type!
-- vim.o.inccommand = 'split'
--
-- -- Show which line your cursor is on
-- vim.o.cursorline = true
--
-- -- Minimal number of screen lines to keep above and below the cursor.
-- vim.o.scrolloff = 10
--
-- -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- -- instead raise a dialog asking if you wish to save the current file(s)
-- -- See `:help 'confirm'`
-- vim.o.confirm = true
--
-- -- turn off wrap
-- vim.o.wrap = false

-- Set terminal shell to powershell
vim.o.shell        = 'pwsh.exe'
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command $PSStyle.OutputRendering = 'PlainText';"
vim.o.shellredir   = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe    = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellquote   = ''
vim.o.shellxquote  = ''
