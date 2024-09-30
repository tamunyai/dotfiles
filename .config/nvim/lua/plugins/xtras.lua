-- RenderMarkdown -------------------------------------------------------------
local RenderMarkdown = {
  "MeanderingProgrammer/render-markdown.nvim",
}

RenderMarkdown.dependencies = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed or {}, {
        "markdown",
        "markdown_inline",
      })
    end,
  },
  "nvim-tree/nvim-web-devicons",
}

RenderMarkdown.config = function(_, opts)
  require("render-markdown").setup(opts)
end

-- MiniAnimate  ---------------------------------------------------------------
local MiniAnimate = {
  "echasnovski/mini.animate",
  event = "VeryLazy",
}

MiniAnimate.opts = function()
  -- don't use animate when scrolling with the mouse
  local mouse_scrolled = false
  for _, scroll in ipairs({ "Up", "Down" }) do
    local key = "<ScrollWheel" .. scroll .. ">"
    vim.keymap.set({ "", "i" }, key, function()
      mouse_scrolled = true
      return key
    end, { expr = true })
  end

  local animate = require("mini.animate")
  return {
    resize = {
      timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
    },
    scroll = {
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
      subscroll = animate.gen_subscroll.equal({
        predicate = function(total_scroll)
          if mouse_scrolled then
            mouse_scrolled = false
            return false
          end
          return total_scroll > 1
        end,
      }),
    },
  }
end

return { RenderMarkdown, MiniAnimate }
