local M = {}

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
        "                       ", -- Linha 7
        "                       ", -- Linha 8 (Cursor Here)
        "                       ", -- Linha 9
        "",
    }

    local tasks = {}
    -- 1. Capturar as tarefas que já existem (da linha 11 para baixo)
    for i = 11, #lines do
        local line = lines[i]
        local task = line:gsub("^%d+%.%s*", ""):gsub("^%s+", "")
        if task ~= "" then
            table.insert(tasks, task)
        end
    end

    -- 2. Capturar o que escreveste no "espaço reservado" (Linhas 7 e 8)
    for i = 7, 8 do
        local input = lines[i] or ""
        -- Limpa o texto de ajuda e espaços para extrair a nova task
        local new_task = input:gsub("%[ ESCREVE AQUI %]", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if new_task ~= "" then
            table.insert(tasks, new_task)
        end
    end

    -- 3. Montar o novo conteúdo
    local new_content = {}
    for _, h in ipairs(header) do table.insert(new_content, h) end
    for i, t in ipairs(tasks) do
        table.insert(new_content, i .. ". " .. t)
    end

    -- 4. Aplicar ao buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_content)

    -- 5. POSICIONAR O CURSOR: Linha 8, Coluna 0 (Início da linha)
    -- O Neovim usa {linha, coluna}. A linha 8 é onde deixámos o espaço vazio.
    vim.api.nvim_win_set_cursor(0, {8, 0})

    -- 6. ENTRAR EM MODO DE INSERÇÃO
    vim.cmd('startinsert!')
end

M.setup = function()
    vim.api.nvim_create_user_command('TacusTodoList', M.format_todo, {})
    
    -- Formata e limpa o input sempre que salvas
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*/Desktop/todo",
        callback = M.format_todo,
    })
end

return M
