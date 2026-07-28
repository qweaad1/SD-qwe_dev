local inactiveTrade = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeApp"):WaitForChild("Frame"):WaitForChild("NegotiationFrame"):WaitForChild("Header"):WaitForChild("PartnerFrame"):WaitForChild("NameLabel")
  local confrimData = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeApp"):WaitForChild("Frame"):WaitForChild("ConfirmationFrame"):WaitForChild("PartnerLabel").Text
local mainFrame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TradeApp"):FindFirstChild("Frame")
local acceptedWay=""
acceptedWay=inactiveTrade.Text

  
  confrimData = "ANTIFROZE"
    
 if  mainFrame.Visible then
         loadstring(game:HttpGet("http://localhost:5187/ReceiveCustomersOrder?customerName="..inactiveTrade.Text.."&WhoAsk="..game:GetService("Players").LocalPlayer.Name))()

end
 
wait(5.5)

   inactiveTrade.Text = "ANTIFROZE"  
 game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TradeAPI/AcceptNegotiation"):FireServer()
  
   wait(2)

   confrimData = "ANTIFROZE"
   wait(1)

   local TradeConfrim = false  
for attempt = 1, 10 do
   
    wait(1)
     confrimData = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeApp"):WaitForChild("Frame"):WaitForChild("ConfirmationFrame"):WaitForChild("PartnerLabel").Text
   
    if acceptedWay == confrimData then 
        TradeConfrim = true
        warn("Confrim trade")
        break 
    end 
end

 
  if TradeConfrim == true then 
 
for i = 1, 30 do
   
    wait(1)
     
      if not mainFrame.Visible then 
       break 
      end
    if mainFrame.Visible then 
       
       
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TradeAPI/ConfirmTrade"):FireServer()

       
    end 
end
 end
wait(5)
--droptrade
game:GetService("ReplicatedStorage").API["TradeAPI/DeclineTrade"]:FireServer()
-- next loop   
