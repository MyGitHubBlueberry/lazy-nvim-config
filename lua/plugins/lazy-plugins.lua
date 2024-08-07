require('lazy').setup({
    { 'numToStr/Comment.nvim',             opts = {} }, --comments
    { 'lewis6991/gitsigns.nvim',           opts = {} }, --git signs
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
