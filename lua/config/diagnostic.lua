local diagnostic_opts = {
    underline = {
        severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
        }
    },
    virtual_text = {
        severity = {
            vim.diagnostic.severity.HINT,
            vim.diagnostic.severity.INFO,
        },
        spacing = 4,
    },
    virtual_lines = {
        severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
        },
        current_line = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    },
    update_in_insert = false,
    float = {
        scope = 'cursor',
        border = 'single',
    },
    severity_sort = true,
}

vim.diagnostic.config(diagnostic_opts)
