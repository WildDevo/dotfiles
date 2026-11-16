return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- The single list of language servers. Each is installed if missing and,
      -- via automatic_enable (on by default), enabled with vim.lsp.enable().
      -- Per-server settings go in lspconfig.lua as vim.lsp.config() calls.
      -- Anything else installed through :Mason is enabled too.
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "elixirls",
        "erlangls",
        "gopls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
      },
    })
  end,
}
