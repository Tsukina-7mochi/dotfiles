vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
    callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})

        if not layout[1] == "leaf" then return end

        local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype")

        if filetype ~= "NvimTree" then return end

        if not layout[3] == nil then return end

        vim.cmd("quit")
    end
})
