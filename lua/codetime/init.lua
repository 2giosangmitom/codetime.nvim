local M = {}

M.Options = {}

function M.setup(opts)
	M.Options = require("codetime.config").set_config(opts) or {}
	require("codetime.util").setup_codetime_data()
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
