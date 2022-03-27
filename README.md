# neocities-roblox

Roblox module to interact with the [Neocities API](https://neocities.org/api).

```lua
local NeocitiesAPI = require(game.ReplicatedStorage.Neocities)
local neocities = NeocitiesAPI.new("YOUR-API-KEY-GOES-HERE")

neocities:UploadFiles({
    ["index.html"] = "Hello world!"
})
print(neocities:GetFileContent("index.html"))
```