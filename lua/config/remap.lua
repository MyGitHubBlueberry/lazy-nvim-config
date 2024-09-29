local M = {}

vim.g.leader = " "

local n_v = { "n", "v" };
local n = "n";
local v = "v";

local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true }
    desc = desc or ""
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

map(n_v, "<leader>p", [["+p]], "[p]aste from clipboard register")
map(n_v, "<leader>P", [["+P]], "[P]aste from clipboard register")
map(n_v, "<leader>y", [["+y]], "[y]ank to clipboard register")
map(n_v, "<leader>Y", [["+Y]], "[Y]ank to clipboard register")
map(n_v, "<leader>d", [["_d]], "[D]elete in blank register")

--diagnostic mappings
map(n, '[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
map(n, ']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
map(n, '<leader>q', vim.diagnostic.setqflist, 'Open [Q]uick Fix List') -- :copen; add :cclose to togle
map(n, 'gl', vim.diagnostic.open_float, '[G]o to f[L]oat window')
--
map(n, '<C-k>', function() vim.api.nvim_exec(":cprev", false) end, { desc = 'Open prev item in fix list' })
map(n, '<C-j>', function() vim.api.nvim_exec(":cnext", false) end, { desc = 'Open next item in fix list' })
--
M.map_telescope = function()
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = 'Find [H]elp' })
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
    -- loc_map('gt', builtin.lsp_type_definitions, '[G]o to [T]ype definition')
    loc_map('gi', builtin.lsp_implementations, '[G]o to [I]mplementation')
    loc_map('gd', builtin.lsp_definitions, '[G]oto [D]efinition') -- <C-t> to go back
    loc_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    loc_map('gr', builtin.lsp_references, '[G]oto [R]eferences')
    vim.keymap.set({ 'i', 'n' }, '<C-Space>', vim.lsp.buf.signature_help,
        { buffer = event.buf, desc = 'LSP: ' .. 'Open Signature' })

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    loc_map('<leader>s', builtin.lsp_document_symbols, 'Find Document [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    loc_map('<leader>S', builtin.lsp_dynamic_workspace_symbols, 'Find Workspace [S]ymbols')
end

M.map_debugger = function()
    local dap = require'dap'
    map(n, "<leader>dp", function() dap.toggle_breakpoint() end, "Toggle break point")
    map(n, "<leader>dc", function() dap.continue() end, "Start or continue the debugger")
    map(n, "<leader>do", function() dap.step_over() end, "Step over in debugger")
    map(n, "<leader>dO", function() dap.step_out() end, "Step over in debugger")
    map(n, "<leader>di", function() dap.step_into() end, "Step into in debugger")
    map(n, "<leader>dlp", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, "Set a break point with debug message")
    map(n, "<leader>drp", function() dap.repl.open() end, "Open repl")
    map(n_v, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end, "Hover in debugger")
    map(n_v, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end, "Preview in depugger")
    map(n, '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end, "Something to do with frames")
    map(n, '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end, "Something to do with scopes")
end

M.normal_mode_cmp_remap = function()
    -- local cmp = require 'cmp'
    -- local luasnip = require 'luasnip'
    -- Following tab remap breaks <C-i> from work
    -- map(n, "<Tab>", function()
    --     if luasnip.expand_or_jumpable() then
    --         luasnip.expand_or_jump()
    --     else
    --         return "<Tab>"
    --     end
    -- end, "Behaves like <Tab> or goes to next snippet")
    --
    -- map(n, "<S-Tab>", function()
    --     if luasnip.jumpable(-1) then
    --         luasnip.jump(-1)
    --     else
    --         return "<S-Tab>"
    --     end
    -- end, "Behaves like <S-Tab> or goes to previous snippet")
end

M.map_cmp = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    M.normal_mode_cmp_remap();
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
            select = true
        },

        -- ['<C-Space>'] = cmp.mapping.complete {},
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
