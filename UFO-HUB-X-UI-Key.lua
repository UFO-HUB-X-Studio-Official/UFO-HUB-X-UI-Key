--===== UFO HUB X • Key UI + Language Panel A V2 + Key System (4 Mode + VIP(10) + Save + Toast i18n) =====
-- LocalScript (StarterGui / StarterPlayerScripts)

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local lp               = Players.LocalPlayer

---------------------------------------------------------------------
-- THEME + HELPERS
---------------------------------------------------------------------
local THEME = {
    GREEN       = Color3.fromRGB(25,255,125),
    GREEN_DARK  = Color3.fromRGB(0,120,60),
    WHITE       = Color3.fromRGB(255,255,255),
    BLACK       = Color3.fromRGB(0,0,0),
    GOLD        = Color3.fromRGB(255,215,0),
    DARK_BG     = Color3.fromRGB(8,8,8),
    RED         = Color3.fromRGB(255,50,50),
}

local function corner(ui, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = ui
    return c
end

local function stroke(ui, th, col, trans)
    local s = Instance.new("UIStroke")
    s.Thickness = th or 2.2
    s.Color = col or THEME.GREEN
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = trans or 0
    s.Parent = ui
    return s
end

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$","%1"))
end

---------------------------------------------------------------------
-- KEY SYSTEM CONFIG (4 ระบบ + VIP 10 รหัส)  + SAVE
---------------------------------------------------------------------
_G.UFOX_KEY_SYSTEM = _G.UFOX_KEY_SYSTEM or {
    -- ระบบ 1: Luarmor (รองรับอนาคต)
    LUARMOR_MAPS = {
        [2753915549]       = true, -- Blox Fruit Sea 1
        [4442272183]       = true, -- Blox Fruit Sea 2
        [7449423635]       = true, -- Blox Fruit Sea 3
        [126509999114328]  = true, -- 99 Nights in the Forest
        [109983668079237]  = true, -- Steal a Brainrot
        [127742093697776]  = true, -- Plants Vs Brainrots
        [121864768012064]  = true, -- Fish It
        [131716211654599]  = true, -- Fisch
        [126884695634066]  = true, -- Grow a Garden
    },

    -- ระบบ 2: Custom Key (ถาวร)
    CUSTOM_KEY = {
        [82013336390273]   = "UFO-HUB X-Axe-Simulator!-max9999jkmax8888jkmax123", -- Axe Simulator!
        [117784363858270]  = "UFO-HUB-X-Throw-a-basketball!-123m888m999m",        -- Throw a basketball!
    },

    -- ระบบ 3: Free (ไม่ต้องใส่ Key)
    FREE_MAPS = {
        [97777561575736]   = true, -- Kayak racing
    },

    -- ระบบ 4: VIP (จำกัด 10 รหัสถาวร)
    VIP_CODES = {
        "UFO-HUB-X-VIP-A1Z9Q7K3",
        "UFO-HUB-X-VIP-B8X2M4N6",
        "UFO-HUB-X-VIP-C3L7P9Q1",
        "UFO-HUB-X-VIP-D6R4T8V2",
        "UFO-HUB-X-VIP-E9Y1K5J7",
        "UFO-HUB-X-VIP-F2H8W3Z9",
        "UFO-HUB-X-VIP-G4P6Q1X8",
        "UFO-HUB-X-VIP-H7M3N9L2",
        "UFO-HUB-X-VIP-J5V1C8R4",
        "UFO-HUB-X-VIP-K9Q2Z7Y6",
    },

    -- ลิงก์ Key ต่อแมพ (ตอนนี้มี 2 แมพระบบ 2)
    KEY_LINK = {
        [82013336390273] = {
            name = "Axe Simulator!",
            url  = "https://link-center.net/1458562/DS9lEKrJEO2z",
        },
        [117784363858270] = {
            name = "Throw a basketball!",
            url  = "https://link-center.net/1458562/1OoW76T3RH2n",
        },
    },
}

local KEY_CONFIG = _G.UFOX_KEY_SYSTEM

-- log VIP codes ให้เจ้าของเห็นใน Output
warn("[UFO HUB X] VIP Codes (10):")
for i,code in ipairs(KEY_CONFIG.VIP_CODES) do
    print(i, code)
end

-- SAVE CONFIG
local SAVE_DIR  = "UFO HUB X"
local SAVE_FILE = SAVE_DIR .. "/KeySystem.json"

local KEY_STATE = { verified = {} }

local function loadKeyState()
    if not readfile then return end
    local ok, raw = pcall(function() return readfile(SAVE_FILE) end)
    if not ok or type(raw) ~= "string" or raw == "" then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(decoded) == "table" then
        return decoded
    end
end

local function saveKeyState()
    if not (writefile and makefolder) then return end
    pcall(function() makefolder(SAVE_DIR) end)
    local ok, data = pcall(function()
        return HttpService:JSONEncode(KEY_STATE)
    end)
    if not ok then return end
    pcall(function() writefile(SAVE_FILE, data) end)
end

local loaded = loadKeyState()
if loaded then
    KEY_STATE = loaded
end
_G.UFOX_KEY_STATE = KEY_STATE

local function markVerified(mode, keyType, rawKey)
    local pid = tostring(game.PlaceId)
    KEY_STATE.verified = KEY_STATE.verified or {}
    KEY_STATE.verified[pid] = {
        mode    = mode,      -- 1/2/3/4
        keyType = keyType,   -- "VIP","CUSTOM","FREE","LUARMOR","UNKNOWN"
        key     = rawKey,
        time    = os.time(),
    }
    saveKeyState()
end

local function detectMapMode()
    local pid = game.PlaceId
    if KEY_CONFIG.CUSTOM_KEY[pid] then
        return 2
    end
    if KEY_CONFIG.FREE_MAPS[pid] then
        return 3
    end
    if KEY_CONFIG.LUARMOR_MAPS[pid] then
        return 1
    end
    return nil
end

local CURRENT_MODE = detectMapMode() or 0
print("[UFO HUB X] Key System Mode for this map =", CURRENT_MODE, "(1=Luarmor, 2=Custom, 3=Free, 0=Unknown)")

---------------------------------------------------------------------
-- TOAST (แบบเดียวกับ UFO Toast, single-step) + i18n message
---------------------------------------------------------------------
local EDGE_RIGHT_PAD, EDGE_BOTTOM_PAD = 2, 2
local TOAST_W, TOAST_H = 320, 86
local RADIUS, STROKE_TH = 10, 2
local GREEN = Color3.fromRGB(0,255,140)
local BLACK = Color3.fromRGB(10,10,10)
local LOGO_TOAST = "rbxassetid://83753985156201" -- โลโก้ Step2 เดิม

local MSG_I18N = {
    EN = {
        CHECKING   = "Checking key... ⏳",
        EMPTY      = "Please enter your key first. ⚠️",
        INVALID    = "Invalid key. ❌",
        VALID      = "Key confirmed. ✅",
        VIP_OK     = "VIP key confirmed. 🌟",
        FREE       = "This game does not require a key. ✅",
        LUARMOR_OK = "Luarmor key (test mode) accepted. ✅",
        UNKNOWN    = "This game is not configured in key system. ❌",
        LINK_OK    = "Key link opened successfully. 🔗",
    },
    TH = {
        CHECKING   = "กำลังตรวจสอบคีย์... ⏳",
        EMPTY      = "กรุณาใส่คีย์ก่อนนะ ⚠️",
        INVALID    = "คีย์ไม่ถูกต้อง ❌",
        VALID      = "ยืนยันคีย์เรียบร้อย ✅",
        VIP_OK     = "ยืนยันคีย์ VIP แล้ว 🌟",
        FREE       = "แมพนี้ไม่ต้องใช้คีย์ ✅",
        LUARMOR_OK = "คีย์ Luarmor (โหมดทดสอบ) ผ่านแล้ว ✅",
        UNKNOWN    = "แมพนี้ยังไม่ได้ตั้งค่าระบบคีย์ ❌",
        LINK_OK    = "กดลิงก์คีย์สำเร็จแล้ว 🔗",
    },
    VN = {
        CHECKING   = "Đang kiểm tra key... ⏳",
        EMPTY      = "Vui lòng nhập key trước. ⚠️",
        INVALID    = "Key không hợp lệ. ❌",
        VALID      = "Đã xác nhận key. ✅",
        VIP_OK     = "Đã xác nhận key VIP. 🌟",
        FREE       = "Map này không cần key. ✅",
        LUARMOR_OK = "Key Luarmor (chế độ test) đã được chấp nhận. ✅",
        UNKNOWN    = "Map này chưa được cấu hình hệ thống key. ❌",
        LINK_OK    = "Đã mở link key thành công. 🔗",
    },
    ID = {
        CHECKING   = "Memeriksa key... ⏳",
        EMPTY      = "Silakan masukkan key dulu. ⚠️",
        INVALID    = "Key tidak valid. ❌",
        VALID      = "Key dikonfirmasi. ✅",
        VIP_OK     = "Key VIP dikonfirmasi. 🌟",
        FREE       = "Game ini tidak membutuhkan key. ✅",
        LUARMOR_OK = "Key Luarmor (mode tes) diterima. ✅",
        UNKNOWN    = "Game ini belum diatur sistem key. ❌",
        LINK_OK    = "Link key berhasil dibuka. 🔗",
    },
    PH = {
        CHECKING   = "Tine-check ang key... ⏳",
        EMPTY      = "Pakilagay muna ng key. ⚠️",
        INVALID    = "Maling key. ❌",
        VALID      = "Na-kumpirma ang key. ✅",
        VIP_OK     = "Na-kumpirma ang VIP key. 🌟",
        FREE       = "Hindi kailangan ng key sa game na ito. ✅",
        LUARMOR_OK = "Luarmor key (test mode) tinanggap. ✅",
        UNKNOWN    = "Wala pang key system para sa game na ito. ❌",
        LINK_OK    = "Matagumpay na na-open ang key link. 🔗",
    },
    BR = {
        CHECKING   = "Verificando a key... ⏳",
        EMPTY      = "Por favor, insira a key primeiro. ⚠️",
        INVALID    = "Key inválida. ❌",
        VALID      = "Key confirmada. ✅",
        VIP_OK     = "Key VIP confirmada. 🌟",
        FREE       = "Este jogo não precisa de key. ✅",
        LUARMOR_OK = "Key Luarmor (modo teste) aceita. ✅",
        UNKNOWN    = "Este jogo não está configurado no sistema de keys. ❌",
        LINK_OK    = "Link da key aberto com sucesso. 🔗",
    },
}

local currentLang = "EN" -- จะอัปเดตตาม UI ภาษาด้านขวา

local function makeToastGui(name)
    local pg = lp:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999
    gui.Parent = pg
    return gui
end

local function buildToastBox(parent)
    local box = Instance.new("Frame")
    box.Name = "Toast"
    box.AnchorPoint = Vector2.new(1,1)
    box.Position = UDim2.new(1, -EDGE_RIGHT_PAD, 1, -(EDGE_BOTTOM_PAD - 24))
    box.Size = UDim2.fromOffset(TOAST_W, TOAST_H)
    box.BackgroundColor3 = BLACK
    box.BorderSizePixel = 0
    box.Parent = parent
    corner(box, RADIUS)
    local strokeUi = Instance.new("UIStroke")
    strokeUi.Parent = box
    strokeUi.Thickness = STROKE_TH
    strokeUi.Color = GREEN
    strokeUi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    strokeUi.LineJoinMode = Enum.LineJoinMode.Round
    return box
end

local function buildToastTitle(box)
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.RichText = true
    title.Text = '<font color="#FFFFFF">UFO</font> <font color="#00FF8C">HUB X</font>'
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(235,235,235)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.fromOffset(68, 12)
    title.Size = UDim2.fromOffset(TOAST_W - 78, 20)
    title.Parent = box
    return title
end

local function buildToastMsg(box, text)
    local msg = Instance.new("TextLabel")
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.Gotham
    msg.Text = text
    msg.TextSize = 13
    msg.TextColor3 = Color3.fromRGB(200,200,200)
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.Position = UDim2.fromOffset(68, 34)
    msg.Size = UDim2.fromOffset(TOAST_W - 78, 18)
    msg.Parent = box
    return msg
end

local function buildToastLogo(box)
    local logo = Instance.new("ImageLabel")
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_TOAST
    logo.Size = UDim2.fromOffset(54, 54)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.Position = UDim2.new(0, 8, 0.5, -2)
    logo.Parent = box
    return logo
end

local function showToast(msgKey)
    local langMap = MSG_I18N[currentLang] or MSG_I18N.EN
    local text = langMap[msgKey] or MSG_I18N.EN[msgKey] or ("[" .. tostring(msgKey) .. "]")
    local guiName = "UFO_Toast_Key_" .. tostring(math.random(1000,9999))

    local gui = makeToastGui(guiName)
    local box = buildToastBox(gui)
    buildToastLogo(box)
    buildToastTitle(box)
    buildToastMsg(box, text)

    local tweenIn = TweenService:Create(
        box,
        TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -EDGE_RIGHT_PAD, 1, -EDGE_BOTTOM_PAD)}
    )
    tweenIn:Play()
    tweenIn.Completed:Wait()

    task.delay(1.2, function()
        if not box or not box.Parent then return end
        local tweenOut = TweenService:Create(
            box,
            TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
            {Position = UDim2.new(1, -EDGE_RIGHT_PAD, 1, -(EDGE_BOTTOM_PAD - 24))}
        )
        tweenOut:Play()
        tweenOut.Completed:Wait()
        if gui then gui:Destroy() end
    end)
end

---------------------------------------------------------------------
-- ROOT GUI
---------------------------------------------------------------------
local playerGui = lp:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "UFOX_KeySystemUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = playerGui

---------------------------------------------------------------------
-- MAIN PANEL (BACKGROUND)  >> ดีไซน์เดิม แต่เลื่อนลงนิดหน่อย
---------------------------------------------------------------------
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.52, 0) -- เลื่อนลงเล็กน้อย
main.Size = UDim2.new(0.62, 0, 0.60, 0)
main.BackgroundColor3 = THEME.DARK_BG
main.BorderSizePixel = 0
corner(main, 18)
stroke(main, 3, THEME.GREEN_DARK, 0.05)

local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.Parent = main
inner.BackgroundTransparency = 1
inner.BorderSizePixel = 0
inner.Size = UDim2.new(1,-10,1,-10)
inner.Position = UDim2.new(0,5,0,5)
corner(inner, 16)
stroke(inner, 2, THEME.GREEN, 0)

---------------------------------------------------------------------
-- TOP RIGHT BUTTONS (SETTINGS + CLOSE)
---------------------------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Parent = main
topBar.BackgroundTransparency = 1
topBar.Size = UDim2.new(1, -20, 0, 26)
topBar.Position = UDim2.new(0, 10, 0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Parent = topBar
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Position = UDim2.new(1, 0, 0, 0)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.BackgroundColor3 = THEME.BLACK
closeBtn.BorderSizePixel = 0
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = THEME.RED
closeBtn.AutoButtonColor = true
corner(closeBtn, 6)
stroke(closeBtn, 1.8, THEME.GREEN_DARK, 0.3)

local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "Settings"
settingsBtn.Parent = topBar
settingsBtn.AnchorPoint = Vector2.new(1, 0)
settingsBtn.Position = UDim2.new(1, -32, 0, 0)
settingsBtn.Size = UDim2.new(0, 26, 0, 26)
settingsBtn.BackgroundColor3 = THEME.BLACK
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "⚙"
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextColor3 = THEME.WHITE
settingsBtn.TextScaled = true
settingsBtn.AutoButtonColor = true
corner(settingsBtn, 6)
local settingsStroke = stroke(settingsBtn, 1.8, THEME.GREEN_DARK, 0.4)

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local function updateSettingsVisual(isOpen)
    if isOpen then
        settingsStroke.Color        = THEME.GREEN
        settingsStroke.Thickness    = 2.2
        settingsStroke.Transparency = 0
    else
        settingsStroke.Color        = THEME.GREEN_DARK
        settingsStroke.Thickness    = 1.8
        settingsStroke.Transparency = 0.4
    end
end
updateSettingsVisual(false)

---------------------------------------------------------------------
-- LOGO IMAGE
---------------------------------------------------------------------
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Parent = main
logo.AnchorPoint = Vector2.new(0.5, 0)
logo.Position = UDim2.new(0.5, 0, 0, -110)
logo.Size = UDim2.new(0, 220, 0, 220)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://100650447103028"
logo.ScaleType = Enum.ScaleType.Fit

---------------------------------------------------------------------
-- TITLE / SUBTITLE
---------------------------------------------------------------------
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = main
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.new(0.5, 0, 0, 50)
title.Size = UDim2.new(0.9, 0, 0, 60)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextColor3 = THEME.WHITE
title.RichText = true
title.TextScaled = true
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextXAlignment = Enum.TextXAlignment.Center
title.Text = '<font color="#FFFFFF">UFO</font> <font color="#19FF7D">HUB X</font>'

local subTitle = Instance.new("TextLabel")
subTitle.Name = "SubTitle"
subTitle.Parent = main
subTitle.AnchorPoint = Vector2.new(0.5, 0)
subTitle.Position = UDim2.new(0.5, 0, 0, 100)
subTitle.Size = UDim2.new(0.5, 0, 0, 32)
subTitle.BackgroundTransparency = 1
subTitle.Font = Enum.Font.GothamBold
subTitle.TextColor3 = THEME.GOLD
subTitle.RichText = true
subTitle.TextScaled = true
subTitle.TextYAlignment = Enum.TextYAlignment.Center
subTitle.TextXAlignment = Enum.TextXAlignment.Center
subTitle.Text = '<font color="#FFD700">Key</font> 🔑'

---------------------------------------------------------------------
-- KEY BOX + BUTTONS
---------------------------------------------------------------------
local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyBox"
keyBox.Parent = main
keyBox.AnchorPoint = Vector2.new(0.5, 0)
keyBox.Position = UDim2.new(0.5, 0, 0, 195)
keyBox.Size = UDim2.new(0.8, 0, 0, 50)
keyBox.BackgroundColor3 = THEME.BLACK
keyBox.BorderSizePixel = 0
keyBox.Font = Enum.Font.GothamBold
keyBox.TextSize = 16
keyBox.TextColor3 = THEME.WHITE
keyBox.ClearTextOnFocus = false
keyBox.PlaceholderText = "Enter Your Key..."
keyBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
keyBox.TextXAlignment = Enum.TextXAlignment.Center
keyBox.Text = ""
corner(keyBox, 10)
stroke(keyBox, 2.4, THEME.GREEN, 0)

local buttonRow = Instance.new("Frame")
buttonRow.Name = "ButtonRow"
buttonRow.Parent = main
buttonRow.AnchorPoint = Vector2.new(0.5, 0)
buttonRow.Position = UDim2.new(0.5, 0, 0, 265)
buttonRow.Size = UDim2.new(0.8, 0, 0, 60)
buttonRow.BackgroundTransparency = 1

local uiList = Instance.new("UIListLayout")
uiList.Parent = buttonRow
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Center
uiList.Padding = UDim.new(0, 18)

local confirmBtn = Instance.new("TextButton")
confirmBtn.Name = "ConfirmKey"
confirmBtn.Parent = buttonRow
confirmBtn.Size = UDim2.new(0.5, -9, 1, 0)
confirmBtn.BackgroundColor3 = THEME.BLACK
confirmBtn.BorderSizePixel = 0
confirmBtn.AutoButtonColor = true
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 16
confirmBtn.TextColor3 = THEME.WHITE
confirmBtn.Text = "Confirm Key"
confirmBtn.TextWrapped = true
corner(confirmBtn, 12)
stroke(confirmBtn, 2.2, THEME.GREEN, 0)

local linkBtn = Instance.new("TextButton")
linkBtn.Name = "GetKeyLink"
linkBtn.Parent = buttonRow
linkBtn.Size = UDim2.new(0.5, -9, 1, 0)
linkBtn.BackgroundColor3 = THEME.BLACK
linkBtn.BorderSizePixel = 0
linkBtn.AutoButtonColor = true
linkBtn.Font = Enum.Font.GothamBold
linkBtn.TextSize = 16
linkBtn.TextColor3 = THEME.WHITE
linkBtn.Text = "Get Key Link"
linkBtn.TextWrapped = true
corner(linkBtn, 12)
stroke(linkBtn, 2.2, THEME.GREEN, 0)

---------------------------------------------------------------------
-- LANGUAGE PACK (6 ภาษา)
---------------------------------------------------------------------
local LANG_PACK = {
    EN = {
        name        = "🇺🇸 English",
        placeholder = "Enter Your Key...",
        confirm     = "Confirm Key",
        link        = "Get Key Link",
        langTitle   = "Language",
        searchHint  = "🔍 Search Language",
    },
    TH = {
        name        = "🇹🇭 ภาษาไทย",
        placeholder = "ใส่คีย์ของคุณ...",
        confirm     = "ยืนยันคีย์",
        link        = "รับลิงก์คีย์",
        langTitle   = "ภาษา",
        searchHint  = "🔍 ค้นหาภาษา",
    },
    VN = {
        name        = "🇻🇳 Tiếng Việt",
        placeholder = "Nhập key của bạn...",
        confirm     = "Xác nhận key",
        link        = "Lấy link key",
        langTitle   = "Ngôn ngữ",
        searchHint  = "🔍 Tìm ngôn ngữ",
    },
    ID = {
        name        = "🇮🇩 Bahasa Indonesia",
        placeholder = "Masukkan key kamu...",
        confirm     = "Konfirmasi key",
        link        = "Dapatkan link key",
        langTitle   = "Bahasa",
        searchHint  = "🔍 Cari bahasa",
    },
    PH = {
        name        = "🇵🇭 Filipino",
        placeholder = "Ilagay ang iyong key...",
        confirm     = "Kumpirmahin ang key",
        link        = "Kunin ang key link",
        langTitle   = "Wika",
        searchHint  = "🔍 Hanapin ang wika",
    },
    BR = {
        name        = "🇧🇷 Português (BR)",
        placeholder = "Digite sua key...",
        confirm     = "Confirmar key",
        link        = "Obter link da key",
        langTitle   = "Idioma",
        searchHint  = "🔍 Buscar idioma",
    },
}

local LANG_ORDER = { "EN","TH","VN","ID","PH","BR" }

---------------------------------------------------------------------
-- PANEL I18N
---------------------------------------------------------------------
local PANEL_I18N = {
    EN = {
        TITLE  = "Language",
        SEARCH = "🔍 Search Language",
        EN     = "🇺🇸 English",
        TH     = "🇹🇭 Thai",
        VN     = "🇻🇳 Vietnamese",
        ID     = "🇮🇩 Indonesian",
        PH     = "🇵🇭 Filipino",
        BR     = "🇧🇷 Brazilian Portuguese",
    },
    TH = {
        TITLE  = "ภาษา",
        SEARCH = "🔍 ค้นหาภาษา",
        EN     = "🇺🇸 อังกฤษ",
        TH     = "🇹🇭 ภาษาไทย",
        VN     = "🇻🇳 ภาษาเวียดนาม",
        ID     = "🇮🇩 ภาษาอินโดนีเซีย",
        PH     = "🇵🇭 ภาษา ฟิลิปปินส์",
        BR     = "🇧🇷 โปรตุเกส (บราซิล)",
    },
    VN = {
        TITLE  = "Ngôn ngữ",
        SEARCH = "🔍 Tìm ngôn ngữ",
        EN     = "🇺🇸 Tiếng Anh",
        TH     = "🇹🇭 Tiếng Thái",
        VN     = "🇻🇳 Tiếng Việt",
        ID     = "🇮🇩 Tiếng Indonesia",
        PH     = "🇵🇭 Tiếng Philippines",
        BR     = "🇧🇷 Tiếng Bồ Đào Nha (Brazil)",
    },
    ID = {
        TITLE  = "Bahasa",
        SEARCH = "🔍 Cari bahasa",
        EN     = "🇺🇸 Inggris",
        TH     = "🇹🇭 Thailand",
        VN     = "🇻🇳 Vietnam",
        ID     = "🇮🇩 Indonesia",
        PH     = "🇵🇭 Filipina",
        BR     = "🇧🇷 Portugis (Brasil)",
    },
    PH = {
        TITLE  = "Wika",
        SEARCH = "🔍 Hanapin ang wika",
        EN     = "🇺🇸 Ingles",
        TH     = "🇹🇭 Thai",
        VN     = "🇻🇳 Vietnamese",
        ID     = "🇮🇩 Indonesia",
        PH     = "🇵🇭 Filipino",
        BR     = "🇧🇷 Portuguese (Brazil)",
    },
    BR = {
        TITLE  = "Idioma",
        SEARCH = "🔍 Buscar idioma",
        EN     = "🇺🇸 Inglês",
        TH     = "🇹🇭 Tailandês",
        VN     = "🇻🇳 Vietnamita",
        ID     = "🇮🇩 Indonésio",
        PH     = "🇵🇭 Filipino",
        BR     = "🇧🇷 Português (Brasil)",
    },
}

---------------------------------------------------------------------
-- LANGUAGE PANEL (Model A V2)
---------------------------------------------------------------------
local PANEL_WIDTH  = 230
local PANEL_HEIGHT = 320
local langPanelOpen = false
local langPanel
local langRows = {}

langPanel = Instance.new("Frame")
langPanel.Name = "LanguagePanel"
langPanel.Parent = gui
langPanel.AnchorPoint = Vector2.new(0, 0.5)
langPanel.Position = UDim2.new(0.76, 0, 0.56, 0)
langPanel.Size     = UDim2.new(0, 0, 0, PANEL_HEIGHT)
langPanel.BackgroundColor3 = THEME.BLACK
langPanel.BackgroundTransparency = 0.05
langPanel.BorderSizePixel = 0
langPanel.ClipsDescendants = true
langPanel.Visible = false
corner(langPanel, 18)
stroke(langPanel, 2.4, THEME.GREEN_DARK, 0)

local body = Instance.new("Frame")
body.Parent = langPanel
body.BackgroundTransparency = 1
body.Size = UDim2.new(1, -10, 1, -10)
body.Position = UDim2.new(0, 5, 0, 5)

local titleLang = Instance.new("TextLabel")
titleLang.Parent = body
titleLang.Size = UDim2.new(1, -8, 0, 26)
titleLang.Position = UDim2.new(0, 4, 0, 0)
titleLang.BackgroundTransparency = 1
titleLang.Font = Enum.Font.GothamBold
titleLang.TextSize = 18
titleLang.TextColor3 = THEME.WHITE
titleLang.TextXAlignment = Enum.TextXAlignment.Left
titleLang.Text = "Language"

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Parent = body
searchBox.BackgroundColor3 = THEME.BLACK
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.GothamBold
searchBox.TextSize = 16
searchBox.TextColor3 = THEME.WHITE
searchBox.PlaceholderText = "🔍 Search Language"
searchBox.TextXAlignment = Enum.TextXAlignment.Center
searchBox.Text = ""
searchBox.Size = UDim2.new(1, -8, 0, 32)
searchBox.Position = UDim2.new(0, 4, 0, 30)
corner(searchBox, 10)
local sbStroke = stroke(searchBox, 1.8, THEME.GREEN_DARK, 0.3)

local list = Instance.new("ScrollingFrame")
list.Parent = body
list.BackgroundColor3 = THEME.BLACK
list.BorderSizePixel = 0
list.ScrollBarThickness = 0
list.Position = UDim2.new(0, 4, 0, 30 + 32 + 8)
list.Size = UDim2.new(1, -8, 1, -(30 + 32 + 12))
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ScrollingDirection = Enum.ScrollingDirection.Y
list.ClipsDescendants = true

local layout = Instance.new("UIListLayout")
layout.Parent = list
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding")
pad.Parent = list
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 6)
pad.PaddingLeft = UDim.new(0, 4)
pad.PaddingRight = UDim.new(0, 4)

local locking = false
list:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if locking then return end
    locking = true
    local p = list.CanvasPosition
    if p.X ~= 0 then
        list.CanvasPosition = Vector2.new(0, p.Y)
    end
    locking = false
end)

---------------------------------------------------------------------
-- LANGUAGE APPLY
---------------------------------------------------------------------
local function updateLangHighlight()
    for code, info in pairs(langRows) do
        local on = (code == currentLang)
        if on then
            info.stroke.Color        = THEME.GREEN
            info.stroke.Thickness    = 2.4
            info.stroke.Transparency = 0
            info.glow.Visible        = true
        else
            info.stroke.Color        = THEME.GREEN_DARK
            info.stroke.Thickness    = 1.6
            info.stroke.Transparency = 0.4
            info.glow.Visible        = false
        end
    end
end

local function applyLanguage(code)
    local pack = LANG_PACK[code]
    if not pack then return end
    currentLang = code

    keyBox.PlaceholderText = pack.placeholder
    confirmBtn.Text        = pack.confirm
    linkBtn.Text           = pack.link
    keyBox.TextColor3      = THEME.WHITE

    local pmap = PANEL_I18N[code] or PANEL_I18N.EN
    titleLang.Text = pmap.TITLE or pack.langTitle or "Language"
    searchBox.PlaceholderText = pmap.SEARCH or pack.searchHint or "🔍 Search Language"

    for _, langCode in ipairs(LANG_ORDER) do
        local row = langRows[langCode]
        if row then
            row.btn.Text = pmap[langCode] or (LANG_PACK[langCode] and LANG_PACK[langCode].name) or langCode
        end
    end

    updateLangHighlight()
end

---------------------------------------------------------------------
-- สร้างแถวภาษา
---------------------------------------------------------------------
local function createLangRow(code, order)
    local pack = LANG_PACK[code]
    if not pack then return end

    local btn = Instance.new("TextButton")
    btn.Name = "Lang_" .. code
    btn.Parent = list
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.BLACK
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = THEME.WHITE
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.Text = pack.name
    btn.LayoutOrder = order or 1
    corner(btn, 10)

    local st = stroke(btn, 1.6, THEME.GREEN_DARK, 0.4)

    local glow = Instance.new("Frame")
    glow.Name = "GlowBar"
    glow.Parent = btn
    glow.BackgroundColor3 = THEME.GREEN
    glow.BorderSizePixel = 0
    glow.Size = UDim2.new(0, 3, 1, 0)
    glow.Position = UDim2.new(0, 0, 0, 0)
    glow.Visible = false

    langRows[code] = {
        btn    = btn,
        stroke = st,
        glow   = glow,
    }

    btn.MouseButton1Click:Connect(function()
        applyLanguage(code)
    end)
end

for i, code in ipairs(LANG_ORDER) do
    createLangRow(code, i)
end

---------------------------------------------------------------------
-- SEARCH FILTER
---------------------------------------------------------------------
local function applySearchLang()
    local q = string.lower(trim(searchBox.Text or ""))
    for code, info in pairs(langRows) do
        local txt = string.lower(info.btn.Text or "")
        local match = (q == "" or string.find(txt, q, 1, true) ~= nil)
        info.btn.Visible = match
    end
    list.CanvasPosition = Vector2.new(0, 0)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearchLang)

searchBox.Focused:Connect(function()
    sbStroke.Color = THEME.GREEN
    sbStroke.Transparency = 0
end)

searchBox.FocusLost:Connect(function()
    sbStroke.Color = THEME.GREEN_DARK
    sbStroke.Transparency = 0.3
end)

---------------------------------------------------------------------
-- OPEN/CLOSE LANGUAGE PANEL
---------------------------------------------------------------------
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local outsideConn

local function closeLangPanel()
    if not langPanelOpen then return end
    langPanelOpen = false
    updateSettingsVisual(false)

    if outsideConn then
        outsideConn:Disconnect()
        outsideConn = nil
    end

    local tween = TweenService:Create(langPanel, tweenInfo, {
        Size = UDim2.new(0, 0, 0, PANEL_HEIGHT)
    })
    tween:Play()
    tween.Completed:Connect(function()
        if not langPanelOpen then
            langPanel.Visible = false
        end
    end)
end

local function openLangPanel()
    if langPanelOpen then return end
    langPanelOpen = true
    updateSettingsVisual(true)
    langPanel.Visible = true

    TweenService:Create(langPanel, tweenInfo, {
        Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    }):Play()

    outsideConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not langPanelOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
           and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local pos = input.Position
        local p   = langPanel.AbsolutePosition
        local sz  = langPanel.AbsoluteSize

        local inside =
            pos.X >= p.X and pos.X <= p.X + sz.X and
            pos.Y >= p.Y and pos.Y <= p.Y + sz.Y

        if inside then return end

        local sp = settingsBtn.AbsolutePosition
        local ss = settingsBtn.AbsoluteSize
        local insideSettings =
            pos.X >= sp.X and pos.X <= sp.X + ss.X and
            pos.Y >= sp.Y and pos.Y <= sp.Y + ss.Y

        if insideSettings then
            return
        end

        closeLangPanel()
    end)
end

settingsBtn.MouseButton1Click:Connect(function()
    if langPanelOpen then
        closeLangPanel()
    else
        openLangPanel()
    end
end)

---------------------------------------------------------------------
-- VERIFY KEY LOGIC
---------------------------------------------------------------------
local function verifyKey(rawKey)
    rawKey = trim(rawKey or "")
    local pid = game.PlaceId

    -- VIP override (10 codes)
    for _, code in ipairs(KEY_CONFIG.VIP_CODES or {}) do
        if rawKey == code then
            markVerified(4, "VIP", rawKey)
            return true, "VIP_OK"
        end
    end

    local mode = detectMapMode()

    if mode == 3 then
        markVerified(3, "FREE", rawKey)
        return true, "FREE"
    elseif mode == 2 then
        local expected = KEY_CONFIG.CUSTOM_KEY[pid]
        if rawKey == expected then
            markVerified(2, "CUSTOM", rawKey)
            return true, "VALID"
        else
            return false, "INVALID"
        end
    elseif mode == 1 then
        -- Luarmor test-mode (ตอนนี้ให้ผ่านทุกคีย์)
        markVerified(1, "LUARMOR", rawKey)
        return true, "LUARMOR_OK"
    else
        return false, "UNKNOWN"
    end
end

---------------------------------------------------------------------
-- BUTTON HANDLERS (Confirm + Link)
---------------------------------------------------------------------
confirmBtn.MouseButton1Click:Connect(function()
    local pack = LANG_PACK[currentLang] or LANG_PACK.EN
    local baseConfirmText = pack.confirm or "Confirm Key"

    local raw = trim(keyBox.Text or "")
    if raw == "" then
        keyBox.TextColor3 = THEME.RED
        confirmBtn.Text   = baseConfirmText .. " ❌"
        showToast("EMPTY")
        return
    end

    keyBox.TextColor3 = THEME.WHITE
    confirmBtn.Text   = baseConfirmText .. " ⏳"
    showToast("CHECKING")

    local ok, msgKey = verifyKey(raw)

    if ok then
        keyBox.TextColor3 = THEME.GREEN
        confirmBtn.Text   = baseConfirmText .. " ✅"
        showToast(msgKey or "VALID")

        task.delay(0.8, function()
            gui.Enabled = false
        end)
    else
        keyBox.TextColor3 = THEME.RED
        confirmBtn.Text   = baseConfirmText .. " ❌"
        showToast(msgKey or "INVALID")
    end
end)

linkBtn.MouseButton1Click:Connect(function()
    local pid    = game.PlaceId
    local linkCfg = KEY_CONFIG.KEY_LINK[pid]

    if linkCfg then
        if setclipboard then
            pcall(setclipboard, linkCfg.url)
        end
        print(("[UFO HUB X] Key link for %s (%d): %s")
            :format(linkCfg.name, pid, linkCfg.url))
    else
        print("[UFO HUB X] No key link configured for this map:", pid)
    end

    showToast("LINK_OK")
end)

---------------------------------------------------------------------
-- INITIAL LANGUAGE (default EN)
---------------------------------------------------------------------
applyLanguage("EN")
updateLangHighlight()

print("[UFO HUB X] Key UI + Language Panel A V2 + Key System (VIP x10 + Links) loaded")
