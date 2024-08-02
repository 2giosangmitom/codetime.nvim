local M = {}

local defaults = {
	cache_path = vim.fn.stdpath("cache") .. "/code_time.json",
}

--- Merge user configuration with default configuration.
---@param user_config table: A table containing user-defined configuration options.
---@return table: The merged configuration table.
function M.set_config(user_config)
	return vim.tbl_deep_extend("force", defaults, user_config)
end

return M
