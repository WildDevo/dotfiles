return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs", -- set to "tabs" to use tab-like behavior
      separator_style = "slant", -- style of the separator between buffers
      diagnostics = "nvim_lsp", -- enable LSP diagnostics
      offsets = {
        {
          filetype = "snacks_layout_box",
          text = "File Explorer",
          text_align = "left",
        },
      },
    },
  },
}
