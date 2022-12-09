" DEPENDENCIES (Installed using distribution package manager)
" Font: FiraCode Nerd Font Mono: https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
"-Git
"-fixjson
"-prettier
"-stylua
"-stylelint
"-selene-linter
"-codespell

" ----------------- LUA CONFIG ---------------------------
lua <<EOF
------------------------ CORE SETTINGS ---------------------------
local getCwdName = function()
  local cwd = vim.loop.cwd()
  return string.match(cwd,"[^\\/]+$")
end

vim.o.shellcmdflag = '-ic'
-- DEFINE LEADER
vim.g.mapleader =","

--CHARACTER ENCODING
vim.opt.encoding='utf-8' -- The encoding displayed.
vim.opt.fileencoding='utf-8' -- The encoding written to file.

--NODE PROVIDER (Make sure it has same version than nvm current)
--vim.g.node_host_prog = vim.fn.expand('~/.nvm/versions/node/v16.13.0/bin/neovim-node-host')

--SAVE/OPEN BEHAVIOR
vim.opt.hidden = true -- Open new files using :e without having to save the buffer

-- CLIPBOARD
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'-- Set clipboard

-- LINE NUMBERS
vim.opt.number = true -- Line number in gutter
-- vim.opt.relativenumber = true -- Line number relative to cursor

-- NATURAL SPLITS
vim.o.splitbelow = true
vim.o.splitright = true

-- VISUAL STYLES
vim.opt.termguicolors = true -- Set true colors
vim.opt.guifont = 'FiraCode Nerd Font Mono:h16'
vim.opt.syntax = 'enable' -- Set syntax highlight

-- RELOAD BUFFERS WHEN CHANGING ON DISK
vim.opt.autoread = true
vim.cmd [[autocmd FocusGained,BufEnter * checktime]]
vim.cmd [[autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk." | echohl None]]

------------------------ PLUGINS MANAGER -------------------------
require('plugins_manager')

------------------------ AUTO PAIRS -------------------------
-- require('pears').setup() --function(conf)
  -- conf.preset "tag_matching"
  -- conf.on_enter(function(pears_handle)
  --   local cmp = require 'cmp'
  --   if cmp.visible() then
  --     return cmp.confirm({select = true})
  --   else
  --     pears_handle()
  --   end
  -- end)
-- end)

require('mini.pairs').setup({})
------------------------ BUFFERS LINE -------------------------
 require('bufferline').setup({
 options = {
     theme = 'nordfox',
     diagnostics = 'nvim_lsp',
     separator_style = "thin",
     show_buffer_close_icons = false,
     close_command = 'conf bwipe %d'
   }
 })

------------------------ BUFFERS REMOVAL -------------------------
 require('mini.bufremove').setup({})

------------------------ CHEATSHEET -------------------------

 require('cheatsheet').setup({
   bundled_cheatsheets = false,
   bundled_plugin_cheatsheets = false,
 })
 -- Default mapping is not working
 vim.api.nvim_set_keymap('n', '<leader>?', '<cmd>Cheatsheet<CR>', { noremap=false, silent=true })

------------------------ COLOR THEME -------------------------
vim.cmd('colorscheme nordfox')

------------------------ COMMENTS -------------------------
 require('Comment').setup()

------------------------ DASHBOARD -----------------
 local alpha = require("alpha")
 local dashboard = require("alpha.themes.dashboard")

 -- Set menu
 dashboard.section.buttons.val = {
     dashboard.button( "er", "  Recent" , ":Telescope oldfiles<CR>"),
     dashboard.button( "ep", "פּ  Projects" , ":Telescope projects<CR>"),
     dashboard.button( "eh", "ﴤ  Home Explorer" , ":Telescope file_browser path=$HOME<CR>"),
     dashboard.button( "ew", "ﱮ  CWD Explorer" , ":Telescope file_browser<CR>"),
     dashboard.button( "nf", "  New file" , ":ene <BAR> startinsert <CR>"),
     dashboard.button( "ff", "  Find file", ":Telescope find_files find_command=rg,--hidden,--files<CR>"),
     dashboard.button( "fs", "  Find string in CWD", ":Telescope live_grep<CR>"),
     dashboard.button( "up", "  Update plugings", ":PackerSync<CR>"),
     dashboard.button( "se", "  Settings" , ":e $MYVIMRC<CR>"),
     dashboard.button( "qa", "  Quit NVIM", ":conf qa<CR>"),
 }

 -- Send config to alpha
 alpha.setup(dashboard.opts)

 -- Automatically open alpha when the last buffer is deleted and only one window left
 -- Not working with tabs
 vim.cmd [[ au BufDelete * if empty(filter(tabpagebuflist(), '!buflisted(v:val)')) && winnr('$') == 1 | exec 'Alpha' | endif ]]

------------------------ ILLUMINATE -----------------
 vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
 vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
 vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
 vim.api.nvim_set_keymap('n', '<M-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
 vim.api.nvim_set_keymap('n', '<M-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})

------------------------ INDENTATION, SPECIAL CHARS CONFIG -----------------
 vim.opt.list = true
 vim.opt.listchars={eol = '↴', tab = '▸ ', trail = '·'}

 require("indent_blankline").setup {
   char = "|",
   buftype_exclude = {"terminal"},
   filetype_exclude = { "alpha" },
   show_end_of_line = true,
 }
------------------------ GIT -------------------------
 require('gitsigns').setup{
     keymaps = {
     noremap = true,
     ['n <leader>gah'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
     ['v <leader>gah'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
     ['n <leader>guh'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
     ['n <leader>grh'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
     ['v <leader>grh'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
     ['n <leader>grf'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
     ['n <leader>gil'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
     ['n <leader>gaf'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
   },
 }
 vim.api.nvim_set_keymap('n', '<leader>mt', '<plug>(MergetoolToggle)',{noremap=false})
 vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>MergetoolDiffExchangeLeft<CR>',{noremap=true})
 vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>MergetoolDiffExchangeRight<CR>',{noremap=true})
 vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>MergetoolDiffExchangeDown<CR>',{noremap=true})
 vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>MergetoolDiffExchangeUp<CR>',{noremap=true})

------------------------ LIGHTBULB -------------------------
 vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

------------------------ MOTIONS: LIGHTSPEED -------------------------
 require('lightspeed')

 vim.api.nvim_set_keymap('n', 'x', '<Plug>Lightspeed_x', { noremap=false, silent=true })
 vim.api.nvim_set_keymap('v', 'x', '<Plug>Lightspeed_x', { noremap=false, silent=true })
 vim.api.nvim_set_keymap('n', 'X', '<Plug>Lightspeed_X', { noremap=false, silent=true })
 vim.api.nvim_set_keymap('n', 'X', '<Plug>Lightspeed_X', { noremap=false, silent=true })

------------------------ LSP -------------------------
-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Preview for LSP's goto definition
require('goto-preview').setup {}
vim.api.nvim_set_keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true})

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp', },
    { name = 'luasnip' },
  },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local default_on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('x', '<leader>ca', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
  buf_set_keymap('n', 'gpr', '<cmd>lua require("goto-preview").goto_preview_references()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', 'gpi', '<cmd>lua require("goto-preview").goto_preview_implementation()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', 'gpd', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'gpD', '<cmd>lua require("goto-preview").goto_preview_type_definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>Telescope lsp_type_definitions<CR>', opts)
  buf_set_keymap('n', '<leader>fd', '<cmd>Telescope diagnostics<CR>', opts)
  buf_set_keymap('n', '<leader>sd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- Illuminate highlighting
 require 'illuminate'.on_attach(client) -- end
end

--null-ls
local null_ls = require("null-ls")

-- register any number of sources simultaneously
local null_ls_sources = {
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.code_actions.gitsigns,
}

local LspFormatAugroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  sources = null_ls_sources,
  on_attach = function(client,bufnr)
    if client.supports_method("textDocument/rangeFormatting") then
      local lsp_format_modifications = require"lsp-format-modifications"
      lsp_format_modifications.attach(client, bufnr, { format_on_save = true })
    elseif client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = LspFormatAugroup , buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = LspFormatAugroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- lsp server installer
local lsp_installer = require("nvim-lsp-installer")
-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = function(client,bufnr)
        default_on_attach(client,bufnr)
        -- null-ls handles formatting instead native lsp
        -- client.resolved_capabilities.document_formatting = false
        -- client.resolved_capabilities.document_range_formating = false
      end,
      capabilities = capabilities,
    }

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
        -- opts.root_dir = function() ... end
    -- end

    -- eslint config
    if server.name == "eslint" then
      opts.settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = true
          }
        },
        codeActionOnSave = {
          enable = false,
          mode = "all"
        },
        format = false,
        onIgnoredFiles = "off",
        packageManager = "yarn",
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = true,
        validate = "on",
        workingDirectory = { pattern = {"./", "./apps/*/", "./packages/*/" }}
      }
      -- opts.root_dir = require('lspconfig.util').find_git_ancestor
    end
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

--Disable virtual text in diagnostics
vim.diagnostic.config({
  virtual_text = false
})

------------------------ PROJECTS -------------------------
 require("project_nvim").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 }

 ------------------------ SEARCH ------------------------
 vim.opt.incsearch = true -- Jump to matching terms, but keep cursor until <CR>
 vim.opt.ignorecase = true -- Ignore case in searches
 vim.opt.smartcase = true -- Don't ignore case if using caps

 local kopts = {noremap = true, silent = true}
 vim.api.nvim_set_keymap('n', 'n',
     [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
     kopts)
 vim.api.nvim_set_keymap('n', 'N',
     [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
     kopts)
 vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
 vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
 vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
 vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

 vim.api.nvim_set_keymap('n', '<Leader>nh', ':noh<CR>', kopts)

------------------------ SCROLLING -------------------------
 require("scrollbar").setup()
 require("scrollbar.handlers.search").setup() -- Add search marks in scroll bar
 require('neoscroll').setup({
   easing_function='quadratic'
 })

-- Shade has a bug causing floating windows to be totally transparent
------------------------ SHADE - DIM INACTIVE WINDOWS -------------------------
-- require('shade').setup({
-- overlay_opacity = 70,
--})

------------------------ SPELL CHECKER -------------------------
 vim.opt.spelllang = {'en','es','cjk'}
 vim.opt.spellsuggest = {'best',9}

------------------------ STATUS LINE -------------------------
 require('lualine').setup{
   options = {
     icons_enabled = true,
     component_separators = { left = '', right = ''},
     disabled_filetypes = {}
   },
   sections = {
     lualine_a = {{'mode', separator = {left = '', right = ''}}},
     lualine_b = {{getCwdName, 'branch','diff', separator = {left = '', right = ''}}},
     lualine_c = {'filename', 'lsp_progress'},
     lualine_x = {
       {
         'diagnostics',
         -- table of diagnostic sources, available sources:
         -- nvim_lsp, coc, ale, vim_lsp
         sources = {'nvim_diagnostic'},
         -- displays diagnostics from defined severity
         sections = {'error', 'warn', 'info', 'hint'},
       },
     },
     lualine_y = {{'encoding', 'fileformat', 'filetype', separator = {left = '', right = ''}}},
     lualine_z = {{'location', separator = {left = '', right = ''}}}
   },
   inactive_sections = {
     lualine_a = {},
     lualine_b = {},
     lualine_c = {'filename'},
     lualine_x = {'location'},
     lualine_y = {},
     lualine_z = {}
   },
   tabline = {},
   extensions = {}
 }

------------------------ SURROUND NVIM -------------------------
 require('mini.surround').setup({
   mappings = {
     add = 'ys', -- Add surrounding
     delete = 'ds', -- Delete surrounding
     find = 'ysf', -- Find surrounding (to the right)
     find_left = 'ysF', -- Find surrounding (to the left)
     highlight = 'ysh', -- Highlight surrounding
     replace = 'cs', -- Replace surrounding
     update_n_lines = 'ysn', -- Update `n_lines`
   }
 })

------------------------ TABOUT -------------------------
 require("tabout").setup({
   tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
   backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
   act_as_tab = true, -- shift content if tab out is not possible
   act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
   enable_backwards = true, -- well ...
   completion = true, -- if the tabkey is used in a completion pum
   tabouts = {
     {open = "'", close = "'"},
     {open = '"', close = '"'},
     {open = '`', close = '`'},
     {open = '(', close = ')'},
     {open = '[', close = ']'},
     {open = '{', close = '}'}
   },
   ignore_beginning = true,
 })

------------------------ TELESCOPE FUZZY FINDER -------------------------
 local actions = require('telescope.actions')
 require('telescope').setup{
   defaults = {
     theme = "dropdown",
     winblend = 8,
     dynamic_preview_title = true,
     path_display = {"truncate"},
     -- layout_strategy = 'flex',
     sorting_strategy = 'ascending',
     layout_config = {
       prompt_position = 'top',
       scroll_speed = 1
     },
     mappings = {
       i = {
         ["<M-j>"] = actions.move_selection_next,
         ["<M-k>"] = actions.move_selection_previous,
         ["<C-h>"] = actions.select_horizontal,
         ["<C-v>"] = actions.select_vertical,
         ["<C-x>"] = actions.close,
         ["<C-t>"] = false, -- Removes default option to open in other TAB
       },
       n = {
         ["<C-h>"] = actions.select_horizontal,
         ["<C-v>"] = actions.select_vertical,
         ["<C-x>"] = actions.close,
         ["<C-t>"] = false, -- Removes default option to open in other TAB
       }
     },
   },
   extensions = {
     file_browser = {
       theme = "dropdown",
       -- disables netrw and use telescope-file-browser in its place
       hijack_netrw = true,
       mappings = {
         ["i"] = {
           -- your custom insert mode mappings
         },
         ["n"] = {
           -- your custom normal mode mappings
         },
       },
     },
   },
   pickers = {
     command_history = {
       theme = "dropdown"
     },
     find_files = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     buffers = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     live_grep = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     grep_string = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     git_commits = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     git_status = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     },
     git_bcommits = {
       theme = "dropdown",
       layout_strategy = 'flex',
       layout_config = {
         width = { 0.75, max = 300, min = 80 },
         height = { 0.75, max = 100, min = 20 }
       }
     }
   }
 }

 require("telescope").load_extension "file_browser"
 require('telescope').load_extension('projects') -- Requires project_nvim
 vim.api.nvim_set_keymap( "n", "<leader>fp", ":Telescope projects<CR>", { noremap = true })
 vim.api.nvim_set_keymap( "n", "<leader>ew", ":Telescope file_browser<CR>", { noremap = true })
 vim.api.nvim_set_keymap( "n", "<leader>eh", ":Telescope file_browser path=$HOME<CR>", { noremap = true })
 vim.api.nvim_set_keymap( "n", "-", ":Telescope file_browser path=%:p:h<CR>", { noremap = true })

------------------------ TREESITTER -------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = { enable = true  }
}

------------------------ COLOR HIGHLIGHTER -------------------------
-- Colorizer needs to be setup after the other plugins
 require('colorizer').setup(nil,{
     RRGGBBAA = true,
     css = true,
     css_fn = true,
 })
EOF
"
" EOF

" ----------------- CORE SETTINGS ---------------------------

" INITIAL POSITION
augroup remember_position
  autocmd!
  let btToIgnore = ['terminal']
  autocmd BufWinLeave ?* if index(btToIgnore, &buftype) < 0 | mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

"FOLDING
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" BUFFER FORMATTING
set expandtab
set tabstop=2
set shiftwidth=2

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" COMMAND LINE
"-- set cmdheight=2

" NETRW
" let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 | Explore | endif
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | Explore | endif

" --------------------KEY MAPS--------------------
" NOTE: Use command ':verbose map <keybinding>' to make sure <keybinding> is not mapped by
" other plugin before putting this into your config.

" Switch modes
inoremap jj <Esc>
inoremap JJ <Esc>
nnoremap <Space><Space> :
tnoremap <silent> jj <c-\><c-n>
tnoremap <silent> JJ <c-\><c-n>
tnoremap <silent> <Esc> <c-\><c-n>
cnoremap <silent> jj <Esc>
cnoremap <silent> JJ <Esc>

" Navigation
nnoremap <M-j> <C-w>j
nnoremap <M-h> <C-w>h
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
inoremap <M-j> <Down>
inoremap <M-h> <Left>
inoremap <M-k> <Up>
inoremap <M-l> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <M-h> <Left>
cnoremap <M-l> <Right>
cnoremap <M-k> <Up>
cnoremap <M-j> <Down>
nnoremap <C-p> <C-o>
nnoremap <C-n> <C-i>
nnoremap <silent> <leader>fc :Telescope command_history<CR>
xnoremap <silent> <leader>fc :Telescope command_history<CR>
cnoremap <silent> <C-f> :Telescope command_history<CR>

" Files/Buffers
nnoremap <silent> <leader>oh :split<CR>
nnoremap <silent> <leader>ov :vsplit<CR>
nnoremap <silent> <leader>ff :Telescope find_files find_command=rg,--hidden,--files<CR>
nnoremap <silent> <C-q> :lua MiniBufremove.delete()<CR>
inoremap <silent> <C-q> <Esc>:lua MiniBufremove.delete()<CR>
inoremap <silent> <C-x> <Esc>:conf bwipe<CR>
nnoremap <silent> <C-x> :conf bwipe<CR>
inoremap <silent> <C-x> <Esc>:conf bwipe<CR>
nnoremap <silent> <C-x><C-x> :conf qa<CR>
inoremap <silent> <C-x><C-x> <Esc>:conf qa<CR>
nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>
nnoremap <silent> <C-s><C-s> :wa<CR>
inoremap <silent> <C-s><C-s> <Esc>:wa<CR>
nnoremap <silent> <M-u> :edit!<CR>
inoremap <silent> <M-u> <Esc>:edit!<CR>
nnoremap <silent> bn :BufferLineCycleNext<CR>
nnoremap <silent> bp :BufferLineCyclePrev<CR>
nnoremap <silent> <leader>fb :Telescope buffers<CR>
nnoremap <silent> <leader>fs :Telescope live_grep<CR>
nnoremap <silent> <leader>fw :Telescope grep_string<CR>
" The following map overrides Entering in visual block mode
nnoremap <silent> <C-v> <Esc>"+p
inoremap <silent> <C-v> <Esc>"+p
nnoremap <silent> <D-v> <Esc>"+p
inoremap <silent> <D-v> <Esc>"+p
" Command
cnoremap <C-v> <C-r>+
cnoremap <D-v> <C-r>+
" Yank path of the file
nnoremap yp :let @*=expand("%:p")<CR>
nnoremap yc :let @*=getcwd()<CR>
" workaraond with issue with copyQ clipboard manager
map! <S-Insert> <C-v>
" Send deleted text to blackhole register (disables cut function)
nnoremap <silent> d "_d
vnoremap <silent> d "_d
" Send replaced text to blackhole register (disables cut function)
nnoremap <silent> c "_c
vnoremap <silent> c "_c

" enable cut
nnoremap <silent> <leader>k "+d
nnoremap <silent> <leader>kk "+dd
vnoremap <silent> <leader>k "+d

" " netrw
" augroup netrw_mapping
"     autocmd!
"     autocmd filetype netrw call NetrwMapping()
" augroup END
"
" function! NetrwMapping()
"     nmap <silent> <buffer> f %
" endfunction

" markdown
nnoremap <silent> <leader>mp :Glow<CR>
" git
nnoremap <silent> <leader>gla :Telescope git_commits<CR>
nnoremap <silent> <leader>gsa :Telescope git_status<CR>
nnoremap <silent> <leader>glf :Telescope git_bcommits<CR>

" terminal
nnoremap <silent> <leader>t :split +resize10<CR>:terminal<CR>:startinsert<CR>
tnoremap <silent> <C-x> <C-\><C-N>:q<CR>
tnoremap <silent> <M-j> <c-\><c-n><c-w>j
tnoremap <silent> <M-h> <c-\><c-n><c-w>h
tnoremap <silent> <M-k> <c-\><c-n><c-w>k
tnoremap <silent> <M-l> <c-\><c-n><c-w>l
