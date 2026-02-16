---@module 'blink.cmp'
---@module 'lazy'

local has_words_before_cursor = function ()
    local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    local row_str = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]

    if row_str == nil then
        return false
    end
    return row_str:sub(1, col):match("^%s*$") == nil
end

---@param cmp blink.cmp.API
---@return boolean | nil
local function next_or_show (cmp)
    if cmp.is_visible() then
        return cmp.select_next()
    elseif has_words_before_cursor() then
        return cmp.show()
    end
end

---@param cmp blink.cmp.API
---@return boolean | nil
local function prev_or_show (cmp)
    if cmp.is_visible() then
        return cmp.select_prev()
    elseif has_words_before_cursor() then
        return cmp.show()
    end
end

---@param cmp blink.cmp.API
---@return boolean | nil
local function toggle_docs (cmp)
    if not cmp.is_visible() then
        return
    end

    if cmp.is_documentation_visible() then
        return cmp.hide_documentation()
    else
        return cmp.show_documentation()
    end
end

---@type LazySpec
return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "fang2hou/blink-copilot",
    },
    version = "1.*",

    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { next_or_show, "fallback" },
            ["<S-Tab>"] = { prev_or_show, "fallback" },
            ["<C-k>"] = { toggle_docs, "fallback" },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        completion = {
            menu = {
                draw = {
                    columns = { { "label", gap = 1 }, { "kind" } },
                },
            },
        },
        cmdline = {
            keymap = { preset = "inherit" },
            completion = {
                menu = { auto_show = true },
                list = {
                    selection = { preselect = false },
                },
            },
        },
    },
    opts_extend = { "sources.default" },
}
