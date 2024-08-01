local M = {}

local util = require("codetime.util")

function M.get_session_codetime()
	return util.session_codetime
end

function M.get_total_codetime_today()
	local total_recorded = util.total_codetime
	local current_session = M.get_session_codetime()
	local h1, m1, s1 = total_recorded:match("(%d+)h (%d+)m (%d+)s")
	local h2, m2, s2 = current_session:match("(%d+)h (%d+)m (%d+)s")

	local total_time = util.normalize_time({
		h = tonumber(h1) + tonumber(h2),
		m = tonumber(m1) + tonumber(m2),
		s = tonumber(s1) + tonumber(s2),
	})

	return total_time
end

return M
