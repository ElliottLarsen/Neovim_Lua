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
vim.opt.tabstop=4 -- number of spaces a <Tab> in the text stands for
vim.opt.shiftwidth=0 -- number of spaces used for each step of (auto)indent
vim.opt.smarttab=false -- a <Tab> in an indent inserts 'shiftwidth' spaces
vim.opt.shiftround=true -- round to 'shiftwidth' for --<<-- and -->>--
vim.opt.expandtab=true -- expand <Tab> to spaces in Insert mode
vim.opt.smartindent=true -- do clever autoindenting

