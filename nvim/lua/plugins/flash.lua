return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "gj",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "gs",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    -- {
    --   "<leader>r",
    --   mode = "o",
    --   function()
    --     require("flash").remote()
    --   end,
    --   desc = "Remote Flash",
    -- },
    -- {
    --   "<leader>R",
    --   mode = { "o", "x" },
    --   function()
    --     require("flash").treesitter_search()
    --   end,
    --   desc = "Treesitter Search",
    -- },
    --{
    --  "<leader>s",
    --  mode = { "c" },
    --  function()
    --    require("flash").toggle()
    --  end,
    --  desc = "Toggle Flash Search",
    --},
  },
}
