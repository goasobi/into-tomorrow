local M = {}

function M.toggle()
    vim.g.format_on_save = not vim.g.format_on_save
    print("format_on_save=" .. tostring(vim.g.format_on_save))
end

local function lsp_formatting(bufnr, timeout_ms)
    local servers = { "jsonls", "ts_ls", "sumneko_lua", "vuels", "volar" }
    local function has_value(tbl, val)
        for _, v in ipairs(tbl) do
            if v == val then
                return true
            end
        end

        return false
    end

    vim.lsp.buf.format({
        async = false,
        filter = function(client)
            -- filter out clients that you don't want to use
            return not has_value(servers, client.name)
        end,
        bufnr = bufnr,
        timeout_ms = timeout_ms,
    })
end

-- Synchronously organise Go imports.
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
local function goimports(timeout_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
    vim.lsp.buf.format({ async = false })
end

function M.lsp_before_save(bufnr)
    local timeout_ms = 2000
    local group = vim.api.nvim_create_augroup("lsp_formatting", { clear = false })

    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if vim.g.format_on_save == false then
                return
            end

            local ext = vim.fn.expand("%:e")
            if ext == "go" then
                goimports(timeout_ms)
            end

            lsp_formatting(bufnr, timeout_ms)
        end,
        buffer = bufnr,
        group = group,
    })
end

return M
