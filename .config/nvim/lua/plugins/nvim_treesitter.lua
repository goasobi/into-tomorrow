local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        {
            "andymass/vim-matchup",
            config = function()
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end,
        },
    },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "c",
            "css",
            "go",
            "html",
            "javascript",
            "json",
            "make",
            "php",
            "python",
            "ruby",
            "rust",
            "sql",
            "proto",
            "terraform",
            "tsx",
            "typescript",
            "vue",
            "xml",
            "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
        matchup = { enable = true },
    })
end

return M
