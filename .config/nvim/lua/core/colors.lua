local override = function(colors)
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            for k, v in pairs(colors) do
                vim.api.nvim_set_hl(0, k, v)
            end
        end,
    })
end

local blue = "#0000ff"
local black = "#000000"
local darkgreen = "#008000"
local darkred = "#a31515"
local red = "#e50000"
local white = "#ffffff"
local yellow = "#fff8c5"

override({
    -- language
    Comment = { fg = darkgreen },
    Constant = { fg = darkred },
    Identifier = { fg = black },
    PreProc = { fg = blue },
    Special = { fg = blue },
    Statement = { fg = blue },
    Title = { fg = darkred },
    Type = { fg = black },

    DiagnosticHint = { fg = blue },
    DiagnosticInfo = { fg = "#1d3ccf" },
    DiagnosticOk = { fg = "#005d26" },
    DiagnosticWarn = { fg = "#ef7727" },

    -- visual
    EndOfBuffer = { fg = white },
    NormalFloat = { bg = "#fffffe" },
    SignColumn = { bg = white },
    QuickFixLine = { bg = yellow },

    -- plugin.fugitive
    Added = { fg = darkgreen },
    Removed = { fg = darkred },

    -- plugin.match-it
    MatchParen = { bg = yellow },

    -- plugin.nvim-tree
    NvimTreeWindowPicker = { link = "StatusLine" },

    -- plugin.telescope
    TelescopeMultiSelection = { bg = yellow },

    -- plugin.treesitter
    ["@boolean"] = { fg = blue },
    ["@constant"] = { fg = black },
    ["@function.call"] = { fg = black },
    ["@keyword.type"] = { fg = blue },
    ["@label"] = { fg = black },
    ["@number"] = { fg = darkgreen },
    ["@number.float"] = { fg = darkgreen },
    ["@punctuation.bracket"] = { fg = black },
    ["@variable.builtin"] = { fg = black },
    ["@tag"] = { fg = darkred },
    ["@tag.attribute"] = { fg = red },
    ["@tag.delimiter"] = { fg = darkred },
    ["@tag.builtin"] = { fg = darkred },
    ["htmlLink"] = { fg = blue },
})
