--!strict

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local UIController = {}

function UIController.start()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local gameUI =
		playerGui:WaitForChild("GameUI's") :: ScreenGui

	local huds =
		gameUI:WaitForChild("HUDs") :: GuiObject

	local uis =
		gameUI:WaitForChild("Uis") :: GuiObject

	local questButton =
		huds:WaitForChild("Quest") :: GuiButton

	local skillsButton =
		huds:WaitForChild("Skills") :: GuiButton

	local dailyReward =
		uis:WaitForChild("DailyReward") :: GuiObject

	local questUI =
		uis:WaitForChild("QuestUI") :: GuiObject

	local shopUi =
		uis:WaitForChild("ShopUi") :: GuiObject

	local closeButton =
		shopUi:FindFirstChild("Close")

	local wasInMatch = false

	local questOriginalPosition =
		questUI.Position

	local questOffScreen =
		UDim2.new(
			1.2,
			0,
			questOriginalPosition.Y.Scale,
			questOriginalPosition.Y.Offset
		)

	local questOpen = false
	local questTween: Tween? = nil
	local questTweenId = 0

	local shopOriginalSize =
		shopUi.Size

	local shopClosedSize =
		UDim2.new(
			0,
			0,
			0,
			0
		)

	local shopOpen = false
	local shopTween: Tween? = nil
	local shopTweenId = 0

	questUI.Position =
		questOffScreen

	questUI.Visible =
		false

	shopUi.Size =
		shopClosedSize

	shopUi.Visible =
		false

	local function updateLobbyVisibility()
		local inMatch =
			player:GetAttribute("InMatch") == true

		gameUI.Enabled =
			true

		if inMatch then
			if not wasInMatch then
				wasInMatch =
					true
			end

			huds.Visible =
				false

			uis.Visible =
				false
		else
			if wasInMatch then
				wasInMatch =
					false
			end

			huds.Visible =
				true

			uis.Visible =
				true
		end
	end

	local function closeQuest()
		if not questOpen then
			return
		end

		questTweenId += 1

		local currentTweenId =
			questTweenId

		if questTween then
			questTween:Cancel()
			questTween = nil
		end

		questOpen =
			false

		questTween =
			TweenService:Create(
				questUI,
				TweenInfo.new(
					0.35,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.In
				),
				{
					Position = questOffScreen
				}
			)

		questTween:Play()

		local closingTween =
			questTween

		closingTween.Completed:Connect(
			function()
				if currentTweenId == questTweenId
					and not questOpen
				then
					questUI.Visible =
						false

					questTween =
						nil
				end
			end
		)
	end

	local function openQuest()
		if player:GetAttribute("InMatch") == true then
			return
		end

		if not huds.Visible
			or not uis.Visible
		then
			return
		end

		if questOpen then
			return
		end

		questTweenId += 1

		if questTween then
			questTween:Cancel()
			questTween = nil
		end

		questOpen =
			true

		questUI.Visible =
			true

		questTween =
			TweenService:Create(
				questUI,
				TweenInfo.new(
					0.5,
					Enum.EasingStyle.Back,
					Enum.EasingDirection.Out
				),
				{
					Position = questOriginalPosition
				}
			)

		questTween:Play()
	end

	questButton.Activated:Connect(
		function()
			if player:GetAttribute("InMatch") == true then
				return
			end

			if not huds.Visible
				or not uis.Visible
			then
				return
			end

			if questOpen then
				closeQuest()
			else
				openQuest()
			end
		end
	)

	local function closeShop()
		if not shopOpen then
			return
		end

		shopTweenId += 1

		local currentTweenId =
			shopTweenId

		if shopTween then
			shopTween:Cancel()
			shopTween = nil
		end

		shopOpen =
			false

		shopTween =
			TweenService:Create(
				shopUi,
				TweenInfo.new(
					0.3,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.In
				),
				{
					Size = shopClosedSize
				}
			)

		shopTween:Play()

		local closingTween =
			shopTween

		closingTween.Completed:Connect(
			function()
				if currentTweenId == shopTweenId
					and not shopOpen
				then
					shopUi.Visible =
						false

					shopTween =
						nil
				end
			end
		)
	end

	local function openShop()
		if player:GetAttribute("InMatch") == true then
			return
		end

		if not huds.Visible
			or not uis.Visible
		then
			return
		end

		if shopOpen then
			return
		end

		shopTweenId += 1

		if shopTween then
			shopTween:Cancel()
			shopTween = nil
		end

		shopOpen =
			true

		shopUi.Visible =
			true

		shopUi.Size =
			shopClosedSize

		shopTween =
			TweenService:Create(
				shopUi,
				TweenInfo.new(
					0.5,
					Enum.EasingStyle.Back,
					Enum.EasingDirection.Out
				),
				{
					Size = shopOriginalSize
				}
			)

		shopTween:Play()
	end

	skillsButton.Activated:Connect(
		function()
			if player:GetAttribute("InMatch") == true then
				return
			end

			if not huds.Visible
				or not uis.Visible
			then
				return
			end

			if shopOpen then
				closeShop()
			else
				openShop()
			end
		end
	)

	if closeButton
		and closeButton:IsA("GuiButton")
	then
		closeButton.Activated:Connect(
			function()
				closeShop()
			end
		)
	end

	local function updateGameUIVisibility()
		local inMatch =
			player:GetAttribute("InMatch") == true

		gameUI.Enabled =
			true

		if inMatch then
			huds.Visible =
				false

			uis.Visible =
				false

			if questTween then
				questTween:Cancel()
				questTween = nil
			end

			questTweenId += 1

			questOpen =
				false

			questUI.Visible =
				false

			questUI.Position =
				questOffScreen

			if shopTween then
				shopTween:Cancel()
				shopTween = nil
			end

			shopTweenId += 1

			shopOpen =
				false

			shopUi.Visible =
				false

			shopUi.Size =
				shopClosedSize
		else
			huds.Visible =
				true

			uis.Visible =
				true
		end
	end

	player:GetAttributeChangedSignal(
		"InMatch"
	):Connect(
		function()
			updateGameUIVisibility()
		end
	)

	player.CharacterAdded:Connect(
		function()
			task.wait()

			updateGameUIVisibility()
		end
	)

	RunService.RenderStepped:Connect(
		function()
			updateLobbyVisibility()
		end
	)

	updateGameUIVisibility()
	updateLobbyVisibility()
end

return UIController
