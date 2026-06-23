
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer


local TradeRequestReceived = ReplicatedStorage:WaitForChild("API"):WaitForChild("TradeAPI/TradeRequestReceived")
local AcceptOrDeclineTradeRequest = ReplicatedStorage:WaitForChild("API"):WaitForChild("TradeAPI/AcceptOrDeclineTradeRequest")
local AcceptNegotiation = ReplicatedStorage:WaitForChild("API"):WaitForChild("TradeAPI/AcceptNegotiation")
local ConfirmTrade = ReplicatedStorage:WaitForChild("API"):WaitForChild("TradeAPI/ConfirmTrade")


local CHECK_INTERVAL = 2
local tradeLoopRunning = false

-- Функция для отправки AcceptNegotiation и ConfirmTrade
local function SendTradeActions()
    local tradeApp = LocalPlayer.PlayerGui:FindFirstChild("TradeApp")
    
    if tradeApp then
        local frame = tradeApp:FindFirstChild("Frame")
        
        if frame and frame.Visible then
           
            
            pcall(function()
                AcceptNegotiation:FireServer()
                task.wait(0.1)
                ConfirmTrade:FireServer()
                
            end)
            
            return true
        end
    end
    
    return false
end

-- Функция для запуска цикла
local function StartTradeLoop()
    if tradeLoopRunning then return end
    
    tradeLoopRunning = true
   
    task.spawn(function()
        while tradeLoopRunning do
            SendTradeActions()
            
            for i = 1, CHECK_INTERVAL do
                if not tradeLoopRunning then break end
                task.wait(1)
            end
        end
    end)
end

-- Функция принятия торговли
local function AcceptTradeRequest(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if targetPlayer then
        local success = pcall(function()
            AcceptOrDeclineTradeRequest:InvokeServer(targetPlayer, true)
        end)
        
        if success then
          
            StartTradeLoop()
            return true
        end
    end
    
    return false
end



if tostring(LocalPlayer) == "qweaadS001" then 
print(tostring(LocalPlayer).." resiver")
end 

TradeRequestReceived.OnClientEvent:Connect(function(playerName)
    local playerNameStr = tostring(playerName)
    print("[Trade Auto-Accept] Получен запрос от: " .. playerNameStr)
    
 
        
        AcceptTradeRequest(playerNameStr)
    
end)
