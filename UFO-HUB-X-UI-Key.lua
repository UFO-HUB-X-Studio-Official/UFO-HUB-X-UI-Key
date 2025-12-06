--===== UFO HUB X • Key UI + Language Panel A V2 (Full i18n) =====
-- LocalScript (StarterGui / StarterPlayerScripts)

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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
-- MAIN PANEL (BACKGROUND)  >> ดีไซน์เดิม
---------------------------------------------------------------------
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
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
-- KEY BOX + BUTTONS (ยืดด้านล่างให้สูงขึ้นหน่อย)
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
buttonRow.Position = UDim2.new(0.5, 0, 0, 265)           -- ขยับลงนิด + สูงขึ้น
buttonRow.Size = UDim2.new(0.8, 0, 0, 60)                -- สูง 60
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

confirmBtn.MouseButton1Click:Connect(function()
    print("[UFO HUB X] Confirm Key clicked (UI only)")
end)

linkBtn.MouseButton1Click:Connect(function()
    print("[UFO HUB X] Get Key Link clicked (UI only)")
end)

---------------------------------------------------------------------
-- LANGUAGE PACK (6 ภาษา)  – เปลี่ยนข้อความ UI หลัก
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

-- ลำดับในลิสต์: EN ก่อน, TH ที่สอง ตามที่ขอ
local LANG_ORDER = { "EN","TH","VN","ID","PH","BR" }

---------------------------------------------------------------------
-- PANEL I18N สำหรับข้อความในลิสต์ด้านขวา (ชื่อภาษาแต่ละภาษา UI)
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
-- LANGUAGE PANEL (Model A V2 – นอก UI หลัก)
---------------------------------------------------------------------
local PANEL_WIDTH  = 260
local PANEL_HEIGHT = 320 -- สูงขึ้น ~50% จากเดิมให้ดูเต็มขึ้น
local langPanelOpen = false
local langPanel
local langRows = {}
local langInputConn

langPanel = Instance.new("Frame")
langPanel.Name = "LanguagePanel"
langPanel.Parent = gui
langPanel.AnchorPoint = Vector2.new(0, 0.5)
langPanel.Position = UDim2.new(0.80, 0, 0.5, 0)
langPanel.Size     = UDim2.new(0, 0, 0, PANEL_HEIGHT) -- เริ่มปิด (ความกว้าง 0)
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
titleLang.Size = UDim2.new(1, -8, 0, 24)
titleLang.Position = UDim2.new(0, 4, 0, 0)
titleLang.BackgroundTransparency = 1
titleLang.Font = Enum.Font.GothamBold
titleLang.TextSize = 16
titleLang.TextColor3 = THEME.WHITE
titleLang.TextXAlignment = Enum.TextXAlignment.Left
titleLang.Text = "Language"

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Parent = body
searchBox.BackgroundColor3 = THEME.BLACK
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.GothamBold
searchBox.TextSize = 14
searchBox.TextColor3 = THEME.WHITE
searchBox.PlaceholderText = "🔍 Search Language"
searchBox.TextXAlignment = Enum.TextXAlignment.Center
searchBox.Text = ""
searchBox.Size = UDim2.new(1, -8, 0, 30)
searchBox.Position = UDim2.new(0, 4, 0, 26)
corner(searchBox, 10)
local sbStroke = stroke(searchBox, 1.8, THEME.GREEN_DARK, 0.3)

local list = Instance.new("ScrollingFrame")
list.Parent = body
list.BackgroundColor3 = THEME.BLACK
list.BorderSizePixel = 0
list.ScrollBarThickness = 0
list.Position = UDim2.new(0, 4, 0, 26 + 30 + 8)
list.Size = UDim2.new(1, -8, 1, -(26 + 30 + 12))
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
-- APPLY LANGUAGE (อัปเดตทั้ง UI หลัก + แพเนลขวา)
---------------------------------------------------------------------
local currentLang = "EN"

local function applyLanguage(code)
    local pack = LANG_PACK[code]
    if not pack then return end
    currentLang = code

    -- UI หลัก
    keyBox.PlaceholderText = pack.placeholder
    confirmBtn.Text        = pack.confirm
    linkBtn.Text           = pack.link

    -- Panel ขวา
    local pmap = PANEL_I18N[code] or PANEL_I18N.EN
    titleLang.Text = pmap.TITLE or pack.langTitle or "Language"
    searchBox.PlaceholderText = pmap.SEARCH or pack.searchHint or "🔍 Search Language"

    for _, langCode in ipairs(LANG_ORDER) do
        local row = langRows[langCode]
        if row then
            row.btn.Text = pmap[langCode] or (LANG_PACK[langCode] and LANG_PACK[langCode].name) or langCode
        end
    end

    print("[UFO HUB X] Language ->", pack.name)
end

---------------------------------------------------------------------
-- สร้างแถว A V2 ในลิสต์ภาษา
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

local function createLangRow(code, order)
    local pack = LANG_PACK[code]
    if not pack then return end

    local btn = Instance.new("TextButton")
    btn.Name = "Lang_" .. code
    btn.Parent = list
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = THEME.BLACK
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = THEME.WHITE
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.Text = pack.name           -- จะถูก applyLanguage ทับอีกทีตามภาษา UI
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
        updateLangHighlight()
    end)
end

for i, code in ipairs(LANG_ORDER) do
    createLangRow(code, i)
end

---------------------------------------------------------------------
-- SEARCH FILTER
---------------------------------------------------------------------
local function applySearch()
    local q = string.lower(trim(searchBox.Text or ""))
    for code, info in pairs(langRows) do
        local txt = string.lower(info.btn.Text or "")
        local match = (q == "" or string.find(txt, q, 1, true) ~= nil)
        info.btn.Visible = match
    end
    list.CanvasPosition = Vector2.new(0, 0)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)

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

        -- ไม่ปิดถ้ากดตรงปุ่มเกียร์
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
-- INITIAL LANGUAGE (เริ่มต้น English)
---------------------------------------------------------------------
applyLanguage("EN")     -- default: ภาษาอังกฤษ
updateLangHighlight()

print("[UFO HUB X] Key UI + Language Panel A V2 (i18n) loaded")
