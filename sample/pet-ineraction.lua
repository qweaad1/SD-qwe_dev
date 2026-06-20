local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local Showers = function(Name)
    
    Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
    
    for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
   
        if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "CheapPetBathtub" then
          print(v:FindFirstChildWhichIsA("Model").Name)
            local String = string.split(v.Name, "true/")[2]
            print(String)
          return String
        end
    end
    
end


     game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(table.unpack({
    [1] = game:GetService("Players").LocalPlayer,
    [2] = "" .. Showers(),
    [3] = "UseBlock",
    [4] = {
        ["cframe"] = HumanoidRootPart.CFrame,
    },
    [5] = workspace.Pets.Cat,
}))
