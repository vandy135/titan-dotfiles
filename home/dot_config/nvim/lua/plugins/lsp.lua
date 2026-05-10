return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            diagnostics = { globals = { "vim" } },
                        },
                    },
                },
                ts_ls = {},
                pyright = {},
                gopls = {},
                rust_analyzer = {},
                bashls = {},
                jsonls = {},
                yamlls = {},
            }

            vim.lsp.config("*", { capabilities = capabilities })
            for name, opts in pairs(servers) do
                vim.lsp.config(name, opts)
            end
            vim.lsp.enable(vim.tbl_keys(servers))

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
                    end

                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "References")
                    map("gI", vim.lsp.buf.implementation, "Implementation")
                    map("gD", vim.lsp.buf.declaration, "Declaration")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
                    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function() require("conform").format({ async = true, lsp_fallback = true }) end,
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                sh = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
}
