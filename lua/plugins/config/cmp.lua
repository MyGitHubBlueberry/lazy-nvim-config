return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                            require('luasnip').filetype_extend("cs", { "unity" }) --Unity snippets
                        end,
                    },
                },
            },
            'saadparwaiz1/cmp_luasnip',

            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            { 'petertriho/cmp-git', ops = {} },
        },
        config = function()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local remap = require 'config.remap'

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert,noselect' },
                mapping = cmp.mapping.preset.insert(remap.map_cmp()),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'treesitter' },
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
                }),
                window = {
                    completion = {
                        border = 'single',
                        scrollbar = false,
                        winhighlight = "Normal:FloatBorder,CursorLine:PmenuSel,Search:None",
                    },
                    documentation = {
                        border = 'single',
                        scrollbar = false,
                    },
                },
                formatting = {
                    fields = { "abbr", "menu", "kind" },
                    format = function(entry, item)
                        -- Define menu shorthand for different completion sources.
                        local menu_icon = {
                            treesitter = "TSTR",
                            nvim_lsp = "NLSP",
                            nvim_lua = "NLUA",
                            luasnip  = "LSNP",
                            buffer   = "BUFF",
                            path     = "PATH",
                            cmd_line = "CMDL",
                            git      = "GIT",
                        }
                        -- Set the menu "icon" to the shorthand for each completion source.
                        item.menu = menu_icon[entry.source.name]

                        -- Set the fixed width of the completion menu to 60 characters.
                        local fixed_width = 20

                        -- Set 'fixed_width' to false if not provided.
                        fixed_width = fixed_width or false

                        -- Get the completion entry text shown in the completion window.
                        local content = item.abbr

                        -- Set the fixed completion window width.
                        if fixed_width then
                            vim.o.pumwidth = fixed_width
                        end

                        -- Get the width of the current window.
                        local win_width = vim.api.nvim_win_get_width(0)

                        -- Set the max content width based on either: 'fixed_width'
                        -- or a percentage of the window width, in this case 20%.
                        -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
                        local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

                        -- Truncate the completion entry text if it's longer than the
                        -- max content width. We subtract 3 from the max content width
                        -- to account for the "..." that will be appended to it.
                        if #content > max_content_width then
                            item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
                        else
                            item.abbr = content .. (" "):rep(max_content_width - #content)
                        end
                        return item
                    end,
                },
            }
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = 'buffer' },
                })
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
}
