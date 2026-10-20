--- Searches for a package within `node_modules` directories starting from the given root.
--- Walks up the directory tree via `vim.fs.find` to locate `node_modules` folders,
--- then checks each one for the named package.
---
---@param root string The starting directory path for the search.
---@param name string The package name (or relative path) to look for inside `node_modules`.
---@return string|nil path The absolute path to the package if found and readable, otherwise nil.
local function find_node_package (root, name)
    for _, dir in ipairs(vim.fs.find("node_modules", { path = root })) do
        local path = vim.fs.joinpath(dir, name)
        if vim.fn.filereadable(path) then
            return path
        end
    end
    return nil
end

---@type vim.lsp.Config
return {
    init_options = {
        hostInfo = "neovim",
        tsserver = {
            -- Explicitly specify path for projects that node_modules are placed
            -- not in root directory, such as pnpm workspace
            path = vim.fs.joinpath(find_node_package(vim.api.nvim_buf_get_name(0), "typescript"), "lib"),
        },
    },
    settings = {
        typescript = {
            inlayHints = {
                parameterNames = {
                    enabled = "literals",
                    suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
        },
    },
    cmd = function (dispatchers, config)
        local cmd = "tsrs"
        if (config or {}).root_dir then
            local bin = find_node_package(config.root_dir, ".bin")
            if bin ~= nil then
                local local_cmd = vim.fs.joinpath(bin, cmd)
                if vim.fn.executable(local_cmd) == 1 then
                    cmd = local_cmd
                end
            end
        end
        return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
    end,
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
}
