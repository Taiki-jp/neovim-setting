function CopilotChatBuffer()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end

-- Open copilot chat
vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>lua CopilotChatBuffer()<CR>", { noremap = true, silent = true })
-- Toggle copilot chat
vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>CopilotChatToggle<CR>", { noremap = true, silent = true })
