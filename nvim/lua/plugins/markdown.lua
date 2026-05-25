return {
  { import = "lazyvim.plugins.extras.lang.markdown" },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      preset = "obsidian",
      render_modes = { "n", "c", "t" },
    },
    keys = {
      {
        "<leader>mp",
        function()
          require("render-markdown").toggle()
        end,
        ft = "markdown",
        desc = "Toggle Markdown Render",
      },
    },
  },
}
