local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/V5/Source.lua"))()

local Window = redzlib:MakeWindow({
    Title = "Revo Hub",
    SubTitle = "by Revo",
    SaveFolder = "RevoHub"
})

Window:AddMinimizeButton({
    Button = { 
        Image = "rbxassetid://98673113877100",
        BackgroundTransparency = 0 
    },
    Corner = { CornerRadius = UDim.new(35, 1) }
})

local Tab = Window:MakeTab({"Main", "cherry"})
Window:SelectTab(Tab)

Tab:AddSection({"Player"})

-- Anchor
local anchorToggle = Tab:AddToggle({Name = "Anchor", Default = false})
anchorToggle:Callback(function(v)
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildWhichIsA("Animator")

    if hrp then hrp.Anchored = v end
    if hum then
        if v then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            hum.AutoRotate = false
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        else
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.AutoRotate = true
        end
    end
end)

-- Buy Brainrot otimizado
local buyBrainrot = false
local MAX_DISTANCE = 25
local usedPrompts = {}
local brainrotPrompts = {}

local function addPrompt(p)
    if not p:IsA("ProximityPrompt") then return end
    if p.Parent.Name:lower():find("brainrot") then
        table.insert(brainrotPrompts, p)
    end
    p.PromptShown:Connect(function()
        usedPrompts[p] = false
    end)
end

-- Adiciona prompts existentes
for _, p in pairs(game:GetDescendants()) do
    addPrompt(p)
end

-- Adiciona prompts que surgirem
game.DescendantAdded:Connect(addPrompt)

-- Loop otimizado
game:GetService("RunService").Heartbeat:Connect(function()
    if not buyBrainrot then return end
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, p in pairs(brainrotPrompts) do
        if p and p.Parent and p.Enabled and not usedPrompts[p] then
            local dist = (hrp.Position - p.Parent.Position).Magnitude
            if dist <= MAX_DISTANCE then
                usedPrompts[p] = true
                p.HoldDuration = 0
                p.RequiresLineOfSight = false
                p:InputHoldBegin()
                p:InputHoldEnd()
            end
        end
    end
end)

Tab:AddToggle({Name = "Buy Brainrot", Default = false, Callback = function(v) buyBrainrot = v end})

-- Anti AFK
local antiAFKConnection
Tab:AddToggle({Name = "Anti AFK", Default = false, Callback = function(v)
    if v then
        local vu = game:GetService("VirtualUser")
        antiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end})
