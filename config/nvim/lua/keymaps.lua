local set_keymap = vim.api.nvim_set_keymap

set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
set_keymap("n", "<Enter>", "O<ESC>", {})
set_keymap("n", "<S-Enter>", "O<ESC>", {})
set_keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", { noremap = true, silent = true })
set_keymap("n", "<C-k>", "", {
    noremap = true,
    silent = true,
    callback = function()
        vim.lsp.buf.signature_help()
    end,
})
set_keymap("i", "<Left>", "<C-G>U<Left>", { noremap = true, silent = true })
set_keymap("i", "<Right>", "<C-G>U<Right>", { noremap = true, silent = true })
set_keymap("i", "<Up>", "<C-G>U<Up>", { noremap = true, silent = true })
set_keymap("i", "<Down>", "<C-G>U<Down>", { noremap = true, silent = true })
