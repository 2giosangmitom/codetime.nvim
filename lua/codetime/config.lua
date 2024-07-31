local M = {}

local defaults = {}

function M.set_config(user_config)
	return vim.tbl_deep_extend("force", defaults, user_config)
end

return M
