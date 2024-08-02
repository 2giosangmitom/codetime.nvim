local M = {}

M.Options = {}

function M.setup(opts)
	M.Options = require("codetime.config").set_config(opts)

	local code_time_data = {}
	local cache_path = M.Options.cache_path

	if vim.fn.filereadable(cache_path) == 0 then
		vim.notify("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
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
	else
		local json_data = vim.fn.readfile(cache_path)[1]
		code_time_data = vim.json.decode(json_data)
	end

	if code_time_data.today.date ~= vim.fn.strftime("%d-%m-%Y") then
		vim.notify("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
		code_time_data.today.date = vim.fn.strftime("%d-%m-%Y")
		code_time_data.today.total_time = "0h 0m 0s"
	end

	if code_time_data.today.total_time == "0h 0m 0s" then
		vim.notify("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
	end

	require("codetime.util").start_new_session(code_time_data)
end

vim.api.nvim_create_user_command("CodeTime", function(opts)
	local api = require("codetime.api")
	if opts.args == "today" then
		vim.notify(
			"Today's code time: " .. api.get_total_codetime_today(),
			vim.log.levels.INFO,
			{ title = "codetime.nvim" }
		)
	end
end, {
	nargs = 1,
	complete = function()
		return { "today" }
	end,
})

return M
