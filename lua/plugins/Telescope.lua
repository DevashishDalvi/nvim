return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- NOTE: Inspiration from https://github.com/SylvanFranklin
      defaults = {
        borderchar = { '', '', '', '', '', '', '', '' },
        mappings = {
          i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        },
        -- NOTE: set all the telescope mode tp start in normal mode instead of the default insert mode
        -- initial_mode = 'normal',
        path_displays = 'smart',
        sorting_strategy = 'ascending',
        layout_config = {
          -- border = 'single',
          height = 400,
          width = 400,
          prompt_position = 'top',
          preview_cutoff = 40,
        },
      },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    -- Function: open selected help topic in a floating window
    local function open_help_in_float(prompt_bufnr)
      local entry = action_state.get_selected_entry()
      actions.close(prompt_bufnr)

      -- Remember current window (so we can close the split that :help opens)
      local prev_win = vim.api.nvim_get_current_win()

      -- Open help normally (creates help buffer and window)
      vim.cmd('help ' .. entry.value)

      -- Grab help buffer + window
      local help_win = vim.api.nvim_get_current_win()
      local help_buf = vim.api.nvim_win_get_buf(help_win)

      -- Create floating window
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local float_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        border = 'rounded',
        style = 'minimal',
      }

      local float_win = vim.api.nvim_open_win(help_buf, true, float_opts)

      -- Close the original split help window
      if help_win ~= float_win and vim.api.nvim_win_is_valid(help_win) then
        pcall(vim.api.nvim_win_close, help_win, true)
      end

      -- Optional: allow closing with q
      vim.keymap.set('n', 'q', function()
        if vim.api.nvim_win_is_valid(float_win) then
          vim.api.nvim_win_close(float_win, true)
        end
      end, { buffer = help_buf, silent = true })
    end

    -- Use Telescope's help_tags picker normally
    vim.keymap.set('n', '<leader>sh', function()
      builtin.help_tags {
        attach_mappings = function(_, map)
          map('i', '<CR>', open_help_in_float)
          map('n', '<CR>', open_help_in_float)
          return true
        end,
      }
    end, { desc = '[S]earch [H]elp (float)' })
    
    -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    
    -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sf', function()
      local opts = themes.get_ivy {
        layout_config = {
          -- border = 'rounded',
          height = 13,
        },
        initial_mode = 'normal',
        winblend = 10,
      }
      builtin.find_files(opts)
    end, { desc = '[S]earch [F]iles' })

    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader><leader>', function()
      local opts = themes.get_ivy {
        layout_config = {
          height = 15,
        },
        initial_mode = 'normal',
        -- previewer = false,
      }
      builtin.buffers(opts)
    end, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
