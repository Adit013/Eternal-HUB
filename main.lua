-- ==========================================
-- IRON SOUL HUB - MAIN.LUA (OTAK FITUR)
-- ==========================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- PANGGIL TAMPILAN HUD (WAJIB GANTI LINK INI DENGAN RAW LINK HUD.LUA ANDA!)
local HUD = loadstring(game:HttpGet("https://raw.githubusercontent.com/Adit013/Eternal-HUB/main/hud.lua"))()

-- FUNGSI UI BUILDER
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

    -- Logika menyimpan teks saat selesai mengetik
    InputBox.FocusLost:Connect(function()
        callback(InputBox.Text)
    end)
end


local function IsInGame() return workspace:FindFirstChild("Enemies") ~= nil end

-- ==========================================
-- ⚔️ TAB COMBAT
-- ==========================================
CreateLabel(HUD.Combat, "Auto Farm & Targets")
getgenv().AutoFarm = false
getgenv().ReachDistantWaves = false
getgenv().ReachDistance = 2000
getgenv().AttackChest = false
getgenv().HitDragonEgg = false
getgenv().AutoDodge = false

CreateToggle(HUD.Combat, "Auto Farm", false, function(state)
    getgenv().AutoFarm = state
    task.spawn(function()
        while getgenv().AutoFarm do
            if IsInGame() then
                local target = nil
                local targetHRP = nil
                local jarakTerdekat = math.huge
                
                -- Deteksi Musuh, Chest, atau Telur Naga
                for _, obj in pairs(workspace:GetChildren()) do
                    local isValidTarget = false
                    if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        if obj.Name ~= player.Name then isValidTarget = true end
                        if obj.Name == "Chest" and not getgenv().AttackChest then isValidTarget = false end
                        if obj.Name == "DragonEgg" and getgenv().HitDragonEgg then
                            -- Trigger Telur Naga jika ada ProximityPrompt
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                            isValidTarget = true
                        elseif obj.Name == "DragonEgg" and not getgenv().HitDragonEgg then
                            isValidTarget = false
                        end
                    end
                    
                    if isValidTarget and obj:FindFirstChild("HumanoidRootPart") then
                        local mag = (player.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                        -- Logika Reach Distant Waves
                        if not getgenv().ReachDistantWaves or (getgenv().ReachDistantWaves and mag <= getgenv().ReachDistance) then
                            if mag < jarakTerdekat then jarakTerdekat = mag; target = obj; targetHRP = obj.HumanoidRootPart end
                        end
                    end
                end
                
                -- Logika Auto Dodge AoE Merah
                local dodgeOffset = CFrame.new(0, 5, 0)
                if getgenv().AutoDodge then
                    for _, aoe in pairs(workspace:GetChildren()) do
                        if aoe:IsA("Part") and aoe.Color == Color3.fromRGB(255,0,0) and aoe.Transparency > 0 then
                            local aoeMag = (player.Character.HumanoidRootPart.Position - aoe.Position).Magnitude
                            if aoeMag < (aoe.Size.X / 2) + 20 then -- 20 studs safety margin
                                dodgeOffset = CFrame.new(0, 20, 20) -- Mundur kejut
                            end
                        end
                    end
                end
                
                if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    player.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * dodgeOffset
                end
            end
            task.wait(0.1)
        end
    end)
end)

CreateToggle(HUD.Combat, "Auto Dodge", false, function(state) getgenv().AutoDodge = state end)
CreateToggle(HUD.Combat, "Reach Distant Waves", false, function(state) getgenv().ReachDistantWaves = state end)
CreateToggle(HUD.Combat, "Attack Chests", false, function(state) getgenv().AttackChest = state end)
CreateToggle(HUD.Combat, "Hit Dragon Eggs", false, function(state) getgenv().HitDragonEgg = state end)

CreateToggle(HUD.Combat, "Auto Progress", false, function(state)
    getgenv().AutoProgress = state
    task.spawn(function()
        while getgenv().AutoProgress do
            if IsInGame() then
                -- Mencari semua objek di map yang berbau pintu atau portal
                for _, obj in pairs(workspace:GetChildren()) do
                    local objName = obj.Name:lower()
                    if objName:match("door") or objName:match("portal") or objName:match("gate") then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            
                            -- Cek apakah objek tersebut PINTU (punya tombol E)
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                -- Curangi game: Ubah durasi tahan E menjadi 0 detik agar instan
                                prompt.HoldDuration = 0 
                                fireproximityprompt(prompt)
                                print("Membuka pintu!")
                            else
                                -- Jika tidak ada tombol E, berarti PORTAL (tabrakkan badan)
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.1) -- Jeda sebentar agar server mendeteksi tabrakan
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                                print("Memasuki portal!")
                            end
                            
                        end
                    end
                end
            end
            task.wait(1.5) -- Pengecekan setiap 1.5 detik
        end
    end)
end)


-- ==========================================
-- 👁️ TAB RUNS
-- ==========================================
CreateLabel(HUD.Runs, "Auto Restart & Health")
CreateToggle(HUD.Runs, "Auto Restart", false, function(state)
    getgenv().AutoRestart = state
    task.spawn(function()
        while getgenv().AutoRestart do
            -- Mengecek UI Summary / Kematian
            local pGui = player:WaitForChild("PlayerGui")
            local isParty = #game.Players:GetPlayers() > 1
            
            if pGui:FindFirstChild("DeathScreen") or pGui:FindFirstChild("DungeonSummary") then
                if isParty then
                    -- Cek apakah sisa pemain masih hidup
                    local allDead = true
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            allDead = false
                        end
                    end
                    if allDead then
                        print("Semua party mati, auto retry!")
                        -- Fire remote retry
                    else
                        print("Party masih hidup, auto give up / wait!")
                        -- Fire remote give up
                    end
                else
                    print("Solo, auto retry!")
                    -- Fire remote retry
                end
                task.wait(5)
            end
            task.wait(1)
        end
    end)
end)

-- ==========================================
-- 🔗 TAB MISC
-- ==========================================
CreateLabel(HUD.Misc, "Rewards & Webhook")
CreateToggle(HUD.Misc, "Auto Collect Drops", true, function(state) print("Auto collect diaktifkan (bawaan sistem).") end)

CreateToggle(HUD.Misc, "Auto Claim All Rewards", false, function(state)
    getgenv().AutoClaim = state
    task.spawn(function()
        while getgenv().AutoClaim do
            -- Scanner RemoteEvent Otomatis untuk Klaim Hadiah
            for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local name = v.Name:lower()
                    if name:find("claim") or name:find("reward") or name:find("daily") or name:find("login") then
                        pcall(function()
                            if v:IsA("RemoteEvent") then v:FireServer() else v:InvokeServer() end
                        end)
                    end
                end
            end
            task.wait(10) -- Scan setiap 10 detik agar tidak spam
        end
    end)
end)

-- ==========================
-- FITUR WEBHOOK DISCORD
-- ==========================
getgenv().WebhookURL = "" 
getgenv().SendWebhook = false

-- Kolom input URL Webhook
CreateTextBox(HUD.Misc, "Discord Webhook URL", "https://discord.com/api/webhooks/...", function(text)
    getgenv().WebhookURL = text
    print("Webhook URL tersimpan!")
end)

-- Tombol On/Off untuk mengirim Webhook
CreateToggle(HUD.Misc, "Run-end loot summary", false, function(state)
    getgenv().SendWebhook = state
    
    if getgenv().SendWebhook and getgenv().WebhookURL == "" then
        warn("Silakan masukkan URL Webhook terlebih dahulu!")
    end
end)
