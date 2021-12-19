-- Helper to map ctrl, atl, shift and permutations
local function map_with_mod(modifiers, extensions)
  return setmetatable({}, {
    __newindex = function(self, key, mapping_arguments)
      if mapping_arguments.mod ~= nil then
        for i, v in ipairs(modifiers) do
          mapping_arguments.mod[#mapping_arguments.mod + i] = v
        end
      else
        mapping_arguments.mod = modifiers
      end
      _G.map[key] = mapping_arguments
    end,
    __index = extensions,
  })
end

--- Provides a nice DSL over which-key.nvim plugin, for example:
---
--- ```lua
--- map [','] = { '<Leader>', "Comma is leader!", remap = false }
--- map:register { modes = 'nvo' }
--- ```
---
_G.map = setmetatable({}, {

  -- Next enables `map ['key'] = { .. }` syntax that could be
  -- called multiple times with the same key e.g. to add keymap
  -- in different modes. The same wasn't possible to achieve by
  -- regular lua tables because they can't store duplicate keys.
  -- Mappings aren't registered yet but only temporarily stored
  -- in the table until `map:register {}` is called
  __newindex = function(self, key, mapping_arguments)
    local key_arguments_tuple = { [tostring(key)] = mapping_arguments }
    local unique_id = #self + 1
    rawset(self, unique_id, key_arguments_tuple)
  end,

  -- Next enables `split` and `register` methods on keymaps
  -- table that allows to batch-operate on its contents.
  -- Also provides Ctrl, Alt, Shift modifier keymaps that could
  -- be used instead of <C-..>, <M-..>, <S-..>
  __index = {
    -- Enables `map.ctrl` modifier which could be extended
    -- as `map.ctrl.alt`, `map.ctrl.shift` and `map.ctrl.alt.shift`
    ctrl = map_with_mod({ "ctrl" }, {
      -- `map.ctrl.alt` extension
      alt = map_with_mod({ "ctrl", "alt" }, {
        -- `map.ctrl.alt.shift` extension
        shift = map_with_mod { "ctrl", "alt", "shift" },
      }),
      -- `map.ctrl.shift` extension
      shift = map_with_mod { "ctrl", "shift" },
    }),

    -- Enables `map.alt` modifier which could be extended
    -- as `map.alt.shift` only
    alt = map_with_mod({ "alt" }, {
      -- `map.alt.shift` extension
      shift = map_with_mod { "alt", "shift" },
    }),

    -- Enables `map.shift` modifier which cannot be extended,
    -- use `map.ctrl` and `map.alt` instead
    shift = map_with_mod { "shift" },

    -- This method thematically groups keymappings that currently
    -- are in the table but not belongs to another group yet, and
    -- allows to batch-modify them. This could be used to avoid
    -- repeating the same arguments before each mapping e.g. `mode`.
    split = function(self, override_arguments)
      -- retain the function that would be called with each
      -- keymap and allows to modify them in this way
      local for_each_hook = override_arguments.each;
      override_arguments.each = nil
      -- iterate from the end
      for rev_id = #self, 1, -1 do
        local prev_key_arguments_tuple = self[rev_id]
        -- stop if another group was ended here
        if prev_key_arguments_tuple == "GROUP-END" then
          break
        end
        -- modify keymapping arguments
        local _key, mapping_arguments = next(prev_key_arguments_tuple)
        for arg, value in pairs(override_arguments) do repeat
          -- append extra modes instead of overriding them
          if arg == "modes" and mapping_arguments.modes then
            mapping_arguments.modes = mapping_arguments.modes .. value
            break
          end
          -- override arguments otherwise
          mapping_arguments[arg] = value
        until true end
        -- call hook that allows to modify the key
        if for_each_hook ~= nil then
          for_each_hook(key, mode_mapping_arguments)
        end
      end
      -- set delimiter so anoter `map:split {}` call wouldn't
      -- iterate over these options
      rawset(self, #self + 1, "GROUP-END")
    end,

    -- This method registers all keymappings that currently are
    -- in the table including grouped ones and removes all them
    -- from the table. It also allows to batch-modify mappings
    -- that currently are in the table but not belongs to any
    -- group, thus, allows to avoid extra `map:split {}` call.
    register = function(self, extra_arguments)
      -- retain the function that would be called with each
      -- keymap and allows to modify them in this way
      local for_each_hook = extra_arguments.each;
      extra_arguments.each = nil
      -- try append extra arguments to mapping if the list of
      -- them was provided and it isn't empty
      if extra_arguments and next(extra_arguments) ~= nil then
        self:split(extra_arguments)
      end
      -- iterate from beginning
      for id, next_key_arguments_tuple in ipairs(self) do repeat
        -- instantly remove the element
        self[id] = nil
        -- skip through group delimiters
        if next_key_arguments_tuple == "GROUP-END" then
          break
        end
        -- proceed to registering the mapping
        local key, mapping_arguments = next(next_key_arguments_tuple)
        -- replace `remap` with `noremap` because
        -- which-key doesn't understand it
        if mapping_arguments.remap ~= nil then
          mapping_arguments.noremap = not mapping_arguments.remap
          mapping_arguments.remap = nil
        end
        -- replace `modes` with `mode` because
        -- which-key doesn't understand it
        mapping_arguments.mode = mapping_arguments.modes
        mapping_arguments.modes = nil
        -- process modifier keys if they're present
        -- and remove `mod` because
        -- which-key doesn't understand it
        if mapping_arguments.mod ~= nil then
          local modifiers = {}
          for _, modifier in pairs(mapping_arguments.mod) do
            modifiers[modifier] = true
          end
          if modifiers.ctrl and modifiers.alt and modifiers.shift then
            key = '<C-M-S-' .. key .. '>'
          elseif modifiers.ctrl and modifiers.alt then
            key = '<C-M-' .. key .. '>'
          elseif modifiers.ctrl and modifiers.shift then
            key = '<C-S-' .. key .. '>'
          elseif modifiers.alt and modifiers.shift then
            key = '<M-S-' .. key .. '>'
          elseif modifiers.ctrl then
            key = '<C-' .. key .. '>'
          elseif modifiers.alt then
            key = '<M-' .. key .. '>'
          elseif modifiers.shift then
            key = '<S-' .. key .. '>'
          end
          mapping_arguments.mod = nil
        end
        -- common functionality
        local function register_key(mapping_arguments)
          -- replace termcoes so < will work as expecteD
          key = vim.api.nvim_replace_termcodes(key, true, false, true)
          -- call hook that allows to modify the key
          if for_each_hook ~= nil then
            for_each_hook(key, mapping_arguments)
          end
          -- map key in the current mode
          require('which-key').register{ [key] = mapping_arguments }
        end
        -- map key in multiple modes if more than one are specified
        if mapping_arguments.mode and #mapping_arguments.mode > 1 then
          for mode_letter in mapping_arguments.mode:gmatch '.' do
            -- create a new keymapping for each mode because
            -- which-key doesn't register them instantly and
            -- doesn't create copies, so updating the same keymap
            -- would update all registered in previous iterations
            local mode_mapping_arguments = {}
            local mode_key_arguments_tuple = {
              [key] = mode_mapping_arguments
            }
            -- copy mapping arguments
            for arg, value in pairs(mapping_arguments) do
              mode_mapping_arguments[arg] = value
            end
            -- swap modes with the current mode letter
            mode_mapping_arguments.mode = mode_letter
          end
          register_key(mode_mapping_arguments)
          break
        end
        register_key(mapping_arguments)
      until true end
    end,
  }
})
