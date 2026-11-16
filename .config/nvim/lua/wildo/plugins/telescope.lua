return {
  "nvim-telescope/telescope.nvim",
  version = "*", -- latest tagged release; the 0.1.x branch is unmaintained
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        file_ignore_patterns = { "%.git/"},
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        color_devicons = true,
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local builtin = require("telescope.builtin")

    keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find files (incl. hidden)" })
    keymap.set("n", "<leader>fa", function()
      builtin.find_files({ hidden = true, no_ignore = true })
    end, { desc = "Find files (incl. hidden + gitignored)" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
    keymap.set("n", "<leader>fs", function()
      builtin.live_grep({ additional_args = { "--hidden" } })
    end, { desc = "Live grep (incl. hidden)" })
    keymap.set("n", "<leader>fS", function()
      builtin.live_grep({ additional_args = { "--hidden", "--no-ignore" } })
    end, { desc = "Live grep (incl. hidden + gitignored)" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word under cursor" })
  end,
}
