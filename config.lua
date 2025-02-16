local M = {}

-- Default settings for search engines
M.search_engines = {
	google = "https://www.google.com/search?q=",
	github = "https://github.com/search?q=",
	youtube = "https://www.youtube.com/results?search_query=",
}

-- Open url in browser function
M.open_url = function(url)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "cmd.exe /c start"
	else
		print("Không thể mở URL trên hệ điều hành này!")
		return
	end
	os.execute(open_cmd .. " " .. url .. " &")
end

-- Search on website with user settings
M.search_on_website = function(website, query)
	local base_url = M.search_engines[website]
	if base_url then
		local search_url = base_url .. query
		M.open_url(search_url)
	else
		print("Trang web không hỗ trợ!")
	end
end

-- Create dynamic each engine
M.create_search_commands = function()
	for website, _ in pairs(M.search_engines) do
		vim.api.nvim_create_user_command(website, function(opts)
			M.search_on_website(website, opts.args)
		end, { nargs = "*" })
	end
end

-- Call function to create search command
M.create_search_commands()

-- User settings via setup()
M.setup = function(config)
	if config.search_engines then
		M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
	end
end

return M
