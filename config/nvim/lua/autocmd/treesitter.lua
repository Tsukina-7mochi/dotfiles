local languages = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "csv",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "nginx",
    "rust",
    "sql",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "xml",
    "yaml",
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function ()
        vim.treesitter.start()
    end,
})
