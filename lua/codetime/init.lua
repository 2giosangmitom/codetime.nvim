local M = {}

M.options = {}

---@param opts table: A table containing user-defined options for configuring the plugin.
function M.setup(opts)
	M.options = require("codetime.config").set_config(opts)
	local util = require("codetime.util")

	local cache_path = M.options.cache_path
	local code_time_data = util.load_code_time_data(cache_path)

	local today_date = vim.fn.strftime("%d-%m-%Y")
	if code_time_data.today.date ~= today_date then
		code_time_data.today.date = today_date
		code_time_data.today.total_time = "0h 0m 0s"
	end

	util.start_session_tracking(code_time_data, cache_path)
end

vim.api.nvim_create_user_command("CodeTime", function(opts)
	local api = require("codetime.api")
	if opts.args == "today" then
		vim.notify(
			"Today's code time: " .. api.get_total_time_today(),
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
