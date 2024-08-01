local M = {}

local defaults = {
	cache_path = vim.fn.stdpath("cache") .. "/code_time.json",
}

function M.set_config(user_config)
	return vim.tbl_deep_extend("force", defaults, user_config)
end

return M
