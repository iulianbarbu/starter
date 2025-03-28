require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Projects
map("n", "<leader>fp", "<CMD>ProjectMgr<CR>", { desc = "Open Projects" })

-- Telescope
map("n", "<leader>fr", "<CMD>Telescope resume<CR>", { desc = "Resume previous search" })
map("n", "<leader>fW", "<cmd>Telescope dir live_grep<CR>", { noremap = true, silent = true })
map("n", "<leader>fF", "<cmd>Telescope dir find_files<CR>", { noremap = true, silent = true })

-- Diagnostics
map("n", "<leader>i", ":lua vim.diagnostic.open_float(nil, {focus=true, scope='cursor'})<CR>",
  { desc = "Open Diagnostic Float", noremap = true, silent = true })

vim.api.nvim_create_user_command("ClearLspLog", function()
  local log_path = vim.lsp.get_log_path()
  local file = io.open(log_path, "w")
  if file then
    file:write("")
    file:close()
    print("LSP log cleared.")
  else
    print("Failed to clear LSP log.")
  end
end, {})
