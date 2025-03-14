return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {  "go",
                            "bash",
                            "dockerfile",
                            "gomod",
                            "gosum",
                            "goctl",
                            "python",
                            "sql",
                            "yaml",
                            "typescript",
                            "javascript",
                            "html",
                            "css",
                            "c",
                            "lua",
                            "vim",
                            "vimdoc",
                            "query",
                            "markdown",
                            "markdown_inline",
                            "json",
                          },                     
      highlight = { enable = true },
    })
    vim.treesitter.language.register("yaml", "values")
  end
}
