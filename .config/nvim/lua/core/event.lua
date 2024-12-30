local autocmd = {}

function autocmd.load_autocmds()
    local whitespace = vim.api.nvim_create_augroup("whitespace", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
        command = "%s/\\s\\+$//e",
        pattern = "*",
        group = whitespace,
    })
end

autocmd.load_autocmds()
