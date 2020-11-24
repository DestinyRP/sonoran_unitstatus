--[[
    Sonoran Plugins

    Plugin Configuration

    Put all needed configuration in this file.
]]
local config = {
    enabled = true,
    pluginName = "unitstatus", -- name your plugin here
    pluginAuthor = "SonoranCAD", -- author
    requiresPlugins = {}, -- required plugins for this plugin to work, separated by commas
    setStatusCommand = "go", -- user command for setting their own status, leave blank to not use
    -- put your configuration options below
    statusCodes = {
        ["42"] = 0,
        ["7"] = 1,
        ["8"] = 2,
        ["76"] = 3,
        ["23"] = 4
    },
    jobs = {
        ['police'] = true,
    },
    enableAceCheck = false -- restrict command via ace permission
}

if config.enabled then
    Config.RegisterPluginConfig(config.pluginName, config)
end
