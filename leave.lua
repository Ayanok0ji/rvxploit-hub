local TARGET_WAVE = 101
local CHECK_INTERVAL = 1
local MAX_MISSED_WAVE = 102

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

while not player:FindFirstChild("PlayerGui") do
    wait(1)
end

local success, waveLabel, sellRemote = pcall(function()
    local gui = player.PlayerGui:WaitForChild("MainUI", 10)
    local wave = gui:WaitForChild("Top", 10):WaitForChild("Wave", 10).Value
    local remote = ReplicatedStorage:WaitForChild("Remotes", 10)
        :WaitForChild("UnitManager", 10)
        :WaitForChild("SellAll", 10)
    return wave, remote
end)

if not success then
    error("Failed to find GUI elements or remotes!")
end

local function getCurrentWave()
    local text = waveLabel.Text or waveLabel.Value or ""
    return tonumber(text:match("%d+")) or 0
end

while true do
    local currentWave = getCurrentWave()
    
    --print("[Wave Checker] Current wave:", currentWave)
    
    if currentWave == TARGET_WAVE then
        pcall(function()
            sellRemote:FireServer()
            print("[Auto-Sell] Sold all units on wave", TARGET_WAVE)
            wait(5)
        end)
    elseif currentWave > MAX_MISSED_WAVE then
        print("[Warning] Overshot target wave, current:", currentWave)
    end
    
    wait(CHECK_INTERVAL)
end
