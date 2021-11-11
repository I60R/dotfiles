---
--- Enables nice DSL around which-key plugin to map keys in neovim
---
return setmetatable({}, {
  __newindex = function(self, key, arguments)
    local tuple = { [key] = arguments }
    rawset(self, #self + 1, tuple)
  end,
  __index = {
    register = function(self, extra_arguments)
      -- try append extra arguments to mapping
      if extra_arguments and next(extra_arguments) ~= nil then
        self:separate(extra_arguments)
      end
      -- start registering keys
      local which_key = require('which-key')
      for id, mapping in ipairs(self) do
        if mapping ~= "SEPARATOR" then
          local key, arguments = next(mapping)
          -- replace remap with noremap because
          -- whichkey doesn't understand it
          if arguments.remap ~= nil then
            arguments.noremap = not arguments.remap
            arguments.remap = nil
          end
          -- replace `modes` with `mode` because
          -- whichkey doesn't understand it
          arguments.mode = arguments.modes
          arguments.modes = nil
          -- try mapping for multiple modes
          if arguments.mode and #arguments.mode > 1 then
            for mode_letter in arguments.mode:gmatch"." do
              local copied_arguments = {}
              for k, v in pairs(arguments) do
                copied_arguments[k] = v
              end
              copied_arguments.mode = mode_letter
              local new_mapping = { [key] = copied_arguments }
              which_key.register(new_mapping)
            end
          else
            which_key.register(mapping)
          end
        end
        self[id] = nil
      end
    end,
    separate = function(self, extra_arguments)
      -- iterate from the end
      for rev_id=#self, 1, -1 do
        local mapping = self[rev_id]
        -- stop if another group was ended here
        if mapping == "SEPARATOR" then
          table.remove(self, rev_id)
          break
        else
          -- modify keymapping arguments
          local _, arguments = next(mapping)
          for k, v in pairs(extra_arguments) do
            -- append extra modes instead of overriding
            if k == "modes" and arguments.modes then
              arguments.modes = arguments.modes .. v
            else
              arguments[k] = v
            end
          end
        end
      end
      -- set delimiter so anoter call to set{}
      -- wouldn't override these options
      rawset(self, #self + 1, "SEPARATOR")
    end,
  }
})
