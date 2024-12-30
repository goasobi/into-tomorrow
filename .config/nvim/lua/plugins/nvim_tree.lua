local M = {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    cmd = "NvimTreeOpen",
}

local function on_attach(bufnr)
    local api = require("nvim-tree.api")
    local view = require("nvim-tree.view")
    local lib = require("nvim-tree.lib")

    local function find_file()
        if view.is_visible() then
            api.tree.find_file(vim.api.nvim_buf_get_name(0))
            api.tree.focus()
        else
            api.tree.toggle({ find_file = true })
        end
    end

    local function toggle()
        if view.is_visible() then
            api.tree.close()
        else
            api.tree.open()
        end
    end

    local function grep_current_node()
        local node = lib.get_node_at_cursor()
        require("telescope.builtin").live_grep({
            search_dirs = { node.absolute_path },
        })
    end

    local opts = { noremap = true, silent = true, nowait = true }

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", ";F", find_file, opts)
    vim.keymap.set("n", ";T", toggle, opts)
    vim.keymap.set("n", ";R", grep_current_node, opts)
end

function M.config()
    require("nvim-tree").setup({
        actions = {
            open_file = {
                window_picker = {
                    enable = true,
                },
                resize_window = false,
            },
        },
        filesystem_watchers = {
            ignore_dirs = {
                ".git",
                "node_modules",
                "venv",
                "vendor",
            },
        },
        filters = {
            custom = {
                "node_modules",
                "venv",
                "vendor",
            },
        },
        git = {
            enable = false,
            show_on_dirs = false,
            show_on_open_dirs = false,
        },
        renderer = {
            highlight_opened_files = "icon",
            icons = {
                show = {
                    git = false,
                },
            },
            indent_markers = {
                enable = true,
            },
            special_files = {},
        },
        view = {
            width = 40,
        },
        on_attach = on_attach,
    })
end

return M
