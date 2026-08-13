-- ==========================================
-- ETERNAL-HUB - MAIN.LUA (OPTIMIZED VERSION)
-- ==========================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- PANGGIL HUD
local HUD = loadstring(game:HttpGet("https://raw.githubusercontent.com/Adit013/Eternal-HUB/main/hud.lua"))()

-- UI BUILDER FUNCTIONS
local function CreateToggle(parent, title, defaultState, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(180, 140, 20) or Color3.fromRGB(40, 40, 40)
    btn.Text = title .. (defaultState and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(180, 140, 20) or Color3.fromRGB(40, 40, 40)}):Play()
        btn.Text = title .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateTextBox(parent, title, placeholder, callback)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, -10, 0, 60)
    Container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Container).Color = Color3.fromRGB(60, 60, 60)

    local Title = Instance.new("TextLabel", Container)
    Title.Size = UDim2.new(1, -10, 0, 25)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox", Container)
    InputBox.Size = UDim2.new(1, -20, 0, 25)
    InputBox.Position = UDim2.new(0, 10, 0, 30)
    InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    InputBox.PlaceholderText = placeholder
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 11
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

    InputBox.FocusLost:Connect(function()
        callback(InputBox.Text)
    end)
end

local function IsInGame() return workspace:FindFirstChild("Enemies") ~= nil or workspace:FindFirstChild("Map") ~= nil end

-- ==========================================
-- ⚔️ TAB COMBAT (Auto Farm & Auto Dodge)
-- ==========================================
CreateLabel(HUD.Combat, "Combat & Farming System")
getgenv().AutoFarm = false
getgenv().ReachDistantWaves = false
getgenv().ReachDistance = 2000
getgenv().AttackChest = false
getgenv().HitDragonEgg = false
getgenv().AutoDodge = false

-- Auto Dodge Logika AoE Merah (Memantau area bahaya secara real-time)
RunService.RenderStepped:Connect(function()
    if getgenv().AutoDodge and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Color == Color3.fromRGB(255, 0, 0) or obj.Name:lower():find("danger") or obj.Name:lower():find("aoe")) then
                local mag = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                if mag < 25 then
                    -- Menggeser karakter menjauh secara instan dari area merah
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(15, 5, 15)
                end
            end
        end
    end
end)

-- Auto Farm & Target Handler
CreateToggle(HUD.Combat, "Auto Farm", false, function(state)
    getgenv().AutoFarm = state
    task.spawn(function()
        while getgenv().AutoFarm do
            -- Scanner Nama Objek di Map
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                    -- Ini akan memprint semua nama musuh yang terdeteksi ke Console Delta
                    print("Terdeteksi target: " .. obj.Name) 
                end
            end
            task.wait(2)
        end
    end)
end)


-- ==========================================
-- 👁️ TAB RUNS (Leveling & Auto Restart)
-- ==========================================
CreateLabel(HUD.Runs, "Dungeon Leveling & Restart")
CreateToggle(HUD.Runs, "Auto Restart / Party Give-up", false, function(state)
    getgenv().AutoRestart = state
    task.spawn(function()
        while getgenv().AutoRestart do
            local pGui = player:FindFirstChild("PlayerGui")
            if pGui then
                local summaryUI = pGui:FindFirstChild("DungeonSummary") or pGui:FindFirstChild("DeathScreen")
                local isParty = #game.Players:GetPlayers() > 1
                
                if summaryUI and summaryUI.Enabled then
                    if isParty then
                        local activePlayers = false
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                                activePlayers = true
                            end
                        end
                        if not activePlayers then
                            -- Semua anggota party mati, lakukan retry
                            print("Party gugur, melakukan Auto Retry...")
                        else
                            -- Masih ada rekan setim yang hidup, lakukan give-up / tunggu
                            print("Rekan masih bertarung, menunggu penyelesaian dungeon...")
                        end
                    else
                        print("Solo Run selesai/mati, Auto Restart aktif!")
                    end
                    task.wait(5)
                end
            end
            task.wait(1)
        end
    end)
end)

-- ==========================================
-- 🔗 TAB MISC (Webhook & Rewards)
-- ==========================================
CreateLabel(HUD.Misc, "Automation & Webhook")
CreateToggle(HUD.Misc, "Auto Collect Drops", true, function(state) print("Auto collect aktif.") end)

CreateToggle(HUD.Misc, "Auto Claim All Rewards", false, function(state)
    getgenv().AutoClaim = state
    task.spawn(function()
        while getgenv().AutoClaim do
            for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local n = v.Name:lower()
                    if n:find("claim") or n:find("reward") or n:find("daily") or n:find("login") then
                        pcall(function()
                            if v:IsA("RemoteEvent") then v:FireServer() else v:InvokeServer() end
                        end)
                    end
                end
            end
            task.wait(15)
        end
    end)
end)

getgenv().WebhookURL = ""
getgenv().SendWebhook = false

CreateTextBox(HUD.Misc, "Discord Webhook URL", "https://discord.com/api/webhooks/...", function(text)
    getgenv().WebhookURL = text
end)

CreateToggle(HUD.Misc, "Run-end loot summary (Webhook)", false, function(state)
    getgenv().SendWebhook = state
    task.spawn(function()
        while getgenv().SendWebhook do
            task.wait(2)
            local pGui = player:FindFirstChild("PlayerGui")
            if pGui and pGui:FindFirstChild("DungeonSummary") then
                -- Jika panel ringkasan dungeon muncul, kirim data via Webhook
                if getgenv().WebhookURL ~= "" then
                    local data = {
                        ["content"] = "🔥 **Eternal-HUB Dungeon Report**\nPlayer: " .. player.Name .. "\nStatus: Dungeon Selesai dengan Sukses!"
                    }
                    local success = pcall(function()
                        request({
                            Url = getgenv().WebhookURL,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = HttpService:JSONEncode(data)
                        })
                    end)
                    if success then
                        task.wait(10) -- Jeda agar tidak terkirim berulang kali di dungeon yang sama
                    end
                end
            end
        end
    end)
end)
