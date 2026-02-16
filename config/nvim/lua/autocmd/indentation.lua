local function enable_tab_indentation()
	vim.opt_local.expandtab = false
	vim.opt_local.softtabstop = -1 -- Use tabstop value
	vim.opt_local.shiftwidth = 0 -- Use tabstop value
	vim.opt_local.indentexpr = ""
end

local function enable_space_indentation(width)
	vim.opt_local.expandtab = true
	vim.opt_local.tabstop = width
	vim.opt_local.softtabstop = -1 -- Use tabstop value
	vim.opt_local.shiftwidth = 0 -- Use tabstop value
	vim.opt_local.indentexpr = ""
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = "*",
	callback = function()
		local max_lines = 100

		local bufnr = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)
		local min_spaces = math.huge
		local space_set = false
		for _, line in ipairs(lines) do
			if line:match("^\t") ~= nil then
				enable_tab_indentation()
				return
			else
				local match = line:match("^ +")
				if match ~= nil and #match > 0 then
					space_set = true
					if #match < min_spaces then
						min_spaces = #match
					end
				end
			end
		end

		if space_set then
			enable_space_indentation(min_spaces)
		end
	end,
})
