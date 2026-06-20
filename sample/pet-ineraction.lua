local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local Dirty = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "CheapPetBathtub" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local Sleepy = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "BasicCrib" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local WaterH = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "PetWaterBowl" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local FoodH = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "PetFoodBowl" then   local String = string.split(v.Name, "true/")[2]   return String end end end


    
    function ineraction(FurnitureName, TypeInteraction)
     game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(table.unpack({  [1] = game:GetService("Players").LocalPlayer,  [2] = "" .. FurnitureName,  [3] = ""..TypeInteraction,  [4] = { ["cframe"] = HumanoidRootPart.CFrame,   },  [5] = workspace:FindFirstChild("Pets"):GetChildren()[1],}))

end
ineraction(FoodH(),"UseBlock")
