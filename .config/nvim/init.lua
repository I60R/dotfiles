local execute = vim.cmd
local fn = vim.fn

local packer_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(packer_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..packer_path)
  execute 'packadd packer.nvim'
end


execute('source ~/.config/nvim/_init.vim')


