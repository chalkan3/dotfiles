require("formatter").setup({
    filetype = {
        lua = require("formatter.filetypes.lua").stylua,
        javascript = require("formatter.filetypes.javascript").prettier,
        typescript = require("formatter.filetypes.typescript").prettier,
        javascriptreact = require("formatter.filetypes.javascriptreact").prettier,
        typescriptreact = require("formatter.filetypes.typescriptreact").prettier,
        css = require("formatter.filetypes.css").prettier,
        html = require("formatter.filetypes.html").prettier,
        json = require("formatter.filetypes.json").prettier,
        yaml = require("formatter.filetypes.yaml").prettier,
        markdown = require("formatter.filetypes.markdown").prettier,
    },
})

vim.api.nvim_create_autocmd("BufWritePost", {
    command = "FormatWrite",
    pattern = "*",
})
