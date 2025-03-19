local set_keymap = vim.api.nvim_set_keymap

set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
set_keymap("n", ";", ":", { noremap = true, silent = true })
set_keymap("v", ";", ":", { noremap = true, silent = true })
set_keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", { noremap = true, silent = true })
set_keymap("n", "<C-k><C-k>", "", {
    noremap = true,
    silent = true,
    callback = function()
        vim.lsp.buf.signature_help()
    end,
})
set_keymap("n", "<C-k><C-l>", "", {
    noremap = true,
    silent = true,
    callback = function()
        vim.diagnostic.open_float()
    end,
})
set_keymap("i", "<Left>", "<C-G>U<Left>", { noremap = true, silent = true })
set_keymap("i", "<Right>", "<C-G>U<Right>", { noremap = true, silent = true })
set_keymap("i", "<Up>", "<C-G>U<Up>", { noremap = true, silent = true })
set_keymap("i", "<Down>", "<C-G>U<Down>", { noremap = true, silent = true })
set_keymap("n", "<Leader>n", ":tabnext<Return>", { noremap = true, silent = true })
set_keymap("n", "<Leader>b", ":tabprevious<Return>", { noremap = true, silent = true })
set_keymap("n", "<Leader>h", "<C-w>h", { noremap = true, silent = true })
set_keymap("n", "<Leader>j", "<C-w>j", { noremap = true, silent = true })
set_keymap("n", "<Leader>k", "<C-w>k", { noremap = true, silent = true })
set_keymap("n", "<Leader>l", "<C-w>l", { noremap = true, silent = true })

set_keymap("n", "<Leader>cc", ":Copilot toggle<Return>", { noremap = true, silent = true })
set_keymap("n", "<Leader>ce", "", {
    noremap = true,
    silent = true,
    callback = function()
        require("copilot.command").enable()
        print("Copilot enabled")
    end
})
set_keymap("n", "<Leader>cd", "", {
    noremap = true,
    silent = true,
    callback = function()
        require("copilot.command").disable()
        print("Copilot disabled")
    end
})


---@param callback fun(...: string[] | nil)
---@param user_command { name: string, nargs: integer | string } | nil
---@param keymap { mode: string, key: string } | nil
local lsp_command_keymap = function(callback, user_command, keymap)
    if user_command ~= nil then
        vim.api.nvim_create_user_command(user_command.name, function(opts)
            callback(table.unpack(opts.fargs or {}))
        end, { nargs = user_command.nargs })
    end

    if keymap ~= nil then
        vim.api.nvim_set_keymap(keymap.mode, keymap.key, "", {
            callback = callback
        })
    end
end

lsp_command_keymap(
    vim.lsp.buf.add_workspace_folder,
    { name = "AddWorkspaceFolder", nargs = "?" },
    nil
)

lsp_command_keymap(
    vim.lsp.buf.code_action,
    { name = "CodeAction", nargs = 0 },
    { mode = "n", key = "<Leader><C-a>" }
)

lsp_command_keymap(
    vim.lsp.buf.declaration,
    { name = "GoToDeclaration", nargs = 0 },
    { mode = "n", key = "gD" }
)

lsp_command_keymap(
    vim.lsp.buf.definition,
    { name = "GoToDefinition", nargs = 0 },
    { mode = "n", key = "gd" }
)

lsp_command_keymap(
    vim.lsp.buf.document_symbol,
    { name = "DocumentSymbol", nargs = 0 },
    nil
)

lsp_command_keymap(
    vim.lsp.buf.hover,
    nil,
    { mode = "n", key = "<Leader><Leader>" }
)

lsp_command_keymap(
    vim.lsp.buf.implementation,
    { name = "GoToImplementation", nargs = 0 },
    { mode = "n", key = "gi" }
)

lsp_command_keymap(
    vim.lsp.buf.incoming_calls,
    { name = "IncomingCalls", nargs = 0 },
    nil
)

lsp_command_keymap(
    vim.lsp.buf.list_workspace_folders,
    { name = "ListWorkspaceFolders", nargs = 0 },
    nil
)

lsp_command_keymap(
    vim.lsp.buf.outgoing_calls,
    { name = "OutgoingCalls", nargs = 0 },
    nil
)

lsp_command_keymap(
    vim.lsp.buf.references,
    { name = "GoToReferences", nargs = 0 },
    { mode = "n", key = "gr" }
)

lsp_command_keymap(
    vim.lsp.buf.rename,
    { name = "Rename", nargs = "?" },
    { mode = "n", key = "<Leader><C-r>" }
)

lsp_command_keymap(
    vim.lsp.buf.remove_workspace_folder,
    { name = "RemoveWorkspaceFolder", nargs = "?" },
    nil
)

vim.api.nvim_create_user_command("TabWidth", function(opts)
    local width = tonumber(opts.fargs[1])
    if width == nil then
        print(opts.fargs[1] .. " is not a valid value as width")
        return
    end

    vim.opt_local.shiftwidth = width
    vim.opt_local.tabstop = width

    print("set tab width to " .. width)
end, {
    nargs = 1
})
