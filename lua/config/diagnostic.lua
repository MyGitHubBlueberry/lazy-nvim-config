local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}

local diagnosti_config = {
    virtual_text = true, -- was true
    signs = {
        active = signs,
    },
    -- underline = true,
    -- severity_sort = true,
    float = {
        focusable = false,
        --style = "minimal",
        source = "always",
        --header = "",
        --prefix = "",
        --border = "rounded",
    },
}

vim.diagnostic.config(diagnosti_config)

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
