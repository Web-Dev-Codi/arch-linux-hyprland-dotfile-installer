local header_file = vim.fn.expand("~/.config/omarchy/branding/about.txt")

-- Single-key prefixes that uniquely match one starter item (LazyVim-style names).
-- Key = keypress, value = query string. Typing the key runs that item immediately.
local item_keymaps = {
  f = "fi",       -- Find file
  r = "rec",      -- Recent files
  t = "ft",       -- Find text
  p = "p",        -- Projects
  n = "n",        -- New file
  q = "q",        -- Quit
  c = "c",        -- Config
  l = "lazy",     -- Lazy
  e = "le",       -- Lazy Extras
  s = "res",      -- Restore session
}

return {
  "nvim-mini/mini.starter",
  version = "*",
  opt = {},
  opts = {
    evaluate_single = true,
    header = function()
      local path = vim.fn.expand(header_file)
      local ok, lines = pcall(vim.fn.readfile, path)
      if not ok or not lines or #lines == 0 then
        return nil
      end
      return table.concat(lines, "\n")
    end,
  },
  config = function()
    local starter = require("mini.starter")
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniStarterOpened",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        for key, query in pairs(item_keymaps) do
          vim.keymap.set("n", key, function()
            starter.set_query(query)
            vim.schedule(function()
              pcall(starter.eval_current_item, buf)
            end)
          end, { buffer = buf, desc = "mini.starter: run item" })
        end
      end,
    })
  end,
}
