https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
example
local controls = module_controls:RegisterControl(
    "keyboard", "E", 
    function(instance) print("Pressed E") end,
    function(instance) print("Released E") end,
    function(event, instance) print("Listener Event:", event) end,
    "Open Menu"
)
