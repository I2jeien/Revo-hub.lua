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

local instantInteract = false
local usedPrompts = {}
local allPrompts = {}
local MAX_DISTANCE = 30

local function addPrompt(p)
    if not p:IsA("ProximityPrompt") then return end
    table.insert(allPrompts, p)
    p.PromptShown:Connect(function()
        usedPrompts[p] = false
    end)
end

for _, p in pairs(game:GetDescendants()) do
    addPrompt(p)
end

game.DescendantAdded:Connect(addPrompt)

game:GetService("RunService").Heartbeat:Connect(function()
    if not instantInteract then return end

    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, p in pairs(allPrompts) do
        if p and p.Enabled and not usedPrompts[p] then
            local part = p.Parent
            if part and part:IsA("BasePart") then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist <= MAX_DISTANCE then
                    usedPrompts[p] = true
                    p.HoldDuration = 0
                    p.RequiresLineOfSight = false
                    p.MaxActivationDistance = MAX_DISTANCE
                    p:InputHoldBegin()
                    task.wait()
                    p:InputHoldEnd()
                end
            end
        end
    end
end)

Tab:AddToggle({
    Name = "Buy Brainrot",
    Default = false,
    Callback = function(v)
        instantInteract = v
    end
})

Tab:AddSlider({
    Name = "Interaction Distance",
    Min = 5,
    Max = 50,
    Increase = 1,
    Default = MAX_DISTANCE,
    Callback = function(value)
        MAX_DISTANCE = value
    end
})

local antiAFKConnection
Tab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(v)
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
    end
})
