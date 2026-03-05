require('lazy').setup({
    { 'lewis6991/gitsigns.nvim', opts = {} },
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup({})
        end
    },
    {
        'Leviathenn/nvim-transparent',
        opts = {
            enable = true,
            extra_groups = "all",
            exclude = {
                "Pmenu",
                "CmpFloatScroll",
                "PmenuSel",
                "PmenuKindSel",
                "PmenuExtraSel",
                "PmenuKind",
                "PmenuExtra",
                "PmenuSbar",
                "PmenuThumb",
                "Scrollbar",
                "ModeMsg",
                "DevIconOrgMode",
                "StatusLine",
                "StatusLineNC",
                "StatusLineTerm",
                "StatusLineTermNC",
                "MiniStatuslineModeNormal",
                "MiniStatuslineModeInsert",
                "MiniStatuslineModeVisual",
                "MiniStatuslineModeReplace",
                "MiniStatuslineModeCommand",
                "MiniStatuslineModeOther",
                "MiniStatuslineDevinfo",
                "MiniStatuslineFilename",
                "MiniStatuslineFileinfo",
                "MiniStatuslineInactive",
                "Visual",
                "TabLineSel",
                "VisualNC",
                "DiffAdd",
                "DiffChange",
                "DiffDelete",
                "DiffText",
                "ErrorMsg",
                "Error",
                "NvimInternalError",
            },
        }
    },
    require 'plugins/config/telescope',
    require 'plugins/config/which-key',
    require 'plugins/config/cmp',
    require 'plugins/config/lsp',
    require 'plugins/config/mini',
    require 'plugins/config/treesitter',
    {
        'deviantfero/wpgtk.vim',
        priority = 1000,         -- Make sure to load this before all the other start plugins.
        config = function()
            vim.cmd.colorscheme('wpgtk')
        end
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    -- --for yuck like in eww
    -- { 'gpanders/nvim-parinfer' },
    -- { 'neodev.nvim' },
    -- -- for non declarative systems
    -- { "williamboman/mason.nvim" },
    -- -- for debugger
    -- { "mfussenegger/nvim-dap" },
    -- { "rcarriga/nvim-dap-ui",              dependencies = {
    --     "mfussenegger/nvim-dap",
    --     "nvim-neotest/nvim-nio",
    -- } },
    --
    -- require 'plugins/config/harpoon',
    -- require 'plugins/config/debugger',
    --
    -- {
    --     'sainnhe/gruvbox-material',
    --     priority = 1000, -- Make sure to load this before all the other start plugins.
    --     config = function()
    --         vim.cmd.colorscheme('gruvbox-material')
    --     end
    -- },
}, {
    rocks = {
        hererocks = false,
        enabled = false,
    },
})
