local disable_default_plugins = function()
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
end

local global_vars = function()
    vim.env.PATH = vim.env.HOME .. "/.asdf/installs/nodejs/18.15.0/bin/:" .. vim.env.PATH
    vim.env.PATH = vim.env.HOME .. "/.asdf/installs/ruby/3.3.5/bin/:" .. vim.env.PATH
    vim.g.format_on_save = true
    vim.lsp.set_log_level("error")
end

local load_core = function()
    disable_default_plugins()

    if vim.g.vscode then
        require("core.option.vscode")
        require("core.lazy")
        require("core.keymap.vscode")
        return
    end

    global_vars()
    require("core.option.nvim")
    require("core.colors")
    require("core.event")
    require("core.lazy")
    require("core.keymap.nvim")
end

load_core()
