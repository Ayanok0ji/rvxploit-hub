local placeId = 72829404259339
local rejoinInterval = 1140
local countdown = rejoinInterval

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoRejoinGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Auto Rejoin"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size = UDim2.new(1, 0, 0, 40)
countdownLabel.Position = UDim2.new(0, 0, 0, 35)
countdownLabel.BackgroundTransparency = 1
countdownLabel.Text = "Next rejoin in: "..countdown.."s"
countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownLabel.Font = Enum.Font.SourceSans
countdownLabel.TextSize = 24
countdownLabel.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(1, 0, 0, 20)
closeButton.Position = UDim2.new(0, 0, 0, 80)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSans
closeButton.TextSize = 14
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    script:Destroy()
end)

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function rejoinGame()
    game:GetService("TeleportService"):Teleport(placeId)
end

local function onTeleportFailure(_, errorType)
    warn("Teleport failed:", errorType)
    wait(5)
    rejoinGame()
end

game:GetService("TeleportService").TeleportInitFailed:Connect(onTeleportFailure)

while true do
    for i = countdown, 0, -1 do
        countdownLabel.Text = "Next rejoin in: "..i.."s"
        wait(1)
    end
    rejoinGame()
end
