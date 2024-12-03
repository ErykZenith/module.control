module_controls = {}
module_controls.__index = module_controls

local function generateCommands(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local command = ""

    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        command = command .. chars:sub(randomIndex, randomIndex)
    end

    for _, registeredCommand in ipairs(GetRegisteredCommands()) do
        if command == registeredCommand then
            return generateCommands(length)
        end
    end

    return command
end

function module_controls:RegisterControl(
    btnType, 
    btn, 
    onPress, 
    onRelease, 
    onListener, 
    description
)
    local eventName = "module.controls/" .. generateCommands(math.random(8, 16))
    print(string.format("[^2INFO^7] Registering control: %s > [ %s ] = %s", eventName, btnType, btn))

    description = description or string.format("(module.controls) [%s]", btn)
    local instance = { controlState = true }

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

-- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
-- example
-- local controls = module_controls:RegisterControl(
--     "keyboard", "E", 
--     function(instance) print("Pressed E") end,
--     function(instance) print("Released E") end,
--     function(event, instance) print("Listener Event:", event) end,
--     "Open Menu"
-- )
