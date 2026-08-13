-- ==========================================
-- IRON SOUL CUSTOM HUD (V6: ULTRA MODERN, SCALE SLIDER, TWEEN ANIMATION)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

-- Bersihkan UI sebelumnya
if CoreGui:FindFirstChild("IronSoulCustomHUD") then
    CoreGui.IronSoulCustomHUD:Destroy()
end

local IronSoulGui = Instance.new("ScreenGui")
IronSoulGui.Name = "IronSoulCustomHUD"
IronSoulGui.Parent = CoreGui

-- ==========================================
-- FLOATING ICON (IKON MINIMIZE)
-- ==========================================
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "FloatingIcon"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0.5, -25, 0, 20)
OpenButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenButton.Image = "rbxassetid://7733674079" 
OpenButton.Visible = false 
OpenButton.Parent = IronSoulGui

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(220, 180, 50) 
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

-- ==========================================
-- BINGKAI UTAMA & UISCALE
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
MainFrame.BackgroundTransparency = 0 
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false 
MainFrame.Parent = IronSoulGui

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1 
MainScale.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 115, 20)) 
}
UIGradient.Rotation = 45 
UIGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 160, 40)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- ==========================================
-- TOP BAR
-- ==========================================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1 
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🗡️ IRON SOUL HUB"
Title.TextColor3 = Color3.fromRGB(255, 220, 100) 
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 1, 0)
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0.8
Divider.BorderSizePixel = 0
Divider.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

local SettingMenuBtn = Instance.new("TextButton")
SettingMenuBtn.Size = UDim2.new(0, 35, 0, 35)
SettingMenuBtn.Position = UDim2.new(1, -85, 0, 5)
SettingMenuBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingMenuBtn.BackgroundTransparency = 0.5
SettingMenuBtn.Text = "⚙️"
SettingMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingMenuBtn.Font = Enum.Font.GothamBold
SettingMenuBtn.TextSize = 16
SettingMenuBtn.Parent = TopBar
Instance.new("UICorner", SettingMenuBtn).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- MENU SETTING (DROPDOWN KANAN ATAS)
-- ==========================================
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 200, 0, 260)
SettingsPanel.Position = UDim2.new(1, -210, 0, 50) 
SettingsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 10
SettingsPanel.Parent = MainFrame
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", SettingsPanel).Color = Color3.fromRGB(180, 140, 20)

local ProfilePic = Instance.new("ImageLabel")
ProfilePic.Size = UDim2.new(0, 40, 0, 40)
ProfilePic.Position = UDim2.new(0, 15, 0, 15)
ProfilePic.BackgroundColor3 = Color3.fromRGB(40,40,40)
ProfilePic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
ProfilePic.ZIndex = 11
ProfilePic.Parent = SettingsPanel
Instance.new("UICorner", ProfilePic).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ProfilePic).Color = Color3.fromRGB(180, 140, 20)

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -70, 0, 40)
ProfileName.Position = UDim2.new(0, 65, 0, 15)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = player.DisplayName
ProfileName.TextColor3 = Color3.fromRGB(255,255,255)
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 12
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.TextWrapped = true
ProfileName.ZIndex = 11
ProfileName.Parent = SettingsPanel

local function CreateSettingToggle(yPos, text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 35)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(180, 140, 20) or Color3.fromRGB(40,40,40)
    btn.Text = text .. (defaultState and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.ZIndex = 11
    btn.Parent = SettingsPanel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(180, 140, 20) or Color3.fromRGB(40,40,40)}):Play()
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        if callback then callback(state) end
    end)
end

CreateSettingToggle(70, "Glass Effect", false, function(state)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = state and 0.25 or 0}):Play()
end)
CreateSettingToggle(115, "Auto Save", true, function(state) end)

local ScaleLabel = Instance.new("TextLabel")
ScaleLabel.Size = UDim2.new(1, -30, 0, 20)
ScaleLabel.Position = UDim2.new(0, 15, 0, 160)
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Text = "UI Scale: 100%"
ScaleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ScaleLabel.Font = Enum.Font.GothamMedium
ScaleLabel.TextSize = 11
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
ScaleLabel.ZIndex = 11
ScaleLabel.Parent = SettingsPanel

local ScaleBG = Instance.new("TextButton")
ScaleBG.Size = UDim2.new(1, -30, 0, 8)
ScaleBG.Position = UDim2.new(0, 15, 0, 180)
ScaleBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScaleBG.Text = ""
ScaleBG.ZIndex = 11
ScaleBG.Parent = SettingsPanel
Instance.new("UICorner", ScaleBG).CornerRadius = UDim.new(1, 0)

local ScaleFill = Instance.new("Frame")
ScaleFill.Size = UDim2.new(1, 0, 1, 0)
ScaleFill.BackgroundColor3 = Color3.fromRGB(180, 140, 20)
ScaleFill.ZIndex = 12
ScaleFill.Parent = ScaleBG
Instance.new("UICorner", ScaleFill).CornerRadius = UDim.new(1, 0)

local draggingScale = false
ScaleBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingScale = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingScale = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingScale and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local bgPos = ScaleBG.AbsolutePosition.X
        local bgSize = ScaleBG.AbsoluteSize.X
        local percentage = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
        local scaleValue = 0.75 + (percentage * 0.25)
        ScaleFill.Size = UDim2.new(percentage, 0, 1, 0)
        ScaleLabel.Text = "UI Scale: " .. math.floor(scaleValue * 100) .. "%"
        MainScale.Scale = scaleValue
    end
end)

local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(1, -30, 0, 30)
UnloadBtn.Position = UDim2.new(0, 15, 1, -40)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
UnloadBtn.Text = "Unload ❌"
UnloadBtn.TextColor3 = Color3.fromRGB(255,255,255)
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.TextSize = 12
UnloadBtn.ZIndex = 11
UnloadBtn.Parent = SettingsPanel
Instance.new("UICorner", UnloadBtn).CornerRadius = UDim.new(0, 8)

UnloadBtn.MouseButton1Click:Connect(function()
    IronSoulGui:Destroy()
end)

SettingMenuBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

-- ==========================================
-- LOGIKA MINIMIZE & DRAG
-- ==========================================
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
    SettingsPanel.Visible = false
end)

local function MakeDraggable(guiObject, dragTarget)
    local dragging, dragInput, dragStart, startPos
    local hasDragged = false

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasDragged = false
            dragStart = input.Position
            startPos = dragTarget.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if guiObject == OpenButton and not hasDragged then
                        OpenButton.Visible = false
                        MainFrame.Visible = true
                    end
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = (input.Position - dragStart) / (dragTarget == MainFrame and MainScale.Scale or 1)
            if delta.Magnitude > 5 then hasDragged = true end
            dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(TopBar, MainFrame)
MakeDraggable(OpenButton, OpenButton)

-- ==========================================
-- SIDEBAR & TAB CONTENT
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -65)
Sidebar.Position = UDim2.new(0, 15, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BackgroundTransparency = 0.5 
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -165, 1, -65)
ContentArea.Position = UDim2.new(0, 155, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentArea.BackgroundTransparency = 0.5
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 10)

local Tabs = {}
local Pages = {}

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Sidebar
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = Sidebar
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 0.95
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 13
    TabButton.Parent = Sidebar
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(180, 140, 20)
    Page.Visible = false 
    Page.Parent = ContentArea
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 10)

    TabButton.MouseButton1Click:Connect(function()
        for _, btn in pairs(Tabs) do 
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end
        for _, pg in pairs(Pages) do pg.Visible = false end
        
        TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 220, 100)}):Play()
        Page.Visible = true
    end)

    table.insert(Tabs, TabButton)
    table.insert(Pages, Page)
    return Page
end

-- ==========================================
-- POP-UP UNLOAD CONFIRMATION (VELLURE STYLE)
-- ==========================================
local UnloadOverlay = Instance.new("Frame")
UnloadOverlay.Size = UDim2.new(1, 0, 1, 0)
UnloadOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UnloadOverlay.BackgroundTransparency = 1 -- Default invisible
UnloadOverlay.Visible = false
UnloadOverlay.ZIndex = 50
UnloadOverlay.Parent = MainFrame
Instance.new("UICorner", UnloadOverlay).CornerRadius = UDim.new(0, 15)

local UnloadPopup = Instance.new("Frame")
UnloadPopup.Size = UDim2.new(0, 250, 0, 120)
UnloadPopup.Position = UDim2.new(0.5, -125, 0.5, -60)
UnloadPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UnloadPopup.ZIndex = 51
UnloadPopup.Parent = UnloadOverlay
Instance.new("UICorner", UnloadPopup).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", UnloadPopup).Color = Color3.fromRGB(60, 60, 60)

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Size = UDim2.new(1, -30, 0, 30)
PopupTitle.Position = UDim2.new(0, 15, 0, 10)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text = "Unload\nClose Vellure?"
PopupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupTitle.Font = Enum.Font.GothamMedium
PopupTitle.TextSize = 13
PopupTitle.TextXAlignment = Enum.TextXAlignment.Left
PopupTitle.ZIndex = 52
PopupTitle.Parent = UnloadPopup

local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Size = UDim2.new(0.4, 0, 0, 30)
ConfirmBtn.Position = UDim2.new(0, 15, 1, -45)
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ConfirmBtn.Text = "Unload"
ConfirmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ConfirmBtn.Font = Enum.Font.GothamSemibold
ConfirmBtn.TextSize = 12
ConfirmBtn.ZIndex = 52
ConfirmBtn.Parent = UnloadPopup
Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ConfirmBtn).Color = Color3.fromRGB(60, 60, 60)

local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(0.4, 0, 0, 30)
CancelBtn.Position = UDim2.new(1, -115, 1, -45)
CancelBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CancelBtn.Text = "Cancel"
CancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CancelBtn.Font = Enum.Font.GothamSemibold
CancelBtn.TextSize = 12
CancelBtn.ZIndex = 52
CancelBtn.Parent = UnloadPopup
Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 8)

-- Logika Tombol Unload di Settings Panel
UnloadBtn.MouseButton1Click:Connect(function()
    UnloadOverlay.Visible = true
    TweenService:Create(UnloadOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)

CancelBtn.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(UnloadOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    tw:Play()
    tw.Completed:Connect(function() UnloadOverlay.Visible = false end)
end)

ConfirmBtn.MouseButton1Click:Connect(function()
    IronSoulGui:Destroy()
end)

-- ==========================================
-- BUAT TAB & SET TAB PERTAMA AKTIF DEFAULT
-- ==========================================
local CombatTab = CreateTab("⚔️ Combat")
local RunsTab = CreateTab("👁️ Runs")
local GearTab = CreateTab("⭐ Gear")
local PetsTab = CreateTab("✨ Pets")
local MiscTab = CreateTab("🔗 Misc")
local InterfaceTab = CreateTab("⚙️ Interface")

Tabs[1].BackgroundTransparency = 0.2
Tabs[1].TextColor3 = Color3.fromRGB(255, 220, 100)
Pages[1].Visible = true

-- MENGEMBALIKAN TAB AGAR BISA DIPANGGIL OLEH FILE MAIN.LUA
return {
    Combat = CombatTab,
    Runs = RunsTab,
    Gear = GearTab,
    Pets = PetsTab,
    Misc = MiscTab,
    Interface = InterfaceTab
}
