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
        focusable = true,
        -- style = "minimal",
        source = "always",
        -- header = "",
        -- prefix = "",
        border = "single",
    },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "single"
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "single"
  }
)

vim.diagnostic.config(diagnosti_config)

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
