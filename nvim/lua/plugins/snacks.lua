return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        {
          icon = "󰒲 ",
          key = "U",
          desc = "Lazy update",
          action = ":Lazy update",
          enabled = package.loaded.lazy ~= nil,
        },
        { icon = " ", key = "q", desc = "Quit", action = ":qa", padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true,             -- show open fold icons
        git_hl = false,          -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    -- Pickers : find (file)
    { "<leader><space>", function() Snacks.picker.smart() end,                                            desc = "Smart Find Files" },
    { "<leader>fb",      function() Snacks.picker.buffers() end,                                          desc = "Buffers" },
    { "<leader>fd",      function() Snacks.picker.files({ cwd = vim.fn.expand("~") .. "/dotfiles" }) end, desc = "Find Config File" },
    { "<leader>ff",      function() Snacks.picker.files() end,                                            desc = "Find Files" },
    { "<leader>fp",      function() Snacks.picker.projects() end,                                         desc = "Projects" },
    { "<leader>fr",      function() Snacks.picker.recent() end,                                           desc = "Recent" },
    -- Pickers : grep
    { "<leader>fg",      function() Snacks.picker.grep() end,                                             desc = "Grep" },
    -- Pickers : LSP
    { "gd",              function() Snacks.picker.lsp_definitions() end,                                  desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,                                 desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,                                   nowait = true,                         desc = "References" },
    { "gI",              function() Snacks.picker.lsp_implementations() end,                              desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end,                             desc = "Goto T[y]pe Definition" },
    { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                                      desc = "LSP Symbols" },
    { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                            desc = "LSP Workspace Symbols" },
    -- Pickers : Other
    { "<leader>e",       function() Snacks.explorer() end,                                                desc = "File Explorer" },
    { "<leader>sh",      function() Snacks.picker.help() end,                                             desc = "Help Pages" },
    { '<leader>s"',      function() Snacks.picker.registers() end,                                        desc = "Registers" },
    { '<leader>s/',      function() Snacks.picker.search_history() end,                                   desc = "Search History" },
    { "<leader>s:",      function() Snacks.picker.command_history() end,                                  desc = "Command History" },
    { "<leader>sC",      function() Snacks.picker.commands() end,                                         desc = "Commands" },
    { "<leader>sj",      function() Snacks.picker.jumps() end,                                            desc = "Jumps" },
    { "<leader>sR",      function() Snacks.picker.resume() end,                                           desc = "Resume last picker" },
    { "<leader>fR",      function() Snacks.picker.resume() end,                                           desc = "Resume last picker" },
    { "<leader>r",       function() Snacks.picker.resume() end,                                           desc = "Resume last picker" },
    -- Buffers
    { "<leader>bb",      function() Snacks.picker.buffers() end,                                          desc = "Search buffers", },
    { "<leader>bd",      function() Snacks.bufdelete() end,                                               desc = "Delete buffer", },
    -- Scratch buffer
    { "<leader>.",       function() Snacks.scratch() end,                                                 desc = "Toggle Scratch Buffer", },
    { "<leader>S",       function() Snacks.scratch.select() end,                                          desc = "Select Scratch Buffer", },
    -- { "<leader>cR", function() Snacks.rename.rename_file() end,      desc = "Rename File", },
    -- git
    { "<leader>gB",      function() Snacks.gitbrowse() end,                                               desc = "Git Browse", },
    { "<leader>gb",      function() Snacks.git.blame_line() end,                                          desc = "Git Blame Line", },
    { "<leader>gf",      function() Snacks.lazygit.log_file() end,                                        desc = "Lazygit Current File History", },
    { "<leader>gg",      function() Snacks.lazygit() end,                                                 desc = "Lazygit", },
    { "<leader>gl",      function() Snacks.lazygit.log() end,                                             desc = "Lazygit Log (cwd)", },
    -- terminal
    { "<c-/>",           function() Snacks.terminal() end,                                                mode = { "n", "t" },                   desc = "Toggle Terminal", },
    { "<c-_>",           function() Snacks.terminal() end,                                                desc = "which_key_ignore", },
    -- various
    { "]]",              function() Snacks.words.jump(vim.v.count1) end,                                  desc = "Next Reference",               mode = { "n", "t" }, },
    { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                                 desc = "Prev Reference",               mode = { "n", "t" }, },
    { "<leader>N",       function() Snacks.notifier.show_history() end,                                   desc = "Notification History", },
    { "<leader>un",      function() Snacks.notifier.hide() end,                                           desc = "Dismiss All Notifications", },
    -- zen mode
    { "<leader>z",       function() Snacks.zen() end,                                                     desc = "Toggle Zen Mode", },
    { "<leader>Z",       function() Snacks.zen.zoom() end,                                                desc = "Toggle Zoom", },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
