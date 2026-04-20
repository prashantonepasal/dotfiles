return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- Treesitter integration
      disable_filetype = { "TelescopePrompt" },
      fast_wrap = {
        map = "<M-e>", -- Alt+e to jump to next pair
        offset = -1, -- Adjust cursor position
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- Fix conflict with completion (optional)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
