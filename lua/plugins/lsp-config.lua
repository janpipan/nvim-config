return {
  'neovim/nvim-lspconfig',
  cmd = {'LspInfo', 'LspInstall', 'LspStart'},
  event = {'BufReadPre', 'BufNewFile'},
  dependencies = {
    {'hrsh7th/cmp-nvim-lsp'},
    {'mason-org/mason.nvim'},
    {'mason-org/mason-lspconfig.nvim'},
  },
  init = function()
    -- Reserve a space in the gutter
    -- This will avoid an annoying layout shift in the screen
    vim.opt.signcolumn = 'yes'
  end,
  config = function()
    local lspconfig = require('lspconfig')
    local lsp_defaults = lspconfig.util.default_config
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    lsp_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lsp_defaults.capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    -- LspAttach is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end,
    })

    require('mason-lspconfig').setup({
      ensure_installed = {
        "yamlls",
        "pyright",
        "ts_ls",
        "html",
        "lua_ls",
        "gopls",
      },
      handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
          lspconfig[server_name].setup({})
        end,
        ["gopls"] = function ()
          lspconfig.gopls.setup({
            cmd = {"gopls"},
            filetypes = {"go", "gomod", "gowork", "gotmpl" },
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
          })
        end,
        ["html"] = function()
          lspconfig.html.setup({
            capabilities = capabilities,
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = {'vim'},
                },
              },
            }
          })
        end,
      }
    })
  end
}
