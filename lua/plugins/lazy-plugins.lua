require('lazy').setup({
    { 'numToStr/Comment.nvim',             opts = {} }, --comments
    { 'lewis6991/gitsigns.nvim',           opts = {} }, --git signs
    { 'MyGitHubBlueberry/wise-delimiters', opts = {} },
    require 'plugins/config/telescope',
    require 'plugins/config/which-key',
    require 'plugins/config/cmp',
    require 'plugins/config/lsp',
    require 'plugins/config/mini',
    require 'plugins/config/treesitter',
    require 'plugins/config/harpoon',
    {
        'sainnhe/gruvbox-material',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            vim.cmd.colorscheme('gruvbox-material')
        end
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
})
