local M = {}

M.Options = {}

function M.setup(opts)
	M.Options = require("codetime.config").set_config(opts) or {}
	require("codetime.util").setup_autocmds()
end

return M
