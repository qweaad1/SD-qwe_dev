
game:GetService("ReplicatedStorage").API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
    [1] = "food",
    [2] = "donut",
    [3] = {
        ["buy_count"] = 1,
    },
}))

game:GetService("ReplicatedStorage").API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
    [1] = "food",
    [2] = "water_paper_cup",
    [3] = {
        ["buy_count"] = 1,
    },
}))

game:GetService("ReplicatedStorage").API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
    [1] = "food",
    [2] = "healing_apple",
    [3] = {
        ["buy_count"] = 1,
    },
}))

--feed player
game:GetService("ReplicatedStorage").API["ToolAPI/ServerUseTool"]:InvokeServer(table.unpack({
    [1] = "2_54463f3c1e644caca28b690db4fe44b4",
    [2] = "START",
}))
game:GetService("ReplicatedStorage").API["ToolAPI/ServerUseTool"]:InvokeServer(table.unpack({
    [1] = "2_54463f3c1e644caca28b690db4fe44b4",
    [2] = "END",
}))
