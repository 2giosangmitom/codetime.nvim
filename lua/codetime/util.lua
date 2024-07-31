local M = {}

function M.set_interval(interval_ms, callback)
	local timer = vim.uv.new_timer()
	timer:start(interval_ms, interval_ms, function()
		callback()
	end)
	return timer
end

function M.setup_codetime_data()
	local code_time_data = {}
	local cache_path = vim.fn.stdpath("cache") .. "/code_time.json"

	if vim.fn.filereadable(cache_path) == 0 then
		vim.notify_once("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
		code_time_data.today = {
			date = vim.fn.strftime("%d-%m-%Y"),
			total_time = "0h 0m 0s",
		}
		local json_data = vim.json.encode(code_time_data)
		local file = io.open(cache_path, "w")
		if file then
			file:write(json_data)
			file:close()
		end
	end

	local json_data = vim.fn.readfile(cache_path)[1]
	code_time_data = vim.json.decode(json_data)

	if code_time_data.today.date ~= vim.fn.strftime("%d-%m-%Y") then
		code_time_data.today.date = vim.fn.strftime("%d-%m-%Y")
		code_time_data.today.total_time = "0h 0m 0s"
	end

	if code_time_data.today.total_time == "0h 0m 0s" then
		vim.notify_once("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
	end

	M.total_codetime = code_time_data.today.total_time

	require("codetime.util").start_new_session(code_time_data)
end

function M.clear_interval(timer)
	timer:stop()
	timer:close()
end

local codetime_group = vim.api.nvim_create_augroup("CodeTime", { clear = true })

local session_codetime = "0h 0m 0s"

function M.get_session_codetime()
	return session_codetime
end

function M.get_total_codetime()
	return M.total_codetime
end

local function format_time(time_table)
	return string.format("%dh %dm %ds", time_table.h, time_table.m, time_table.s)
end

function M.normalize_time(time)
	if time.s >= 60 then
		time.m = time.m + math.floor(time.s / 60)
		time.s = time.s % 60
	end
	if time.m >= 60 then
		time.h = time.h + math.floor(time.m / 60)
		time.m = time.m % 60
	end
	return format_time(time)
end

function M.start_new_session(code_time_data)
	local cache_path = vim.fn.stdpath("cache") .. "/code_time.json"
	local session_time = { h = 0, m = 0, s = 0 }

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
		session_codetime = format_time(session_time)
	end)

	vim.api.nvim_create_autocmd("VimLeave", {
		group = codetime_group,
		callback = function()
			local total_time = code_time_data.today.total_time
			local h, m, s = total_time:match("(%d+)h (%d+)m (%d+)s")

			h = session_time.h + tonumber(h)
			m = session_time.m + tonumber(m)
			s = session_time.s + tonumber(s)

			code_time_data.today.total_time = M.normalize_time({ h = h, m = m, s = s })
			local json_data = vim.json.encode(code_time_data)

			local file = io.open(cache_path, "w")
			if file then
				file:write(json_data)
				file:close()
			end

			M.clear_interval(session_timer)
		end,
	})
end

return M
