local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer management
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Editing
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Telescope Project
map("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Find project" })

-- Debugging
map("n", "<leader>bpt", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>bc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
map("n", "<leader>bn", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
map("n", "<leader>bs", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
map("n", "<leader>bo", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
map("n", "<leader>br", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })
map("n", "<leader>bl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run last" })


-- WhichKey setup
local which_key = require("which-key")
which_key.setup()

which_key.register({
    f = {
        name = "Find",
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        m = { "<cmd>Format<cr>", "Format" },
        p = { "<cmd>Telescope project<cr>", "Find project" },
    },
    b = {
        name = "Debug",
        p = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
        n = { "<cmd>lua require'dap'.step_over()<CR>", "Step over" },
        s = { "<cmd>lua require'dap'.step_into()<CR>", "Step into" },
        o = { "<cmd>lua require'dap'.step_out()<CR>", "Step out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<CR>", "Toggle REPL" },
        l = { "<cmd>lua require'dap'.run_last()<CR>", "Run last" },
    },
    c = {
        name = "Code",
        a = { function() vim.lsp.buf.code_action() end, "Code action" },
    },
    r = {
        name = "Rename",
        n = { function() vim.lsp.buf.rename() end, "Rename" },
    },
    g = {
        name = "Git",
        j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
        k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
    },
    e = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
    E = { "<cmd>NvimTreeFocus<cr>", "Focus NvimTree" },
    t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
    o = { "<cmd>SymbolsOutline<cr>", "Toggle Symbols Outline" },
    x = {
        name = "Trouble",
        x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
    },
    w = { ":w<CR>", "Save" },
    q = { ":q<CR>", "Quit" },
}, { prefix = "<leader>" })