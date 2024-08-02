local M = {}

local util = require("codetime.util")

function M.get_session_codetime()
	return util.session_codetime
end

function M.get_total_codetime_today()
	local total_recorded = util.total_codetime
	local current_session = M.get_session_codetime()
	local h1, m1, s1 = util.parse_time(total_recorded)
	local h2, m2, s2 = util.parse_time(current_session)

	local total_time = util.normalize_time({
		h = h1 + h2,
		m = m1 + m2,
		s = s1 + s2,
	})

	return total_time
end

return M
