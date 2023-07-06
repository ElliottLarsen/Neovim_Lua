require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "bashls", "clangd", "jsonls", "sqlls", "jdtls" }
})

require("lspconfig").lua_ls.setup {}
require("lspconfig").pyright.setup {}
require("lspconfig").bashls.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").jsonls.setup {}
require("lspconfig").sqlls.setup {}
require("lspconfig").jdtls.setup {}
