-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Selected options from list in :options

-- 2 moving around, searching and patterns
vim.opt.whichwrap='b,s,h,l,<,>,[,]' -- list of flags specifying which commands wrap to another line

-- 4 displaying text
vim.opt.scrolloff=5 -- number of screen lines to show around the cursor
vim.opt.wrap=false -- long lines wrap
vim.opt.sidescrolloff=5 -- minimal number of columns to keep left and right of the cursor
vim.opt.number=true -- show the line number for each line

-- 5 syntax, highlighting and spelling
vim.opt.termguicolors=true -- use GUI colors for the terminal
vim.opt.cursorline=true -- highlight the screen line of the cursor

--  9 using the mouse
vim.opt.mouse='a' -- list of flags for using the mouse

-- 11 messages and info
vim.opt.showmode=false -- display the current mode in the status line

-- 13 editing text
vim.opt.undolevels=10000 -- maximum number of changes that can be undone
vim.opt.undofile=true -- automatically save and restore undo history

-- 14 tabs and indenting
vim.opt.tabstop=2 -- number of spaces a <Tab> in the text stands for
vim.opt.shiftwidth=0 -- number of spaces used for each step of (auto)indent
vim.opt.smarttab=false -- a <Tab> in an indent inserts 'shiftwidth' spaces
vim.opt.shiftround=true -- round to 'shiftwidth' for --<<-- and -->>--
vim.opt.expandtab=true -- expand <Tab> to spaces in Insert mode
vim.opt.smartindent=true -- do clever autoindenting

src = debug.getinfo(1, 'S').source:sub(2):match('.*/')

-- Add custom site directory to runtimepath/packpath
vim.opt.runtimepath:append(src .. '/site')
vim.opt.packpath:append(src .. '/site')

-- Guess background color
-- if vim.opt.background == "light" then
--  vim.g.catppuccin_flavour = "latte"
-- else
--  -- MacOS Terminal, WSL terminal, and most linux terminals default to a black background, so fallback to "dark"
--  vim.g.catppuccin_flavor = "mocha"
-- end

require("catppuccin").setup {
  styles = {
    comments = { "italic" },
  },
	highlight_overrides = {
		latte = {
			Normal = { bg = "#ffffff", fg = "#080808" },
      Comment = { fg = "#8c6cac" },
		},
	}
}
-- vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
 		vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
	end,
})

vim.cmd("colorscheme catppuccin")

-- Turn on lualine 
require('lualine').setup {
  icons_enabled = false,
	options = {
		theme = "catppuccin",
    disabled_filetypes = {'packer', 'NvimTree'}
	},
  sections = {
    lualine_b = {'branch', 'diff', {'diagnostics', symbols = {error = 'E ', warn = 'W ', info = 'I ', hint = 'H '}, update_in_insert = true,}},
    lualine_x = {'encoding', {'fileformat', symbols = { unix = 'unix', dos = 'dos', mac = 'mac' }}, 'filetype'}
  }
}

-- Turn on last place (remember where you were when reopening a file)
require'nvim-lastplace'.setup{}

-- Turn on treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  matchup = {
    enable = true,
    include_match_words = true,
  }
}

local null_ls = require("null-ls")

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    end
  end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.22+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- Turn on indentline
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  enabled=false,
  show_current_context = false,
  show_current_context_start = true,
  show_first_indent_level = false,
  use_treesitter = true,
  use_treesitter_scope = true,
  blankline_char='',
}

local lspconfig = require('lspconfig')

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
  )

local util = require 'lspconfig.util'

local root_files = {
  'compile_commands.json',
  '.ccls',
}

require'lspconfig'.ccls.setup {
  single_file_support = true,
  root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
  end,
  init_options = {
    cache = {
      directory = "";
    },
    completion = {
      placeholder = false;
    },
    diagnostics = {
      onOpen = 0,
      onChange = 1,
      onSave = 0,
    },
    clang = {
      extraArgs = 
        vim.list_extend(vim.split(os.getenv("CFLAGS") or "", " ", true), 
        {'--gcc-toolchain=/usr'})
    }
  },
}

print(vim.inspect(vim.list_extend(vim.split(os.getenv("CFLAGS") or "", " ", true), 
        {'-DMENU=12'})))

vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    bufmap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>')
    bufmap('x', '<Leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')
  end
})