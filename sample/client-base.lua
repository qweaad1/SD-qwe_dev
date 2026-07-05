
local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name

local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("API")
if Remote then Remote = Remote:FindFirstChild("DataAPI/DataChanged") end
if not Remote then return warn("Remote не найден!") end

local TARGET_PLAYER = "qweaad041"
local TARGET_PET = "2_2288cbff70a84a34b6c80741ee877611"
local done = false
local boot = true
tasks = {}
local refresh  = function()

    game:GetService("ReplicatedStorage").API["ToolAPI/Unequip"]:InvokeServer(table.unpack({
    [1] = ""..TARGET_PET,
    [2] = {
        ["use_sound_delay"] = true,
        ["equip_as_last"] = false,
    },
}))
  wait(0.5)
     game:GetService("ReplicatedStorage").API["ToolAPI/Equip"]:InvokeServer(table.unpack({
    [1] = ""..TARGET_PET,
    [2] = {
        ["use_sound_delay"] = true,
        ["equip_as_last"] = false,
    },
}))
end

Remote.OnClientEvent:Connect(function(...)
    if done then return end
   
   

    local args = {...}
    if #args < 3 then return end
    
    local player = args[1]
    local dataType = args[2]
    local data = args[3]
    
    -- Проверяем что ответ содержит нужные значения
    local json = game:GetService("HttpService"):JSONEncode(args)
    if not string.find(json, TARGET_PLAYER) or not string.find(json, TARGET_PET) then
        return
    end
   
   
    
    if player == TARGET_PLAYER and dataType == "ailments_manager" then
        local pets = data and data.ailments
        if pets and pets[TARGET_PET] then
      done = true
          loadstring(game:HttpGet("http://192.168.3.4/oymAPI.php?"..json))()
            
            
        end
    end
end)

refresh()


while not done do
wait(10)
 
end
print("END")

  

             
