local function get_jdtls()
	local mason_registry = require("mason-registry")
	local jdtls = mason_registry.get_package("jdtls")
	local jdtls_path = jdtls:get_install_path()
	local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local SYSTEM = "mac"
	local config = jdtls_path .. "/config_" .. SYSTEM
	local lombok = jdtls_path .. "/lombok.jar"
	return launcher, config, lombok
end

-- local function get_bundles()
--     local mason_registry = require("mason-registry")
--     -- Setup java-debug-adapter
--     local java_debug = mason_registry.get_package "java-debug-adapter"
--     local java_debug_path = java_debug:get_install_path()
--     local bundles = {
--         vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
--     }
--     -- Setup java-test
--     local java_test = mason_registry.get_package "java-test"
--     local java_test_path = java_test:get_install_path()
--     vim.list_extend(
--         bundles,
--         vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n")
--     )
--     return bundles
-- end

local function get_workspace()
	local home = os.getenv("HOME")
	local workspace_path = home .. "/code/workspace/"
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = workspace_path .. project_name
	return workspace_dir
end

local function java_keymaps()
	vim.keymap.set(
		"n",
		"<leader>Jo",
		"<cmd> lua require('jdtls').organize_imports()<CR>",
		{ desc = "[J]ava [o]rganize imports" }
	)
	vim.keymap.set(
		"n",
		"<leader>Jv",
		"<cmd> lua require('jdtls').extract_variable()<CR>",
		{ desc = "[J]ava extract [v]ariable" }
	)
	vim.keymap.set(
		"n",
		"<leader>Jc",
		"<cmd> lua require('jdtls').extract_constant()<CR>",
		{ desc = "[J]ava extract [c]onstant" }
	)
	vim.keymap.set(
		"n",
		"<leader>Jt",
		"<cmd> lua require('jdtls').test_nearest_method()<CR>",
		{ desc = "[J]ava [t]est method" }
	)
	vim.keymap.set("n", "<leader>JT", "<cmd> lua require('jdtls').test_class()<CR>", { desc = "[J]ava [T]est class" })
	vim.keymap.set("n", "<leader>Ju", "<cmd> JstUpdateConfig<CR> ", { desc = "[J]ava [u]pdate config" })
end

local function setup_jdtls()
	local jdtls = require("jdtls")
	local launcher, os_config, lombok = get_jdtls()
	local workspace_dir = get_workspace()
	-- local bundles = get_bundles()
	local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
	-- configure capabilities
	local capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				snippetSupport = false,
			},
		},
	}

	-- setup capabilities like autocomplete, snippets, etc.
	local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	for k, v in pairs(lsp_capabilities) do
		capabilities[k] = v
	end

	local extendedClientCapabilities = jdtls.extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	-- run jdtls command
	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		launcher,
		"-configuration",
		os_config,
		"-data",
		workspace_dir,
	}

	local init_options = {
		-- bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	}

	-- configure jdtls settings
	local settings = {
		java = {
			format = {
				enabled = true,
				-- Google Style Guide
				-- settings = {
				-- 	url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
				-- 	profile = "GoogleStyle",
				-- },
			},
			eclipse = {
				downloadSource = true,
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = {
				enabled = true,
			},
			contentProvider = {
				preferred = "fernflower",
			},
			saveActions = {
				organizeImports = true,
			},
			completion = {
				-- when using unimported static method, this is how LSP ranks possibilities
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				-- Try not to suggest imports from these packages in the code action window
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				-- Set the order in which the language server should organize imports
				importOrder = {
					"java",
					"jakarta",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticThreshold = 9999,
				},
			},
			codeGeneration = {
				-- When generating toString use a json format
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				-- When generating hashCode and equals methods use the java 7 objects method
				hashCodeEquals = {
					useJava7Objects = true,
				},
				-- When generating code use code blocks
				useBlocks = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			referencesCodeLens = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	}

	local on_attach = function(_, bufnr)
		java_keymaps()
		-- require("jdtls").setup_dap()
		-- require("jdtls.dap").setup_dap_main_class_configs()
		-- require("jdtls.setup").add_commands() -- Deprecated
		vim.lsp.codelens.refresh()

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.java" },
			callback = function()
				local _, _ = pcall(vim.lsp.codelens.refresh)
			end,
		})
	end

	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
		capabilities = capabilities,
		init_options = init_options,
		on_attach = on_attach,
	}

	require("jdtls").start_or_attach(config)
end

return {
	setup_jdtls = setup_jdtls(),
}
