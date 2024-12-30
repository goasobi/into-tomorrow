vim.keymap.set("n", "K", ":<C-u>call VSCodeNotify('editor.action.showHover')<cr>")
vim.keymap.set("n", "gi", ":<C-u>call VSCodeNotify('editor.action.peekDefinition')<cr>")
vim.keymap.set("n", "gp", ":<C-u>call VSCodeNotify('editor.action.goToImplementation')<cr>")

-- tab switching
vim.keymap.set("n", "gt", ":Tabnext<cr>")
vim.keymap.set("n", "gT", ":Tabprevious<cr>")
