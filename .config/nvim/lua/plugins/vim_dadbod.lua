local M = {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle" },
    dependencies = { "tpope/vim-dadbod" },
}

function M.config()
    local function load_env_file()
        local env_file = os.getenv("HOME") .. "/.env"
        local env_contents = {}

        if vim.fn.filereadable(env_file) ~= 1 then
            print(".env file does not exist")
            return
        end

        local contents = vim.fn.readfile(env_file)

        for _, item in pairs(contents) do
            local line_content = vim.fn.split(item, "=")
            env_contents[line_content[1]] = line_content[2]
        end

        return env_contents
    end

    local function load_dbs()
        local env_contents = load_env_file()
        local keys = {}

        for key, _ in pairs(env_contents) do
            table.insert(keys, key)
        end

        table.sort(keys, function(a, b)
            return a < b
        end)

        local prefix = "DB_CONNECTION_"
        local dbs = {}

        for _, key in pairs(keys) do
            if vim.fn.stridx(key, prefix) >= 0 then
                local db_name = string.gsub(key, prefix, ""):lower()
                table.insert(dbs, { name = db_name, url = env_contents[key] })
            end
        end

        return dbs
    end

    vim.g.db_ui_show_help = 0
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_save_location = os.getenv("HOME") .. "/.cache/nvim/vim_dadbod_ui"
    vim.g.dbs = load_dbs()
end

return M
