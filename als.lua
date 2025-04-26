local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local matchCounter = 0
local previousState = false
local MAX_MATCHES = 4
local GAME_END_GUI_NAME = "EndGameUI"
local TELEPORT_PLACE_ID = 18583778121

local function hasGameEnded()
	local gui = player:WaitForChild("PlayerGui", 10)
	return gui and gui:FindFirstChild(GAME_END_GUI_NAME) ~= nil
end

while matchCounter < MAX_MATCHES do
	task.wait(4)

	local currentState = hasGameEnded()
	print("Waiting for 4 matches...")

	if currentState and not previousState then
		matchCounter += 1
		print("Game ended! Count:", matchCounter)
	end

	previousState = currentState
end

TeleportService:Teleport(TELEPORT_PLACE_ID)
