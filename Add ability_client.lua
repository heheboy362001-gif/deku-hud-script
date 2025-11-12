-- ability_client.lua
-- LocalScript: StarterPlayer -> StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local abilityEvent = ReplicatedStorage:WaitForChild("AbilityRequest")

local doubleJumped = false
local sprinting = false

local SPRINT_KEY = Enum.KeyCode.LeftShift
local JUMP_KEY = Enum.KeyCode.Space

-- Thời gian giữa các trigger để tránh spam
local lastSprintToggle = 0
local SPRINT_TOGGLE_COOLDOWN = 0.3

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == SPRINT_KEY then
        local now = tick()
        if now - lastSprintToggle >= SPRINT_TOGGLE_COOLDOWN then
            lastSprintToggle = now
            sprinting = true
            abilityEvent:FireServer("SprintStart")
        end
    elseif input.KeyCode == JUMP_KEY then
        if not doubleJumped then
            doubleJumped = true
            abilityEvent:FireServer("DoubleJump")
        end
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == SPRINT_KEY then
        sprinting = false
        abilityEvent:FireServer("SprintStop")
    end
end

local function onCharacterAdded(char)
    doubleJumped = false
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            doubleJumped = false
        end
    end)
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end
