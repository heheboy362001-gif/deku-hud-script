-- ability_server.lua
-- Script: ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local abilityEvent = ReplicatedStorage:FindFirstChild("AbilityRequest")
if not abilityEvent then
    abilityEvent = Instance.new("RemoteEvent")
    abilityEvent.Name = "AbilityRequest"
    abilityEvent.Parent = ReplicatedStorage
end

local DEFAULT_WALKSPEED = 16
local SPRINT_MULT = 1.8
local SPRINT_MAX_DURATION = 12
local SPRINT_COOLDOWN = 1.0
local DOUBLEJUMP_FORCE = 50
local DOUBLEJUMP_COOLDOWN = 0.25

local playerState = {}

local function ensureState(player)
    if not playerState[player] then
        playerState[player] = {
            sprinting = false,
            sprintStart = 0,
            lastSprintToggle = 0,
            lastDoubleJump = 0
        }
    end
    return playerState[player]
end

abilityEvent.OnServerEvent:Connect(function(player, action)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    local st = ensureState(player)
    local now = tick()

    if action == "SprintStart" then
        if now - st.lastSprintToggle < SPRINT_COOLDOWN then return end
        st.lastSprintToggle = now

        if not st.sprinting then
            st.sprinting = true
            st.sprintStart = now
            humanoid.WalkSpeed = DEFAULT_WALKSPEED * SPRINT_MULT
        end

    elseif action == "SprintStop" then
        if st.sprinting then
            st.sprinting = false
            humanoid.WalkSpeed = DEFAULT_WALKSPEED
        end

    elseif action == "DoubleJump" then
        if now - st.lastDoubleJump < DOUBLEJUMP_COOLDOWN then return end
        st.lastDoubleJump = now

        local state = humanoid:GetState()
        if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
            return
        end

        local vel = root.Velocity
        root.Velocity = Vector3.new(vel.X, 0, vel.Z) + Vector3.new(0, DOUBLEJUMP_FORCE, 0)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    playerState[p] = nil
end)
