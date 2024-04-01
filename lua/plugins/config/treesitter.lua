return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { "lua", "vim", "vimdoc", "query", "rust", "c", "c_sharp", "markdown" },

            auto_install = true,

            highlight = {
                enable = true,

                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            require('config/set').enable_folding()
        end,
    },
}
