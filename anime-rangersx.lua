local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local deploymentRemote = replicatedStorage:WaitForChild("Remote", 9e9):WaitForChild("Server", 9e9):WaitForChild("Units", 9e9):WaitForChild("Deployment", 9e9)

local function deployUnit(unitName)
    local unitData = replicatedStorage:WaitForChild("Player_Data", 9e9)
        :WaitForChild(player.Name, 9e9)
        :WaitForChild("Collection", 9e9)
        :WaitForChild(unitName, 9e9)
    
    if unitData then
        deploymentRemote:FireServer(unitData)
    else
        warn("Unit data not found for:", unitName)
    end
end

task.spawn(function()
    while true do
        deployUnit("Saber")
        task.wait(0.2)
    end
end)

task.spawn(function()
    task.wait(0.2)
    
    print("Starting carrot detection...")
    
    local success, errorMsg = pcall(function()
        local hud = player:WaitForChild("PlayerGui", 9e9):WaitForChild("HUD", 9e9)
        local unitsManager = hud:WaitForChild("InGame", 9e9):WaitForChild("UnitsManager", 9e9)
            :WaitForChild("Main", 9e9):WaitForChild("Main", 9e9)
            :WaitForChild("ScrollingFrame", 9e9)
        
        while not unitsManager:FindFirstChild("Carrot:Evo") do
            task.wait(1)
        end
        
        local carrotEvoText = unitsManager:WaitForChild("Carrot:Evo", 9e9):WaitForChild("UpgradeText", 9e9)
        print("Carrot:Evo UI element found")
        
        while true do
            local currentText = carrotEvoText.Text
            
            if string.find(currentText, "%(MAX%)") then
                print("Carrot is at MAX level - deploying...")
                deployUnit("Carrot:Evo")
                task.wait(1)
            else
                task.wait(0.5)
            end
        end
    end)
    
    if not success then
        warn("Carrot detection failed:", errorMsg)
    end
end)
