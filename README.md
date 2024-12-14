# example
- **https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/**
```
local sprintControl = ModuleControl.RegisterControl({
    type = "KEYBOARD",
    button = "LSHIFT",
    onPress = function(instance)
        -- Start sprinting
        print("Sprint started")
    end,
    onRelease = function(instance)
        -- Stop sprinting
        print("Sprint stopped")
    end,
    onListener = function(state, instance)
        -- Optional additional logic
        print("Control state:", state)
    end,
    description = "Sprint Control"
})
