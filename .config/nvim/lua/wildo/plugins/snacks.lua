return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                header = table.concat({
                    "                                                       ",
                    "  ██╗    ██╗██╗██╗     ██████╗  ██████╗  ",
                    "  ██║    ██║██║██║     ██╔══██╗██╔═══██╗ ",
                    "  ██║ █╗ ██║██║██║     ██║  ██║██║   ██║ ",
                    "  ██║███╗██║██║██║     ██║  ██║██║   ██║ ",
                    "  ╚███╔███╔╝██║███████╗██████╔╝╚██████╔╝ ",
                    "   ╚══╝╚══╝ ╚═╝╚══════╝╚═════╝  ╚═════╝  ",
                    "                                                       ",
                }, "\n"),
                keys = {
                    { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "E", desc = "File Explorer", action = ":lua Snacks.explorer()" },
                    { icon = "󰱼 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
                    { icon = " ", key = "g", desc = "Find Word", action = ":Telescope live_grep" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = {
            sources = {
                explorer = {
                    layout = { preset = "sidebar", preview = false },
                    hidden = true,
                    ignored = false,
                    exclude = { ".DS_Store" },
                },
            },
        },
        notifier = {
            enabled = true,
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
            },
        },
    },
    keys = {
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>ee", function() Snacks.explorer() end, desc = "Toggle file explorer" },
        { "<leader>ef", function() Snacks.explorer.reveal() end, desc = "Reveal current file in explorer" },
    },
}
