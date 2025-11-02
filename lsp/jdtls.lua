return{
   -- Java LSP (JDTLS) with Lombok
   local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

   vim.lsp.config("jdtls", {
      -- Command including lombok javaagent
      cmd = {
         vim.fn.stdpath("data") .. "/mason/bin/jdtls",
         "-javaagent:" .. lombok_path,
         "--add-opens",
         "java.base/java.lang=ALL-UNNAMED",
      },
      -- Root directory for the project
      root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
      -- Optional: project settings
      settings = {
         java = {
            project = {
               referencedLibraries = { lombok_path },
            },
            maven = {
               downloadSources = true,
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
         },
      },
   })

   -- Java mine
   -- vim.lsp.config("jdtls", {
      -- 	cmd = { "jdtls", "-javaagent:" .. lombok_path },
      -- 	root_dir = require("lspconfig.util").root_pattern(".git", "pom.xml", "build.gradle", "*.java"),
      -- 	settings = {
         -- 		java = {
            -- 			contentProvider = { preferred = "fernflower" },
            -- 			maven = { downloadSources = true },
            -- 			signatureHelp = { enabled = true },
            -- 			project = {
               -- 				referencedLibraries = {
                  -- 					lombok_path,
                  -- 				},
                  -- 			},
                  -- 		},
                  -- 	},
                  -- })
                  -- vim.lsp.enable("jdtls")

                  -- Java 2 (minimal JDTLS setup)
                  -- local lombok_path = vim.fn.expand("~/.local/share/nvim/lombok.jar")
                  -- vim.api.nvim_create_autocmd("FileType", {
                     -- 	pattern = "java",
                     -- 	callback = function()
                        -- 		local jdtls = require("jdtls")
                        -- 		local config = {
                           -- 			cmd = {
                              -- 				vim.fn.stdpath("data") .. "/mason/bin/jdtls",
                              -- 				"-javaagent:" .. lombok_path,
                              -- 				"--add-opens",
                              -- 				"java.base/java.lang=ALL-UNNAMED",
                              -- 			},
                              -- 			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git" }, { upward = true })[1]),
                              -- 		}
                              -- 		jdtls.start_or_attach(config)
                              -- 	end,
                              -- })
}
