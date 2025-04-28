repeat wait() until game:IsLoaded()
local player = game.Players.LocalPlayer
local matchCounter = 0
local previousState = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MatchTracker"
screenGui.ResetOnSpawn = false 
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Match Progress"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local counter = Instance.new("TextLabel")
counter.Text = "Completed: 0/4"
counter.Size = UDim2.new(1, 0, 0, 25)
counter.Position = UDim2.new(0, 0, 0, 30)
counter.BackgroundTransparency = 1
counter.TextColor3 = Color3.fromRGB(255, 255, 255)
counter.Font = Enum.Font.SourceSans
counter.TextSize = 16
counter.Parent = frame

local status = Instance.new("TextLabel")
status.Text = "Status: In Match"
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 55)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.SourceSans
status.TextSize = 16
status.Parent = frame

local function GameEnded()
    local endGameUI = player.PlayerGui:FindFirstChild("EndGameUI")
    return endGameUI ~= nil
end

while matchCounter < 4 do
    task.wait(0.2)
    
    local currentState = GameEnded()

    if currentState and not previousState then
        matchCounter = matchCounter + 1
        counter.Text = "Completed: "..matchCounter.."/4"
    end

    previousState = currentState
end

status.Text = "Status: Restarting..."
task.wait(6)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RestartMatch"):FireServer()

screenGui:Destroy()
