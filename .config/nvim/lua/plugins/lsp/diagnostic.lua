local M = {}

function M.setup()
    local borderize_floating_preview = function()
        local border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
        }

        local open_floating_preview = vim.lsp.util.open_floating_preview

        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or border
            return open_floating_preview(contents, syntax, opts, ...)
        end
    end

    local customize_diagnostic_signs = function()
        local signs = {
            Error = "",
            Hint = "",
            Info = "",
            Warn = "",
        }

        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end

    borderize_floating_preview()
    customize_diagnostic_signs()

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = false,
        update_in_insert = false,
        virtual_text = false,
    })
end

function M.toggle()
    local toggle = not vim.diagnostic.is_enabled()
    print("enable_diagnostic=" .. tostring(toggle))
    vim.diagnostic.enable(toggle)
end

return M
