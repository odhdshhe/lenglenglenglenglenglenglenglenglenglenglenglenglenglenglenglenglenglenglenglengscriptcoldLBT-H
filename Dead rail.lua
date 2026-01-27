local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local TweenService = cloneref(game:GetService("TweenService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local HttpService = cloneref(game:GetService("HttpService"))
local RbxAnalyticsService = cloneref(game:GetService("RbxAnalyticsService"))
local void =
    pcall(
    function()
        workspace.FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
    end
)

LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)

if Character:FindFirstChild("AntiSlideClientTest") then
    Character.AntiSlideClientTest:Destroy()
end
if Character:FindFirstChild("AntiSlide") then
    Character.AntiSlide:Destroy()
end
if Character:FindFirstChild("AntiFling") then
    Character.AntiFling:Destroy()
end
if Character:FindFirstChild("AntiFly") then
    Character.AntiFly:Destroy()
end

local function getnpc()
    local closestNPC = nil
    local closestDistance = math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local humanoid = v:FindFirstChild("Humanoid") or v:FindFirstChildWhichIsA("Humanoid")
            local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
            if humanoid and hrp and humanoid.Health > 0 then
                if not Players:GetPlayerFromCharacter(v) then
                    local distance = (hrp.Position - HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = v
                    end
                end
            end
        end
    end
    return closestNPC
end

local tplocation = {
    ["出生点"] = CFrame.new(56.6396217, 3.24999976, 29936.3516),
    ["10 KM"] = CFrame.new(-160.576843, 2.99617577, 19913.252),
    ["20 KM"] = CFrame.new(-556.92572, 2.98922157, 9956.79883),
    ["30 KM"] = CFrame.new(-569.779663, 2.99999976, 47.5958443),
    ["40 KM"] = CFrame.new(-184.494064, 3.14674306, -9899.91797),
    ["50 KM"] = CFrame.new(55.228714, 3.19885039, -19842.3789),
    ["60 KM"] = CFrame.new(-199.620743, 3.14927387, -29733.9453),
    ["70 KM"] = CFrame.new(-577.781921, 3.49909163, -39654.2148)
}

local function getseat(position)
    local closestSeat = nil
    local minDistance = math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            local distance = (v.Position - position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestSeat = v
            end
        end
    end
    return closestSeat
end

local selectedLocation = "Spawn"

local function tptl(locationName)
    if not Character then
        CharacterAdded:Wait()
    end
    if Character and HumanoidRootPart then
        local originalWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = 0
        HumanoidRootPart.CFrame = tplocation[locationName]
        HumanoidRootPart.Anchored = true
        task.wait(2)
        local fseat = getseat(HumanoidRootPart.Position)
        if fseat then
            HumanoidRootPart.CFrame = fseat.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.15)
            HumanoidRootPart.Anchored = false
            task.wait(0.5)
            fseat:Sit(Character:FindFirstChildOfClass("Humanoid"))
        else
            HumanoidRootPart.Anchored = false
        end
        task.wait(1)
        Humanoid.WalkSpeed = originalWalkSpeed
    end
end

local Setting = {
    AutoThrottle = false,
    Hitbox = 0,
    AimLock = false,
    AutoBurningFuel = false,
    AutoTeleporttoTrain = false,
    UseBandage = false,
    MinHealth = 30,
    Aimbot = false,
    Revive = false,
    MeleeHitAura = false,
    GunAura = false,
    Noclip = false,
    AutoRevive = false,
    QuickReload = false,
    SwordGuest = false,
    Reload = false,
    Quickshoot = false,
    AutoStores = false,
    Light = false,
    AutoCollectMoneybag = false,
    AutoCollectOther = false,
    AutoCollectBond = false,
    AutoCollectTool = false,
    AutoCollectAmmo = false,
    AutoCollectArmor = false,
    AutoBanjo = false,
    AutoSell = false,
    AutoThrow = false,
    AutoLever = false,
    EndGame = false,
    Loop = {
        items = nil,
        Ore = nil,
        Enemy = nil,
        Unicorn = nil,
        build = nil,
        zombie = nil,
        bank = nil,
        Outlaw = nil,
        Bond = nil,
        Hitbox = nil
    }
}

local rainbowBorderAnimation
local currentBorderColorScheme = "彩虹颜色"
local currentFontColorScheme = "彩虹颜色"
local borderInitialized = false
local animationSpeed = 2
local borderEnabled = true
local fontColorEnabled = false
local uiScale = 1
local blurEnabled = false
local soundEnabled = true

local FONT_STYLES = {
    "SourceSansBold","SourceSansItalic","SourceSansLight","SourceSans",
    "GothamSSm","GothamSSm-Bold","GothamSSm-Medium","GothamSSm-Light",
    "GothamSSm-Black","GothamSSm-Book","GothamSSm-XLight","GothamSSm-Thin",
    "GothamSSm-Ultra","GothamSSm-SemiBold","GothamSSm-ExtraLight","GothamSSm-Heavy",
    "GothamSSm-ExtraBold","GothamSSm-Regular","Gotham","GothamBold",
    "GothamMedium","GothamBlack","GothamLight","Arial","ArialBold",
    "Code","CodeLight","CodeBold","Highway","HighwayBold","HighwayLight",
    "SciFi","SciFiBold","SciFiItalic","Cartoon","CartoonBold","Handwritten"
}

local FONT_DESCRIPTIONS = {
    ["SourceSansBold"] = "标准粗体",["SourceSansItalic"] = "斜体",["SourceSansLight"] = "细体",
    ["SourceSans"] = "标准体",["GothamSSm"] = "哥特标准",["GothamSSm-Bold"] = "哥特粗体",
    ["GothamSSm-Medium"] = "哥特中等",["GothamSSm-Light"] = "哥特细体",["GothamSSm-Black"] = "哥特黑体",
    ["GothamSSm-Book"] = "哥特书本体",["GothamSSm-XLight"] = "哥特超细体",["GothamSSm-Thin"] = "哥特极细体",
    ["GothamSSm-Ultra"] = "哥特超黑体",["GothamSSm-SemiBold"] = "哥特半粗体",["GothamSSm-ExtraLight"] = "哥特特细体",
    ["GothamSSm-Heavy"] = "哥特粗重体",["GothamSSm-ExtraBold"] = "哥特特粗体",["GothamSSm-Regular"] = "哥特常规体",
    ["Gotham"] = "经典哥特体",["GothamBold"] = "经典哥特粗体",["GothamMedium"] = "经典哥特中等",
    ["GothamBlack"] = "经典哥特黑体",["GothamLight"] = "经典哥特细体",["Arial"] = "标准Arial体",
    ["ArialBold"] = "Arial粗体",["Code"] = "代码字体",["CodeLight"] = "代码细体",
    ["CodeBold"] = "代码粗体",["Highway"] = "高速公路体",["HighwayBold"] = "高速公路粗体",
    ["HighwayLight"] = "高速公路细体",["SciFi"] = "科幻字体",["SciFiBold"] = "科幻粗体",
    ["SciFiItalic"] = "科幻斜体",["Cartoon"] = "卡通字体",["CartoonBold"] = "卡通粗体",
    ["Handwritten"] = "手写体"
}

local currentFontStyle = "SourceSansBold"

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},
    ["黑红颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"alert-triangle"},
    ["蓝白颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["紫金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"crown"},
    ["蓝黑颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"moon"},
    ["绿紫颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00"))}),"zap"},
    ["粉蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4"))}),"heart"},
    ["橙青颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500"))}),"sun"},
    ["红金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000"))}),"award"},
    ["银蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")),ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0"))}),"star"},
    ["霓虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))}),"sparkles"},
    ["森林颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")),ColorSequenceKeypoint.new(1, Color3.fromHex("228B22"))}),"tree"},
    ["火焰颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00"))}),"flame"},
    ["海洋颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000080")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF"))}),"waves"},
    ["日落颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"sunset"},
    ["银河颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB"))}),"galaxy"},
    ["糖果颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"candy"},
    ["金属颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")),ColorSequenceKeypoint.new(1, Color3.fromHex("696969"))}),"shield"}
}

local fontColorAnimations = {}

local function applyFontColorGradient(textElement, colorScheme)
    if not textElement or not textElement:IsA("TextLabel") and not textElement:IsA("TextButton") and not textElement:IsA("TextBox") then
        return
    end
    
    local existingGradient = textElement:FindFirstChild("FontColorGradient")
    if existingGradient then
        existingGradient:Destroy()
    end
    
    if fontColorAnimations[textElement] then
        fontColorAnimations[textElement]:Disconnect()
        fontColorAnimations[textElement] = nil
    end
    
    if not fontColorEnabled then
        textElement.TextColor3 = Color3.new(1, 1, 1)
        return
    end
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentFontColorScheme]
    if not schemeData then return end
    
    local fontGradient = Instance.new("UIGradient")
    fontGradient.Name = "FontColorGradient"
    fontGradient.Color = schemeData[1]
    fontGradient.Rotation = 0
    fontGradient.Parent = textElement
    
    textElement.TextColor3 = Color3.new(1, 1, 1)
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not textElement or textElement.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        if not fontGradient or fontGradient.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        local time = tick()
        fontGradient.Rotation = (time * animationSpeed * 30) % 360
    end)
    
    fontColorAnimations[textElement] = animation
end

local function applyFontStyleToWindow(fontStyle)
    if not Window or not Window.UIElements then 
        wait(0.5)
        if not Window or not Window.UIElements then
            return false
        end
    end
    
    local successCount = 0
    local totalCount = 0
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                totalCount = totalCount + 1
                pcall(function()
                    child.Font = Enum.Font[fontStyle]
                    successCount = successCount + 1
                end)
            end
        end
    end
    
    processElement(Window.UIElements.Main)
    
    return successCount, totalCount
end

local function applyFontColorsToWindow(colorScheme)
    if not Window or not Window.UIElements then return end
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                applyFontColorGradient(child, colorScheme)
            end
        end
    end
    
    processElement(Window.UIElements.Main)
end

local function createRainbowBorder(window, colorScheme, speed)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil, nil
        end
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil, nil
    end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke, rainbowBorderAnimation
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke, nil
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end
    
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    
    local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

local function playSound()
    if soundEnabled then
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9047002353"
            sound.Volume = 0.3
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 2)
        end)
    end
end

local function applyBlurEffect(enabled)
    if enabled then
        pcall(function()
            local blur = Instance.new("BlurEffect")
            blur.Size = 8
            blur.Name = "UISX HUBBlur"
            blur.Parent = game:GetService("Lighting")
        end)
    else
        pcall(function()
            local existingBlur = game:GetService("Lighting"):FindFirstChild("UISX HUBBlur")
            if existingBlur then
                existingBlur:Destroy()
            end
        end)
    end
end

local function applyUIScale(scale)
    if Window and Window.UIElements and Window.UIElements.Main then
        local mainFrame = Window.UIElements.Main
        mainFrame.Size = UDim2.new(0, 600 * scale, 0, 400 * scale)
    end
end
local Confirmed = false
local gradientColors = {
    "rgb(255, 230, 235)",
    "rgb(255, 210, 220)",
    "rgb(255, 190, 205)",
    "rgb(255, 170, 190)",
    "rgb(255, 150, 175)",
    "rgb(245, 140, 180)",
    "rgb(235, 130, 185)",
    "rgb(225, 120, 190)",
    "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}
local username = game:GetService("Players").LocalPlayer.Name
local coloredUsername = ""
local gradientColors = {
    "#4169E1", 
    "#6A5ACD",  
    "#9370DB",  
    "#8A2BE2", 
    "#4B0082"   
}
local goldColor = "#FFD700"
for i = 1, #username do
    local char = username:sub(i, i)
    
  
    if char:match("[A-Za-z0-9]") then
    
        local colorIndex = (i - 1) % #gradientColors + 1
        coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. char .. '</font>'
    else
    
        coloredUsername = coloredUsername .. '<font color="' .. goldColor .. '">' .. char .. '</font>'
    end
end

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bailib/Roblox/refs/heads/main/main/ESP.lua"))()

ESP.AddFolder("Car")
ESP.AddFolder("OreESPFolder")
ESP.AddFolder("PlantESPFolder")
ESP.AddFolder("LootESPFolder")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/LENG8123/UI/refs/heads/main/Wind%20ui.lua"))()

local Image = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/LENGPICTURE.jpg")

local Image1 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/1761584153464.jpg")

local Image2 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/17786352553741696.jpeg")

local Image3 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/IMG_20251028_004626.jpg")

local Image4 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/_20251028010151167.png")

local Image5 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/c84a2c276c5ed34031cda1ce111d9686.jpeg")

local Image6 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/image_download_1761583901351.jpg")

local Image7 = game:HttpGet("https://raw.githubusercontent.com/LENG8123/PICTURE/refs/heads/main/quality_restoration_20251028010920212.jpg")

if not isfile("LENGPICTURE.jpg") then
    writefile("LENGPICTURE.jpg", Image)
end

if not isfile("1761584153464.jpg") then
    writefile("1761584153464.jpg", Image1)
end

if not isfile("17786352553741696.jpeg") then
    writefile("17786352553741696.jpeg", Image2)
end

if not isfile("IMG_20251028_004626.jpg") then
    writefile("IMG_20251028_004626.jpg", Image3)
end

if not isfile("_20251028010151167.png") then
    writefile("_20251028010151167.png", Image4)
end

if not isfile("c84a2c276c5ed34031cda1ce111d9686.jpeg") then
    writefile("c84a2c276c5ed34031cda1ce111d9686.jpeg", Image5)
end

if not isfile("image_download_1761583901351.jpg") then
    writefile("image_download_1761583901351.jpg", Image6)
end

if not isfile("quality_restoration_20251028010920212.jpg") then
    writefile("quality_restoration_20251028010920212.jpg", Image7)
end

local Confirmed = false

WindUI:Popup({
    Title = "尊贵的"..game.Players.LocalPlayer.DisplayName.."用户",
    Icon = "sparkles",
    IconThemed = true,
    Content = "欢迎使用此脚本",
    Buttons = {
        {
            Title = "取消",
            --Icon = "",
            Callback = function() end,
            Variant = "Secondary", -- Primary, Secondary, Tertiary
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary", -- Primary, Secondary, Tertiary
        }
    }
})

repeat task.wait() until Confirmed

local Window =
    WindUI:CreateWindow(
    {
        Title = "Action",
        Icon = "door-open",
        IconThemed = true,
        Author = "by 冷",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(300, 350), -- Increased size for new features
        Transparent = false,
        Theme = "Dark",
        User = {
            Enabled = false,
            Callback = function()
                print("clicked")
            end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = false,
        HideSearchBar = false,
        Background = getcustomasset("LENGPICTURE.jpg")
})

Window:SetBackgroundImage("")

Window:SetToggleKey(Enum.KeyCode.F)

Window:Tag({
        Title = "冷制作",
        Color = Color3.fromHex("#30ff6a")
    })
Window:Tag({
        Title = "付费版", 
        Color = Color3.fromHex("#315dff")
    })
local TimeTag = Window:Tag({
        Title = "00:00",
        Color = Color3.fromHex("#e53935")
    })
    
    local hue = 0
    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            
            TimeTag:SetTitle(hours .. ":" .. minutes)
            task.wait(0.06)
        end
    end)
    
local TimeTag = Window:Tag({
    Title = "新年倒计时: --",
    Color = Color3.fromHex("#f57c00")
})

local function getNextNewYear()
    local now = os.date("*t")
    local newYear = {
        year = now.year,
        month = 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }
    
    if now.month > 1 or (now.month == 1 and now.day > 1) then
        newYear.year = newYear.year + 1
    end
    return os.time(newYear)
end

task.spawn(function()
    local nextNewYear = getNextNewYear()
    while true do
        local now = os.time()
        local remaining = nextNewYear - now
        if remaining <= 0 then
            nextNewYear = getNextNewYear()
            remaining = nextNewYear - now
        end
        local days = math.floor(remaining / 86400)
        remaining = remaining % 86400
        local hours = math.floor(remaining / 3600)
        remaining = remaining % 3600
        local minutes = math.floor(remaining / 60)
        local seconds = remaining % 60
        local displayText
        if days > 0 then
            displayText = string.format("新年倒计时: %d天%02d:%02d:%02d", days, hours, minutes, seconds)
        else
            displayText = string.format("新年倒计时: %02d:%02d:%02d", hours, minutes, seconds)
        end
        TimeTag:SetTitle(displayText)
        hue = (hue + 0.01) % 1
        TimeTag:SetColor(Color3.fromHSV(hue, 1, 1))
        task.wait(1)
    end
end)

WindUI:AddTheme({
        Name = "Gradient-[1]",
        
        Text = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#AEEEEE"), Transparency = 0.3 },    
            ["50"] = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2 },
            ["100"] = { Color = Color3.fromHex("#6495ED"), Transparency = 0.2 },          
        }, {                                                                        
            Rotation = 0,                                                           
        }),              
                Button = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#F5DEB3"), Transparency = 0.3 },             
            ["50"]   = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2  }, 
            ["100"] = { Color = Color3.fromHex("#6495ED"), Transparency = 0.2 },       
        }, {                                                                        
            Rotation = 0,                                                           
        }),         
                    Dialog, Outline, Icon, Placeholder = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#FFB6C1"), Transparency = 0.3 },             
            ["100"]   = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2 },    
        }, {                                                                        
            Rotation = 0,                                                           
        }),                   
                                            
        Background = Color3.fromHex("#101010"),
    })

    WindUI:AddTheme({
        Name = "Gradient-[2]", 
        
        Text = WindUI:Gradient({          
            ["0"] = { Color = Color3.fromHex("#B0C4DE"), Transparency = 0.2 },    
            ["50"] = { Color = Color3.fromHex("#6495ED"), Transparency = 0.2 },                                  
            ["100"] = { Color = Color3.fromHex("#FFA07A"), Transparency = 0.3 },           
        }, {                                                                        
            Rotation = 0,                                                           
        }),              
                Button = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#F5DEB3"), Transparency = 0.3 },             
            ["50"]   = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2  }, 
            ["100"] = { Color = Color3.fromHex("#6495ED"), Transparency = 0.2 },       
        }, {                                                                        
            Rotation = 0,                                                           
        }),         
                    Dialog, Outline, Placeholder = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#FFB6C1"), Transparency = 0.3 },             
            ["100"]   = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2 },    
        }, {                                                                        
            Rotation = 0,                                                           
        }),                   
                                            
        Background = Color3.fromHex("#101010"),
    })
    WindUI:AddTheme({
        Name = "Gradient-[3]", 
        
        Text = WindUI:Gradient({          
            ["0"] = { Color = Color3.fromHex("#7B68EE"), Transparency = 0.2 },  
            ["50"] = { Color = Color3.fromHex("#DCDCDC"), Transparency = 0.2 },                                      
            ["100"] = { Color = Color3.fromHex("#2F4F4F"), Transparency = 0.3 },           
        }, {                                                                        
            Rotation = 0,                                                           
        }),              
                Button = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#4682B4"), Transparency = 0.2 }, 
            ["50"] = { Color = Color3.fromHex("#DCDCDC"), Transparency = 0.5 },             
            ["100"] = { Color = Color3.fromHex("#B0C4DE"), Transparency = 0.6 },       
        }, {                                                                        
            Rotation = 0,                                                           
        }),         
                    Dialog, Outline, Placeholder = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#556B2F"), Transparency = 0.4 },             
            ["100"]   = { Color = Color3.fromHex("#BC8F8F"), Transparency = 0.4 },    
        }, {                                                                        
            Rotation = 0,                                                           
        }),                   
                                            
        Background = Color3.fromHex("#101010"),
    })
        WindUI:AddTheme({
        Name = "Gradient-[4]", 
        
        Text = WindUI:Gradient({          
            ["0"] = { Color = Color3.fromHex("#B0C4DE"), Transparency = 0.2 },  
            ["50"] = { Color = Color3.fromHex("#F5F5DC"), Transparency = 0.2 },                                      
            ["100"] = { Color = Color3.fromHex("#E6E6FA"), Transparency = 0.3 },           
        }, {                                                                        
            Rotation = 0,                                                           
        }),              
                Button = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#6495ED"), Transparency = 0.3 }, 
            ["50"] = { Color = Color3.fromHex("#B0C4DE"), Transparency = 0.2 },             
            ["100"] = { Color = Color3.fromHex("#00BFFF"), Transparency = 0.2 },       
        }, {                                                                        
            Rotation = 0,                                                           
        }),         
                    Dialog, Outline, Placeholder = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#FFB6C1"), Transparency = 0.3 },             
            ["100"]   = { Color = Color3.fromHex("#D8BFD8"), Transparency = 0.2 },    
        }, {                                                                        
            Rotation = 0,                                                           
        }),                   
                                            
        Background = Color3.fromHex("#101010"),
    })
    WindUI:AddTheme({
        Name = "Gradient-[5]", 
        
        Text = WindUI:Gradient({          
            ["0"] = { Color = Color3.fromHex("#0000CD"), Transparency = 0.2 },  
            ["50"] = { Color = Color3.fromHex("#000000"), Transparency = 0.1 },                                      
            ["100"] = { Color = Color3.fromHex("#B0E0E6"), Transparency = 0.3 },           
        }, {                                                                        
            Rotation = 0,                                                           
        }),              
                Button = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#3CB371"), Transparency = 0.2 }, 
            ["50"] = { Color = Color3.fromHex("#DCDCDC"), Transparency = 0.5 },             
            ["100"] = { Color = Color3.fromHex("#20B2AA"), Transparency = 0.6 },       
        }, {                                                                        
            Rotation = 0,                                                           
        }),         
                    Dialog, Outline, Placeholder, Background = WindUI:Gradient({                                                  
            ["0"] = { Color = Color3.fromHex("#F5F5DC"), Transparency = 0.1 },             
            ["100"]   = { Color = Color3.fromHex("#000000"), Transparency = 0.2 },    
        }, {                                                                        
            Rotation = 0,                                                           
        }),                   
    })


printidentity()
local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(message, messageType)
    if string.find(message, "Current identity is") then
        local identityNumber = string.match(message, "Current identity is (%d+)")
        if identityNumber then
Window:Tag({ 
            Title = "注入器等级: "..identityNumber,
                Color = Color3.fromHex("#808080"),
    Radius = 10,
            })
            end
    end
end)  

Window:CreateTopbarButton('theme-switcher', 'moon', function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == 'Dark' and 'Light' or 'Dark')
    WindUI:Notify({
        Title = '通知',
        Content = '当前主题：' .. WindUI:GetCurrentTheme(),
        Duration = 2,
    })
end, 0)


Window:EditOpenButton({
    Title = "Action",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
    Draggable = true,
})
  Window:EditOpenButton({
        StrokeColor = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),     -- 红色
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)), -- 橙色
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)), -- 黄色
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),   -- 绿色
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),   -- 蓝色
            ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))    -- 紫色
        }),
        StrokeThickness = 3,  
    })
    
    spawn(function()
    while true do
        for hue = 0, 1, 0.01 do  
            local color = Color3.fromHSV(hue, 0.8, 1)  
            Window:EditOpenButton({
                Color = ColorSequence.new(color)
            })
            wait(0.04)  
        end
    end
end)
if not borderInitialized then
    spawn(function()
        wait(0.5)
        initializeRainbowBorder("彩虹颜色", animationSpeed)
        wait(1)
        applyFontStyleToWindow(currentFontStyle)
    end)
end

local windowOpen = true

Window:OnClose(function()
    windowOpen = false
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
end)

local originalOpenFunction = Window.Open
Window.Open = function(...)
    windowOpen = true
    local result = originalOpenFunction(...)
    
    if borderInitialized and borderEnabled and not rainbowBorderAnimation then
        wait(0.1)
        startBorderAnimation(Window, animationSpeed)
    end
    
    return result
end
            
-- 修改后的标签页图标
local Main = Window:Tab({Title = "主要", Icon = "rbxassetid://6026568198"})           -- 主页图标
local juan = Window:Tab({Title = "债券", Icon = "dollar-sign"})    -- 货币/债券图标
local items = Window:Tab({Title = "物品", Icon = "package"})       -- 包裹/物品图标
local bil = Window:Tab({Title = "枪械", Icon = "target"})         -- 目标/枪械图标
local ESP = Window:Tab({Title = "ESP", Icon = "eye"})              -- 眼睛/透视图标
local other = Window:Tab({Title = "其他", Icon = "settings"})      -- 设置/其他图标
local Teleport = Window:Tab({Title = "传送", Icon = "map-pin"})    -- 地图定位/传送图标
local Settings = Window:Tab({Title = "ui设置", Icon = "palette"}) -- 调色板图标（保持不变）


local BypassCheat =
    Main:Toggle(
    {
        Title = "反拉回",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                local invisChair = Instance.new("Seat")
                invisChair.Name = "invisChair"
                invisChair.Size = Vector3.new(2, 0.5, 2)
                invisChair.Position = HumanoidRootPart.Position + Vector3.new(0, -2, 0)
                invisChair.Transparency = 1
                invisChair.CanCollide = false
                invisChair.Parent = workspace
                local weld = Instance.new("Weld")
                weld.Part0 = invisChair
                weld.Part1 = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
                weld.C0 = CFrame.new(0, -2, 0)
                weld.C1 = CFrame.new(0, 0, 0)
                weld.Parent = invisChair
            else
                if workspace:FindFirstChild("invisChair") then
                    workspace.invisChair:Destroy()
                end
            end
        end
    }
)

local AntiVoid =
    Main:Toggle(
    {
        Title = "反虚空",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                workspace.FallenPartsDestroyHeight = state and 0 / 0 or -500
            end
        end
    }
)

local AutoThrottle =
    Main:Toggle(
    {
        Title = "自动开火车",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoThrottle = state
            game:GetService("RunService").RenderStepped:Connect(
                function()
                    if Setting.AutoThrottle then
                        for _, v in next, workspace:GetChildren() do
                            if v:GetAttribute("Stopped") ~= nil then
                                if math.abs(v.RequiredComponents.Controls.ConductorSeat.VehicleSeat.Throttle) == 0 then
                                    v.RequiredComponents.Controls.ConductorSeat.VehicleSeat.Throttle = 1
                                end
                            end
                        end
                    end
                end
            )
        end
    }
)

local MeleeAura =
    Main:Toggle(
    {
        Title = "快速挥舞",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.MeleeHitAura = state
            task.spawn(
                function()
                    while Setting.MeleeHitAura and task.wait(0.2) do
                        spawn(
                            function()
                                if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end
                                local npc = getnpc()
                                for _, tool in pairs(Character:GetChildren()) do
                                    if tool:FindFirstChild("SwingEvent", math.huge) then
                                        ReplicatedStorage.Shared.Network.RemoteEvent.SwingMelee:FireServer(
                                            tool,
                                            workspace:GetServerTimeNow(),
                                            CFrame.lookAt(
                                                Character:GetPivot().Position,
                                                npc:GetPivot().Position + Vector3.new(0, 2)
                                            ).LookVector
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local MeleeAura =
    Main:Toggle(
    {
        Title = "自动重击",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.MeleeHitAura = state
            task.spawn(
                function()
                    while Setting.MeleeHitAura and task.wait(0.2) do
                        spawn(
                            function()
                                if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end
                                for _, tool in pairs(Character:GetChildren()) do
                                    if tool:FindFirstChild("SwingEvent", math.huge) then
                                        ReplicatedStorage.Shared.Network.RemoteEvent.ChargeMelee:FireServer(
                                            tool,
                                            workspace:GetServerTimeNow()
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local GunAura =
    Main:Toggle(
    {
        Title = "枪械光环",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.GunAura = state
            pcall(
                function()
                    while Setting.GunAura do
                        wait(0.2)
                        spawn(
                            function()
                                if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end
                                local npc = getnpc()
                                if npc and npc:FindFirstChild("Humanoid") then
                                    local head = npc.Head
                                    local humanoid = npc.Humanoid
                                    if humanoid.Health > 0 then
                                        for _, tool in pairs(Character:GetChildren()) do
                                            if tool:FindFirstChild("WeaponConfiguration") then
                                                if tool.ClientWeaponState.CurrentAmmo.Value ~= 0 then
                                                    if tool.Name == "Shotgun" or tool.Name == "Sawed-Off Shotgun" then
                                                        local args = {
                                                            [1] = workspace:GetServerTimeNow(),
                                                            [2] = tool,
                                                            [3] = CFrame.lookAt(
                                                                head.Position,
                                                                head.Position + head.CFrame.LookVector * 10
                                                            ),
                                                            [4] = {
                                                                ["14"] = npc.Humanoid,
                                                                ["8"] = npc.Humanoid,
                                                                ["2"] = npc.Humanoid,
                                                                ["5"] = npc.Humanoid,
                                                                ["11"] = npc.Humanoid,
                                                                ["7"] = npc.Humanoid
                                                            }
                                                        }
                                                        ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(unpack(args))
                                                        ReplicatedStorage.Remotes.Weapon.Reload:FireServer(
                                                            workspace:GetServerTimeNow(),
                                                            tool
                                                        )
                                                    else
                                                        local args = {
                                                            [1] = workspace:GetServerTimeNow(),
                                                            [2] = tool,
                                                            [3] = CFrame.lookAt(
                                                                head.Position,
                                                                head.Position + head.CFrame.LookVector * 10
                                                            ),
                                                            [4] = {
                                                                ["4"] = npc.Humanoid,
                                                                ["2"] = npc.Humanoid
                                                            }
                                                        }
                                                        ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(unpack(args))
                                                        ReplicatedStorage.Remotes.Weapon.Reload:FireServer(
                                                            workspace:GetServerTimeNow(),
                                                            tool
                                                        )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoRevive =
    Main:Toggle(
    {
        Title = "自动救人",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoRevive = state
            pcall(
                function()
                    while Setting.AutoRevive do
                        wait(0.1)
                        spawn(
                            function()
                                for _, v in pairs(Players:GetPlayer()) do
                                    for _, p in pairs(v.Character:GetChildren()) do
                                        if p.HumanoidRootPart:FindFirstChild("RevivePrompt") then
                                            fireproximityprompt(p)
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local Noclip =
    juan:Toggle(
    {
        Title = "穿墙",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.Noclip = state
            pcall(
                function()
                    while Setting.Noclip do
                        wait(0.1)
                        spawn(
                            function()
                                if Setting.Noclip and Character and Character:FindFirstChild("HumanoidRootPart") then
                                    if HumanoidRootPart.Position.Y <= -10 then
                                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 10, 0)
                                        Character:PivotTo(Character:GetPivot() + Vector3.new(0, 20, 0))
                                    end
                                end

                                if Character then
                                    for _, part in pairs(Character:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = not Setting.Noclip
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local NPCLock =
    juan:Toggle(
    {
        Title = "NPC锁定",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                Setting.AimLock = state
                spawn(
                    function()
                        while Setting.AimLock do
                            wait(0.1)
                            pcall(
                                function()
                                    local npc = getnpc()
                                    if npc and Setting.AimLock and npc:FindFirstChild("Humanoid") then
                                        local npcHumanoid = npc:FindFirstChild("Humanoid")
                                        if npcHumanoid.Health > 0 then
                                            camera.CameraSubject = npcHumanoid
                                        end
                                    end
                                end
                            )
                        end
                    end
                )
            else
                Setting.AimLock = false
                camera.CameraSubject = Humanoid
            end
        end
    }
)

local AutoUseBandage =
    juan:Toggle(
    {
        Title = "自动使用绷带",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.UseBandage = state
            pcall(
                function()
                    while Setting.UseBandage do
                        wait(0.1)
                        spawn(
                            function()
                                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                                    if v.Name == "Bandage" then
                                        if Humanoid.Health <= Setting.MinHealth then
                                            v.Parent = Character
                                            Character.Bandage.Use:FireServer()
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoUseSnakeOil =
    juan:Toggle(
    {
        Title = "自动使用蛇油",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.UseSnakeOil = state
            pcall(
                function()
                    while Setting.UseSnakeOil do
                        wait(0.1)
                        spawn(
                            function()
                                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                                    if v.Name == "Snake Oil" then
                                        wait(Setting.USECooldown)
                                        v.Parent = Character
                                        Character[v].Use:FireServer()
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local UseHealth =
    juan:Slider(
    {
        Title = "使用绷带的最低血量",
        Desc = "滑动调整",
        Value = {
            Min = 1,
            Max = 100,
            Default = 50
        },
        Callback = function(Value)
            Setting.MinHealth = Value
        end
    }
)

local UseCooldown =
    juan:Slider(
    {
        Title = "蛇油使用间隔",
        Desc = "滑动调整",
        Value = {
            Min = 1,
            Max = 10,
            Default = 5
        },
        Callback = function(Value)
            Setting.USECooldown = Value
        end
    }
)

local AutoStores =
    items:Toggle(
    {
        Title = "自动收集物品(无条件)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoStores = state
            pcall(
                function()
                    while Setting.AutoStores do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 then
                                        ReplicatedStorage.Remotes.StoreItem:FireServer(v)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoStore =
    items:Toggle(
    {
        Title = "自动收集物品(燃料)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoStores = state
            pcall(
                function()
                    while Setting.AutoStores do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            v:GetAttribute("Value")
                                     then
                                        ReplicatedStorage.Remotes.StoreItem:FireServer(v)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoStore =
    items:Toggle(
    {
        Title = "自动收集物品(价值)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoStores = state
            pcall(
                function()
                    while Setting.AutoStores do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            v:GetAttribute("Value")
                                     then
                                        ReplicatedStorage.Remotes.StoreItem:FireServer(v)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectMoneyBag =
    items:Toggle(
    {
        Title = "自动捡钱袋",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectMoneybag = state
            pcall(
                function()
                    while Setting.AutoCollectMoneybag do
                        wait(0.1)
                        spawn(
                            function()
                                if workspace.RuntimeItems:FindFirstChild("Moneybag") then
                                    fireproximityprompt(workspace.RuntimeItems.Moneybag.MoneyBag.CollectPrompt)
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectOther =
    items:Toggle(
    {
        Title = "自动收集物品",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectOther = state
            pcall(
                function()
                    while Setting.AutoCollectOther do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            (v.Name ~= "Bond" or v.Name ~= "RevolverAmmo" or v.Name ~= "RifleAmmo" or
                                                v.Name ~= "ShotgunShells")
                                     then
                                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(
                                            v
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectBond =
    items:Toggle(
    {
        Title = "自动捡债券",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectBond = state
            pcall(
                function()
                    while Setting.AutoCollectBond do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            v.Name == "Bond"
                                     then
                                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(
                                            v
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectTool =
    items:Toggle(
    {
        Title = "自动收集工具",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectTool = state
            pcall(
                function()
                    while Setting.AutoCollectTool do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            not v:GetAttribute("BuyPrice")
                                     then
                                        ReplicatedStorage.Remotes.Tool.PickUpTool:FireServer(v)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectAmmo =
    items:Toggle(
    {
        Title = "自动收集子弹",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectAmmo = state
            pcall(
                function()
                    while Setting.AutoCollectAmmo do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            (v.Name == "RevolverAmmo" or v.Name == "RifleAmmo" or
                                                v.Name == "ShotgunShells") and
                                            not v:GetAttribute("BuyPrice")
                                     then
                                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(
                                            v
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoCollectArmor =
    items:Toggle(
    {
        Title = "自动拾取装甲",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectArmor = state
            pcall(
                function()
                    while Setting.AutoCollectArmor do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            not v:GetAttribute("BuyPrice")
                                     then
                                        ReplicatedStorage.Remotes.Object.EquipObject:FireServer(v)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local QuickShoot =
    bil:Toggle(
    {
        Title = "开枪无间隔",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.Quickshoot = state
            pcall(
                function()
                    while Setting.Quickshoot do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in next, LocalPlayer.Backpack:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        v.WeaponConfiguration.FireDelay.Value = 0
                                    end
                                end
                                for i, v in next, Character:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        v.WeaponConfiguration.FireDelay.Value = 0
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local Quickreload =
    bil:Toggle(
    {
        Title = "无换弹时间",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.QuickReload = state
            pcall(
                function()
                    while Setting.QuickReload do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in next, LocalPlayer.Backpack:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        v.WeaponConfiguration.ReloadDuration.Value = 0
                                    end
                                end
                                for i, v in next, Character:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        v.WeaponConfiguration.ReloadDuration.Value = 0
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local MagazineFed =
    bil:Toggle(
    {
        Title = "秒杀子弹(已失效)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.SwordGuest = state
            pcall(
                function()
                    while Setting.SwordGuest do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in next, LocalPlayer.Backpack:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                                        if not magazineFed then
                                            magazineFed = Instance.new("BoolValue")
                                            magazineFed.Title = "MagazineFed"
                                            magazineFed.Value = true
                                            magazineFed.Parent = v.WeaponConfiguration
                                        end
                                    end
                                end
                                for i, v in next, Character:GetChildren() do
                                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                        local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                                        if not magazineFed then
                                            magazineFed = Instance.new("BoolValue")
                                            magazineFed.Title = "MagazineFed"
                                            magazineFed.Value = true
                                            magazineFed.Parent = v.WeaponConfiguration
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)



local ItemESP =
    ESP:Toggle(
    {
        Title = "物品透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("BillboardGui") then
                        local b = Instance.new("BillboardGui")
                        b.Parent = v
                        b.Adornee = v
                        b.Size = UDim2.new(0, 20, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0)
                        b.AlwaysOnTop = true

                        local t = Instance.new("TextLabel")
                        t.Parent = b
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Text = v.Name
                        t.TextColor3 = Color3.new(255, 215, 0)
                        t.TextStrokeTransparency = 0.5
                        t.TextScaled = true
                    end
                end
                Setting.Loop.items =
                    workspace.RuntimeItems.ChildAdded:Connect(
                    function(v)
                        if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and state then
                            local b = Instance.new("BillboardGui")
                            b.Parent = v
                            b.Adornee = v
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = v.Name
                            t.TextColor3 = Color3.new(255, 215, 0)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                )
            else
                if Setting.Loop.items then
                    Setting.Loop.items:Disconnect()
                    Setting.Loop.items = nil
                end

                for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if v:FindFirstChild("BillboardGui") then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local OreESP =
    ESP:Toggle(
    {
        Title = "矿石透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for _, v in ipairs(workspace.Ore:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("BillboardGui") then
                        local b = Instance.new("BillboardGui")
                        b.Parent = v
                        b.Adornee = v
                        b.Size = UDim2.new(0, 20, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0)
                        b.AlwaysOnTop = true

                        local t = Instance.new("TextLabel")
                        t.Parent = b
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Text = v.Name
                        t.TextColor3 = Color3.new(0, 0, 255)
                        t.TextStrokeTransparency = 0.5
                        t.TextScaled = true
                    end
                end
                Setting.Loop.Ore =
                    workspace.Ore.ChildAdded:Connect(
                    function(v)
                        if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and state then
                            local b = Instance.new("BillboardGui")
                            b.Parent = v
                            b.Adornee = v
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = v.Name
                            t.TextColor3 = Color3.new(0, 0, 255)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                )
            else
                if Setting.Loop.Ore then
                    Setting.Loop.Ore:Disconnect()
                    Setting.Loop.Ore = nil
                end

                for _, v in ipairs(workspace.Ore:GetChildren()) do
                    if v:FindFirstChild("BillboardGui") then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local EnemiesESP = {
    ESP:Toggle(
        {
            Title = "怪物透视",
            Default = false,
            Image = "check",
            Callback = function(state)
                if state then
                    local idk = {"RuntimeEnemies", "RuntimeEntities", "NightEnemies"}

                    for _, fdna in ipairs(idk) do
                        for _, v in ipairs(workspace:FindFirstChild(fdna):GetChildren()) do
                            if v:IsA("Model") and not v:FindFirstChild("BillboardGui") then
                                local b = Instance.new("BillboardGui")
                                b.Parent = v
                                b.Adornee = v
                                b.Size = UDim2.new(0, 20, 0, 20)
                                b.StudsOffset = Vector3.new(0, 3, 0)
                                b.AlwaysOnTop = true

                                local t = Instance.new("TextLabel")
                                t.Parent = b
                                t.Size = UDim2.new(1, 0, 1, 0)
                                t.BackgroundTransparency = 1
                                t.Text = v.Name
                                t.TextColor3 = Color3.new(1, 0, 0)
                                t.TextStrokeTransparency = 0.5
                                t.TextScaled = true
                            end
                        end

                        Setting.Loop.Enemy =
                            workspace:FindFirstChild(fdna).ChildAdded:Connect(
                            function(v)
                                if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and state then
                                    local b = Instance.new("BillboardGui")
                                    b.Parent = v
                                    b.Adornee = v
                                    b.Size = UDim2.new(0, 20, 0, 20)
                                    b.StudsOffset = Vector3.new(0, 3, 0)
                                    b.AlwaysOnTop = true

                                    local t = Instance.new("TextLabel")
                                    t.Parent = b
                                    t.Size = UDim2.new(1, 0, 1, 0)
                                    t.BackgroundTransparency = 1
                                    t.Text = v.Name
                                    t.TextColor3 = Color3.new(1, 0, 0)
                                    t.TextStrokeTransparency = 0.5
                                    t.TextScaled = true
                                end
                            end
                        )
                    end
                else
                    if Setting.Loop.Enemy then
                        Setting.Loop.Enemy:Disconnect()
                        Setting.Loop.Enemy = nil
                    end

                    for _, fdna in ipairs(idk) do
                        for _, v in ipairs(workspace:FindFirstChild(fdna):GetChildren()) do
                             if v:FindFirstChild("BillboardGui") then
                                v.BillboardGui:Destroy()
                            end
                        end
                    end
                end
            end
        }
    )
}



local UnicornESP =
    ESP:Toggle(
    {
        Title = "独角兽透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for i, v in ipairs(workspace:GetDescendants()) do
                    if v.Name == "Unicorn" and not v:FindFirstChild("BillboardGui") then
                        local b = Instance.new("BillboardGui")
                        b.Parent = v
                        b.Adornee = v
                        b.Size = UDim2.new(0, 20, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0)
                        b.AlwaysOnTop = true

                        local t = Instance.new("TextLabel")
                        t.Parent = b
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Text = "独角兽"
                        t.TextColor3 = Color3.new(1, 1, 1)
                        t.TextStrokeTransparency = 0.5
                        t.TextScaled = true
                    end
                end
                Setting.Loop.Unicorn =
                    workspace.DescendantAdded:Connect(
                    function(v)
                        if v.Name == "Unicorn" and not v:FindFirstChild("BillboardGui") and state then
                            local b = Instance.new("BillboardGui")
                            b.Parent = v
                            b.Adornee = v
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = v.Name
                            t.TextColor3 = Color3.new(1, 1, 1)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                )
            else
                if Setting.Loop.Unicorn then
                    Setting.Loop.Unicorn:Disconnect()
                    Setting.Loop.Unicorn = nil
                end

                for i, v in ipairs(workspace:GetChildren()) do
                    if v:FindFirstChild("BillboardGui") and v.BillboardGui.TextLabel.Text == "独角兽" then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local BuildESP =
    ESP:Toggle(
    {
        Title = "建筑物透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for _, v in ipairs(workspace.RandomBuildings:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("BillboardGui") then
                        local b = Instance.new("BillboardGui")
                        b.Parent = v
                        b.Adornee = v
                        b.Size = UDim2.new(0, 20, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0)
                        b.AlwaysOnTop = true

                        local t = Instance.new("TextLabel")
                        t.Parent = b
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Text = v.Name
                        t.TextColor3 = Color3.new(0, 255, 0)
                        t.TextStrokeTransparency = 0.5
                        t.TextScaled = true
                    end
                end
                Setting.Loop.build =
                    workspace.RandomBuildings.ChildAdded:Connect(
                    function(v)
                        if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and state then
                            local b = Instance.new("BillboardGui")
                            b.Parent = v
                            b.Adornee = v
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = v.Name
                            t.TextColor3 = Color3.new(0, 255, 0)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                )
            else
                if Setting.Loop.build then
                    Setting.Loop.build:Disconnect()
                    Setting.Loop.build = nil
                end

                for _, v in ipairs(workspace.RandomBuildings:GetChildren()) do
                    if v:FindFirstChild("BillboardGui") then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local BuildZombieESP =
    ESP:Toggle(
    {
        Title = "房中怪物透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for _, building in ipairs(workspace.RandomBuildings:GetChildren()) do
                    for _, zombie in ipairs(building.StandaloneZombiePart.Zombies:GetChildren()) do
                        if zombie:IsA("Model") and not zombie:FindFirstChild("BillboardGui") then
                            local b = Instance.new("BillboardGui")
                            b.Parent = zombie
                            b.Adornee = zombie
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = zombie.Name
                            t.TextColor3 = Color3.new(0, 255, 0)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                end
                Setting.Loop.zombie =
                    workspace.RandomBuildings.ChildAdded:Connect(
                    function(building)
                        for _, zombie in ipairs(building.StandaloneZombiePart.Zombies:GetChildren()) do
                            if zombie:IsA("Model") and not zombie:FindFirstChild("BillboardGui") and state then
                                local b = Instance.new("BillboardGui")
                                b.Parent = zombie
                                b.Adornee = zombie
                                b.Size = UDim2.new(0, 20, 0, 20)
                                b.StudsOffset = Vector3.new(0, 3, 0)
                                b.AlwaysOnTop = true

                                local t = Instance.new("TextLabel")
                                t.Parent = b
                                t.Size = UDim2.new(1, 0, 1, 0)
                                t.BackgroundTransparency = 1
                                t.Text = zombie.Name
                                t.TextColor3 = Color3.new(0, 255, 0)
                                t.TextStrokeTransparency = 0.5
                                t.TextScaled = true
                            end
                        end
                    end
                )
            else
                if Setting.Loop.zombie then
                    Setting.Loop.zombie:Disconnect()
                    Setting.Loop.zombie = nil
                end

                for _, building in ipairs(workspace.RandomBuildings:GetChildren()) do
                    for _, zombie in ipairs(building.StandaloneZombiePart.Zombies:GetChildren()) do
                        if zombie:FindFirstChild("BillboardGui") then
                            zombie.BillboardGui:Destroy()
                        end
                    end
                end
            end
        end
    }
)

local BankESP =
    ESP:Toggle(
    {
        Title = "银行透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for i, v in ipairs(workspace.Towns:GetChildren()) do
                    for _, z in ipairs(v.Buildingns:GetChildren()) do
                        if
                            z:IsA("Model") and not z:FindFirstChild("BillboardGui") and z.Name:find("Bank") and
                                z:FindFirstChild("Vault") and
                                z.Vault:FindFirstChild("Union")
                         then
                            local b = Instance.new("BillboardGui")
                            b.Parent = z
                            b.Adornee = z
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = "银行 | 密码" .. z.Vault.Combination.Value
                            t.TextColor3 = Color3.new(1, 0, 1)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                end
                Setting.Loop.bank =
                    workspace.Towns.ChildAdded:Connect(
                    function(v)
                        for _, Bank in ipairs(v.Buildingns:GetChildren()) do
                            if
                                Bank:IsA("Model") and not Bank:FindFirstChild("BillboardGui") and Bank.Name:find("Bank") and
                                    Bank:FindFirstChild("Vault") and
                                    Bank.Vault:FindFirstChild("Union")
                             then
                                if not Bank:FindFirstChild("BillboardGui") then
                                    local b = Instance.new("BillboardGui")
                                    b.Parent = Bank
                                    b.Adornee = Bank
                                    b.Size = UDim2.new(0, 20, 0, 20)
                                    b.StudsOffset = Vector3.new(0, 3, 0)
                                    b.AlwaysOnTop = true

                                    local t = Instance.new("TextLabel")
                                    t.Parent = b
                                    t.Size = UDim2.new(1, 0, 1, 0)
                                    t.BackgroundTransparency = 1
                                    t.Text = "银行 | 密码" .. Bank.Vault.Combination.Value
                                    t.TextColor3 = Color3.new(1, 0, 1)
                                    t.TextStrokeTransparency = 0.5
                                    t.TextScaled = true
                                end
                            end
                        end
                    end
                )
            else
                if Setting.Loop.bank then
                    Setting.Loop.bank:Disconnect()
                    Setting.Loop.bank = nil
                end

                for i, v in ipairs(workspace:GetDescendants()) do
                    if v:FindFirstChild("BillboardGui") and v.Name == "Bank" then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local BondESP =
    ESP:Toggle(
    {
        Title = "债券透视",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and v.Name == "Bond" then
                        local b = Instance.new("BillboardGui")
                        b.Parent = v
                        b.Adornee = v
                        b.Size = UDim2.new(0, 20, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0)
                        b.AlwaysOnTop = true

                        local t = Instance.new("TextLabel")
                        t.Parent = b
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.Text = v.Name
                        t.TextColor3 = Color3.new(255, 215, 0)
                        t.TextStrokeTransparency = 0.5
                        t.TextScaled = true
                    end
                end
                Setting.Loop.Bond =
                    workspace.RuntimeItems.ChildAdded:Connect(
                    function(v)
                        if v:IsA("Model") and not v:FindFirstChild("BillboardGui") and v.Name == "Bond" and state then
                            local b = Instance.new("BillboardGui")
                            b.Parent = v
                            b.Adornee = v
                            b.Size = UDim2.new(0, 20, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true

                            local t = Instance.new("TextLabel")
                            t.Parent = b
                            t.Size = UDim2.new(1, 0, 1, 0)
                            t.BackgroundTransparency = 1
                            t.Text = v.Name
                            t.TextColor3 = Color3.new(255, 215, 0)
                            t.TextStrokeTransparency = 0.5
                            t.TextScaled = true
                        end
                    end
                )
            else
                if Setting.Loop.Bond then
                    Setting.Loop.Bond:Disconnect()
                    Setting.Loop.Bond = nil
                end

                for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if v:FindFirstChild("BillboardGui") and v.Name == "Bond" then
                        v.BillboardGui:Destroy()
                    end
                end
            end
        end
    }
)

local AutoBurningFuel =
    ESP:Toggle(
    {
        Title = "自动燃烧物品",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoBurningFuel = state
            pcall(
                function()
                    while Setting.AutoBurningFuel do
                        wait(0.1)
                        spawn(
                            function()
                                for _, v in next, workspace.RuntimeItems:GetChildren() do
                                    if v:GetAttribute("Fuel") and v:GetAttribute("Fuel") > 0 then
                                        for _, z in next, workspace:GetChildren() do
                                            if z:GetAttribute("Stopped") ~= nil then
                                                local distance =
                                                    (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                                if distance <= 30 then
                                                    ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                        v
                                                    )
                                                    task.wait(.5)
                                                    v.PrimaryPart.DragAttachment:Destroy()
                                                    v.PrimaryPart.DragAlignPosition:Destroy()
                                                    v.PrimaryPart.DragAlignOrientation:Destroy()
                                                    v:PivotTo(z.RequiredComponents.FuelZone:GetPivot())
                                                    task.wait(0.01)
                                                    ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                    )
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)



local AutoTeleporttoTrain =
    other:Toggle(
    {
        Title = "自动传送物品到车上",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoTeleporttoTrain = state
            pcall(
                function()
                    while Setting.AutoTeleporttoTrain do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    for _, t in next, workspace:GetChildren() do
                                        if t:GetAttribute("Stopped") ~= nil then
                                            local distance =
                                                (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                            if distance < 30 then
                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                    v
                                                )
                                                task.wait(.5)
                                                v.PrimaryPart.DragAttachment:Destroy()
                                                v.PrimaryPart.DragAlignPosition:Destroy()
                                                v.PrimaryPart.DragAlignOrientation:Destroy()
                                                v:PivotTo(
                                                    CFrame.new(t:FindFirstChild("Platform").Base:GetPivot().Position)
                                                )
                                                task.wait(0.01)
                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoBurningFuel =
    other:Toggle(
    {
        Title = "自动燃烧炸药并传送到队友旁边(:D) (离你的朋友远点不然会出问题)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoBurningFuel = state
            pcall(
                function()
                    while Setting.AutoBurningFuel do
                        wait(0.1)
                        spawn(
                            function()
                                for _, p in next, Players:GetPlayers() do
                                    if p ~= LocalPlayer then
                                        for _, v in next, workspace.RuntimeItems:GetChildren() do
                                            if v.Name == "Dynamite" then
                                                for _, z in next, workspace:GetChildren() do
                                                    if z:GetAttribute("Stopped") ~= nil then
                                                        local distance =
                                                            (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                                        if distance <= 30 then
                                                            ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                                v
                                                            )
                                                            task.wait(.5)
                                                            v.PrimaryPart.DragAttachment:Destroy()
                                                            v.PrimaryPart.DragAlignPosition:Destroy()
                                                            v.PrimaryPart.DragAlignOrientation:Destroy()
                                                            v:PivotTo(p.Character:GetPivot())
                                                            task.wait(0.01)
                                                            ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                            )
                                                            wait(1)
                                                            ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                                v
                                                            )
                                                            task.wait(.5)
                                                            v.PrimaryPart.DragAttachment:Destroy()
                                                            v.PrimaryPart.DragAlignPosition:Destroy()
                                                            v.PrimaryPart.DragAlignOrientation:Destroy()
                                                            v:PivotTo(ClosestPlayer:GetPivot())
                                                            task.wait(0.01)
                                                            ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                            )
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoBurningZombie =
    other:Toggle(
    {
        Title = "自动燃烧僵尸尸体",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoBurningFuel = state
            pcall(
                function()
                    while Setting.AutoBurningFuel do
                        wait(0.1)
                        spawn(
                            function()
                                for _, v in next, workspace.RuntimeItems:GetChildren() do
                                    if
                                        v:GetAttribute("Fuel") and v:GetAttribute("Fuel") > 0 and
                                            (v.Name:find("Walker") or v.Name:find("Runner"))
                                     then
                                        for _, z in next, workspace:GetChildren() do
                                            if z:GetAttribute("Stopped") ~= nil then
                                                local distance =
                                                    (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                                if distance <= 30 then
                                                    ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                        v
                                                    )
                                                    task.wait(.5)
                                                    v.PrimaryPart.DragAttachment:Destroy()
                                                    v.PrimaryPart.DragAlignPosition:Destroy()
                                                    v.PrimaryPart.DragAlignOrientation:Destroy()
                                                    v:PivotTo(z.RequiredComponents.FuelZone:GetPivot())
                                                    task.wait(0.01)
                                                    ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                    )
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local NPCLockGUI =
    other:Button(
    {
        Title = "强锁NPC快捷GUI",
        Desc = "点击开始",
        Callback = function()
            if not game.CoreGui:FindFirstChild("NPCLockGUI") then
                local NPCLockGUI = Instance.new("ScreenGui")
                NPCLockGUI.Title = "NPCLockGUI"
                NPCLockGUI.ResetOnSpawn = false
                NPCLockGUI.Parent = game:GetService("CoreGui")

                local NPCLockFrame = Instance.new("Frame")
                NPCLockFrame.Size = UDim2.new(0, 200, 0, 60)
                NPCLockFrame.Position = UDim2.new(0.85, -100, 0.75, -60)
                NPCLockFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                NPCLockFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NPCLockFrame.BackgroundTransparency = 0.3
                NPCLockFrame.BorderSizePixel = 0
                NPCLockFrame.Active = true
                NPCLockFrame.Draggable = true
                NPCLockFrame.Parent = NPCLockGUI

                local uicorner = Instance.new("UICorner")
                uicorner.CornerRadius = UDim.new(0, 12)
                uicorner.Parent = NPCLockFrame

                local NPCLockToggleButton = Instance.new("TextButton")
                NPCLockToggleButton.Size = UDim2.new(1, -20, 0, 40)
                NPCLockToggleButton.Position = UDim2.new(0, 10, 0, 10)
                NPCLockToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NPCLockToggleButton.BackgroundTransparency = 0.4
                NPCLockToggleButton.Text = "NPC锁定: 关"
                NPCLockToggleButton.TextColor3 = Color3.new(1, 1, 1)
                NPCLockToggleButton.Font = Enum.Font.Fantasy
                NPCLockToggleButton.TextSize = 22
                NPCLockToggleButton.Parent = NPCLockFrame

                local uicorner2 = Instance.new("UICorner")
                uicorner2.CornerRadius = UDim.new(0, 12)
                uicorner2.Parent = NPCLockToggleButton

                NPCLockToggleButton.MouseButton1Click:Connect(
                    function()
                        NpcState = not NpcState
                        if NpcState then
                            NPCLockToggleButton.Text = "NPC锁定: 开"
                            spawn(
                                function()
                                    while NpcState do
                                        wait(0.1)
                                        pcall(
                                            function()
                                                local npc = getnpc()
                                                if npc and NpcState and npc:FindFirstChild("Humanoid") then
                                                    local npcHumanoid = npc:FindFirstChild("Humanoid")
                                                    if npcHumanoid.Health > 0 then
                                                        workspace.CurrentCamera.CameraSubject = npcHumanoid
                                                    end
                                                end
                                            end
                                        )
                                    end
                                end
                            )
                        else
                            workspace.CurrentCamera.CameraSubject = Humanoid
                            NPCLockToggleButton.Text = "NPC锁定: 关"
                        end
                    end
                )
            end
        end
    }
)

local NoclipGUI =
    other:Button(
    {
        Title = "穿墙快捷GUI",
        Desc = "点击开始",
        Callback = function()
            if not game.CoreGui:FindFirstChild("NoclipGUI") then
                local NoclipGUI = Instance.new("ScreenGui")
                NoclipGUI.Title = "NoclipGUI"
                NoclipGUI.ResetOnSpawn = false
                NoclipGUI.Parent = game:GetService("CoreGui")

                local NoclipFrame = Instance.new("Frame")
                NoclipFrame.Size = UDim2.new(0, 200, 0, 60)
                NoclipFrame.Position = UDim2.new(0.85, -100, 0.75, -120)
                NoclipFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                NoclipFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NoclipFrame.BackgroundTransparency = 0.3
                NoclipFrame.BorderSizePixel = 0
                NoclipFrame.Active = true
                NoclipFrame.Draggable = true
                NoclipFrame.Parent = NoclipGUI

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 12)
                UICorner.Parent = NoclipFrame

                local NoclipToggleButton = Instance.new("TextButton")
                NoclipToggleButton.Size = UDim2.new(1, -20, 0, 40)
                NoclipToggleButton.Position = UDim2.new(0, 10, 0, 10)
                NoclipToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NoclipToggleButton.BackgroundTransparency = 0.4
                NoclipToggleButton.Text = "穿墙: 关"
                NoclipToggleButton.TextColor3 = Color3.new(1, 1, 1)
                NoclipToggleButton.Font = Enum.Font.Fantasy
                NoclipToggleButton.TextSize = 22
                NoclipToggleButton.Parent = NoclipFrame

                NoclipToggleButton.MouseButton1Click:Connect(
                    function()
                        NoclipState = not NoclipState
                        NoclipToggleButton.Text = NoclipState and "穿墙: 开" or "穿墙: 关"
                        if NoclipState then
                            spawn(
                                function()
                                    while NoclipState do
                                        wait(0.1)
                                        pcall(
                                            function()
                                                if
                                                    NoclipState and Character and
                                                        Character:FindFirstChild("HumanoidRootPart")
                                                 then
                                                    if HumanoidRootPart.Position.Y <= -10 then
                                                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 10, 0)
                                                        Character:PivotTo(Character:GetPivot() + Vector3.new(0, 20, 0))
                                                    end
                                                end

                                                if Character then
                                                    for _, part in pairs(Character:GetDescendants()) do
                                                        if part:IsA("BasePart") then
                                                            part.CanCollide = not NoclipState
                                                        end
                                                    end
                                                end
                                            end
                                        )
                                    end
                                end
                            )
                        end
                    end
                )

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(0, 12)
                UICorner2.Parent = NoclipToggleButton
            end
        end
    }
)

local WeldGUI =
    other:Button(
    {
        Title = "绑定快捷键UI",
        Desc = "点击开始",
        Callback = function()
            if not game.CoreGui:FindFirstChild("WeldGui") then
                local WeldGUI = Instance.new("ScreenGui")
                WeldGUI.Title = "WeldGui"
                WeldGUI.ResetOnSpawn = false
                WeldGUI.Parent = game:GetService("CoreGui")

                local WeldFrame = Instance.new("Frame")
                WeldFrame.Size = UDim2.new(0, 200, 0, 60)
                WeldFrame.Position = UDim2.new(0.85, -100, 0.75, -180)
                WeldFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                WeldFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                WeldFrame.BackgroundTransparency = 0.3
                WeldFrame.BorderSizePixel = 0
                WeldFrame.Active = true
                WeldFrame.Draggable = true
                WeldFrame.Parent = WeldGUI

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 12)
                UICorner.Parent = WeldFrame

                local WeldToggleButton = Instance.new("TextButton")
                WeldToggleButton.Size = UDim2.new(1, -20, 0, 40)
                WeldToggleButton.Position = UDim2.new(0, 10, 0, 10)
                WeldToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                WeldToggleButton.BackgroundTransparency = 0.4
                WeldToggleButton.Text = "固定"
                WeldToggleButton.TextColor3 = Color3.new(1, 1, 1)
                WeldToggleButton.Font = Enum.Font.Fantasy
                WeldToggleButton.TextSize = 22
                WeldToggleButton.Parent = WeldFrame

                WeldToggleButton.MouseButton1Click:Connect(
                    function()
                        for _, model in pairs(workspace.RuntimeItems:GetChildren()) do
                            if
                                model:IsA("Model") and model.PrimaryPart and
                                    model.PrimaryPart:FindFirstChild("DragAlignPosition")
                             then
                                if not model.PrimaryPart:FindFirstChild("DragWeldConstraint") then
                                    for _, target in pairs(workspace:GetChildren()) do
                                        if
                                            target:IsA("Model") and target:FindFirstChild("RequiredComponents") and
                                                target.RequiredComponents:FindFirstChild("Base")
                                         then
                                            ReplicatedStorage.Shared.Network.RemoteEvent.RequestWeld:FireServer(
                                                model,
                                                target.RequiredComponents.Base
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    end
                )

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(0, 12)
                UICorner2.Parent = WeldToggleButton
            end
        end
    }
)

local Highlight =
    other:Toggle(
    {
        Title = "高光",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.Light = state
            game:GetService("RunService").RenderStepped:Connect(
                function()
                    if Setting.Light then
                        game:GetService("Lighting").Brightness = 2
                        game:GetService("Lighting").ClockTime = 14
                        game:GetService("Lighting").FogEnd = 1000000
                        game:GetService("Lighting").GlobalShadows = false
                    else
                        game:GetService("Lighting").Brightness = 1
                        game:GetService("Lighting").ClockTime = 12
                        game:GetService("Lighting").FogEnd = 1000
                        game:GetService("Lighting").GlobalShadows = true
                    end
                end
            )
        end
    }
)


local CameraMode =
    other:Toggle(
    {
        Title = "人称切换",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                LocalPlayer.CameraMaxZoomDistance = math.huge
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            else
                LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            end
        end
    }
)

local AutoLever =
    other:Toggle(
    {
        Title = "自动拉终点开关",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.EndGame = state
            pcall(
                function()
                    while Setting.EndGame do
                        wait(0.1)
                        spawn(
                            function()
                                local EndGame =
                                    workspace:WaitForChild("Baseplates"):WaitForChild("FinalBasePlate"):WaitForChild(
                                    "OutlawBase"
                                ):WaitForChild("Bridge"):WaitForChild("BridgeControl"):WaitForChild("Crank"):WaitForChild(
                                    "Model"
                                ):WaitForChild("Mid"):WaitForChild("EndGame")
                                EndGame.MaxActivationDistance = math.huge
                                fireproximityprompt(EndGame)
                            end
                        )
                    end
                end
            )
        end
    }
)

local NoHoldDuration =
    other:Toggle(
    {
        Title = "秒互动",
        Default = false,
        Image = "check",
        Callback = function(state)
            game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(
                function(v)
                    if state then
                        fireproximityprompt(v)
                    end
                end
            )
        end
    }
)

local DropAll =
    other:Button(
    {
        Title = "丢弃所有物品",
        Desc = "点击开始",
        Callback = function()
            for _ = 1, 15 do
                ReplicatedStorage.Remotes.DropItem:FireServer()
            end
        end
    }
)

local TpTrain =
    other:Button(
    {
        Title = "传送火车",
        Desc = "点击开始",
        Callback = function()
            for _, v in next, workspace:GetChildren() do
                if v:GetAttribute("Stopped") ~= nil then
                    local oldPos = v.RequiredComponents.Controls.ConductorSeat.VehicleSeat:GetPivot()
                    repeat
                        local hum = Character:FindFirstChild("Humanoid")
                        if hum then
                            local seat = v.RequiredComponents.Controls.ConductorSeat.VehicleSeat
                            if seat:FindFirstChild("SeatWeld") then
                                break
                            end

                            seat.CFrame = HumanoidRootPart.CFrame
                            firetouchinterest(seat, HumanoidRootPart, 0)
                            firetouchinterest(seat, HumanoidRootPart, 1)
                        end
                        task.wait(0.01)
                    until seat:FindFirstChild("SeatWeld")
                    v.RequiredComponents.Controls.ConductorSeat.VehicleSeat:PivotTo(oldPos)
                end
            end
        end
    }
)

local Monster =
    other:Toggle(
    {
        Title = "显示今晚的怪物",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                if not game.CoreGui:FindFirstChild("MonsterGui") then
                    local MonsterGui = Instance.new("ScreenGui", game.CoreGui)
                    local MonsterMessage = Instance.new("TextLabel", MonsterGui)
                    local UIGradient = Instance.new("UIGradient")

                    MonsterGui.Title = "MonsterGui"
                    MonsterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    MonsterMessage.Title = "MonsterMessage"
                    MonsterMessage.BackgroundColor3 = Color3.new(1, 1, 1)
                    MonsterMessage.BackgroundTransparency = 1
                    MonsterMessage.BorderColor3 = Color3.new(0, 0, 0)
                    MonsterMessage.Position = UDim2.new(0.5, 100, 0.5, -25)
                    MonsterMessage.Size = UDim2.new(0, 135, 0, 50)
                    MonsterMessage.Font = Enum.Font.GothamSemibold
                    MonsterMessage.Text = "今晚的怪物: "
                    MonsterMessage.TextColor3 = Color3.new(1, 1, 1)
                    MonsterMessage.TextScaled = true
                    MonsterMessage.TextSize = 14
                    MonsterMessage.TextWrapped = true

                    UIGradient.Color =
                        ColorSequence.new {
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 127, 0)),
                        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(139, 0, 255)),
                        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(255, 127, 0)),
                        ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 0))
                    }
                    UIGradient.Rotation = 360
                    UIGradient.Parent = MonsterMessage
                    local TweenService = game:GetService("TweenService")
                    local tweeninfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
                    local tween = TweenService:Create(UIGradient, tweeninfo, {Rotation = 360})
                    tween:Play()
                    game:GetService("RunService").RenderStepped:Connect(
                        function()
                            for i, v in ipairs(workspace.NightEnemies:GetChildren()) do
                                if v:IsA("Model") then
                                    if v.Name:find("Werewolf") then
                                        MonsterMessage.Text = "今晚的怪物是狼人"
                                    elseif v.Name:find("Vampire") then
                                        MonsterMessage.Text = "今晚的怪物是吸血鬼"
                                    elseif v.Name:find("Walker") then
                                        MonsterMessage.Text = "今晚的怪物是正常僵尸"
                                    elseif v.Name:find("Runner") then
                                        MonsterMessage.Text = "今晚的怪物是奔跑僵尸"
                                    end
                                end
                            end
                        end
                    )
                end
            else
                if game.CoreGui:FindFirstChild("MonsterGui") then
                    game.CoreGui.MonsterGui:Destroy()
                end
            end
        end
    }
)

local AutoSell =
    other:Toggle(
    {
        Title = "自动售卖",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoSell = state
            pcall(
                function()
                    while Setting.AutoSell and task.wait() do
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if v:GetAttribute("Value") then
                                        if
                                            workspace:FindFirstChild("SafeZones") and
                                                workspace.SafeZones:FindFirstChild("SafeZone") and
                                                workspace.SafeZones.SafeZone:FindFirstChild("Buildings")
                                         then
                                            for z, j in pairs(workspace.SafeZones.SafeZone.Buildings:GetChildren()) do
                                                if j.Name:find("Trading") and j:FindFirstChild("BountySquare") then
                                                    for k, w in pairs(j.BountySquare:GetChildren()) do
                                                        if
                                                            w.Name == "Part" and w:FindFirstChild("SurfaceGui") and
                                                                w.SurfaceGui:FindFirstChild("TextLabel")
                                                         then
                                                            local distance =
                                                                (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                                            if distance <= 30 then
                                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                                    v
                                                                )
                                                                task.wait(.5)
                                                                v.PrimaryPart.DragAttachment:Destroy()
                                                                v.PrimaryPart.DragAlignPosition:Destroy()
                                                                v.PrimaryPart.DragAlignOrientation:Destroy()
                                                                v:PivotTo(CFrame.new(w.CFrame))
                                                                task.wait(0.01)
                                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                                )
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoSell =
    other:Toggle(
    {
        Title = "自动售卖(赏金)",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoSell = state
            pcall(
                function()
                    while Setting.AutoSell and task.wait() do
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if v:GetAttribute("Value") and v.Name:find("Outlaw") then
                                        if
                                            workspace:FindFirstChild("SafeZones") and
                                                workspace.SafeZones:FindFirstChild("SafeZone") and
                                                workspace.SafeZones.SafeZone:FindFirstChild("Buildings")
                                         then
                                            for z, j in pairs(workspace.SafeZones.SafeZone.Buildings:GetChildren()) do
                                                if j.Name:find("Trading") and j:FindFirstChild("BountySquare") then
                                                    for k, w in pairs(j.BountySquare:GetChildren()) do
                                                        if
                                                            w.Name == "Part" and w:FindFirstChild("SurfaceGui") and
                                                                w.SurfaceGui:FindFirstChild("TextLabel")
                                                         then
                                                            local distance =
                                                                (v:GetPivot().Position - Character:GetPivot().Position).Magnitude
                                                            if distance <= 30 then
                                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                                    v
                                                                )
                                                                task.wait(.5)
                                                                v.PrimaryPart.DragAttachment:Destroy()
                                                                v.PrimaryPart.DragAlignPosition:Destroy()
                                                                v.PrimaryPart.DragAlignOrientation:Destroy()
                                                                v:PivotTo(CFrame.new(w.CFrame))
                                                                task.wait(0.01)
                                                                ReplicatedStorage.Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                                )
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoBanjo =
    other:Toggle(
    {
        Title = "自动弹奏",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoBanjo = state
            pcall(
                function()
                    while Setting.AutoBanjo and wait() do
                        spawn(
                            function()
                                for i, v in pairs(Backpack:GetChildren()) do
                                    if v.Name == "Banjo" then
                                        v.Parent = LocalPlayer.Character
                                    end
                                end
                                for i, v in pairs(Character:GetChildren()) do
                                    if v.Name == "Banjo" then
                                        v.Events.PlayBanjo:FireServer(v, 1)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoThrow =
    other:Toggle(
    {
        Title = "自动向你的队友扔燃烧瓶",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoThrow = state
            pcall(
                function()
                    while Setting.AutoThrow and wait() do
                        spawn(
                            function()
                                for i, v in pairs(Backpack:GetChildren()) do
                                    if v.Name == "Molotov" then
                                        v.Parent = LocalPlayer.Character
                                    end
                                end
                                for i, v in pairs(Character:GetChildren()) do
                                    if v.Name == "Molotov" then
                                        for _, p in next, Players:GetPlayers() do
                                            if p ~= LocalPlayer then
                                                ReplicatedStorage.Remotes.Weapon.Throw:FireServer(
                                                    v,
                                                    p.HumanoidRootPart.CFrame
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local AutoThrow =
    other:Toggle(
    {
        Title = "自动向敌人扔燃烧瓶",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoThrow = state
            pcall(
                function()
                    while Setting.AutoThrow and wait() do
                        spawn(
                            function()
                                for i, v in pairs(Backpack:GetChildren()) do
                                    if v.Name == "Molotov" then
                                        v.Parent = LocalPlayer.Character
                                    end
                                end
                                for i, v in pairs(Character:GetChildren()) do
                                    if v.Name == "Molotov" then
                                        local npc = getnpc()
                                        if npc.HumanoidRootPart and npc.Humanoid > 0 then
                                            ReplicatedStorage.Remotes.Weapon.Throw:FireServer(
                                                v,
                                                npc.HumanoidRootPart.CFrame
                                            )
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local Noclip =
    other:Toggle(
    {
        Title = "穿墙",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.Noclip = state
            pcall(
                function()
                    while Setting.Noclip do
                        wait(0.1)
                        spawn(
                            function()
                                if Setting.Noclip and Character and Character:FindFirstChild("HumanoidRootPart") then
                                    if HumanoidRootPart.Position.Y <= -10 then
                                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 10, 0)
                                        Character:PivotTo(Character:GetPivot() + Vector3.new(0, 20, 0))
                                    end
                                end

                                if Character then
                                    for _, part in pairs(Character:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = not Setting.Noclip
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local GunAura =
    other:Toggle(
    {
        Title = "枪械光环",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.GunAura = state
            pcall(
                function()
                    while Setting.GunAura do
                        wait(0.2)
                        spawn(
                            function()
                                if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end
                                local npc = getnpc()
                                if npc and npc:FindFirstChild("Humanoid") then
                                    local head = npc.Head
                                    local humanoid = npc.Humanoid
                                    if humanoid.Health > 0 then
                                        for _, tool in pairs(Character:GetChildren()) do
                                            if tool:FindFirstChild("WeaponConfiguration") then
                                                if tool.ClientWeaponState.CurrentAmmo.Value ~= 0 then
                                                    if tool.Name == "Shotgun" or tool.Name == "Sawed-Off Shotgun" then
                                                        local args = {
                                                            [1] = workspace:GetServerTimeNow(),
                                                            [2] = tool,
                                                            [3] = CFrame.lookAt(
                                                                head.Position,
                                                                head.Position + head.CFrame.LookVector * 10
                                                            ),
                                                            [4] = {
                                                                ["14"] = npc.Humanoid,
                                                                ["8"] = npc.Humanoid,
                                                                ["2"] = npc.Humanoid,
                                                                ["5"] = npc.Humanoid,
                                                                ["11"] = npc.Humanoid,
                                                                ["7"] = npc.Humanoid
                                                            }
                                                        }
                                                        ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(unpack(args))
                                                        ReplicatedStorage.Remotes.Weapon.Reload:FireServer(
                                                            workspace:GetServerTimeNow(),
                                                            tool
                                                        )
                                                    else
                                                        local args = {
                                                            [1] = workspace:GetServerTimeNow(),
                                                            [2] = tool,
                                                            [3] = CFrame.lookAt(
                                                                head.Position,
                                                                head.Position + head.CFrame.LookVector * 10
                                                            ),
                                                            [4] = {
                                                                ["4"] = npc.Humanoid,
                                                                ["2"] = npc.Humanoid
                                                            }
                                                        }
                                                        ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(unpack(args))
                                                        ReplicatedStorage.Remotes.Weapon.Reload:FireServer(
                                                            workspace:GetServerTimeNow(),
                                                            tool
                                                        )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)

local NPCLock =
    other:Toggle(
    {
        Title = "强锁NPC",
        Default = false,
        Image = "check",
        Callback = function(state)
            if state then
                Setting.AimLock = state
                spawn(
                    function()
                        while Setting.AimLock do
                            wait(0.1)
                            pcall(
                                function()
                                    local npc = getnpc()
                                    if npc and Setting.AimLock and npc:FindFirstChild("Humanoid") then
                                        local npcHumanoid = npc:FindFirstChild("Humanoid")
                                        if npcHumanoid.Health > 0 then
                                            camera.CameraSubject = npcHumanoid
                                        end
                                    end
                                end
                            )
                        end
                    end
                )
            else
                Setting.AimLock = false
                camera.CameraSubject = Humanoid
            end
        end
    }
)

local tpend =
    other:Button(
    {
        Title = "传送终点",
        Desc = "点击开始",
        Callback = function()
            HumanoidRootPart.Anchored = true
            wait(0.5)
            HumanoidRootPart.CFrame = CFrame.new(-424, 30, -49041)
            repeat task.wait() until workspace.Baseplates:FindFirstChild("FinalBasePlate")
            BasePart = workspace.Baseplates:FindFirstChild("FinalBasePlate")
            OurLaw = BasePart:FindFirstChild("OutlawBase") 
            Sen = OurLaw:FindFirstChild("Sentries")
            if Sen:FindFirstChild("TurretSpot") and Sen.TurretSpot:FindFirstChild("MaximGun") and Sen.TurretSpot.MaximGun:FindFirstChild("VehicleSeat") then
            wait(1.5)
            for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
            v.VehicleSeat.Disabled = false
            end
            end
            wait(0.5)
            HumanoidRootPart.Anchored = false
            repeat task.wait()
            for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
            HumanoidRootPart.CFrame = v:FindFirstChild("VehicleSeat").CFrame
            end
            end
            until Humanoid.Sit == true
            wait(0.5)
            Humanoid.Sit = false
            end
        end
    }
)

local AutoCollectBond =
    other:Toggle(
    {
        Title = "自动收集债券",
        Default = false,
        Image = "check",
        Callback = function(state)
            Setting.AutoCollectBond = state
            pcall(
                function()
                    while Setting.AutoCollectBond do
                        wait(0.1)
                        spawn(
                            function()
                                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                                    if
                                        (v:GetPivot().Position - Character:GetPivot().Position).Magnitude <= 30 and
                                            v.Name == "Bond"
                                     then
                                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(
                                            v
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            )
        end
    }
)



local AutoBond =
    Teleport:Button(
    {
        Title = "自动债券(椅子)",
        Desc = "点击开始",
        Callback = function()
            pcall(
                function()
                    workspace.StreamingEnabled = false
                    if workspace:FindFirstChild("SimulationRadius") then
                        workspace.SimulationRadius = 999999
                    end
                end
            )
            local BondData = {}
            local SeenKeys = {}
            local function RecordBonds()
                for _, item in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if item.Name:match("Bond") then
                        local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local key = ("%0.1f_%0.1f_%0.1f"):format(part.Position.X, part.Position.Y, part.Position.Z)
                            if not SeenKeys[key] then
                                SeenKeys[key] = true
                                table.insert(BondData, {item = item, pos = part.Position})
                            end
                        end
                    end
                end
            end
            for i = 1, 50 do
                HumanoidRootPart.CFrame =
                    HumanoidRootPart.CFrame:Lerp(CFrame.new(-424.448975, 26.055481, -49040.6562), i / 50)
                task.wait(0.3)
                RecordBonds()
                task.wait(0.1)
            end
            HumanoidRootPart.CFrame = CFrame.new(-424.448975, 26.055481, -49040.6562)
            task.wait(0.3)
            RecordBonds()
            local chair = workspace.RuntimeItems:WaitForChild("Chair")
            chair.PrimaryPart.CanCollide = false
            local seat = chair and chair:FindFirstChild("Seat")
            if seat then
                seat:Sit(Humanoid)
            end
            local canSit = Humanoid.SeatPart == seat
            for index, bond in ipairs(BondData) do
                local pos = bond.pos + Vector3.new(0, 2, 0)
                if canSit then
                    seat:PivotTo(CFrame.new(pos))
                    task.wait(0.1)
                    if Humanoid.SeatPart ~= seat then
                        seat:Sit(Humanoid)
                    end
                else
                    HumanoidRootPart.CFrame = CFrame.new(pos)
                end
                pcall(
                    function()
                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(bond.item)
                    end
                )
                task.wait(0.5)
            end
            Humanoid:TakeDamage(999999)
            ReplicatedStorage.Remotes.EndDecision:FireServer(false)
        end
    }
)

local AutoBond2 =
    Teleport:Button(
    {
        Title = "自动债券(机枪)",
        Desc = "点击开始",
        Callback = function()
            pcall(
                function()
                    workspace.StreamingEnabled = false
                    if workspace:FindFirstChild("SimulationRadius") then
                        workspace.SimulationRadius = 999999
                    end
                end
            )
            local BondData = {}
            local SeenKeys = {}
            local function RecordBonds()
                for _, item in ipairs(workspace.RuntimeItems:GetChildren()) do
                    if item.Name:match("Bond") then
                        local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local key = ("%0.1f_%0.1f_%0.1f"):format(part.Position.X, part.Position.Y, part.Position.Z)
                            if not SeenKeys[key] then
                                SeenKeys[key] = true
                                table.insert(BondData, {item = item, pos = part.Position})
                            end
                        end
                    end
                end
            end
            for i = 1, 50 do
                HumanoidRootPart.CFrame =
                    HumanoidRootPart.CFrame:Lerp(CFrame.new(-424.448975, 26.055481, -49040.6562), i / 50)
                task.wait(0.3)
                RecordBonds()
                task.wait(0.1)
            end
            HumanoidRootPart.CFrame = CFrame.new(-424.448975, 26.055481, -49040.6562)
            task.wait(0.3)
            RecordBonds()
            local chair = workspace.RuntimeItems:WaitForChild("MaximGun")
            chair.PrimaryPart.CanCollide = false
            local seat = chair and chair:FindFirstChild("VehicleSeat")
            if seat then
                seat:Sit(Humanoid)
            end
            local canSit = Humanoid.SeatPart == seat
            for index, bond in ipairs(BondData) do
                local pos = bond.pos + Vector3.new(0, 2, 0)
                if canSit then
                    seat:PivotTo(CFrame.new(pos))
                    task.wait(0.1)
                    if Humanoid.SeatPart ~= seat then
                        seat:Sit(Humanoid)
                    end
                else
                    HumanoidRootPart.CFrame = CFrame.new(pos)
                end
                pcall(
                    function()
                        ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(bond.item)
                    end
                )
                task.wait(0.5)
            end
            Humanoid:TakeDamage(999999)
            ReplicatedStorage.Remotes.EndDecision:FireServer(false)
        end
    }
)

local tpcastle =
    Teleport:Button(
    {
        Title = "传送吸血鬼城堡",
        Desc = "点击开始",
        Callback = function()
            if not (Character and HumanoidRootPart) then
                return
            end
            HumanoidRootPart.Anchored = true
            task.wait(0.5)
            HumanoidRootPart.CFrame = CFrame.new(57, 3, -9000)
            repeat
                task.wait()
            until workspace.RuntimeItems:FindFirstChild("MaximGun")
            task.wait(0.3)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                    v.VehicleSeat.Disabled = false
                end
            end
            task.wait(0.5)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if
                    v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and
                        (HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400
                 then
                    HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
                end
            end
            task.wait(1)
            HumanoidRootPart.Anchored = false
        end
    }
)

local tpTeslaLab =
    Teleport:Button(
    {
        Title = "传送特斯拉实验室",
        Desc = "点击开始",
        Callback = function()
            if not (Character and HumanoidRootPart) then
                return
            end
            HumanoidRootPart.Anchored = true
            task.wait(0.5)
            HumanoidRootPart.CFrame = workspace.TeslaLab.Generator.Generator.CFrame
            repeat
                task.wait()
            until workspace.RuntimeItems:FindFirstChild("Chair")
            task.wait(0.3)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "Chair" and v:FindFirstChild("Seat") then
                    v.Seat.Disabled = false
                end
            end
            task.wait(0.5)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if
                    v.Name == "Chair" and v:FindFirstChild("Seat") and
                        (HumanoidRootPart.Position - v.Seat.Position).Magnitude < 250
                 then
                    HumanoidRootPart.CFrame = v.Seat.CFrame
                end
            end
            task.wait(1)
            HumanoidRootPart.Anchored = false
        end
    }
)

local tpfort =
    Teleport:Button(
    {
        Title = "传送军营",
        Desc = "点击开始",
        Callback = function()
            local tween =
                TweenService:Create(
                HumanoidRootPart,
                TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {CFrame = CFrame.new(HumanoidRootPart.CFrame.X, HumanoidRootPart.CFrame.Y, -1000)}
            )
            tween:Play()
            tween.Completed:Wait()
            local found = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == "Cannon" then
                    local seat = v:FindFirstChild("VehicleSeat")
                    if seat then
                        Humanoid.Sit = true
                        Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                        seat:Sit(Humanoid)
                        HumanoidRootPart.CFrame = seat.CFrame
                        wait(2)
                        found = true
                        break
                    end
                end
            end
        end
    }
)

local tpSterling =
    Teleport:Button(
    {
        Title = "传送矿洞小镇",
        Desc = "点击开始",
        Callback = function()
            local tween =
                TweenService:Create(
                HumanoidRootPart,
                TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {CFrame = CFrame.new(HumanoidRootPart.CFrame.X, HumanoidRootPart.CFrame.Y, -3000)}
            )
            tween:Play()
            tween.Completed:Wait()
            local found = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == "Sterling" then
                    SterlingPos = v:GetPivot().Position + Vector3.new(0, 10)
                end
            end
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "Chair" and v:FindFirstChild("Seat") then
                    Chair = v
                end
            end
            if (HumanoidRootPart.Position - Chair.Seat.Position).Magnitude < 250 then
                Chair:PivotTo(CFrame.new(SterlingPos))
                Chair.Seat.Disabled = false
                Chair.Seat:Sit(Humanoid)
                Humanoid.Sit = true
                Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                HumanoidRootPart.CFrame = Chair.Seat.CFrame
            end
        end
    }
)

local Select =
    Teleport:Dropdown(
    {
        Title = "选择站点",
        Values = {
            "出生点",
            "10 KM",
            "20 KM",
            "30 KM",
            "40 KM",
            "50 KM",
            "60 KM",
            "70 KM"
        },
        Value = "未选择",
        Callback = function(option)
            tptl(option)
        end
    }
)


Settings:Paragraph({
    Title = "ui设置",
    Desc = "二改wind原版ui",
    Image = "settings",
    ImageSize = 20,
    Color = "White"
})

Settings:Toggle({
    Title = "启用边框",
    Value = borderEnabled,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and windowOpen and not rainbowBorderAnimation then
                    startBorderAnimation(Window, animationSpeed)
                elseif not value and rainbowBorderAnimation then
                    rainbowBorderAnimation:Disconnect()
                    rainbowBorderAnimation = nil
                end
                
                WindUI:Notify({
                    Title = "边框",
                    Content = value and "已启用" or "已禁用",
                    Duration = 2,
                    Icon = value and "eye" or "eye-off"
                })
            end
        end
    end
})

Settings:Toggle({
    Title = "启用字体颜色",
    Value = fontColorEnabled,
    Callback = function(value)
        fontColorEnabled = value
        applyFontColorsToWindow(currentFontColorScheme)
        
        WindUI:Notify({
            Title = "字体颜色",
            Content = value and "已启用" or "已禁用",
            Duration = 2,
            Icon = value and "type" or "type"
        })
    end
})

Settings:Toggle({
    Title = "启用音效",
    Value = soundEnabled,
    Callback = function(value)
        soundEnabled = value
        WindUI:Notify({
            Title = "音效",
            Content = value and "已启用" or "已禁用",
            Duration = 2,
            Icon = value and "volume-2" or "volume-x"
        })
    end
})

Settings:Toggle({
    Title = "启用背景模糊",
    Value = blurEnabled,
    Callback = function(value)
        blurEnabled = value
        applyBlurEffect(value)
        WindUI:Notify({
            Title = "背景模糊",
            Content = value and "已启用" or "已禁用",
            Duration = 2,
            Icon = value and "cloud-rain" or "cloud"
        })
    end
})

local colorSchemeNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorSchemeNames, name)
end
table.sort(colorSchemeNames)

Settings:Dropdown({
    Title = "边框颜色方案",
    Desc = "选择喜欢的颜色组合",
    Values = colorSchemeNames,
    Value = "彩虹颜色",
    Callback = function(value)
        currentBorderColorScheme = value
        local success = initializeRainbowBorder(value, animationSpeed)
        playSound()
    end
})

Settings:Dropdown({
    Title = "字体颜色方案",
    Desc = "选择文字颜色组合",
    Values = colorSchemeNames,
    Value = "彩虹颜色",
    Callback = function(value)
        currentFontColorScheme = value
        applyFontColorsToWindow(value)
        playSound()
    end
})

local fontOptions = {}
for _, fontName in ipairs(FONT_STYLES) do
    local description = FONT_DESCRIPTIONS[fontName] or fontName
    table.insert(fontOptions, {text = description, value = fontName})
end

table.sort(fontOptions, function(a, b)
    return a.text < b.text
end)

local fontValues = {}
local fontValueToName = {}
for _, option in ipairs(fontOptions) do
    table.insert(fontValues, option.text)
    fontValueToName[option.text] = option.value
end

Settings:Dropdown({
    Title = "字体样式",
    Desc = "选择文字字体样式 (" .. #FONT_STYLES .. " 种可用)",
    Values = fontValues,
    Value = "标准粗体",
    Callback = function(value)
        local fontName = fontValueToName[value]
        if fontName then
            currentFontStyle = fontName
            local successCount, totalCount = applyFontStyleToWindow(fontName)
            playSound()
        end
    end
})

Settings:Slider({
    Title = "边框转动速度",
    Desc = "调整边框旋转的快慢",
    Value = { 
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        animationSpeed = value
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        if borderEnabled then
            startBorderAnimation(Window, animationSpeed)
        end
        
        applyFontColorsToWindow(currentFontColorScheme)
        playSound()
    end
})

Settings:Slider({
    Title = "UI整体缩放",
    Desc = "调整UI大小比例",
    Value = { 
        Min = 0.5,
        Max = 1.5,
        Default = 1,
    },
    Step = 0.1,
    Callback = function(value)
        uiScale = value
        applyUIScale(value)
        playSound()
    end
})

Settings:Divider()

Settings:Slider({
    Title = "UI透明度",
    Desc = "调整整个UI的透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
        playSound()
    end
})

Settings:Slider({
    Title = "调整UI宽度",
    Desc = "调整窗口的宽度",
    Value = { 
        Min = 500,
        Max = 800,
        Default = 600,
    },
    Callback = function(value)
        if Window.UIElements and Window.UIElements.Main then
            Window.UIElements.Main.Size = UDim2.fromOffset(value, 400)
        end
        playSound()
    end
})

Settings:Slider({
    Title = "调整UI高度",
    Desc = "调整窗口的高度",
    Value = { 
        Min = 300,
        Max = 600,
        Default = 400,
    },
    Callback = function(value)
        if Window.UIElements and Window.UIElements.Main then
            local currentWidth = Window.UIElements.Main.Size.X.Offset
            Window.UIElements.Main.Size = UDim2.fromOffset(currentWidth, value)
        end
        playSound()
    end
})

Settings:Slider({
    Title = "边框粗细",
    Desc = "调整边框的粗细",
    Value = { 
        Min = 1,
        Max = 5,
        Default = 1.5,
    },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
        playSound()
    end
})

Settings:Slider({
    Title = "圆角大小",
    Desc = "调整UI圆角的大小",
    Value = { 
        Min = 0,
        Max = 20,
        Default = 16,
    },
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
        playSound()
    end
})

Settings:Button({
    Title = "恢复UI到原位",
    Icon = "rotate-ccw",
    Callback = function()
        if Window.UIElements and Window.UIElements.Main then
            Window.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
            playSound()
        end
    end
})

Settings:Button({
    Title = "重置UI大小",
    Icon = "maximize-2",
    Callback = function()
        if Window.UIElements and Window.UIElements.Main then
            Window.UIElements.Main.Size = UDim2.fromOffset(600, 400)
            playSound()
        end
    end
})

Settings:Button({
    Title = "随机字体",
    Icon = "shuffle",
    Callback = function()
        local randomFont = FONT_STYLES[math.random(1, #FONT_STYLES)]
        currentFontStyle = randomFont
        applyFontStyleToWindow(randomFont)
        playSound()
    end
})

Settings:Button({
    Title = "随机颜色",
    Icon = "palette",
    Callback = function()
        local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
        currentBorderColorScheme = randomColor
        initializeRainbowBorder(randomColor, animationSpeed)
        playSound()
    end
})

Settings:Divider()

Settings:Button({
    Title = "刷新字体颜色",
    Icon = "refresh-cw",
    Callback = function()
        applyFontColorsToWindow(currentFontColorScheme)
        playSound()
    end
})

Settings:Button({
    Title = "刷新字体样式",
    Icon = "refresh-cw",
    Callback = function()
        local successCount, totalCount = applyFontStyleToWindow(currentFontStyle)
        playSound()
    end
})

Settings:Button({
    Title = "测试所有字体",
    Icon = "check-circle",
    Callback = function()
        local workingFonts = {}
        local totalFonts = #FONT_STYLES
        
        for i, fontName in ipairs(FONT_STYLES) do
            local success = pcall(function()
                local test = Enum.Font[fontName]
            end)
            
            if success then
                table.insert(workingFonts, fontName)
            end
        end
        playSound()
    end
})

Settings:Button({
    Title = "导出设置",
    Icon = "download",
    Callback = function()
        local settings = {
            font = currentFontStyle,
            borderColor = currentBorderColorScheme,
            fontSize = currentFontColorScheme,
            speed = animationSpeed,
            scale = uiScale
        }
        setclipboard("Action 设置: " .. game:GetService("HttpService"):JSONEncode(settings))
        playSound()
    end
})

Window:OnClose(function()
    windowOpen = false
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    applyBlurEffect(false)
end)

Window:OnDestroy(function()
    windowOpen = false
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    for _, animation in pairs(fontColorAnimations) do
        animation:Disconnect()
    end
    fontColorAnimations = {}
    applyBlurEffect(false)
end)