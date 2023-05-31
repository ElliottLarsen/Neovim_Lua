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