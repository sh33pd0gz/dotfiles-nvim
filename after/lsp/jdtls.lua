local function get_jdtls_cache_dir()
    return vim.fn.stdpath("cache") .. "/jdtls"
end

local function get_jdtls_workspace_dir()
    return get_jdtls_cache_dir() .. "/workspace"
end

local function get_jdtls_jvm_args()
    local env = os.getenv("JDTLS_JVM_ARGS")
    local args = { "--add-modules=ALL_SYSTEM" }
    for a in string.gmatch((env or ""), "%S+") do
        local arg = string.format("--jvm-arg=%s", a)
        table.insert(args, arg)
    end
    return unpack(args)
end

return {
    cmd = function(dispatchers, config)
        local workspace_dir = get_jdtls_workspace_dir()
        local data_dir = workspace_dir

        if config.root_dir then
            data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
        end

        local config_cmd = {
            "jdtls",
            "-data",
            data_dir,
            get_jdtls_jvm_args(),
        }

        return vim.lsp.rpc.start(config_cmd, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
        })
    end,
    root_markers = { "pom.xml" },
    filetypes = { "java" },
    init_options = {
        extendendCapabilities = {
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
            overrideMethodsPromptSupport = true,
            executeClientCommandSupport = true,
            inferSelectionSupport = {
                "extractMethod",
                "extractVariable",
                "extractConstant",
                "extractVariableAllOccurrence",
            },
        },
    },
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
                    },
                    {
                        name = "JavaSE-21",
                        path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
                    },
                    {
                        name = "JavaSE-25",
                        path = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home",
                    },
                },
            },
        },
    },
}
