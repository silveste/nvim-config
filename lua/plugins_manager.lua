-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- automatically run :PackerCompile whenever plugins-manager.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins_manager.lua source <afile> | PackerCompile
  augroup end
]])

-- Bootstrap packer on new installations
-- Comment if you are using and external packer.nvim package i.e. arch aur package: https://aur.archlinux.org/packages/nvim-packer-git/
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- Packer can manage itself

	use({ "neovim/nvim-lspconfig" }) --LSP client config
	use({ "williamboman/nvim-lsp-installer" }) -- LSP servers config
	use({ "hrsh7th/nvim-cmp" }) -- Autocompletion plugin
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP source for nvim-cmp
	use({ "saadparwaiz1/cmp_luasnip" }) -- Snippets source for nvim-cmp
	use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } }) -- Virtual LSP that hooks diagnostic and formatting tools not included in real LSPs
	use({ "L3MON4D3/LuaSnip" }) -- Snippets plugin
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- treesitter
	use({ "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }) -- Fuzzy finder
	use({ "echasnovski/mini.nvim" }) --Set of differentplugins
	-- use("navarasu/onedark.nvim") -- Color theme
	use("EdenEast/nightfox.nvim") -- Color theme
	use("sunjon/shade.nvim") -- Dims inactive windows
	use("lewis6991/spellsitter.nvim") -- Spell checker
	use("RRethy/vim-illuminate") -- Underline symbol
	use("norcalli/nvim-colorizer.lua") -- Color highlighter
	use("steelsojka/pears.nvim") -- auto pairs
	use("karb94/neoscroll.nvim") -- Smooth scrolling
	use("numToStr/Comment.nvim") -- Comments
	use("ggandor/lightspeed.nvim") -- Motions anywhere with 4 strokes
	use({ "abecodes/tabout.nvim", requires = "nvim-treesitter/nvim-treesitter" }) -- Move out of groups with <Tab>
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use({ "hoob3rt/lualine.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use("lukas-reineke/indent-blankline.nvim") -- indent guides
	use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim" }) -- Git utils
	use("samoshkin/vim-mergetool") -- Git mergetool
	use({
		"sudormrfbin/cheatsheet.nvim",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
		},
	}) -- Extension for telescope: Show cheatsheet
	use({ "nvim-telescope/telescope-file-browser.nvim", requires = "nvim-telescope/telescope.nvim" }) -- Integrates file browser with Telescope
	use({ "ellisonleao/glow.nvim" }) -- Markdown preview

	use("tpope/vim-vinegar") -- Netwr enhancer
	use("mattn/emmet-vim") -- Emmet
	use("kosayoda/nvim-lightbulb") -- Show lightbulb icon when there is code actions available
	use("arkav/lualine-lsp-progress") -- Show LSP async action progress on lualine
	use("ahmedkhalf/project.nvim") -- Manage projects
	use({
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	}) -- Show some code actions in floating windows
	use({ "goolord/alpha-nvim", requires = "kyazdani42/nvim-web-devicons" }) --Dashboard
	use("petertriho/nvim-scrollbar") -- Scrollbar
	use({ "kevinhwang91/nvim-hlslens" }) -- Enhance search

	if packer_bootstrap then
		require("packer").sync()
	end
end)
