local Location
for i, v in pairs(getgc()) do
    if type(v) == "function" then
        local e = getfenv(v)
        if e and e.script and string.find(e.script:GetFullName(), "InteriorsM") then
            for _, c in pairs(getconstants(v)) do
                if type(c) == "string" and string.find(c, "SetLocation") then
                    Location = v
                    break
                end
            end
        end
    end
    if Location then break end
end

local function SetLocation(...)
    local o = get_thread_identity()
    set_thread_identity(2)
    local r = {pcall(Location, ...)}
    set_thread_identity(o)
    return unpack(r)
end

local Neighborhood
for k, v in pairs(getfenv(0)) do
    if type(v) == "function" and string.find(k, "Neighbor") then
        Neighborhood = v
        break
    end
end
local function mainMapP()
   SetLocation("MainMap", "MainDoor", {})
wait(3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-607.94,27.96,-1468.74)
wait(4)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-607.94,27.96,-1468.74)
end
mainMapP()
