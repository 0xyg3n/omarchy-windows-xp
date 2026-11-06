-- Classic XP: square corners, no glass.
hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(245edcee)", "rgba(0054e3ee)" }, angle = 90 },
      inactive_border = "rgba(7a96dfaa)",
    },
  },
  decoration = {
    rounding = 0,
    dim_inactive = false,
    shadow = { enabled = false },
    blur = { enabled = false },
  },
})
