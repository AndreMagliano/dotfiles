-- Copilot plugins are defined below:
vim.opt.relativenumber = true
lvim.colorscheme = "rose-pine-main"
lvim.plugins = {
  {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
          require("copilot").setup({})
      end,
  },
  {
      "zbirenbaum/copilot-cmp",
      config = function()
          require("copilot_cmp").setup({
              suggestion = { enabled = false },
              panel = { enabled = false }
          })
      end
  },
  -- {
  --   "ggandor/leap.nvim",
  --   name = "leap",
  --   config = function()
  --     require("leap").add_default_mappings()
  --   end,
  -- },
  {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {
        {
          mode = {
          search = {
            enabled = true,
            mode = "search",
            highlight = { backdrop = false },
            label = { after = { pattern = ".", max_length = 0 } },
          },
          },
        },
      },
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  { "rose-pine/neovim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-pack/nvim-spectre" },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "bedrock",
      providers = {
        -- deepseek = {
        --   __inherited_from = "openai",
        --   endpoint = "https://api.deepseek.com",
        --   model = "deepseek-coder",
        -- },
        bedrock = {
          model = "us.anthropic.claude-sonnet-4-20250514-v1:0"
        }
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    }
  }
}

-- Below config is required to prevent copilot overriding Tab with a suggestion
-- when you're just trying to indent!
local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
local on_tab = vim.schedule_wrap(function(fallback)
    local cmp = require("cmp")
    if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    else
        fallback()
    end
end)

vim.keymap.set('n', '<leader>t', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})

lvim.builtin.cmp.mapping["<Tab>"] = on_tab
