local M = {}

vim.g.leader = " "

local n_v = { "n", "v" };
local n = "n";
local v = "v";

local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true, desc = desc or "" }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options);
end

-- toggles file tree
map(n_v, "<leader>e", function()
    if vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
        vim.api.nvim_exec(":bd", false); -- opens previous buffer
    else
        vim.api.nvim_exec(":Ex", false); -- opens explorer
    end
end, "Toggle [E]xplorer")

map(v, "J", ":m '>+1<CR>gv=gv", "Move selected line of code down and indent")
map(v, "K", ":m '<-2<CR>gv=gv", "Move selected line of code up and indent")

map(n, "J", "<C-d>zz", "Go half-page [D]own and center on cursor")
map(n, "K", "<C-u>zz", "Go half-page [U]p and ceter on cursor")

-- cursor in the center when use n or N in search mode
map(n, "n", "nzzzv", "Go to [n]ext in search")
map(n, "N", "Nzzzv", "Go to [N]ext (previous) in search")

map("x", "<leader>p", [["_dP]], "[P]aste from clipboard register")
map(n_v, "<leader>y", [["+y]], "[y]ank to clipboard register")
map(n_v, "<leader>Y", [["+Y]], "[Y]ank to clipboard register")
map(n_v, "<leader>d", [["_d]], "[D]elete in blank register")

--diagnostic mappings
map(n, '[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
map(n, ']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
map(n, '<leader>fx', vim.diagnostic.setloclist, 'Open [F]i[X] list')
map(n, 'gl', vim.diagnostic.open_float, '[G]o to f[L]oat window')
--
--vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
--vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
--vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
--vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--
M.map_telescope = function()
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fiw', builtin.grep_string, { desc = '[F]ind [I]n [w]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
    vim.keymap.set('n', '<leader>fc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind in [C]onfig' })
end

M.map_lsp = function(event)
    local loc_map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local builtin = require('telescope.builtin')

    loc_map('H', vim.lsp.buf.hover, '[H]over Documentation')
    loc_map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    loc_map('<leader>fm', vim.lsp.buf.format, '[F]or[m]at current buffer')
    loc_map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    loc_map('gt', builtin.lsp_type_definitions, '[G]o to [T]ype definition')
    loc_map('gi', builtin.lsp_implementations, '[G]o to [I]mplementation')
    loc_map('gd', builtin.lsp_definitions, '[G]oto [D]efinition') -- <C-t> to go back
    loc_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    loc_map('gr', builtin.lsp_references, '[G]oto [R]eferences')
    loc_map('gs', vim.lsp.buf.signature_help, '[G]oto [R]eferences')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    loc_map('<leader>fn', builtin.lsp_document_symbols, '[F]ind Document Symbols (like [F]unctions)')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    loc_map('<leader>wfn', builtin.lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace Symbols (like [Functions)')
end

M.map_cmp = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    return {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<C-j>'] = cmp.mapping.scroll_docs(-4),
        ['<C-k>'] = cmp.mapping.scroll_docs(4),

        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        },

        ['<C-Space>'] = cmp.mapping.complete {},
    }
end

M.map_harpoon = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    map(n, "<leader>a", mark.add_file, "[A]dd file to harpoon")
    map(n, "<leader>h", ui.toggle_quick_menu, "Toggle [H]arpoon menu")

    map(n, "<leader>1", function() ui.nav_file(1) end, "Harpoon [1]st file")
    map(n, "<leader>2", function() ui.nav_file(2) end, "Harpoon [2]st file")
    map(n, "<leader>3", function() ui.nav_file(3) end, "Harpoon [3]st file")
    map(n, "<leader>4", function() ui.nav_file(4) end, "Harpoon [4]st file")
end

map(n, "<leader>u", vim.cmd.UndotreeToggle, "Toggle undo tree")

map(n, "<leader>gs", vim.cmd.Git, "Open [G]it [S]tatus")

return M
