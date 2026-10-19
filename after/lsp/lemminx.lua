return {
    cmd = {
        "java",
        "-jar",
        vim.env.HOME .. "/java/lemminx/org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar",
    },
    filetypes = { "xml" },
    root_markers = { "pom.xml" }, -- only maven projects
    settings = {
        xml = {
            format = {
                enabled = true,
                splitAttributes = "preserve",
                maxLineWidth = 120,
            },
        },
        xslt = {
            format = {
                enabled = true,
                splitAttributes = "preserve",
                maxLineWidth = 120,
            },
        },
    },
}
