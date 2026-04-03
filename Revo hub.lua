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

local anchorToggle = Tab:AddToggle({
    Name = "Anchor",
    Default = false
})

anchorToggle:Callback(function(v)
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hrp then
        hrp.Anchored = v
    end

    if hum then
        if v then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            hum.AutoRotate = false
        else
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.AutoRotate = true
        end
    end
end)

local buyBrainrot = false
local MAX_DISTANCE = 25
local usedPrompts = {}

local function interactPrompt(p)
    if not p or not p:IsA("ProximityPrompt") then return end
    if not p.Enabled or usedPrompts[p] then return end

    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local part = p.Parent
    if part and part:IsA("BasePart") then
        local dist = (hrp.Position - part.Position).Magnitude
        if dist <= MAX_DISTANCE then
            usedPrompts[p] = true
            p.HoldDuration = 0
            p.RequiresLineOfSight = false
            p:InputHoldBegin()
            p:InputHoldEnd()
        end
    end
end

for _,p in pairs(game:GetDescendants()) do
    if p:IsA("ProximityPrompt") then
        p.PromptShown:Connect(function()
            usedPrompts[p] = false
        end)
    end
end

game.DescendantAdded:Connect(function(p)
    if p:IsA("ProximityPrompt") then
        p.PromptShown:Connect(function()
            usedPrompts[p] = false
        end)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if not buyBrainrot then return end
    for _,p in pairs(game:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            interactPrompt(p)
        end
    end
end)

Tab:AddToggle({
    Name = "Buy Brainrot",
    Default = false,
    Callback = function(v)
        buyBrainrot = v
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
