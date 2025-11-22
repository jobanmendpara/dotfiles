local cal = sbar.add("item", {
  icon = {
    font = {
      style = "Bold",
      size = 18.0,
    },
    padding_right = 10,
  },
  label = {
    align = "right",
    font = {
      style = "Bold",
      size = 18.0,
    },
  },
  position = "right",
  update_freq = 10,
})

local function update()
  local date = os.date("%a - %b %d -")
  local time = os.date("%H:%M")
  cal:set({ icon = date, label = time })
end

cal:subscribe("routine", update)
cal:subscribe("forced", update)

