local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local placeId = 72829404259339
local timeout = 200
local lastHeartbeat = tick()

if game.PlaceId ~= placeId then return end

RunService.Heartbeat:Connect(function()
	lastHeartbeat = tick()
end)

local function hopToSmallestServer()
	local cursor = ""
	local smallestServerId = nil
	local smallestCount = math.huge

	while true do
		local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		if success and result and result.data then
			for _, server in pairs(result.data) do
				if server.playing < smallestCount and server.id ~= game.JobId then
					smallestCount = server.playing
					smallestServerId = server.id
				end
			end

			if result.nextPageCursor then
				cursor = result.nextPageCursor
			else
				break
			end
		else
			break
		end
	end

	if smallestServerId then
		TeleportService:TeleportToPlaceInstance(placeId, smallestServerId, LocalPlayer)
	end
end

task.spawn(function()
	wait(timeout)
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	local guiLoaded = gui and #gui:GetChildren() > 0

	if not guiLoaded or tick() - lastHeartbeat > timeout then
		hopToSmallestServer()
	end
end)
