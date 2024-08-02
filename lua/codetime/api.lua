local M = {}

local util = require("codetime.util")

--- Get the current session's coding time.
---@return string: The current session's coding time in "Xh Xm Xs" format.
function M.get_session_time()
	return util.session_time
end

--- Get the total coding time for today.
---@return string: The total coding time accumulated today in "Xh Xm Xs" format.
function M.get_total_time_today()
	local h1, m1, s1 = util.parse_time(util.total_time_today)
	local h2, m2, s2 = util.parse_time(M.get_session_time())

	return util.normalize_time({
		h = h1 + h2,
		m = m1 + m2,
		s = s1 + s2,
	})
end

return M
