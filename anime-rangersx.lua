-- print("hays ako nalang kasi")

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local deploymentRemote = replicatedStorage:WaitForChild("Remote", 9e9):WaitForChild("Server", 9e9):WaitForChild("Units", 9e9):WaitForChild("Deployment", 9e9)

local function deployUnit(unitName)
    local args = {
        replicatedStorage:WaitForChild("Player_Data", 9e9)
            :WaitForChild(player.Name, 9e9)
            :WaitForChild("Collection", 9e9)
            :WaitForChild(unitName, 9e9)
    }
    deploymentRemote:FireServer(unpack(args))
end

task.spawn(function()
    while true do
        deployUnit("Saber")
        task.wait(0.2)
    end
end)

task.spawn(function()
    task.wait(0.2)
    
    print("start")
    
    local success, errorMsg = pcall(function()
        local hud = player:WaitForChild("PlayerGui", 9e9):WaitForChild("HUD", 9e9)
        local unitsManager = hud:WaitForChild("InGame", 9e9):WaitForChild("UnitsManager", 9e9):WaitForChild("Main", 9e9):WaitForChild("Main", 9e9):WaitForChild("ScrollingFrame", 9e9)
        local carrotEvoText = unitsManager:WaitForChild("Carrot:Evo", 9e9):WaitForChild("UpgradeText", 9e9)

        -- print("found:", carrotEvoText)
        
        while true do
            local currentText = carrotEvoText.Text
            -- print("lvl value:", currentText)
          
            if string.find(currentText, "MAX") then
                print("max lvl")
                deployUnit("Carrot:Evo")
            end
            
            task.wait(0.1)
        end
    end)
    
    if not success then
        warn("Carrot detection failed:", errorMsg)
    end
end)
