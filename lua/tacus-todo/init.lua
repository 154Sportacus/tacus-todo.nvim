local M = {} -- ESTA LINHA É OBRIGATÓRIA NO TOPO

M.format_todo = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    
    local header = {
        "  _           _        ",
        " | |_ ___  __| | ___   ",
        " | __/ _ \\/ __ |/ _ \\  ",
        " | || (_) | (_|| (_) | ",
        "  \\___\\___/\\__,_|\\___/ ",
        "-----------------------",
        "",
    }

    local tasks = {}
    for _, line in ipairs(lines) do
        local task = line:gsub("^%d+%.%s*", ""):gsub("^%s+", "")
        if task ~= "" and not task:find("|") and not task:find("%-") and not task:find("_") then
            table.insert(tasks, task)
        end
    end

    local new_content = {}
    for _, h in ipairs(header) do table.insert(new_content, h) end
    for i, t in ipairs(tasks) do
        table.insert(new_content, i .. ". " .. t)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_content)
    -- Opcional: coloca o cursor no fim para o modo FIFO
    vim.api.nvim_win_set_cursor(0, {#new_content, 0})
end

M.setup = function()
    vim.api.nvim_create_user_command('TacusTodoList', M.format_todo, {})
    
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*/Desktop/todo",
        callback = M.format_todo,
    })
end

return M
