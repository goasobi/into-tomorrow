local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.7",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}

function M.config()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")

    telescope.setup({
        defaults = {
            border = {},
            borderchars = {
                "─",
                "│",
                "─",
                "│",
                "╭",
                "╮",
                "╯",
                "╰",
            },
            buffer_previewer_maker = function(filepath, bufnr, opts)
                local job = require("plenary.job")
                filepath = vim.fn.expand(filepath)
                job:new({
                    command = "file",
                    args = { "--mime-type", "-b", filepath },
                    on_exit = function(j)
                        local mime_type = vim.split(j:result()[1], "/")
                        local type = mime_type[1]
                        local sub_type = mime_type[2]
                        local sub_types = {
                            json = true,
                            xml = true,
                            ["ld+json"] = true,
                        }
                        if type == "text" or sub_types[sub_type] then
                            opts = opts or {}
                            opts.use_ft_detect = false
                            previewers.buffer_previewer_maker(filepath, bufnr, opts)
                        else
                            vim.schedule(function()
                                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                            end)
                        end
                    end,
                }):sync()
            end,
            entry_prefix = "  ",
            file_ignore_patterns = {},
            qflist_previewer = previewers.qflist.new,
            initial_mode = "insert",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                },
                preview_width = 0.5,
            },
            layout_strategy = "horizontal",
            mappings = {
                i = {
                    ["<C-h>"] = actions.cycle_history_prev,
                    ["<C-l>"] = actions.cycle_history_next,
                },
                n = {
                    ["q"] = actions.close,
                },
            },
            prompt_prefix = "",
            selection_strategy = "reset",
            set_env = { ["COLORTERM"] = "truecolor" },
            sorting_strategy = "ascending",
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--follow",
                "--glob=!.git/",
            },
        },
        pickers = {
            buffers = {
                mappings = {
                    n = {
                        ["dd"] = actions.delete_buffer,
                    },
                },
            },
            find_files = {
                disable_devicons = true,
                follow = true,
                find_command = {
                    "fd",
                    "--type=file",
                    "--follow",
                    "--hidden",
                    "--case-sensitive",
                    "--exclude",
                    ".git",
                },
            },
            live_grep = {
                disable_devicons = true,
                --@usage don't include the filename in the search results
                only_sort_text = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            live_grep_args = {
                disable_devicons = true,
            },
        },
    })

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("live_grep_args")
end

return M
