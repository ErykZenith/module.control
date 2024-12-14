ModuleControl = {}

local function generateUniqueCommand(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local existingCommands = GetRegisteredCommands()
    
    local function generateRandomCommand()
        local command = ""
        for i = 1, length do
            local randomIndex = math.random(1, #chars)
            command = command .. chars:sub(randomIndex, randomIndex)
        end
        return command
    end

    local command = generateRandomCommand()
    
    while table.contains(existingCommands, command) do
        command = generateRandomCommand()
    end

    return command
end

function ModuleControl.RegisterControl(params)
    assert(type(params) == "table", "Parameters must be passed as a table")
    local btnType = params.type or error("Control type is required")
    local btn = params.button or error("Button is required")
    local onPress = params.onPress
    local onRelease = params.onRelease
    local onListener = params.onListener
    
    local eventName = "module.controls/" .. generateUniqueCommand(math.random(8, 16))
    
    local instance = {
        controlState = true,
        enable = function(self)
            self.controlState = true
        end,
        disable = function(self)
            self.controlState = false
        end,
        toggle = function(self)
            self.controlState = not self.controlState
        end
    }

    local description = params.description or string.format("(module.controls) [%s]", btn)
    
    print(string.format("[^2INFO^7] Registering control: %s > [ %s ] = %s", eventName, btnType, btn))

    RegisterKeyMapping("+" .. eventName, description, btnType, btn)

    RegisterCommand("+" .. eventName, function()
        if not instance.controlState or IsPauseMenuActive() then
            if onListener then onListener("block", instance) end
            return
        end

        if onListener then onListener("onPress", instance) end
        if onPress then onPress(instance) end
    end)

    if onRelease then
        RegisterCommand("-" .. eventName, function()
            if not instance.controlState or IsPauseMenuActive() then
                if onListener then onListener("block", instance) end
                return
            end

            if onListener then onListener("onRelease", instance) end
            onRelease(instance)
        end)
    end

    SetTimeout(500, function()
        TriggerEvent('chat:removeSuggestion', "/+" .. eventName)
        TriggerEvent('chat:removeSuggestion', "/-" .. eventName)
    end)

    return instance
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
