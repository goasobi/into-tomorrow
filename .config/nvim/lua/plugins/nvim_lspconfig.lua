local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- "simrat39/rust-tools.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
}

function M.config()
    require("plugins.lsp.diagnostic").setup()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
            local map = function(keys, func)
                vim.keymap.set("n", keys, func, { buffer = event.buf })
            end
            map("K", vim.lsp.buf.hover)
            map("gd", require("telescope.builtin").lsp_definitions)
            map("gp", require("telescope.builtin").lsp_implementations)
            map("gi", require("telescope.builtin").lsp_incoming_calls)
            map("go", require("telescope.builtin").lsp_outgoing_calls)
            map(";a", vim.lsp.buf.code_action)
        end,
    })

    local formatting = {
        eslint = true,
        jsonls = false,
        lua_ls = false,
        ts_ls = false,
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil

        local f = formatting[client.name]
        if f ~= nil then
            client.server_capabilities.documentFormattingProvider = f
            if f == false then
                return
            end
        end

        if client.name == "ruby_lsp" then
            vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
                local params = vim.lsp.util.make_text_document_params()
                local showAll = opts.args == "all"

                client.request("rubyLsp/workspace/dependencies", params, function(error, result)
                    if error then
                        print("Error showing deps: " .. error)
                        return
                    end

                    local qf_list = {}
                    for _, item in ipairs(result) do
                        if showAll or item.dependency then
                            table.insert(qf_list, {
                                text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
                                filename = item.path,
                            })
                        end
                    end

                    vim.fn.setqflist(qf_list)
                    vim.cmd("copen")
                end, bufnr)
            end, {
                nargs = "?",
                complete = function()
                    return { "all" }
                end,
            })
        end

        if client.supports_method("textDocument/formatting") then
            local format = require("plugins.lsp.format")
            format.lsp_before_save(bufnr)
        end
    end

    local servers = {
        cssls = {},
        eslint = {},
        gopls = {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        },
        jsonls = {},
        lua_ls = {
            settings = {
                Lua = {
                    telemetry = { enable = false },
                },
            },
        },
        pyright = {},
        ruby_lsp = {},
        ts_ls = {},
        -- rust_analyzer = {},
        -- volar = {},
        -- vuels = {},
    }

    require("mason").setup()

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
    })
    mason_lspconfig.setup_handlers({
        function(server_name)
            local setup = {
                capabilities = capabilities,
                on_attach = on_attach,
            }
            local server = servers[server_name]
            if server ~= nil and next(server) ~= nil then
                setup.settings = server.settings
                setup.filetypes = server.filetypes
            end
            require("lspconfig")[server_name].setup(setup)
        end,
    })

    -- Configure LSP through rust-tools.nvim plugin.
    -- rust-tools will configure and enable certain LSP features for us.
    -- See https://github.com/simrat39/rust-tools.nvim#configuration
    -- require("rust-tools").setup({
    --     tools = {
    --         runnables = {
    --             use_telescope = true,
    --         },
    --         inlay_hints = {
    --             auto = true,
    --             show_parameter_hints = false,
    --             parameter_hints_prefix = "",
    --             other_hints_prefix = "",
    --         },
    --     },
    --     -- All the opts to send to nvim-lspconfig which override the defaults set by rust-tools.nvim
    --     -- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    --     server = {
    --         on_attach = on_attach,
    --         settings = {
    --             ["rust-analyzer"] = {
    --                 -- enable clippy on save
    --                 checkOnSave = {
    --                     command = "clippy",
    --                 },
    --             },
    --         },
    --     },
    -- })
end

return M
