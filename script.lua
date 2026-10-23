-- BlockSpin Pro Hub - Ultimate Fixed Edition
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ضمان استمرارية السكربت عند الانتقال
local queue_func = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue_func then
    queue_func([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vekokoop/bs/refs/heads/main/script.lua"))()
    ]])
end

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("BlockSpinSilentESP") then
    CoreGui.BlockSpinSilentESP:Destroy()
end

-- إعداد دائرة الـ FOV للسايلنت أيم
local FOV_Radius = 120
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = FOV_Radius
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 69, 0)
fovCircle.Thickness = 1.5
fovCircle.Transparency = 0.7
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- واجهة المستخدم الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockSpinSilentESP"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الأيقونة العائمة الفخمة (قابل للسحب)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 54, 0, 54)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🎯"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 69, 0)
FloatingIcon.TextSize = 26

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 69, 0)
IconStroke.Thickness = 2.5
IconStroke.Parent = FloatingIcon

-- النافذة الرئيسية للقائمة (تم تكبيرها قليلاً لتسع الأزرار الجديدة)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -175)
MainFrame.Size = UDim2.new(0, 340, 0, 300)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 69, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
TopBar.Size = UDim2.new(1, 0, 0, 48)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local FixFrame = Instance.new("Frame")
FixFrame.Parent = TopBar
FixFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
FixFrame.BorderSizePixel = 0
FixFrame.Position = UDim2.new(0, 0, 0.5, 0)
FixFrame.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BLOCKSPIN | Pro Hub"
Title.TextColor3 = Color3.fromRGB(255, 69, 0)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق القائمة (X)
local CloseXBtn = Instance.new("TextButton")
CloseXBtn.Parent = TopBar
CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseXBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseXBtn.Size = UDim2.new(0, 26, 0, 26)
CloseXBtn.Font = Enum.Font.SourceSansBold
CloseXBtn.Text = "X"
CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseXBtn.TextSize = 13
CloseXBtn.AutoButtonColor = false

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(1, 0)
XCorner.Parent = CloseXBtn

-- حاوية العناصر الداخلية
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 12)

local UIPad = Instance.new("UIPadding")
UIPad.Parent = Container
UIPad.PaddingTop = UDim.new(0, 5)

-- دالة إنشاء أزرار الخصائص
local function createFeatureToggle(name, desc)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Size = UDim2.new(0.9, 0, 0, 58)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = ""
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1.2
    stroke.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 16, 0, 9)
    nameLabel.Size = UDim2.new(0.7, 0, 0, 20)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 15
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = btn
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 16, 0, 30)
    statusLabel.Size = UDim2.new(0.7, 0, 0, 18)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Text = "Status: [ OFF ]"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 13
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    return btn, statusLabel, stroke
end

local SilentAimBtn, SilentStatus, SilentStroke = createFeatureToggle("Silent Aim", "تصويب صامت داخل الدائرة")
local EspBtn, EspStatus, EspStroke = createFeatureToggle("Players ESP", "كشف وتلوين الأجسام بوضوح")

-- إنشاء قسم التحكم بحجم دائرة الـ FOV
local FovControlFrame = Instance.new("Frame")
FovControlFrame.Parent = Container
FovControlFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
FovControlFrame.Size = UDim2.new(0.9, 0, 0, 55)

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(0, 12)
FovCorner.Parent = FovControlFrame

local FovStroke = Instance.new("UIStroke")
FovStroke.Color = Color3.fromRGB(50, 50, 70)
FovStroke.Thickness = 1.2
FovStroke.Parent = FovControlFrame

local FovLabel = Instance.new("TextLabel")
FovLabel.Parent = FovControlFrame
FovLabel.BackgroundTransparency = 1
FovLabel.Position = UDim2.new(0, 16, 0, 0)
FovLabel.Size = UDim2.new(0.5, 0, 1, 0)
FovLabel.Font = Enum.Font.SourceSansBold
FovLabel.Text = "FOV Size: " .. FOV_Radius
FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovLabel.TextSize = 14
FovLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر التصغير (-)
local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = FovControlFrame
MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinusBtn.Position = UDim2.new(1, -85, 0.5, -16)
MinusBtn.Size = UDim2.new(0, 32, 0, 32)
MinusBtn.Font = Enum.Font.SourceSansBold
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 18

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 8)
MinusCorner.Parent = MinusBtn

-- زر التكبير (+)
local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = FovControlFrame
PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
PlusBtn.Position = UDim2.new(1, -42, 0.5, -16)
PlusBtn.Size = UDim2.new(0, 32, 0, 32)
PlusBtn.Font = Enum.Font.SourceSansBold
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 18

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 8)
PlusCorner.Parent = PlusBtn

MinusBtn.MouseButton1Click:Connect(function()
    if FOV_Radius > 40 then
        FOV_Radius = FOV_Radius - 15
        fovCircle.Radius = FOV_Radius
        FovLabel.Text = "FOV Size: " .. FOV_Radius
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    if FOV_Radius < 300 then
        FOV_Radius = FOV_Radius + 15
        fovCircle.Radius = FOV_Radius
        FovLabel.Text = "FOV Size: " .. FOV_Radius
    end
end)

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

FloatingIcon.MouseButton1Click:Connect(toggleMenu)
CloseXBtn.MouseButton1Click:Connect(toggleMenu)

local function setupFeatureLogic(button, statusLabel, stroke, callback)
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            statusLabel.Text = "Status: [ ACTIVE ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 69, 0)
            stroke.Color = Color3.fromRGB(255, 69, 0)
            task.spawn(function()
                callback(true)
            end)
        else
            statusLabel.Text = "Status: [ OFF ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            stroke.Color = Color3.fromRGB(50, 50, 70)
            callback(false)
        end
    end)
end

-- دالة لاختيار أقرب هدف داخل دائرة الفوف (تستهدف الرأس أو الجسم لتكون طبيعية)
local function getClosestTargetInFOV()
    local closestTarget = nil
    local shortestDist = fovCircle.Radius
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local partToTarget = math.random(1, 10) <= 3 and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if partToTarget then
                local screenPos, onScreen = Camera:WorldToViewportPoint(partToTarget.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = partToTarget
                    end
                end
            end
        end
    end
    return closestTarget
end

-- 1. منطق الـ Silent Aim الآمن (بدون تجميد الشاشة)
local silentAimEnabled = false
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if silentAimEnabled and not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        local targetPart = getClosestTargetInFOV()
        if targetPart and self == Workspace then
            if method == "Raycast" and args[1] and args[2] then
                local origin = args[1]
                args[2] = (targetPart.Position - origin).Unit * args[2].Magnitude
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

setupFeatureLogic(SilentAimBtn, SilentStatus, SilentStroke, function(enabled)
    silentAimEnabled = enabled
    fovCircle.Visible = enabled
end)

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- 2. منطق الـ ESP المطور (تلوين أجسام اللاعبين فقط + رصد اللاعبين الجدد تلقائياً)
local espEnabled = false
local activeHighlights = {}

local function applyHighlight(char)
    if char and not char:FindFirstChild("BlockSpinHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "BlockSpinHighlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 69, 0)      -- لون التعبئة (برتقالي مميز)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- لون الحدود (أبيض)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.Parent = char
        table.insert(activeHighlights, hl)
    end
end

setupFeatureLogic(EspBtn, EspStatus, EspStroke, function(enabled)
    espEnabled = enabled
    if enabled then
        -- تفعيل على الموجودين حالياً
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                applyHighlight(p.Character)
            end
        end
    else
        -- إزالة التلوين عند الإيقاف
        for _, hl in ipairs(activeHighlights) do
            if hl then hl:Destroy() end
        end
        activeHighlights = {}
    end
end)

-- رصد اللاعبين الجدد أو من يعيدون إحياء أنفسهم تلقائياً
for _, p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function(char)
        if espEnabled then
            task.wait(0.5)
            applyHighlight(char)
        end
    end)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if espEnabled then
            task.wait(0.5)
            applyHighlight(char)
        end
    end)
end)

-- سحب وإفلات الأيقونة العائمة بسلاسة
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("BlockSpin Pro Hub - Final Fixed Version Loaded!")
