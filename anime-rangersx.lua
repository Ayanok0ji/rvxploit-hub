local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local deploymentRemote = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Deployment")

local function deployUnit(unitName)
    local unitData = replicatedStorage:WaitForChild("Player_Data")
        :WaitForChild(player.Name)
        :WaitForChild("Collection")
        :WaitForChild(unitName)
    
    if unitData then
        deploymentRemote:FireServer(unitData)
        -- print("Deployed:", unitName)
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
    task.wait(2)
    -- print("Starting carrot level detection...")

    local success, errorMsg = pcall(function()
        while true do
            if player:FindFirstChild("UnitsFolder") then
                local carrotUnit = player.UnitsFolder:FindFirstChild("Carrot:Evo")
                
                if carrotUnit and carrotUnit:FindFirstChild("Upgrade_Folder") then
                    local levelValue = carrotUnit.Upgrade_Folder:FindFirstChild("Level")
                    
                    if levelValue and tonumber(levelValue.Value) >= 3 then
                        -- print("Carrot is level 5 - Deploying!")
                        deployUnit("Carrot:Evo")
                        task.wait(1)
                    else
                        if levelValue then
                            -- print("Current carrot level:", levelValue.Value)
                        end
                    end
                else
                    -- print("Waiting for Carrot:Evo unit to exist...")
                end
            else
                -- print("Waiting for UnitsFolder...")
            end
            
            task.wait(0.1)
        end
    end)
    
    if not success then
        warn("Carrot detection failed:", errorMsg)
    end
end)

print("Auto-deploy script loaded successfully")
