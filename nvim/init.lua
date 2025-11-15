-- ==== Bootstrap lazy.nvim ====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==== Opciones básicas ====
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.g.mapleader = " "
vim.opt.signcolumn = "no"
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false

-- ==== Plugins ====
require("lazy").setup({
    -- Explorador de archivos
    { "nvim-tree/nvim-tree.lua",       dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },
    -- Búsqueda
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- Tree-sitter y textobjects
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = function(_, opts)
            -- Initialize ensure_installed if it doesn't exist
            opts.ensure_installed = opts.ensure_installed or {}

            -- Ensure C# and related parsers are installed
            vim.list_extend(opts.ensure_installed, {
                "c_sharp",  -- C# syntax
                "xml",      -- For .csproj files and XML docs
                "json",     -- For appsettings.json
                "yaml",     -- For .yml configs
                "regex",    -- For regex highlighting in strings
                "markdown", -- For README and docs
                "markdown_inline",
            })

            -- Enhanced C# specific configuration
            opts.highlight = {
                enable = true,
                -- Disable for very large C# files (>100KB) to prevent lag
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            }

            opts.indent = {
                enable = true,
                disable = {},
            }

            -- Incremental selection - amazing for C# refactoring
            opts.incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            }

            -- Text objects for C# specific constructs
            opts.textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                    },
                },
            }
        end,
    },

    -- Treesitter text objects plugin
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = "nvim-treesitter/nvim-treesitter",
    },

    -- Show context (current class/method) at top
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            enable = true,
            max_lines = 4,
            min_window_height = 20,
            mode = "topline",
            separator = "─",
        },
    },

    -- Automatic tag closing for XML
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {
            opts = {
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = true,
            },
            filetypes = { "html", "xml", "razor" },
        },
    },
    -- LSP y autocompletado
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim",          build = ":MasonUpdate", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    {
        "windwp/nvim-autopairs",
        lazy = false,
        config = function()
            require("nvim-autopairs").setup {}
        end
    },
    { "tpope/vim-commentary", event = "VeryLazy" },
    { "folke/trouble.nvim",   dependencies = { "nvim-tree/nvim-web-devicons" } },
    {   "tpope/vim-commentary", },
    -- Tema Kanagawa
    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "kanagawa-paper"
        end
    },
    -- Barra de estado
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },
})

-- No dejar resaltado después de buscar
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ==== Configuración de Diagnósticos ====
vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        source = "always",
        prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- Símbolos para el gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ==== Atajos ====
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "<C-^>")


-- Diagnósticos
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
    { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Mostrar diagnóstico flotante" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnóstico anterior" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Siguiente diagnóstico" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lista de diagnósticos" })

-- QoL
vim.keymap.set("i", "<C-z>", "<C-o>u")
vim.keymap.set('i', '<C-H>', '<C-w>', { noremap = true })
vim.keymap.set('', '<S-Left>', '20zh')
vim.keymap.set('', '<S-Right>', '20zl')
vim.cmd([[
  cnoreabbrev wq xa
  cnoreabbrev Wq xa
  cnoreabbrev WQ xa
]])


-- ==== Autocompletado Setup ====
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})

-- ==== Integración con autopairs ====
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- ==== Mason ====
require("mason").setup()

-- ==== Mason-lspconfig ====
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "omnisharp" },
    automatic_installation = true,
})

-- ==== Trouble Setup ====
require("trouble").setup({
    modes = {
        diagnostics = {
            auto_open = false,
            auto_close = false,
        },
    },
})

-- ==== Configuración de LSP (Nueva API) ====
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Función on_attach común
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Navegación LSP
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

    -- Acciones LSP
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>fo", function() vim.lsp.buf.format({ async = true }) end, opts)

    -- Destacar símbolo bajo el cursor
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-- ==== Configuración de Omnisharp ====
local omnisharp_bin = vim.fn.stdpath("data") .. "\\mason\\bin\\omnisharp.cmd"

vim.lsp.config('omnisharp', {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        omnisharp = {
            useGlobalMono = "always"
        }
    },
    handlers = {
        ["textDocument/semanticTokens"] = function() end,
    },
})

-- ==== Configuración de Lua LSP ====
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})

-- ==== Habilitar los servidores LSP ====
vim.lsp.enable('omnisharp')
vim.lsp.enable('lua_ls')
