local M = {}

--- Set an interval timer to execute a callback repeatedly.
---@param interval_ms number: The interval time in milliseconds.
---@param callback function: The callback function to execute at each interval.
---@return uv_timer_t: A reference to the timer object.
function M.set_interval(interval_ms, callback)
	local timer = vim.uv.new_timer()
	timer:start(interval_ms, interval_ms, callback)
	return timer
end

--- Clear a previously set interval timer.
---@param timer uv_timer_t: The timer object to clear.
function M.clear_interval(timer)
	timer:stop()
	timer:close()
end

--- Format a time table into a string.
---@param time table: A table with keys `h`, `m`, `s` representing hours, minutes, and seconds.
---@return string: A formatted time string in "Xh Xm Xs" format.
local function format_time(time)
	return string.format("%dh %dm %ds", time.h, time.m, time.s)
end

--- Normalize a time table by converting excess seconds and minutes to minutes and hours.
---@param time table: A table with keys `h`, `m`, `s` representing hours, minutes, and seconds.
---@return string: A formatted time string after normalization.
function M.normalize_time(time)
	time.m = time.m + math.floor(time.s / 60)
	time.s = time.s % 60
	time.h = time.h + math.floor(time.m / 60)
	time.m = time.m % 60
	return format_time(time)
end

--- Parse a formatted time string into hours, minutes, and seconds as numbers.
---@param time string: The time string in "Xh Xm Xs" format.
---@return number, number, number: The hours, minutes, and seconds as numbers.
function M.parse_time(time)
	local h, m, s = time:match("(%d+)h (%d+)m (%d+)s")
	h, m, s = tonumber(h), tonumber(m), tonumber(s)
	if not h or not m or not s then
		error("Invalid time format. Expected format: 'Xh Xm Xs'")
	end
	return h, m, s
end

--- Load coding time data from a JSON file.
---@param cache_path string: The path to the JSON file containing coding time data.
---@return table: The loaded coding time data as a Lua table.
function M.load_code_time_data(cache_path)
	if vim.fn.filereadable(cache_path) == 0 then
		vim.schedule(function()
			vim.notify("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
		end)
		local initial_data = {
			today = {
				date = vim.fn.strftime("%d-%m-%Y"),
				total_time = "0h 0m 0s",
			},
		}
		M.save_code_time_data(cache_path, initial_data)
		return initial_data
	end

	local json_data = vim.fn.readfile(cache_path)[1]
	return vim.json.decode(json_data)
end

--- Save coding time data to a JSON file.
---@param cache_path string: The path to the JSON file where coding time data will be saved.
---@param data table: The coding time data as a Lua table.
function M.save_code_time_data(cache_path, data)
	local json_data = vim.json.encode(data)
	local file = io.open(cache_path, "w")
	if file then
		file:write(json_data)
		file:close()
	end
end

--- Start tracking a new coding session.
--- This function initializes the session timer and updates the total coding time upon exiting Neovim.
---@param code_time_data table: The coding time data for the current session.
---@param cache_path string: The path to the JSON file where coding time data will be saved.
function M.start_session_tracking(code_time_data, cache_path)
	M.total_time_today = code_time_data.today.total_time
	local session_time = { h = 0, m = 0, s = 0 }
	M.session_time = format_time(session_time)

	local session_timer = M.set_interval(1000, function()
		session_time.s = session_time.s + 1
		if session_time.s == 60 then
			session_time.s = 0
			session_time.m = session_time.m + 1
		end
		if session_time.m == 60 then
			session_time.m = 0
			session_time.h = session_time.h + 1
		end
		M.session_time = format_time(session_time)
	end)

	vim.api.nvim_create_autocmd("VimLeave", {
		group = vim.api.nvim_create_augroup("CodeTime", { clear = true }),
		callback = function()
			local h, m, s = M.parse_time(M.total_time_today)
			h, m, s = h + session_time.h, m + session_time.m, s + session_time.s

			code_time_data.today.total_time = M.normalize_time({ h = h, m = m, s = s })
			M.save_code_time_data(cache_path, code_time_data)

			M.clear_interval(session_timer)
		end,
	})
end

return M
