local alpha = require("alpha")
local theta = require("alpha.themes.theta")
-- just needed to import the button function
local dashboard = require("alpha.themes.dashboard")

-- this works with the "dashboard" theme
-- theme.section.header.val = {
--   [[ ]],
--   [[                                                                      ]],
--   [[       ████ ██████           █████      ██                      ]],
--   [[      ███████████             █████                              ]],
--   [[      █████████ ███████████████████ ███   ███████████    ]],
--   [[     █████████  ███    █████████████ █████ ██████████████    ]],
--   [[    █████████ ██████████ █████████ █████ █████ ████ █████    ]],
--   [[  ███████████ ███    ███ █████████ █████ █████ ████ █████   ]],
--   [[ ██████  █████████████████████ ████ █████ █████ ████ ██████  ]],
--   [[ ]],
--   [[ ]],
-- }

local buttons = theta.buttons.val
-- #buttons is Lua for length of buttons table...
table.insert(
  buttons,
  #buttons,
  dashboard.button("S", "♻  Select session", function()
    require("persistence").select()
  end)
)
table.insert(
  buttons,
  #buttons,
  dashboard.button("s", "♻  Restore session", function()
    require("persistence").load()
  end)
)

alpha.setup(theta.config)
