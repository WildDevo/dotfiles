return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true,
                     timeout = 3000,
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
            -- wo = { wrap = true } -- Wrap notifications
            }
        }
    },
    keys = {
        -- Top Pickers & Explorer
        --{ "<leader>tf", ":lua Snacks.picker.smart()<CR>", desc = "Smart Find Files" },
        --{ "<leader>tb", ":lua Snacks.picker.buffers()<CR>", desc = "Buffers" },
        --{ "<leader>te", ":lua  Snacks.picker.grep()<CR>", desc = "Grep" },
        --{ "<leader>th", ":lua  Snacks.picker.command_history()<CR>", desc = "Command History" },
        { "<leader>fn", ":lua  Snacks.picker.notifications()<CR>", desc = "Notification History" },
        --{ "<leader>tk", ":lua  Snacks.explorer()<CR>", desc = "File Explorer" },
    },
}
