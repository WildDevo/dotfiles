return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "#80a7ea",
      green = "#a6e3a1",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      orange = "#fab387",
      red = "#FF4A4A",
      black = "#1e1e2e",
      white = "#414559",
      bg = "#303446",
      subtext1 = "#b5bfe2",
	    subtext0 = "#a5adce",
	    overlay2 = "#949cbb",
	    overlay1 = "#838ba7",
	    overlay0 = "#737994",
	    surface2 = "#626880",
	    surface1 = "#51576d",
	    surface0 = "#414559",
	    base = "#303446",
    }

    local my_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.black, gui = "bold" },
        b = { bg = colors.bg, fg = colors.blue },
        c = { bg = colors.bg, fg = colors.black },
        x = { bg = colors.bg, fg = colors.bg},
        z = { bg = colors.bg, fg = colors.black}
      },
      insert = {
        a = { bg = colors.orange, fg = colors.black, gui = "bold" },
      },
      visual = {
        a = { bg = colors.green, fg = colors.black, gui = "bold" },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
      },
      replace = {
        a = { bg = colors.red, fg = colors.black, gui = "bold" },
      },
    }

    local vim_icons = {
      function()
        return " "
      end,
      separator = {left = "", right = ""},
      color = {bg = colors.white, fg = colors.blue},
    }

    local space = {
      function()
        return " "
      end,
      color = { bg = colors.bg, fg = colors.bg},
    }

    local filename = {
      "filename",
      color = { bg = colors.blue, fg = colors.black},
      separator = {left = "", right = ""},
    }

    local filetype = {
      "filetype",
      icon_only = true,
      colored = true,
      color = { bg = colors.white},
      separator = {left = "", right = ""},
    }

    local fileformat = {
      "fileformat",
      color = { bg = colors.blue, fg = colors.white},
      separator = {left = "", right = ""},
    }

    local encoding = {
      "encoding",
      color = { bg = colors.white, fg = colors.blue},
      separator = {left = "", right = ""},
    }

    local branch = {
      "branch",
      color = { bg = colors.green, fg = colors.white},
      separator = {left = "", right = ""},
    }

    local diff = {
      "diff",
      color = { bg = colors.white, fg = colors.white},
      separator = {left = "", right = ""},
    }

    local modes = {
      "mode",
      fmt = function(str)
              return str:sub(1, 1)
      end,
      -- color = { bg = colors.orange, fg = colors.black},
      separator = {left = "", right = ""},
    }

    local function getLspName()
      local msg = "No Active LSP"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return " " .. client.name
        end
      end
    end

    local dia = {
      "diagnostics",
      color = { bg = colors.white, fg = colors.blue},
      separator = {left = "", right = ""},
    }

    local lsp = {
      function()
        return getLspName()
      end,
      color = { bg = colors.red, fg = colors.black},
      separator = {left = "", right = ""},
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = my_theme,

      },
      sections = {
        lualine_a = {
          modes,
          vim_icons,
        },
        lualine_b = {
          space,
        },
        lualine_c = {
          filename,
          filetype,
          space,
          branch,
          diff,
          space,
        },
        lualine_x = {
          space,
        },
        lualine_y = {
          encoding,
          fileformat,
          space,
        },
        lualine_z = {
          dia,
          lsp,
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {},
      inactive_winbar = {},
    })
  end,
}
