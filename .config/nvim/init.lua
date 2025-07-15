if vim.g.vscode then
    -- VSCode extension
    -- https://github.com/vscode-neovim/vscode-neovim/issues/298
    vim.opt.clipboard:append("unnamedplus")
    return
end

-- Bootstrap lazy.nvim
require("config.lazy")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")
