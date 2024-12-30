local M = { "numToStr/Navigator.nvim" }

function M.config()
    require("Navigator").setup()
    vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>NavigatorLeft<cr>")
    vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>NavigatorRight<cr>")
    vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>NavigatorUp<cr>")
    vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>NavigatorDown<cr>")
end

return M
