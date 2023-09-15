------------
-- fzf + lua
------------

-- https://github.com/ibhagwan/fzf-lua, replaces fzf.vim

local M = {}

local function extend(lhs)
  return function(rhs) return vim.tbl_deep_extend("force", lhs, rhs) end
end

function M.setup()
  local defaults = require('fzf-lua.defaults').defaults

  require('fzf-lua').setup {
    keymap = {
      -- 'builtin' means keymap for the neovim's terminal buffer (tmap <buffer>)
      builtin = extend(defaults.keymap.builtin) {
        ["<Esc>"] = "abort",
        ["<C-/>"] = "toggle-preview",
        ["<C-_>"] = "toggle-preview",
      },
      -- 'fzf' means keymap that is directly fed to the fzf process (fzf --bind)
      fzf = extend(defaults.keymap.fzf) {
        ["ctrl-/"] = "toggle-preview",
      },
    },
    winopts = {
      width = 0.90,
      height = 0.80,
      preview = {
        vertical = "down:45%",
        horizontal = "right:50%",
        layout = "flex",
      },
      on_create = function()
        -- Some (global) terminal keymaps should be disabled for fzf-lua, see GH-871
        local keys_passthrough = { '<C-e>', '<C-y>' }
        local bufnr = vim.api.nvim_get_current_buf()
        for _, key in ipairs(keys_passthrough) do
          vim.keymap.set('t', key, key, { buffer = bufnr, remap = false, silent = true, nowait = true })
        end
      end,
    },

    -- Customize builtin finders
    autocmds = {
      winopts = { preview = { layout = "vertical", vertical = "down:33%" } },
    },
  }

  ---[[ Highlights ]]
  ---https://github.com/ibhagwan/fzf-lua#highlights
  require("utils.rc_utils").RegisterHighlights(function()
    vim.cmd [[
      hi!      FzfLuaNormal guibg=#151b21
      hi! link FzfLuaBorder FzfLuaNormal
    ]]
  end)

  ---[[ Commands ]]
  local command_alias = vim.fn.CommandAlias
  command_alias("FL", "FzfLua")

  local command = function(name, opts, rhs)
    vim.api.nvim_create_user_command(name, rhs, opts)
    return {
      alias = function(self, lhs, ...) command_alias(lhs, name, ...); return self; end
    }
  end
  local fzf = require("fzf-lua")
  local empty_then_nil = function(x) return x ~= "" and x or nil; end
  -- wrap a fzf-lua provider to a neovim user_command function
  -- with the (optional) argument set as the default fzf query.
  local bind_query = function(fzf_provider)
    return function(e)
      fzf_provider({ query = empty_then_nil(e.args) })
    end
  end

  -- Finder (fd, rg, grep, etc.)
  -- Note: fzf-lua grep uses rg internally
  command("Files", { nargs = "?", complete = "dir", desc = "FzfLua files" }, function(e)
    fzf.files({ cwd = empty_then_nil(e.args) })
  end)
  command("History", {}, "FzfLua oldfiles"):alias("H")
  command("Grep", { nargs = "?", bang = true, desc = "FzfLua grep" }, function(e)
    local args = e.args:gsub('\n', '')
    if not e.bang then
      fzf.grep({ search = args })
    else
      fzf.live_grep({ search = args })
    end
  end)
  command_alias("Rg", "Grep")
  command("LiveGrep", { nargs = "?", desc = "FzfLua live_grep" }, function(e)
    fzf.live_grep({ search = e.args })
  end)
  if vim.fn.executable("rg") == 0 then
    local msg = "rg (ripgrep) not found. Try `dotfiles install rg`."
    vim.notify(msg, vim.log.levels.WARN, { title = "config.fzf" })
  end
  command_alias("RG", "LiveGrep")
  -- keymaps (grep): CTRL-g, <leader>rg
  vim.keymap.set('n', '<C-g>', '<cmd>LiveGrep<CR>')
  vim.keymap.set('n', '<leader>rg', function()
    fzf.grep({ search = vim.fn.expand("<cword>") })
  end, { desc = ':Grep with <cword>' })
  vim.keymap.set('x', '<C-g>', '<leader>rg', { remap = true, silent = true,
    desc = ':Grep with visual selection' } )
  vim.keymap.set('x', '<leader>rg', [["gy:Grep <C-R>g<CR>]], { silent = true,
    desc = ':Grep with visual selection' } )


  -- Git providers
  command("Commits", {}, "FzfLua git_commits")  -- for the CWD. TODO: Support file arg
  command("BCommits", {}, "FzfLua git_bcommits")  -- for the buffer.
  command("GitStatus", { nargs = 0 }, "FzfLua git_status"
    ):alias("GStatus"):alias("GS")
  command("GitFiles", { nargs = "?", bang = true, complete = "dir", desc = "FzfLua git_files" }, function(e)
    if e.args == "?" then  -- GFiles?
      return vim.cmd [[ GitStatus ]]
    end
    local opts = { cwd = empty_then_nil(e.args) }
    if e.bang then  -- GFiles!: include untracked files as well
      opts.cmd = "git ls-files --exclude-standard --cached --modified --others --deduplicate"
    end
    -- Note: Unlike junegunn's GitFiles, it no longer accepts CLI flag. Use Lua API instead
    fzf.git_files(opts)
  end):alias("GFiles", { register_cmd = true }):alias("GF")
  command("Tags", { nargs = "?" }, bind_query(fzf.tags))

  -- neovim providers
  -- (some commands are provided by telescope because it's often better with telescope)
  --    :Commands, :Maps, :Highlights
  command("Buffers", { nargs = "?", complete = "buffer" }, bind_query(fzf.buffers)):alias("B")
  vim.keymap.set('n', '<leader>B', '<Cmd>Buffers<CR>')
  command("Colors", { nargs = "?", complete = "color" }, bind_query(fzf.colorschemes))
  command("Help", { nargs = "?", complete = "help" }, bind_query(fzf.help_tags))
  command("Lines", { nargs = "?" }, bind_query(fzf.lines))
  command("BLines", { nargs = "?" }, bind_query(fzf.blines))
  command("BTags", { nargs= "?" }, bind_query(fzf.btags))
  command("Marks", {}, "FzfLua marks")
  command("Jumps", {}, "FzfLua jumps")
  command("Filetypes", {}, "FzfLua filetypes")

  ---[[ Keymaps ]]
  -- TODO: Add insert mode keymaps <plug>(fzf-complete-*)

  ---[[ Misc. ]]
  _G.fzf = require('fzf-lua')
end

-- Resourcing support
if RC and RC.should_resource() then
  M.setup()
end

(RC or {}).fzf = M
return M
