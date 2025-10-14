return {
  {
    "nvim-mini/mini.visits",
    version = "*",
    event = "VeryLazy",
    opts = {
      store = {
        autowrite = true, -- <--- Tells the plugin to SAVE on exit
        path = vim.fn.stdpath("data") .. "/mini.visits/visits.json",
      },
    },

    config = function(_, opts)
      local visits = require("mini.visits")
      local MiniVisits = require("mini.visits") -- Define MiniVisits locally for the keymap functions
      visits.setup(opts)

      ---------------------------------------------------------------------------
      -- 1. Keymaps for Path Selection (Recency/Frequency)
      ---------------------------------------------------------------------------

      -- Helper function to generate the selection function based on parameters
      local make_select_path = function(select_global, recency_weight)
        local sort = visits.gen_sort.default({ recency_weight = recency_weight })
        local select_opts = { sort = sort }

        return function()
          -- Use ternary operator for conditional CWD
          local cwd = select_global and "" or vim.fn.getcwd()
          visits.select_path(cwd, select_opts)
        end
      end

      -- Helper function to set keymaps for readability
      local map_select = function(lhs, desc, select_global, recency_weight)
        vim.keymap.set("n", lhs, make_select_path(select_global, recency_weight), { desc = desc })
      end

      -- Define Select Keymaps:
      map_select("<Leader>vr", "Select recent (all)", true, 1)
      map_select("<Leader>vR", "Select recent (cwd)", false, 1)
      map_select("<Leader>vy", "Select frecent (all)", true, 0.5)
      map_select("<Leader>vY", "Select frecent (cwd)", false, 0.5)
      map_select("<Leader>vf", "Select frequent (all)", true, 0)
      map_select("<Leader>vF", "Select frequent (cwd)", false, 0)

      ---------------------------------------------------------------------------
      -- 2. Keymaps for Label Management (Your New Code)
      ---------------------------------------------------------------------------
      -- Helper function to create mappings for label commands
      local map_vis = function(keys, method, desc, label_args)
        -- The function to be executed by the keymap
        local rhs = function()
          -- Safely require the module every time the key is pressed
          local MiniVisits = require("mini.visits")

          -- Check if arguments need to be passed
          if label_args then
            MiniVisits[method](unpack(label_args))
          else
            MiniVisits[method]()
          end
        end

        -- Set the keymap
        vim.keymap.set("n", "<Leader>" .. keys, rhs, { desc = desc })
      end

      -- Define Label Keymaps (using the method name and arguments):
      map_vis("va", "add_label", "Add label") -- Method is 'add_label', no args
      map_vis("vA", "remove_label", "Remove label") -- Method is 'remove_label', no args
      map_vis("vl", "select_label", "Select label (all)", { "", "" }) -- Method is 'select_label', args are { "", "" }
      map_vis("vL", "select_label", "Select label (cwd)") -- Method is 'select_label', no args
    end,
  },
}
