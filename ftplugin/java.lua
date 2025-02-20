local jdtls_setup = require("custom.config.nvim-jdtls")
require("jdtls").start_or_attach(jdtls_setup.get_config)
