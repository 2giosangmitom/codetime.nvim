local M = {}

local codetime_util = require("codetime.util")

function M.get_session_codetime()
	return codetime_util.get_session_codetime()
end

function M.get_total_codetime_today()
	local total_recorded = codetime_util.get_total_codetime()
	local current_session = codetime_util.get_session_codetime()
	local h, m, s = total_recorded:match("(%d+)h (%d+)m (%d+)s")
	local h2, m2, s2 = current_session:match("(%d+)h (%d+)m (%d+)s")
	return codetime_util.normalize_time({ h = h + h2, m = m + m2, s = s + s2 })
end

return M
