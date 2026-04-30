return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()
    local set = vim.keymap.set
    -- Select word under cursor, then select next/prev occurrence
    set({ "n", "x" }, "<A-n>", function() mc.matchAddCursor(1) end)
    set({ "n", "x" }, "<A-p>", function() mc.matchAddCursor(-1) end)
    -- Select ALL occurrences
    set({ "n", "x" }, "<A-a>", mc.matchAllAddCursors)
    -- Escape clears cursors
    set("n", "<Esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      end
    end)
  end,
}
