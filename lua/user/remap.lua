local M = {}


vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'Q', '<nop>')

-- [F]ormat
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat' })
vim.keymap.set('n', '<leader>', '<nop>')

-- Harpoon
local harpoon = require('harpoon')

-- [A]dd to Harpoon
vim.keymap.set('n', '<leader>a', function()
    harpoon:list():append()
end, { desc = '[A]dd to Harpoon' })

vim.keymap.set('n', '<C-e>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', '<C-h>', function()
    harpoon:list():select(1)
end)
vim.keymap.set('n', '<C-t>', function()
    harpoon:list():select(2)
end)
vim.keymap.set('n', '<C-n>', function()
    harpoon:list():select(3)
end)
vim.keymap.set('n', '<C-s>', function()
    harpoon:list():select(4)
end)

-- Telescope
-- [S]earch
local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sv', builtin.git_files, { desc = '[S]earch [V]ersion control' })
vim.keymap.set('n', '<leader>sw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string { search = word }
end)
vim.keymap.set('n', '<leader>sW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string { search = word }
end)

vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end, { desc = '[S]earch [/] in Open Files' })

--
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

--
vim.keymap.set('n', '<leader><leader>', builtin.git_status, { desc = '[ ] Find existing buffers' })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
M.map_lsp_keybinds = function(buffer_number)
    -- [G]o to
    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
        { desc = '[G]oto [D]efinition', buffer = buffer_number })

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration', buffer = buffer_number })

    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
        { desc = '[G]oto [R]eferences', buffer = buffer_number })

    vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
        { desc = '[G]oto [I]mplementation', buffer = buffer_number })

    vim.keymap.set('n', 'gt', require('telescope.builtin').lsp_type_definitions,
        { desc = '[Go] [T]ype', buffer = buffer_number })

    -- [S]earch [S]ymbols
    vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols,
        { desc = '[S]earch [S]ymbols', buffer = buffer_number })

    vim.keymap.set('n', '<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        { desc = '[S]earch Workspace [S]ymbols', buffer = buffer_number })

    --
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame', buffer = buffer_number })

    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction', buffer = buffer_number })

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation', buffer = buffer_number })
end

vim.keymap.set('n', '[q', '<CMD>cprevious<CR>', { silent = true })
vim.keymap.set('n', ']q', '<CMD>cnext<CR>', { silent = true })
vim.keymap.set('n', '[Q', '<CMD>cfirst<CR>', { silent = true })
vim.keymap.set('n', ']Q', '<CMD>clast<CR>', { silent = true })

--
-- [T]rouble
vim.keymap.set('n', 'tt', function()
    require('trouble').toggle()
end)

vim.keymap.set('n', '[t', function()
    require('trouble').open()
    require('trouble').previous { skip_groups = true, jump = true }
end)

vim.keymap.set('n', ']t', function()
    require('trouble').open()
    require('trouble').next { skip_groups = true, jump = true }
end)

vim.keymap.set('n', 'to', vim.diagnostic.open_float)

-- Git sign <leade> [H]unk
--
M.map_git_sign_keybindings = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, { expr = true })

    map('n', '[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end, { expr = true })

    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)

    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
end


-- Fugitive
M.map_fugitive_keybindings = function(bufnr)
    -- [F]ugitive
    -- [TODO] add git things
end

return M
