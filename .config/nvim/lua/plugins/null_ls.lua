local M = {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
        {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
            "nvim-lua/plenary.nvim",
        },
    },
    event = { "BufReadPre", "BufNewFile" },
}

function M.config()
    require("mason").setup()
    require("mason-null-ls").setup({
        ensure_installed = {
            "biome",
            "black",
            "erb-lint",
            "golangci-lint",
            "prettierd",
            "rubocop",
            "sql-formatter",
            "shfmt",
            "stylua",
        },
        automatic_installation = false,
        handlers = {},
    })

    local null_ls = require("null-ls")
    local b = null_ls.builtins

    local on_attach = function(client, bufnr)
        vim.diagnostic.config({
            virtual_text = false,
            float = {
                source = "always",
            },
            severity_sort = true,
        })

        if client.supports_method("textDocument/formatting") then
            local format = require("plugins.lsp.format")
            format.lsp_before_save(bufnr)
        end
    end

    local sources = {
        b.formatting.black.with({
            extra_args = { "--line-length", "79" },
        }),
        b.formatting.erb_lint.with({
            filetypes = {
                "ruby",
            },
        }),
        b.formatting.prettierd.with({
            filetypes = {
                "css",
                "graphql",
                "html",
                "less",
                "markdown",
                "scss",
                "vue",
                "xhtml",
                "yaml",
            },
        }),
        b.formatting.biome.with({
            filetypes = {
                "json",
                "jsonc",
            },
        }),
        b.formatting.shfmt,
        b.formatting.stylua,
        b.formatting.sql_formatter,
    }

    null_ls.setup({
        debug = false,
        on_attach = on_attach,
        sources = sources,
    })
end

return M
