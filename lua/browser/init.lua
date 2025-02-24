-- Create log file
local log_path = vim.fn.stdpath("cache") .. "/browser_nvim.log"
local log_file = io.open(log_path, "a")

-- Function to log messages
local function log_message(level, msg)
	if log_file then
		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		log_file:write(string.format("[%s] [%s] %s\n", timestamp, level, msg))
		log_file:flush()
	end
	vim.notify(msg, vim.log.levels[level])
end

-- log_message("INFO", "Starting to load browser.nvim")

local status, browser = pcall(require, "browser.browser")
if not status then
	log_message("ERROR", "Failed to load browser.browser: " .. browser)
	return
end

log_message("INFO", "Successfully loaded browser.nvim")
return browser

