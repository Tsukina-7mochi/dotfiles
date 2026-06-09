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
        "fang2hou/blink-copilot",
        "mattn/emmet-vim",
        "Tsukina-7mochi/blink-emmet-vim",
        -- { dir = "/home/ts7m/workspace/blink-emmet-vim" },
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
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
        },
        sources = {
            default = { "lsp", "path", "buffer", "emmet", "copilot" },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                },
                emmet = {
                    name = "emmet",
                    module = "blink_emmet_vim",
                    score_offset = 101,
                },
                path = {
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                    },
                },
                cmdline = {
                    transform_items = function (_, items)
                        -- remove tailing slash
                        for _, item in ipairs(items) do
                            if item.insertText and item.insertText:sub(-1) == "/" then
                                item.insertText = item.insertText:sub(1, -2)
                            end
                            if item.textEdit and item.textEdit.newText and item.textEdit.newText:sub(-1) == "/" then
                                item.textEdit.newText = item.textEdit.newText:sub(1, -2)
                            end
                        end
                        return items
                    end,
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
