local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--  --  --

vim.g.lt_height = 10
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
vim.g.nocompatible = 1
vim.g.termguicolors = false

vim.opt.autoread = true
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.expandtab = true
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2

--  --  --

require("lazy").setup({
  -- colorscheme (none currently)
  {
    "nordtheme/vim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_cursor_line_number_background = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_italic = true
      vim.g.nord_italic_comments = true
      vim.cmd([[colorscheme nord]])
    end,
  },
  -- others
  {
    "github/copilot.vim",
    cond = not vim.g.vscode,
  },
  "junegunn/vim-easy-align",
  {
    "lewis6991/gitsigns.nvim",
    cond = not vim.g.vscode,
    config = function(gs)
      local gs = require('gitsigns')
      gs.setup({
        on_attach = function(bufnr)
          require('nest').applyKeymaps({
            { buffer = bufnr,
              { mode = "ox", {
                { "ih", ":<C-U>Gitsigns select_hunk<CR>" },
                { "ah", ":<C-U>Gitsigns select_hunk<CR>" },
              }},
              { options = { expr = true }, {
                { "[c",
                  function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                  end
                },
                { "]c",
                  function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                  end
                },
              }},
              { "<leader>", {
                { "hs", gs.stage_hunk },
                { "hr", gs.reset_hunk },
                { "hu", gs.undo_stage_hunk },
              }},
            }
          })
        end
      })
    end,
  },
  "maxmellon/vim-jsx-pretty",
  {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "fannheyward/telescope-coc.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<C-j>"] = {
                actions.move_selection_next,
                type = "action",
                opts = { nowait = true, silent = true },
              },
              ["<C-k>"] = {
                actions.move_selection_previous,
                type = "action",
                opts = { nowait = true, silent = true },
              },
            },
          },
          file_ignore_patterns = {
            "node_modules",
            "**/*.pyz",
          },
          preview = {
            filesize_limit = 0.1, -- MB
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          coc = {
            theme = "ivy",
            prefer_locations = true,
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("coc")
    end,
  },
  "tpope/vim-abolish",
  "tpope/vim-commentary",
  "tpope/vim-endwise",
  {
    "tpope/vim-fugitive",
    cond = not vim.g.vscode,
    dependencies = {
      "tpope/vim-rhubarb"
    },
  },
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-tbone",
  "tpope/vim-unimpaired",
  "wellle/targets.vim",
  {
    "nvim-treesitter/nvim-treesitter",
    cond = not vim.g.vscode,
    cmd = "TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript",
          "lua",
          "python",
          "swift",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        indent = {
          enable = true,
          disable = { "jsx", "tsx" },
        },
        highlight = {
          enable = true,
          disable = { "jsx", "tsx", "help", "vimdoc" },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      })
    end,
  },
  -- coc.nvim
  {
    "neoclide/coc.nvim",
    branch = "release",
    --   { "neoclide/coc-tsserver", build = "yarn install --frozen-lockfile" },
    --   { "neoclide/coc-html", build = "yarn install --frozen-lockfile" },
    --   { "neoclide/coc-json", build = "yarn install --frozen-lockfile" },
    --   { "neoclide/coc-prettier", build = "yarn install --frozen-lockfile" },
    --   { "neoclide/coc-eslint", build = "yarn install --frozen-lockfile" },
    --   { "josa42/coc-lua", build = "yarn install --frozen-lockfile" },
  },
  -- keybindings
  {
    "lionc/nest.nvim",
    cond = not vim.g.vscode,
    dependencies = {
      "neoclide/coc.nvim",
    },
    config = function()
      require("nest").applyKeymaps({
        { "-", "<Cmd>Explore <CR>" },
        { "<C-t>", "<Cmd>tabnew <CR>" },
        { "j", "gj" },
        { "k", "gk" },
        { "K",
          function()
            if vim.fn.CocAction("hasProvider", "hover") then
              vim.fn.CocActionAsync("doHover")
            else
              vim.fn.feedkeys('K', 'n')
            end
          end
        },
        { "<leader>", {
          { "f", {
            { "f", "<Cmd>Telescope git_files find_command=rg,--ignore,--hidden,--files,--glob='!**/*.pyz'<CR>" },
            { "F", "<Cmd>Telescope find_files<CR>" },
            { "g", "<Cmd>Telescope live_grep<CR>" },
            { "b", "<Cmd>Telescope buffers<CR>" },
            { "h", "<Cmd>Telescope help_tags<CR>" },
            { "y", "<Cmd>Telescope command_history<CR>" },
            { ":", "<Cmd>Telescope commands<CR>" },
            { "-", "<Cmd>Telescope oldfiles<CR>" },
          }},
          { "g", {
            { "d", "<Plug>(coc-definition)" },
            { "i", "<Plug>(coc-implementation)" },
          }},
          { "c", {
              { "c", "<Cmd>Telescope coc commands<CR>" },
              { "r", "<Cmd>Telescope coc references<CR>" },
              { "a", "<Cmd>Telescope coc code_actions<CR>" },
              { "d", "<Cmd>Telescope coc diagnostics<CR>" },
              { "s", "<Cmd>Telescope coc symbols<CR>" },
              { "S", "<Cmd>Telescope coc workspace_symbols<CR>" },
              { "t", "<Cmd>Telescope coc type_definitions<CR>" },
              { "i", "<Cmd>Telescope coc implementations<CR>" },
              { "p", "<Cmd>Telescope coc list<CR>" },
          }},
          { "m", "<Cmd>CocCommand prettier.formatFile<CR>" },
          { "h", function() vim.o.hlsearch = not vim.o.hlsearch end },
          { "t", function() vim.b.copilot_enabled = not vim.b.copilot_enabled end }
          },
        },
        { "[g", "<Plug>(coc-diagnostic-prev)" },
        { "]g", "<Plug>(coc-diagnostic-next)" },
        { mode = "v", {
          { "m", "<Plug>(coc-format-selected)" }
        }},
      })
    end,
  },
})
