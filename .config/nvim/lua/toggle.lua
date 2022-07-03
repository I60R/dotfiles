local M = {}

function M.scrolloff()
  if vim.wo.scrolloff == 999 then
    if vim.w.toggle_scrolloff_backup ~= nil then
      vim.wo.scrolloff = vim.w.toggle_scrolloff_backup
    else
      vim.wo.scrolloff = 0
    end
  else
    if vim.wo.scrolloff ~= 0 then
      vim.w.keepmiddle_scrolloff_backup = vim.wo.scrolloff
    end
    vim.wo.scrolloff = 999
    vim.cmd 'norm M'
  end
end

function M.cursorcolumn()
  vim.wo.cursorcolumn = not vim.wo.cursorcolumn
end

return M
