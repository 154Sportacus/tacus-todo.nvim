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
        -- Remove números antigos (ex: "1. ", "2. ") e espaços
        local task = line:gsub("^%d+%.%s*", ""):gsub("^%s+", "")
        
        -- Filtra para não adicionar linhas vazias ou o cabeçalho antigo
        if task ~= "" and not task:find("|") and not task:find("%-") and not task:find("_") then
            table.insert(tasks, task) -- Adiciona ao fim da lista (FIFO)
        end
    end

    local new_content = {}
    -- 1. Insere o Cabeçalho
    for _, h in ipairs(header) do table.insert(new_content, h) end
    
    -- 2. Insere as tarefas (A primeira que foi escrita será o número 1)
    for i, t in ipairs(tasks) do
        table.insert(new_content, i .. ". " .. t)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_content)
    
    -- Coloca o cursor no fim do ficheiro para adicionares a tarefa N
    vim.api.nvim_win_set_cursor(0, {#new_content, 0})
end
