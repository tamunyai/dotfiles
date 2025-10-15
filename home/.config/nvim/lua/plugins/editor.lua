-- treesj ---------------------------------------------------------------------
local treesj = {
  "Wansmer/treesj",
}

treesj.keys = {
  { "J", "<cmd>TSJToggle<cr>", desc = "[J]oin Toggle" },
}

treesj.opts = {
  use_default_keymaps = false,
  max_join_length = 150,
}

-- gitsigns.nvim --------------------------------------------------------------
local gitsigns = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
}

gitsigns.opts = {
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },

  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 3000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
}

-- vim-illuminate -------------------------------------------------------------
local vim_illuminate = {
  "RRethy/vim-illuminate",
}

vim_illuminate.event = {
  "BufReadPost",
  "BufWritePost",
  "BufNewFile",
}

vim_illuminate.keys = {
  { "]]", desc = "Next Reference" },
  { "[[", desc = "Prev Reference" },
}

vim_illuminate.opts = {
  delay = 200,
  large_file_cutoff = 2000,
  large_file_overrides = {
    providers = { "lsp" },
  },
}

vim_illuminate.config = function(_, opts)
  require("illuminate").configure(opts)

  local function map(key, dir, buffer)
    vim.keymap.set("n", key, function()
      require("illuminate")["goto_" .. dir .. "_reference"](false)
    end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
  end

  map("]]", "next")
  map("[[", "prev")

  -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      map("]]", "next", buffer)
      map("[[", "prev", buffer)
    end,
  })
end

-- todo-comments.nvim ---------------------------------------------------------
local todo_comments = {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
}

todo_comments.keys = {
  {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    desc = "Next [T]odo Comment",
  },
  {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    desc = "Previous [T]odo Comment",
  },
}

todo_comments.config = function()
  require("todo-comments").setup()
end

-- telescope.nvim -------------------------------------------------------------
local telescope = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
}

telescope.event = { "BufEnter" }

telescope.dependencies = {
  "nvim-telescope/telescope-ui-select.nvim",
}

telescope.keys = {
  {
    "<leader><space>",
    "<cmd>Telescope find_files<cr>",
    desc = "Find Files",
  },
  {
    "<leader>fd",
    "<cmd>Telescope diagnostics<cr>",
    desc = "[F]ile [D]iagnostics",
  },
  {
    "<leader>fg",
    "<cmd>Telescope live_grep<cr>",
    desc = "[F]ind Live [G]rep",
  },
  {
    "<leader>fb",
    "<cmd>Telescope buffers  sort_mru=true sort_lastused=true<cr>",
    desc = "[F]ind [B]uffers",
  },

  {
    "<leader>ft",
    "<cmd>Telescope todo-comments<cr>",
    desc = "[F]ind [T]odo",
  },
}

telescope.opts = function()
  return {
    defaults = {
      prompt_prefix = "   ",
      entry_prefix = " ",
      file_ignore_patterns = {
        "node_modules",   -- Node.js projects
        ".git",           -- Git repository metadata
        "build",          -- Build directories (common in many projects)
        "%.lock",         -- Lock files (npm/yarn, etc.)
        "%.log",          -- Log files
        "%.min.js",       -- Minified JavaScript files
        "dist/",          -- Distribution folder (JS, TS, Rust, etc.)
        "target/",        -- Rust build artifacts
        "venv/",          -- Python virtual environments
        "__pycache__/",   -- Python bytecode cache
        "%.class",        -- Java compiled class files
        "%.jar",          -- Java archive files
        "%.war",          -- Java Web Application Archive files
        "bin/",           -- Binary output directory (C/C++ projects)
        "obj/",           -- Object files (C/C++ projects)
        "%.o",            -- Object files by extension
        "%.dll",          -- Windows dynamic link library
        "%.exe",          -- Windows executable files
        "%.so",           -- Linux shared object files
        "%.dylib",        -- macOS dynamic libraries
        "%.out",          -- Executable output files (compiled binaries)
        "%.zip",          -- Zip archive files
        "%.tar",          -- Tarballs (compressed archive files)
        "%.gz",           -- Gzipped files
        "%.rar",          -- RAR compressed archive files
        "%.7z",           -- 7zip compressed files
        "%.png",          -- PNG image files
        "%.jpg",          -- JPEG image files
        "%.jpeg",         -- JPEG image files
        "%.svg",          -- SVG vector images
        "%.gif",          -- GIF image files
        "%.mp4",          -- MP4 video files
        "%.mp3",          -- MP3 audio files
        "%.mkv",          -- MKV video files
        "%.avi",          -- AVI video files
        "coverage/",      -- Code coverage report directories
        "%-lock.json",    -- Lock JSON files (yarn-lock, etc.)
        "%.lock.json",    -- Lock JSON files (yarn.lock, etc.)
        ".DS_Store",      -- macOS system file
        "yarn-error.log", -- Yarn error logs
        "%.pem",          -- SSL certificate files
        "%.crt",          -- Certificate files
        "%.key",          -- Key files for certificates
      },
      vimgrep_arguments = {
        "rg",
        "-L",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
    },

    extensions_list = { "ui-select" },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  }
end

telescope.config = function(_, opts)
  local _telescope = require("telescope")
  _telescope.setup(opts)

  for _, ext in ipairs(opts.extensions_list) do
    _telescope.load_extension(ext)
  end
end

return {
  treesj,
  gitsigns,
  vim_illuminate,
  todo_comments,
  telescope,
  { "nvim-lua/plenary.nvim" }, -- Dependency for TodoComments and Telescope
}
