vim.lsp.enable("astro")
vim.lsp.enable("clangd")
vim.lsp.enable("denols")
vim.lsp.enable("gopls")
vim.lsp.enable("hls")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ocamllsp")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ts_ls")
vim.lsp.enable("typos_lsp")
vim.lsp.enable("zls")

---@param callback fun(...: string[] | nil)
---@param user_command { name: string, nargs: integer | string } | nil
---@param keymap { mode: string, key: string } | nil
local set_lsp_command_keymap = function (callback, user_command, keymap)
    if user_command ~= nil then
        vim.api.nvim_create_user_command(user_command.name, function (opts)
            callback(table.unpack(opts.fargs or {}))
        end, { nargs = user_command.nargs })
    end

    if keymap ~= nil then
        vim.api.nvim_set_keymap(keymap.mode, keymap.key, "", {
            callback = callback,
        })
    end
end

set_lsp_command_keymap(vim.lsp.buf.add_workspace_folder, { name = "AddWorkspaceFolder", nargs = "?" }, nil)

set_lsp_command_keymap(
    vim.lsp.buf.code_action,
    { name = "CodeAction", nargs = 0 },
    { mode = "n", key = "<Leader><C-a>" }
)

set_lsp_command_keymap(vim.lsp.buf.declaration, { name = "GoToDeclaration", nargs = 0 }, { mode = "n", key = "gD" })

set_lsp_command_keymap(function ()
    vim.cmd(":tab split")
    vim.lsp.buf.definition()
end, { name = "GoToDefinition", nargs = 0 }, { mode = "n", key = "gd" })

set_lsp_command_keymap(vim.lsp.buf.document_symbol, { name = "DocumentSymbol", nargs = 0 }, nil)

set_lsp_command_keymap(vim.lsp.buf.hover, nil, { mode = "n", key = "<Leader><Leader>" })

set_lsp_command_keymap(
    vim.lsp.buf.implementation,
    { name = "GoToImplementation", nargs = 0 },
    { mode = "n", key = "gi" }
)

set_lsp_command_keymap(vim.lsp.buf.incoming_calls, { name = "IncomingCalls", nargs = 0 }, nil)

set_lsp_command_keymap(vim.lsp.buf.list_workspace_folders, { name = "ListWorkspaceFolders", nargs = 0 }, nil)

set_lsp_command_keymap(vim.lsp.buf.outgoing_calls, { name = "OutgoingCalls", nargs = 0 }, nil)

set_lsp_command_keymap(vim.lsp.buf.references, { name = "GoToReferences", nargs = 0 }, { mode = "n", key = "gr" })

set_lsp_command_keymap(vim.lsp.buf.rename, { name = "Rename", nargs = "?" }, { mode = "n", key = "<Leader><C-r>" })

set_lsp_command_keymap(vim.lsp.buf.remove_workspace_folder, { name = "RemoveWorkspaceFolder", nargs = "?" }, nil)
