vim.notify("Starting to load browser.nvim", vim.log.levels.INFO)

local status, browser = pcall(require, "browser.browser")
if not status then
    vim.notify("Failed to load browser.browser: " .. browser, vim.log.levels.ERROR)
    return
end

vim.notify("Successfully loaded browser.nvim", vim.log.levels.INFO)
return browser