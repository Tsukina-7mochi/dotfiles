local set_keymap = vim.api.nvim_set_keymap

--mapleader
set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
set_keymap("i", "<Left>", "<C-G>U<Left>", { noremap = true, silent = true })
set_keymap("i", "<Right>", "<C-G>U<Right>", { noremap = true, silent = true })
set_keymap("i", "<Up>", "<C-G>U<Up>", { noremap = true, silent = true })
set_keymap("i", "<Down>", "<C-G>U<Down>", { noremap = true, silent = true })

set_keymap("n", ";", ":", { noremap = true, silent = true })
set_keymap("v", ";", ":", { noremap = true, silent = true })

set_keymap("n", "<Esc><Esc>", ":noh<Return>", { noremap = true, silent = true })

set_keymap("n", "<C-k><C-k>", "", {
    noremap = true,
    silent = true,
    callback = function ()
        vim.lsp.buf.signature_help()
    end,
})
set_keymap("n", "<C-k><C-l>", "", {
    noremap = true,
    silent = true,
    callback = function ()
        vim.diagnostic.open_float()
    end,
})

set_keymap("n", "<Leader>n", ":tabnext<Return>", { noremap = true, silent = true })
set_keymap("n", "<Leader>b", ":tabprevious<Return>", { noremap = true, silent = true })
set_keymap("n", "<Leader>h", "<C-w>h", { noremap = true, silent = true })
set_keymap("n", "<Leader>j", "<C-w>j", { noremap = true, silent = true })
set_keymap("n", "<Leader>k", "<C-w>k", { noremap = true, silent = true })
set_keymap("n", "<Leader>l", "<C-w>l", { noremap = true, silent = true })
