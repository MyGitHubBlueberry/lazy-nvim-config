require('lazy').setup({
    { 'gpanders/nvim-parinfer' }, --for yuck
    { 'neodev.nvim' }, --for yuck
    { "williamboman/mason.nvim" },
    { "mfussenegger/nvim-dap" },
    { "jay-babu/mason-nvim-dap.nvim",      opts = {} },
    { "rcarriga/nvim-dap-ui",              dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    } },
    { 'numToStr/Comment.nvim',             opts = {} }, --comments
    { 'lewis6991/gitsigns.nvim',           opts = {} }, --git signs
    { 'brenoprata10/nvim-highlight-colors',       config = function()
        require ('nvim-highlight-colors').setup({})
    end },
    { 'Leviathenn/nvim-transparent',        opts = {
        enable = true,
        extra_groups = "all",
        exclude = {
            "PmenuSel",
            "PmenuKindSel",
            "PmenuExtraSel",
            "PmenuKind",
            "PmenuExtra",
            "PmenuSbar",
            "PmenuThumb",
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
            "VisualNC",
            "DiffAdd",
            "DiffChange",
            "DiffDelete",
            "DiffText",
            "ErrorMsg",
            "Error",
            "NvimInternalError",
        },
    }},
    require 'plugins/config/telescope',
    require 'plugins/config/which-key',
    require 'plugins/config/cmp',
    require 'plugins/config/lsp',
    require 'plugins/config/mini',
    require 'plugins/config/treesitter',
    require 'plugins/config/harpoon',
    -- {
    --     'sainnhe/gruvbox-material',
    --     priority = 1000, -- Make sure to load this before all the other start plugins.
    --     config = function()
    --         vim.cmd.colorscheme('gruvbox-material')
    --     end
    -- },
    {
        'deviantfero/wpgtk.vim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            vim.cmd.colorscheme('wpgtk')
        end
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
})
