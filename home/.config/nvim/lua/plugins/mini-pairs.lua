return {
  -- LazyVim's default plugin name for this changed from "echasnovski/mini.pairs"
  -- to "nvim-mini/mini.pairs" after the org transfer. Match whichever string
  -- your installed LazyVim version uses so this spec merges with it instead
  -- of installing a second copy (check `:Lazy` if unsure).
  "nvim-mini/mini.pairs",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    -- (only actually applied to quote characters below, not brackets)
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  },
  config = function(_, opts)
    -- Re-implements LazyVim's default mini.pairs wrapper, but changes one
    -- thing: the `skip_ts` (treesitter "don't autopair inside a string")
    -- rule is only applied when the character being typed is a quote
    -- ('"' / "'" / "`"). Brackets still auto-pair even inside a string,
    -- e.g. typing `(` inside an f-string or a docstring in Python.
    local pairs = require("mini.pairs")
    pairs.setup(opts)
    local open = pairs.open
    pairs.open = function(pair, neigh_pattern)
      if vim.fn.getcmdline() ~= "" then
        return open(pair, neigh_pattern)
      end
      local o, c = pair:sub(1, 1), pair:sub(2, 2)
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local next = line:sub(cursor[2] + 1, cursor[2] + 1)
      local before = line:sub(1, cursor[2])

      if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
        return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
      end

      if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
        return o
      end

      -- CHANGED FROM DEFAULT: only quote characters honor skip_ts.
      -- Brackets ((, [, {) fall through and pair normally even inside a
      -- string treesitter node.
      local is_quote_char = o == '"' or o == "'" or o == "`"
      if is_quote_char and opts.skip_ts and #opts.skip_ts > 0 then
        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains(opts.skip_ts, capture.capture) then
            return o
          end
        end
      end

      if opts.skip_unbalanced and next == c and c ~= o then
        local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
        local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
        if count_close > count_open then
          return o
        end
      end

      return open(pair, neigh_pattern)
    end
  end,
}
