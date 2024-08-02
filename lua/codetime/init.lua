local M = {}

M.options = {}

---@param opts table: A table containing user-defined options for configuring the plugin.
function M.setup(opts)
	M.options = require("codetime.config").set_config(opts)

	local cache_path = M.options.cache_path
	local code_time_data = require("codetime.util").load_code_time_data(cache_path)

	if code_time_data.today.date ~= vim.fn.strftime("%d-%m-%Y") then
		vim.notify("Have a great day!", vim.log.levels.INFO, { title = "codetime.nvim" })
		code_time_data.today.date = vim.fn.strftime("%d-%m-%Y")
		code_time_data.today.total_time = "0h 0m 0s"
	end

	require("codetime.util").start_session_tracking(code_time_data, cache_path)
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
