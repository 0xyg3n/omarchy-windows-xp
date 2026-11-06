return {
  {
    "omacom/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "#ECE9D8",
        dark_bg = "#D4D0C8",
        darker_bg = "#C0C0C0",
        lighter_bg = "#F5F4ED",

        fg = "#000000",
        dark_fg = "#808080",
        light_fg = "#1a1a1a",
        bright_fg = "#000000",
        muted = "#A0A0A0",

        red = "#C42B1C",
        yellow = "#D4A017",
        orange = "#E68A00",
        green = "#3C8D2F",
        cyan = "#2B8CBE",
        blue = "#0A246A",
        magenta = "#6D2E9C",
        brown = "#8B5A2B",

        bright_red = "#E81123",
        bright_yellow = "#F5C518",
        bright_green = "#5CBB3A",
        bright_cyan = "#5AB1E8",
        bright_blue = "#3A6EA5",
        bright_magenta = "#9B59B6",

        accent = "#245EDC",
        cursor = "#000000",
        foreground = "#000000",
        background = "#ECE9D8",
        selection = "#316AC5",
        selection_foreground = "#000000",
        selection_background = "#316AC5",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
