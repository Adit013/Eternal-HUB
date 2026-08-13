-- ==========================================
-- IRON SOUL HUB - MAIN.LUA (OTAK FITUR)
-- ==========================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- 1. PANGGIL TAMPILAN HUD (WAJIB GANTI LINK INI!)
-- Ganti tulisan "LINK_RAW_HUD_LUA_ANDA" dengan link raw file hud.lua Anda di GitHub
local HUD = loadstring(game:HttpGet("LINK_RAW_HUD_LUA_ANDA"))()

-- ==========================================
-- FUNGSI BANTUAN PEMBUAT UI (TOMBOL, SLIDER, DROPDOWN)
-- ==========================================
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

-- ==========================================
-- SISTEM PENGECEKAN WORLD
-- ==========================================
local function IsInGame()
    -- Cek apakah karakter ada di dalam zona pertarungan/dungeon
    return workspace:FindFirstChild("Enemies") ~= nil 
end

-- ==========================================
-- TAHAP 1: FITUR COMBAT
-- ==========================================
CreateLabel(HUD.Combat, "⚔️ AUTO FARM SETTINGS")

getgenv().AutoFarm = false
getgenv().TinggiDariMusuh = 5
getgenv().JarakBelakang = 0
getgenv().AutoSkill = false

CreateToggle(HUD.Combat, "Aktifkan Auto Farm", false, function(state)
    getgenv().AutoFarm = state
    task.spawn(function()
        while getgenv().AutoFarm do
            if IsInGame() then
                local target = nil
                local jarakTerdekat = math.huge
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Name ~= player.Name then
                        if obj.Humanoid.Health > 0 then
                            local mag = (player.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                            if mag < jarakTerdekat then jarakTerdekat = mag; target = obj end
                        end
                    end
                end
                
                if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Velocity = Vector3.new(0,0,0) -- Anti terpental
                    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().TinggiDariMusuh, getgenv().JarakBelakang)
                end
            end
            task.wait(0.1)
        end
    end)
end)

CreateToggle(HUD.Combat, "Aktifkan Auto Skill (1, 2, Ulti)", false, function(state)
    getgenv().AutoSkill = state
    -- Logika eksekusi skill ditaruh di sini nanti setelah tahu RemoteEvent-nya
end)

CreateToggle(HUD.Combat, "Aktifkan Noclip", false, function(state)
    -- Logika Noclip (Tembus tembok saat auto farm)
end)

-- ==========================================
-- TAHAP 2: FITUR DUNGEON
-- ==========================================
CreateLabel(HUD.Dungeon, "🏰 AUTO DUNGEON SETTINGS")

CreateToggle(HUD.Dungeon, "Mulai Auto Dungeon", false, function(state)
    -- Logika masuk dungeon otomatis
end)

CreateToggle(HUD.Dungeon, "Auto Restart / Retry", true, function(state)
    -- Logika klik tombol retry saat dungeon selesai/mati
end)

CreateToggle(HUD.Dungeon, "Auto Collect (HP/EXP/Coin)", true, function(state)
    -- Logika magnet/teleport ke drop item
end)

-- ==========================================
-- TAHAP 3: FITUR EQUIPMENT
-- ==========================================
CreateLabel(HUD.Equipment, "🔨 FORGE SETTINGS")

CreateToggle(HUD.Equipment, "Auto Perfect Forge", false, function(state)
    -- Logika bypass/auto klik minigame forge
end)

-- ==========================================
-- TAHAP 4: FITUR MISC
-- ==========================================
CreateLabel(HUD.Misc, "🔗 WEBHOOK & FPS")

-- (Untuk TextBox URL Webhook butuh elemen UI khusus, sementara diganti Toggle aktif/mati)
CreateToggle(HUD.Misc, "Kirim Summary ke Discord", false, function(state)
    -- Logika pengiriman HTTP Post ke Webhook
end)

CreateToggle(HUD.Misc, "FPS Optimizer (No VFX/Pets)", false, function(state)
    if state then
        -- Menghapus tekstur dan efek agar tidak lag
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("ParticleEmitter") then v.Enabled = false end
        end
    end
end)

-- ==========================================
-- TAHAP 5: FITUR INTERFACE
-- ==========================================
CreateLabel(HUD.Interface, "⚙️ SYSTEM SETTINGS")

CreateToggle(HUD.Interface, "Auto Reconnect", true, function(state)
    -- Logika anti-disconnect / Rejoin server
end)

CreateToggle(HUD.Interface, "Auto Execute (Server Hop)", true, function(state)
    -- Logika sinkronisasi file auto-execute
end)

print("Main.lua Berhasil Dimuat dan Dihubungkan ke HUD!")
