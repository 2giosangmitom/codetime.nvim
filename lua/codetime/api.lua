local M = {}

local codetime_util = require("codetime.util")

function M.get_current_session()
	return codetime_util.get_session_codetime()
end

return M
