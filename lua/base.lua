vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"

vim.wo.number = true

-- Open memo file
vim.api.nvim_create_user_command("Memo", function(opts)
        vim.cmd("e " .. "~/_/memo/memo.markdown")
end, {})

vim.api.nvim_create_user_command("Init", function(opts)
        vim.cmd("e " .. "~/.config/nvim/init.lua")
end, {})

vim.api.nvim_create_user_command("Base", function(opts)
        vim.cmd("e " .. "~/.config/nvim/lua/base.lua")
end, {})

vim.api.nvim_create_user_command("Keymaps", function(opts)
        vim.cmd("e " .. "~/.config/nvim/lua/keymaps.lua")
end, {})

vim.api.nvim_create_user_command("Plugins", function(opts)
        vim.cmd("e " .. "~/.config/nvim/lua/plugins.lua")
end, {})
