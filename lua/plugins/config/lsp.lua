return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    require('config.remap').map_lsp(event)
                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                clangd = {},
                rust_analyzer = {},
                pyright = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
                bashls = {},
                ts_ls = {},
                csharp_ls ={},
            }

            for i, _ in pairs(servers) do
                local server = servers[i] or {}
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[i].setup(server)
            end

            -- require('mason').setup()
            -- require('mason-nvim-dap').setup()
        end,
    },
}
