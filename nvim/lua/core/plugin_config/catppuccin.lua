if vim.opt.background == "light" then
    vim.g.catppuccin_flavour = "latte"
else
--  -- MacOS Terminal, WSL terminal, and most linux terminals default to a black background, so fallback to "dark"
    vim.g.catppuccin_flavor = "mocha"
end

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

