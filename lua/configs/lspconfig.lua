-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig["taplo"].setup {}
lspconfig["bacon_ls"].setup {
    init_options = {
        updateOnSave = true,
        updateOnSaveWaitMillis = 5000,
    },
}

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
