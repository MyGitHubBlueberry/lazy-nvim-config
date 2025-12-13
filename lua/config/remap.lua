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

map(n_v, "<leader>e", function()
    if vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
        vim.cmd("b#");
    else
        vim.cmd("Ex"); -- opens explorer
    end
end, "Toggle [E]xplorer")

map(n_v, "L", ":join<CR>", "Joins [L]ines with a space")

map(v, "J", ":m '>+1<CR>gv=gv", "Move selected line of code down and indent")
map(v, "K", ":m '<-2<CR>gv=gv", "Move selected line of code up and indent")

map(n, "J", "<C-d>zz", "Go half-page [D]own and center on cursor")
map(n, "K", "<C-u>zz", "Go half-page [U]p and ceter on cursor")

map(n, "n", "nzzzv", "Go to [n]ext in search")
map(n, "N", "Nzzzv", "Go to [N]ext (previous) in search")

map(n_v, "<leader>p", [["+p]], "[p]aste from clipboard register")
map(n_v, "<leader>P", [["+P]], "[P]aste from clipboard register")
map(n_v, "<leader>y", [["+y]], "[y]ank to clipboard register")
map(n_v, "<leader>Y", [["+Y]], "[Y]ank to clipboard register")
map(n_v, "<leader>d", [["_d]], "[D]elete in blank register")

map("n", "<leader>q", function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid

    if qf_winid == 0 then
        vim.diagnostic.setqflist()
    else
        vim.cmd("cclose")
    end
end, "Toggle [Q]uick Fix List")

map("n", "<C-j>", function()
    local qf = vim.fn.getqflist({ idx = 0, size = 0 })
    if qf.size == 0 then return end

    if qf.idx == qf.size then
        vim.cmd("cfirst")
    else
        vim.cmd("cnext")
    end
end, "Cycle Next QF Item")
map("n", "<C-k>", function()
    local qf = vim.fn.getqflist({ idx = 0, size = 0 })
    if qf.size == 0 then return end -- Safety: Do nothing if list is empty

    if qf.idx == 1 then
        vim.cmd("clast") -- If at the start, cycle to the bottom
    else
        vim.cmd("cprev")
    end
end, "Cycle Prev QF Item")

M.map_telescope = function()
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Find [H]elp' })
    vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = 'Find [K]eymaps' })
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find [F]iles' })
    vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Find by [G]rep' })
    vim.keymap.set('n', '<leader>?', builtin.diagnostics, { desc = 'Find Diagnostics (? for what is wrong)' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
    vim.keymap.set('n', '<leader>/', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Find in Config (/ for home dir)' })
end

M.map_lsp = function(event)
    local loc_map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local builtin = require('telescope.builtin')

    loc_map('H', vim.lsp.buf.hover, '[H]over Documentation')
    loc_map('<leader>r', vim.lsp.buf.rename, '[R]ename')
    loc_map('<leader>F', vim.lsp.buf.format, '[F]ormat current buffer')
    loc_map('<leader>a', vim.lsp.buf.code_action, 'Code [A]ction')
    loc_map('gt', builtin.lsp_type_definitions, '[G]o to [T]ype definition')
    loc_map('gi', builtin.lsp_implementations, '[G]o to [I]mplementation')
    loc_map('gd', builtin.lsp_definitions, '[G]oto [D]efinition') -- <C-t> to go back
    loc_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    loc_map('gr', builtin.lsp_references, '[G]oto [R]eferences')
    vim.keymap.set({ 'i', 'n' }, '<C-Space>', vim.lsp.buf.signature_help,
        { buffer = event.buf, desc = 'LSP: ' .. 'Open Signature' })

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    loc_map('<leader>s', builtin.lsp_document_symbols, 'Find Document [s]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    loc_map('<leader>S', builtin.lsp_dynamic_workspace_symbols, 'Find Workspace [S]ymbols')
end

M.map_debugger = function()
    local dap = require 'dap'
    local loc_map = function(keys, func, desc)
        vim.keymap.set(n_v, keys, func, { desc = 'Debugger: ' .. desc })
    end

    loc_map("<leader>dt", function() dap.toggle_breakpoint() end, "[t]oggle break point")
    loc_map("<leader>dc", function() dap.continue() end, "Start or [c]ontinue")
    loc_map("<leader>do", function() dap.step_over() end, "Step [o]ver")
    loc_map("<leader>dO", function() dap.step_out() end, "Step [O]ut")
    loc_map("<leader>di", function() dap.step_into() end, "Step [i]nto")
    loc_map("<leader>dm", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
        "Set a break point with [m]essage")
    loc_map("<leader>dr", function() dap.repl.open() end, "Open [r]epl")
    loc_map("<Leader>dh", function()
        require("dap.ui.widgets").hover()
    end, "[h]over")
    loc_map("<Leader>dp", function()
        require("dap.ui.widgets").preview()
    end, "[p]review")
    loc_map("<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
    end, "Something to do with [f]rames")
    loc_map("<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end, "Something to do with [s]copes")
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
        end, { 'i', 'c' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 'c' }),

        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
        },
        ['<C-space>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.mapping.close()(fallback)
            else
                cmp.mapping.complete()(fallback)
            end
        end, { "i", "c" }),
    }
end

M.map_harpoon = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    map(n, "<leader>x", mark.add_file, "Add file to harpoon")
    map(n, "<leader>h", ui.toggle_quick_menu, "Toggle [H]arpoon menu")

    map(n, "<leader>1", function() ui.nav_file(1) end, "Harpoon [1]st file")
    map(n, "<leader>2", function() ui.nav_file(2) end, "Harpoon [2]st file")
    map(n, "<leader>3", function() ui.nav_file(3) end, "Harpoon [3]st file")
    map(n, "<leader>4", function() ui.nav_file(4) end, "Harpoon [4]st file")
end

map(n, "<leader>u", vim.cmd.UndotreeToggle, "Toggle undo tree")

return M
