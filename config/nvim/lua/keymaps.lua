local set_keymap = vim.api.nvim_set_keymap
local vim_mode = {
    normal="n",
    insert="i",
    visual="v",
    visual_block="x",
    term="t",
    command="c"
}

set_keymap("", "<Space>", "<Nop>", { noremap=true, silent=true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set_keymap(vim_mode.insert, "jj", "<ESC>", { noremap=true, silent=true })
set_keymap(vim_mode.normal, "<Enter>", "O<ESC>", {})
set_keymap(vim_mode.normal, "<S-Enter>", "O<ESC>", {})
set_keymap(vim_mode.normal, "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", { noremap=true, silent=true })
