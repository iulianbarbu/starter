return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    -- overwrite format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false,   -- This plugin is already lazy
    ft = "rust",
    config = function()
      local mason_registry = require "mason-registry"
      local codelldb = mason_registry.get_package "codelldb"
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      local cfg = require "rustaceanvim.config"

      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(_, bufnr)
            local function opts(desc)
              return { buffer = bufnr, desc = "LSP " .. desc }
            end

            vim.g.rustfmt_command = 'rustfmt +nightly-2024-04-10'

            local map = vim.keymap.set
            map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
            map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
            map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
            map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

            map("n", "<leader>wl", function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts "List workspace folders")

            map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

            map("n", "<leader>ra", function()
              require "nvchad.lsp.renamer" ()
            end, opts "NvRenamer")

            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
            map("n", "gr", vim.lsp.buf.references, opts "Show references")
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
              check = {
                command = 'clippy',
                extraArgs = {
                  '--target-dir',
                  'target/rust-analyzer-check'
                }
              },
              procMacro = {
                enable = true, -- Enable procedural macros support
              },
              rustfmt = {
                extraArgs = { "+nightly-2024-04-10" },
              },
            },
          },
        },
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true,
          },
        },
      }
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
    end,
  },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
