--[[ ═══════════════════════════════════════════════════════════════
     ValzHub v6.0 FINAL | Violence District | 69 Features
     ═══════════════════════════════════════════════════════════════ ]]
_G.V = _G.V or {}
local V = _G.V
V.P = game:GetService("Players")
V.R = game:GetService("RunService")
V.U = game:GetService("UserInputService")
V.VI = game:GetService("VirtualInputManager")
V.W = game:GetService("Workspace")
V.RS = game:GetService("ReplicatedStorage")
V.L = game:GetService("Lighting")
V.G = game:GetService("GuiService")
V.CS = game:GetService("CollectionService")
V.LP = V.P.LocalPlayer
V.PG = V.LP:WaitForChild("PlayerGui")
V.C = V.W.CurrentCamera
V.M = V.U.TouchEnabled and not V.U.KeyboardEnabled
V.CFG = V.CFG or {}
local C = V.CFG

function V.N(t, c, d) print("[Valz]", t, c) end

V.KA = {}
local raw = {"105374834496520","113255068724446","118907603246885","129784271201071","117042998468241","122812055447896","78935059863801","74968262036854","78432063483146","132817836308238","133963973694098","111920872708571","80411309607666","98163597193511","82666958311998","110355011987939","139369275981139","135002183282873","121216847022485","130593238885843","117070354890871","106871536134254","138720291317243","109928123357793","88848807662765","73681849513551","123809268724645","74796685455129","130819705183003"}
for _, i in ipairs(raw) do V.KA[i] = true; V.KA["rbxassetid://"..i] = true end

function V.root() local c = V.LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
function V.isK(p) return p and p.Team and (p.Team.Name == "Killer" or p.Team.Name == "Killers") end
function V.isS(p) return p and p.Team and (p.Team.Name == "Survivor" or p.Team.Name == "Survivors") end
function V.role() if not V.LP.Team then return "?" end local n = V.LP.Team.Name if n == "Killer" then return "Killer" end if n == "Survivors" then return "Survivor" end return "Lobby" end
function V.down(c) if not c then return false end local h = c:FindFirstChildOfClass("Humanoid") if h and h.Health <= 0 then return true end return c:GetAttribute("Knocked") == true or c:GetAttribute("Downed") == true end
function V.parent() if gethui then return gethui() end local ok, co = pcall(function() return game:GetService("CoreGui") end) if ok and co then return co end return V.PG end

local defaults = {
    Parry=false, ParryR=8, AntiFake=true, Ring=true, IgAbyss=true, IgMask=true,
    ParryV2=false, ParryV2R=8,
    SC=false, SCMode="Perfect", HideSC=false,
    FP=false, FPAnim="Enten", FG=false,
    FPFlow=false, FPQuick=false, FPLand=false, FPAdren=false, FPCD=10,
    Speed=false, SpeedV=16, Jump=false, JumpV=50, InfJump=false, Noclip=false,
    ToF=false, ToFLaser=true, ToFWall=false, ToFMode="Killer", ToFKey="None", ToFBlock=true,
    Flash=false, FlashLaser=true, FlashPart="Head", FlashRange=120, FlashSm=0.35,
    Flask=false,
    Aim=false, AimRMB=false, AimFOV=120, AimSm=0.3, AimVis=false, AimPred=false,
    ALock=false, ALockR=50, ALBtn=false,
    Atk=false, AtkR=12, Hitbox=false, HitboxS=15, AutoHook=false, AntiBlind=false, NoSlow=false,
    ESPK=false, ESPS=false, ESPG=false, ESPP=false, ESPW=false, ESPGate=false, ESPH=false,
    ESPD=500, ESPDShow=true,
    Radar=false, RadK=true, RadS=false, RadG=false, RadP=false, RadH=false, RadGate=false, RadW=false,
    RadSize=150, RadRange=250,
    FB=false, NoFog=false,
    CamFOV=false, CamFOVV=90, TP3=false, Shift=false, InfZ=false, NoCut=false,
    Cross=false, CrossStyle="Dot", CrossS=3, CrossT=4, CrossG=6, CrossColor=Color3.new(1,1,1),
    TPOff=3, TPSafe=true,
    FirstPerson=false, AntiFall=false, AntiAFK=false, AutoWiggle=false, SelfUnhook=false, AutoMed=false,
    DestroyPal=false, AutoBreakGen=false, BlockVaults=false, BreakAllPal=false,
    AutoCrouch=false, PalletReflex=false, PalletR=20, AntiKnock=false,
    HealAura=false, HealAll=false, InvNV=false, InvNVSpeed=5,
    BypassGate=false, FleeKiller=false, FleeDist=40, DodgeSpear=false, BeatSurv=false,
    Moonwalk=false, MoonSpeed=11, MoonBoost=1.08,
    InfLunge=false, FakeAttack=false, BeatKiller=false,
    InfAbyss=false, InfHidden=false, InfJeff=false, InfLake=false, InfPursuit=false, BypassVeilCD=false,
    SwiftV1=false, SwiftV2=false, VaultSpeed=13,
    Fling=false, ALEnabled=false, WeatherTheme="Default",
}
for k, v in pairs(defaults) do if C[k] == nil then C[k] = v end end

-- ═══ PARry V1 + V2 ═══
V.ringSegs = V.ringSegs or {}
V.ringLast = V.ringLast or Vector3.new(1e9,0,0)
V.ringTick = 0
V.parryCD = false
V.parryAttach = {}
V.p2Att = {}
function V.buildRing()
    if #V.ringSegs > 0 then return end
    for i = 1, 48 do
        local p = Instance.new("Part")
        p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Material = Enum.Material.Neon; p.Color = Color3.fromRGB(0,255,255); p.Transparency = 1
        p.Name = "ValzRing"
        p.TopSurface = Enum.SurfaceType.SmoothNoOutlines; p.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
        p.Parent = V.W; V.ringSegs[i] = p
    end
end
function V.hideRing() for _, p in ipairs(V.ringSegs) do if p and p.Parent and p.Transparency ~= 1 then p.Transparency = 1 end end end
function V.updRing()
    if not C.Ring or not (C.Parry or C.ParryV2) then V.hideRing(); return end
    local r = V.root(); if not r then V.hideRing(); return end
    V.ringTick = V.ringTick + 1
    if (r.Position - V.ringLast).Magnitude < 0.15 and V.ringTick % 4 ~= 0 then return end
    V.ringLast = r.Position
    V.buildRing()
    local rad = C.ParryV2 and C.ParryV2R or C.ParryR
    local cen = r.Position - Vector3.new(0, r.Size.Y/2 + 1.8, 0)
    local segL = ((2*math.pi*rad)/48) * 1.3
    for i = 1, 48 do
        local p = V.ringSegs[i]
        if p and p.Parent then
            local ang = (i-1)/48 * math.pi * 2
            local x, z = math.cos(ang)*rad, math.sin(ang)*rad
            local pos = cen + Vector3.new(x, 0, z)
            local tan = Vector3.new(-math.sin(ang), 0, math.cos(ang))
            p.CFrame = CFrame.new(pos, pos+tan)
            p.Size = Vector3.new(0.14, 0.16, segL)
            p.Transparency = 0.1
        end
    end
end
V.R.Heartbeat:Connect(V.updRing)
function V.tapParry()
    if V.M then
        local sm = V.PG:FindFirstChild("Survivor-mob")
        local b = sm and sm:FindFirstChild("Controls") and sm.Controls:FindFirstChild("Gui-mob")
        if b and b.Visible then
            local p, s = b.AbsolutePosition, b.AbsoluteSize
            local i = V.G:GetGuiInset()
            pcall(function() V.VI:SendTouchEvent(8823, 0, p.X+s.X/2+i.X, p.Y+s.Y/2+i.Y); task.wait(0.01); V.VI:SendTouchEvent(8823, 2, p.X+s.X/2+i.X, p.Y+s.Y/2+i.Y) end)
            return
        end
    end
    pcall(function() V.VI:SendMouseButtonEvent(0,0,1,true,game,0); task.wait(0.01); V.VI:SendMouseButtonEvent(0,0,1,false,game,0) end)
end
function V.doParry()
    if V.parryCD then return end
    pcall(function()
        local rem = V.RS:FindFirstChild("Remotes")
        local it = rem and rem:FindFirstChild("Items")
        local dg = it and it:FindFirstChild("Parrying Dagger")
        local pr = dg and dg:FindFirstChild("parry")
        if pr then for _ = 1, 10 do pr:FireServer() end end
        task.spawn(V.tapParry)
    end)
end
task.spawn(function()
    local rem = V.RS:WaitForChild("Remotes", 5)
    local it = rem and rem:WaitForChild("Items", 5)
    local dg = it and it:WaitForChild("Parrying Dagger", 5)
    local res = dg and dg:WaitForChild("parryResult", 5)
    if res then res.OnClientEvent:Connect(function(a, b)
        local cd = tonumber(b) or ((a == true) and 90 or 60)
        V.parryCD = true; task.delay(cd, function() V.parryCD = false end)
    end) end
end)
function V.ignSkill(c)
    local s = c:GetAttribute("Skill") or c:GetAttribute("UsingSkill")
    if s and typeof(s) == "string" then
        local l = string.lower(s)
        if string.find(l,"abyss",1,true) or string.find(l,"mask",1,true) or string.find(l,"duck",1,true) then return true end
    end
    for _, o in ipairs(c:GetChildren()) do
        local n = string.lower(o.Name)
        if string.find(n,"abyss",1,true) or string.find(n,"mask",1,true) then return true end
    end
    return false
end
function V.attachParry(k)
    if not k or V.parryAttach[k] then return end
    V.parryAttach[k] = true
    local h = k:FindFirstChild("Humanoid") or k:WaitForChild("Humanoid", 5); if not h then return end
    local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 5); if not a then return end
    k.AncestryChanged:Connect(function(_, p) if not p then V.parryAttach[k] = nil end end)
    a.AnimationPlayed:Connect(function(tr)
        local id = tr.Animation and tr.Animation.AnimationId or ""
        local n = id:match("%d+"); if not n then return end
        if not V.KA["rbxassetid://"..n] then return end
        if not C.Parry or V.parryCD then return end
        local mc = V.LP.Character; if V.down(mc) then return end
        local mr = mc and mc:FindFirstChild("HumanoidRootPart")
        local kr = k:FindFirstChild("HumanoidRootPart")
        if not mr or not kr then return end
        if (mr.Position - kr.Position).Magnitude > C.ParryR then return end
        if C.IgAbyss and V.ignSkill(k) then return end
        if C.AntiFake then
            local kl = kr.CFrame.LookVector; local dm = (mr.Position - kr.Position).Unit
            if kl:Dot(dm) < 0.3 then return end
        end
        V.doParry()
    end)
end
function V.p2Attach(k)
    if not k or V.p2Att[k] then return end
    V.p2Att[k] = true
    local h = k:FindFirstChild("Humanoid") or k:WaitForChild("Humanoid", 5); if not h then return end
    local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 5); if not a then return end
    k.AncestryChanged:Connect(function(_, p) if not p then V.p2Att[k] = nil end end)
    a.AnimationPlayed:Connect(function(tr)
        local id = tr.Animation and tr.Animation.AnimationId or ""
        local n = id:match("%d+"); if not n then return end
        if not V.KA["rbxassetid://"..n] then return end
        if not C.ParryV2 or V.parryCD then return end
        local mc = V.LP.Character; if V.down(mc) then return end
        local mr = mc and mc:FindFirstChild("HumanoidRootPart")
        local kr = k:FindFirstChild("HumanoidRootPart")
        if not mr or not kr then return end
        if (mr.Position - kr.Position).Magnitude > C.ParryV2R then return end
        local myF = Vector3.new(mr.Position.X, 0, mr.Position.Z)
        local kF = Vector3.new(kr.Position.X, 0, kr.Position.Z)
        local fd = myF - kF
        if fd.Magnitude > 0 then
            local fdir = fd.Unit
            local kLook = Vector3.new(kr.CFrame.LookVector.X, 0, kr.CFrame.LookVector.Z).Unit
            if kLook:Dot(fdir) < 0.6 then return end
        end
        V.doParry()
    end)
end
function V.setupParry(p)
    if p == V.LP then return end
    p.CharacterAdded:Connect(function() if V.isK(p) and p.Character then V.attachParry(p.Character); V.p2Attach(p.Character) end end)
    p:GetPropertyChangedSignal("Team"):Connect(function() if V.isK(p) and p.Character then V.attachParry(p.Character); V.p2Attach(p.Character) end end)
    if p.Character and V.isK(p) then V.attachParry(p.Character); V.p2Attach(p.Character) end
end
for _, p in ipairs(V.P:GetPlayers()) do V.setupParry(p) end
V.P.PlayerAdded:Connect(V.setupParry)
task.spawn(function() while true do task.wait(5) for _, p in ipairs(V.P:GetPlayers()) do if p.Character and V.isK(p) then V.attachParry(p.Character); V.p2Attach(p.Character) end end end end)

-- ═══ SKILL CHECK ═══
V.scPress = function()
    if V.M then
        local b = V.PG:FindFirstChild("check", true)
        if b and b:IsA("GuiObject") then
            local p, s = b.AbsolutePosition, b.AbsoluteSize
            local i = V.G:GetGuiInset()
            local x, y = p.X+s.X/2+i.X, p.Y+s.Y/2+i.Y
            pcall(function() V.VI:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y) end); task.wait(0.01)
            pcall(function() V.VI:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y) end)
        end
    else
        pcall(function() V.VI:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end); task.wait(0.01)
        pcall(function() V.VI:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end
function V.getSC()
    for _, gn in ipairs({"SkillCheckPromptGui","SkillCheckPromptGui-con"}) do
        local g = V.PG:FindFirstChild(gn, true)
        if g then
            local c = g:FindFirstChild("Check", true)
            if c and c.Visible then
                local l = c:FindFirstChild("Line", true)
                local go = c:FindFirstChild("Goal", true)
                if l and go then return l, go end
            end
        end
    end
end
function V.angD(f, t) local d = t - f; if d > 180 then d = d - 360 end; if d < -180 then d = d + 360 end; return d end
function V.crossZ(pv, cu, sp, ep)
    local function inz(r) if sp > ep then return r >= sp or r <= ep end return r >= sp and r <= ep end
    if inz(cu) then return true end
    if pv == nil then return false end
    local d = V.angD(pv, cu)
    local st = math.abs(math.floor(d)); if st < 2 then return false end
    local sz = d / st
    for i = 1, st do if inz((pv + sz*i) % 360) then return true end end
    return false
end
V.SC = {NG=nil, NC=false, NL=nil, NT=nil, NW=false, PG=nil, PC=false, PL=nil, PT=nil, PW=false}
function V.scUpd()
    if not C.SC then return end
    local SC = V.SC
    local l, g = V.getSC()
    if not (l and g) then
        SC.NG=nil; SC.NC=false; SC.NL=nil; SC.NT=nil; SC.NW=false
        SC.PG=nil; SC.PC=false; SC.PL=nil; SC.PT=nil; SC.PW=false
        return
    end
    local lr, gr = l.Rotation % 360, g.Rotation % 360
    local n = os.clock()
    if C.SCMode == "Perfect" then
        if not SC.PW then SC.PW=true; SC.PC=false; SC.PG=gr; SC.PL=lr; SC.PT=n; return end
        if SC.PG and math.abs(V.angD(SC.PG, gr)) > 5 then SC.PC=false; SC.PL=nil; SC.PT=nil end
        SC.PG = gr
        if SC.PC then SC.PL=lr; SC.PT=n; return end
        if SC.PL and SC.PT and (n - SC.PT) > 0 then
            if V.crossZ(SC.PL, lr, (gr+104)%360, (gr+108)%360) then SC.PC = true; V.scPress() end
        end
        SC.PL = lr; SC.PT = n
    else
        if not SC.NW then SC.NW=true; SC.NC=false; SC.NG=gr; SC.NL=lr; SC.NT=n; return end
        if SC.NG and math.abs(V.angD(SC.NG, gr)) > 5 then SC.NC=false; SC.NL=nil; SC.NT=nil end
        SC.NG = gr
        if SC.NC then SC.NL=lr; SC.NT=n; return end
        if SC.NL and SC.NT and (n - SC.NT) > 0 then
            if V.crossZ(SC.NL, lr, (gr+104)%360, (gr+109)%360) then SC.NC = true; task.spawn(function() task.wait(0.03); V.scPress() end) end
        end
        SC.NL = lr; SC.NT = n
    end
end
V.R.RenderStepped:Connect(function() pcall(V.scUpd) end)
V.R.RenderStepped:Connect(function()
    if not C.HideSC then return end
    local a = V.PG:FindFirstChild("SkillCheckPromptGui"); local b = V.PG:FindFirstChild("SkillCheckPromptGui-con")
    if a and a.Enabled then a.Enabled = false end
    if b and b.Enabled then b.Enabled = false end
end)

-- ═══ FAKE PARRY / GEN / PERKS ═══
V.FPAnim = {["Enten"]="rbxassetid://127096285501517", ["Stopwatch"]="rbxassetid://81793464499285", ["Fih"]="rbxassetid://123307242865945", ["BloodShield"]="rbxassetid://75939529748815"}
V.FPTrack, V.FGTrack = nil, nil
V.FPD = {UI=nil, Btn=nil, Drg=false, DS=nil, DP=nil}
V.FGD = {UI=nil, Btn=nil, Drg=false, DS=nil, DP=nil}
function V.playFP()
    if not C.FP then return end
    pcall(function()
        local c = V.LP.Character; if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
        local a = h:FindFirstChildOfClass("Animator") or Instance.new("Animator", h)
        if V.FPTrack then pcall(function() V.FPTrack:Stop() end); V.FPTrack = nil end
        local an = Instance.new("Animation"); an.AnimationId = V.FPAnim[C.FPAnim] or V.FPAnim["Enten"]
        local t = a:LoadAnimation(an); t.Priority = Enum.AnimationPriority.Action; t:Play(); V.FPTrack = t
    end)
end
function V.mkFPBtn()
    local old = V.PG:FindFirstChild("ValzFPUI"); if old then old:Destroy() end
    local ui = Instance.new("ScreenGui", V.PG); ui.Name = "ValzFPUI"; ui.ResetOnSpawn = false; ui.IgnoreGuiInset = true
    local b = Instance.new("ImageButton", ui)
    b.Size = UDim2.new(0,54,0,54); b.Position = UDim2.new(1,-38,0.34,0); b.AnchorPoint = Vector2.new(0.5,0.5)
    b.BackgroundColor3 = Color3.fromRGB(20,0,30); b.BackgroundTransparency = 0.15; b.Visible = C.FP
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local st = Instance.new("UIStroke", b); st.Color = Color3.fromRGB(150,70,255); st.Thickness = 2
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "FAKE\nPARRY"; l.TextColor3 = Color3.fromRGB(200,150,255); l.TextScaled = true; l.Font = Enum.Font.GothamBlack
    V.FPD.UI, V.FPD.Btn = ui, b
    b.MouseButton1Click:Connect(V.playFP)
end
function V.togFG()
    if not C.FG then if V.FGTrack then pcall(function() V.FGTrack:Stop() end); V.FGTrack = nil end; return end
    if V.FGTrack then pcall(function() V.FGTrack:Stop() end); V.FGTrack = nil
    else pcall(function()
        local c = V.LP.Character; if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
        local a = h:FindFirstChildOfClass("Animator") or Instance.new("Animator", h)
        local an = Instance.new("Animation"); an.AnimationId = "rbxassetid://83160743983246"
        local t = a:LoadAnimation(an); t.Looped = true; t.Priority = Enum.AnimationPriority.Action; t:Play(); V.FGTrack = t
    end) end
end
function V.mkFGBtn()
    local old = V.PG:FindFirstChild("ValzFGUI"); if old then old:Destroy() end
    local ui = Instance.new("ScreenGui", V.PG); ui.Name = "ValzFGUI"; ui.ResetOnSpawn = false; ui.IgnoreGuiInset = true
    local b = Instance.new("ImageButton", ui)
    b.Size = UDim2.new(0,54,0,54); b.Position = UDim2.new(1,-38,0.62,0); b.AnchorPoint = Vector2.new(0.5,0.5)
    b.BackgroundColor3 = Color3.fromRGB(20,30,0); b.BackgroundTransparency = 0.15; b.Visible = C.FG
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local st = Instance.new("UIStroke", b); st.Color = Color3.fromRGB(150,255,70); st.Thickness = 2
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "FAKE\nGEN"; l.TextColor3 = Color3.fromRGB(200,255,150); l.TextScaled = true; l.Font = Enum.Font.GothamBlack
    V.FGD.UI, V.FGD.Btn = ui, b
    b.MouseButton1Click:Connect(V.togFG)
end
V.mkFPBtn(); V.mkFGBtn()
V.U.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.V then V.playFP() end
    if i.KeyCode == Enum.KeyCode.B then V.togFG() end
end)
V.LP.CharacterAdded:Connect(function() task.wait(0.5); V.mkFPBtn(); V.mkFGBtn(); if V.FPD.Btn then V.FPD.Btn.Visible = C.FP end; if V.FGD.Btn then V.FGD.Btn.Visible = C.FG end end)

V.FP2 = {Conns={}, Buffs={}, HB=nil, Last=0}
function V.fpTotal() local t = 0; for _, b in pairs(V.FP2.Buffs) do if tick() < b.e then t = t + b.a end end; return t end
function V.fpApply()
    local c = V.LP.Character; local t = V.fpTotal()
    if c then c:SetAttribute("speedboost", t > 0 and (1 + t/14) or 1) end
end
function V.fpHB()
    if V.FP2.HB then return end
    V.FP2.HB = V.R.Heartbeat:Connect(function()
        local ex = {}
        for n, b in pairs(V.FP2.Buffs) do if tick() >= b.e then table.insert(ex, n) end end
        for _, n in ipairs(ex) do V.FP2.Buffs[n] = nil end
        if #ex > 0 and V.fpTotal() <= 0 then V.FP2.Last = tick() end
        V.fpApply()
        if V.fpTotal() <= 0 and next(V.FP2.Buffs) == nil then
            if V.FP2.HB then V.FP2.HB:Disconnect(); V.FP2.HB = nil end
            local c = V.LP.Character; if c then c:SetAttribute("speedboost", 1) end
        end
    end)
end
function V.fpBuff(n, a, d)
    if V.FP2.Buffs[n] then return end
    if tick() - V.FP2.Last < C.FPCD and next(V.FP2.Buffs) == nil then return end
    V.FP2.Buffs[n] = {a = a, e = tick() + d}
    V.fpApply(); V.fpHB()
    V.N("Fake Perks", "["..n.."] +"..a.." speed", 2)
end
function V.fpReg(n, c) if not V.FP2.Conns[n] then V.FP2.Conns[n] = {} end table.insert(V.FP2.Conns[n], c) end
function V.fpClean(n) if V.FP2.Conns[n] then for _, c in ipairs(V.FP2.Conns[n]) do pcall(function() c:Disconnect() end) end V.FP2.Conns[n] = nil end end
function V.setPerk(name, en)
    if name == "Flowstate" then
        local c = V.LP.Character; if c then c:SetAttribute("Flowstate", en) end
        if en then
            local r = V.RS:FindFirstChild("Remotes"); local w = r and r:FindFirstChild("Window"); local p = r and r:FindFirstChild("Pallet")
            local function onV() task.delay(0.5, function() if C.FPFlow then V.fpBuff("Flowstate", 5, 3) end end) end
            if w then local vb = w:FindFirstChild("Vaultbindable") if vb and vb:IsA("BindableEvent") then V.fpReg("Flowstate", vb.Event:Connect(onV)) end end
            if p then local sb = p:FindFirstChild("Slidebindable") if sb and sb:IsA("BindableEvent") then V.fpReg("Flowstate", sb.Event:Connect(onV)) end end
        else V.fpClean("Flowstate"); V.FP2.Buffs["Flowstate"] = nil; if c then c:SetAttribute("Flowstate", false) end end
    elseif name == "QuickRecovery" then
        if en then
            local function onH() if C.FPQuick then V.fpBuff("QuickRecovery", 6, 3) end end
            local r = V.RS:FindFirstChild("Remotes"); local hf = r and r:FindFirstChild("Healing")
            if hf then local hd = hf:FindFirstChild("Healdone") if hd and hd:IsA("BindableEvent") then V.fpReg("QuickRecovery", hd.Event:Connect(onH)) end end
            local function hookHP(c) if not c then return end local h = c:FindFirstChildOfClass("Humanoid")
                if h then local l = h.Health V.fpReg("QuickRecovery", h.HealthChanged:Connect(function(n) if C.FPQuick and n > l+3 then onH() end l = n end)) end end
            hookHP(V.LP.Character); V.fpReg("QuickRecovery", V.LP.CharacterAdded:Connect(hookHP))
        else V.fpClean("QuickRecovery"); V.FP2.Buffs["QuickRecovery"] = nil end
    elseif name == "PerfectLanding" then
        if en then
            local function hookF(c) if not c then return end local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
                local wf, fs = false, 0
                V.fpReg("PerfectLanding", h.StateChanged:Connect(function(_, n)
                    if n == Enum.HumanoidStateType.Freefall then wf = true; fs = tick()
                    elseif wf and (n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Running) then
                        local ft = tick() - fs; wf = false
                        if ft >= 0.25 and C.FPLand then V.fpBuff("PerfectLanding", 8, 3) end
                    end
                end)) end
            hookF(V.LP.Character); V.fpReg("PerfectLanding", V.LP.CharacterAdded:Connect(hookF))
        else V.fpClean("PerfectLanding"); V.FP2.Buffs["PerfectLanding"] = nil end
    elseif name == "AdrenalineRush" then
        if en then
            local function hookD(c) if not c then return end local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
                local l = h.Health
                V.fpReg("AdrenalineRush", h.HealthChanged:Connect(function(n) if C.FPAdren and n < l and n <= 50 and n > 0 then V.fpBuff("AdrenalineRush", 4, 5) end l = n end)) end
            hookD(V.LP.Character); V.fpReg("AdrenalineRush", V.LP.CharacterAdded:Connect(hookD))
        else V.fpClean("AdrenalineRush"); V.FP2.Buffs["AdrenalineRush"] = nil end
    end
end

-- ═══ SILENT AIM ToF ═══
V.ToF = {Con=nil, Beam=nil, Aim=false}
V.ToFKey = {None=nil, Q=Enum.KeyCode.Q, E=Enum.KeyCode.E, R=Enum.KeyCode.R, T=Enum.KeyCode.T, F=Enum.KeyCode.F, G=Enum.KeyCode.G, H=Enum.KeyCode.H, J=Enum.KeyCode.J, K=Enum.KeyCode.K, L=Enum.KeyCode.L, X=Enum.KeyCode.X, Z=Enum.KeyCode.Z}
function V.tofEv() local r=V.RS:FindFirstChild("Remotes") local i=r and r:FindFirstChild("Items") local t=i and i:FindFirstChild("Twist of Fate") local f=t and t:FindFirstChild("Fire") return f and f:IsA("RemoteEvent") and f or nil end
function V.tofGun()
    local c = V.LP.Character; if not c then return nil end
    local b = c:FindFirstChild("Twist of Fate", true); if not b then return nil end
    local ra = b:FindFirstChild("Right Arm")
    if ra then local g = ra:FindFirstChild("gun") or ra:FindFirstChild("EmperorGun") if g then return g end end
    return b
end
function V.tofVis(op, tp, tc)
    local d = tp - op; local ds = d.Magnitude; if ds < 0.1 then return true end
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    local ex = {} if V.LP.Character then table.insert(ex, V.LP.Character) end if tc and tc ~= V.LP.Character then table.insert(ex, tc) end if V.ToF.Beam then table.insert(ex, V.ToF.Beam) end
    rp.FilterDescendantsInstances = ex
    return V.W:Raycast(op, d.Unit*ds, rp) == nil
end
function V.tofTarget()
    local g = V.tofGun(); local c = V.LP.Character; if not (g and c) then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local mp = hrp.Position
    local op
    if c:GetAttribute("IsCarried") then op = hrp.Position + hrp.CFrame.LookVector * 2
    else pcall(function() op = g:IsA("BasePart") and g.Position or (g:FindFirstChildOfClass("BasePart") and g:FindFirstChildOfClass("BasePart").Position) end) op = op or Vector3.new(mp.X, mp.Y+1.5, mp.Z) end
    local function pred(torso, tc)
        local tp = torso.Position
        if C.ToFWall and not V.tofVis(op, tp, tc) then return end
        local rp = tc and (tc:FindFirstChild("HumanoidRootPart") or torso)
        local tv = rp and rp.Velocity or Vector3.zero
        local d = tp - op; local ds = d.Magnitude; if ds < 0.1 then return end
        if ds < 5 then return d.Unit, g, op, tp end
        local tt = ds / 400; local pp = tp + tv * tt
        for _ = 1, 2 do tt = (pp - op).Magnitude/400; pp = tp + tv*tt end
        local fd = pp - op; if fd.Magnitude < 0.1 then return end
        return fd.Unit, g, op, pp
    end
    if C.ToFMode == "Killer" then
        local bt, bc, bs = nil, nil, math.huge
        for _, p in ipairs(V.P:GetPlayers()) do
            if p ~= V.LP and V.isK(p) and p.Character then
                local t = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
                if t then local d = (mp - t.Position).Magnitude if d < bs then bs = d; bt = t; bc = p.Character end end
            end
        end
        if not bt then return end; return pred(bt, bc)
    elseif C.ToFMode == "Survivors" then
        local bt, bc, bd = nil, nil, -1e9
        local cam = V.W.CurrentCamera; local cl = cam.CFrame.LookVector
        for _, p in ipairs(V.P:GetPlayers()) do
            if p ~= V.LP and V.isS(p) and p.Character then
                local t = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
                if t then local d = t.Position - cam.CFrame.Position if d.Magnitude > 0.1 then local dt = cl:Dot(d.Unit) if dt > 0.5 and dt > bd then bd = dt; bt = t; bc = p.Character end end end
            end
        end
        if not bt then return end; return pred(bt, bc)
    end
end
function V.tofShoot()
    if not C.ToF then return end
    local c = V.LP.Character; if c and C.ToFBlock and V.down(c) then return end
    local d, g, op, tp = V.tofTarget()
    if not (d and g and tp and op) then return end
    local ev = V.tofEv(); if not ev then return end
    local fd = tp - op; if fd.Magnitude < 0.1 then return end
    pcall(function() ev:FireServer(g, fd.Unit) end)
end
function V.tofUpdLaser(op, tp)
    if not V.ToF.Beam then
        local l = Instance.new("Part"); l.Name = "ValzToF"; l.Anchored = true; l.CanCollide = false; l.CanTouch = false; l.CastShadow = false
        l.Material = Enum.Material.Neon; l.Color = Color3.fromRGB(255,50,50); l.Parent = V.W; V.ToF.Beam = l
    end
    V.ToF.Beam.Size = Vector3.new(0.05, 0.05, (tp-op).Magnitude)
    V.ToF.Beam.CFrame = CFrame.new((op+tp)/2, tp); V.ToF.Beam.Transparency = 0
end
function V.tofSet(on)
    C.ToF = on and true or false
    if C.ToF then
        if V.ToF.Con then return end
        V.ToF.Con = V.R.Heartbeat:Connect(function()
            if not C.ToF or not V.ToF.Aim then if V.ToF.Beam then V.ToF.Beam.Transparency = 1 end; return end
            local _, _, op, tp = V.tofTarget()
            if op and tp then if C.ToFLaser then V.tofUpdLaser(op, tp) elseif V.ToF.Beam then V.ToF.Beam.Transparency = 1 end
            elseif V.ToF.Beam then V.ToF.Beam.Transparency = 1 end
        end)
    else
        if V.ToF.Con then pcall(function() V.ToF.Con:Disconnect() end); V.ToF.Con = nil end
        V.ToF.Aim = false
        if V.ToF.Beam then pcall(function() V.ToF.Beam:Destroy() end); V.ToF.Beam = nil end
    end
end
V.U.InputBegan:Connect(function(i, gp)
    if gp then return end
    local kc = V.ToFKey[C.ToFKey or "None"]
    if kc and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == kc then V.tofSet(not C.ToF); return end
    if not C.ToF then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then V.ToF.Aim = true; V.tofShoot() end
end)
V.U.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then V.ToF.Aim = false; if V.ToF.Beam then V.ToF.Beam.Transparency = 1 end end
end)

-- ═══ SILENT AIM Flashlight + Flask + Veil (compact) ═══
V.FS = {Con=nil, Act=false}
function V.flashTgt()
    local lc = V.LP.Character; local lr = lc and lc:FindFirstChild("HumanoidRootPart"); if not lr then return nil end
    local bp, bs = nil, math.huge
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character and V.isK(p) then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                local pt = p.Character:FindFirstChild(C.FlashPart) or p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if pt then local d = (lr.Position - pt.Position).Magnitude if d <= C.FlashRange and d < bs then bs = d; bp = pt end end
            end
        end
    end
    return bp
end
function V.flashSet(on)
    C.Flash = on and true or false
    if C.Flash then
        if V.FS.Con then return end
        V.FS.Con = V.R.RenderStepped:Connect(function()
            if not (C.Flash and V.FS.Act) then return end
            local cam = V.W.CurrentCamera; local tp = V.flashTgt()
            if not (cam and tp) then return end
            pcall(function() cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, tp.Position), math.clamp(C.FlashSm, 0.05, 1)) end)
        end)
    else
        V.FS.Act = false
        if V.FS.Con then pcall(function() V.FS.Con:Disconnect() end); V.FS.Con = nil end
    end
end
V.flashActive = function(a, p) V.FS.Act = a and true or false end

V.flaskState = {LaserOn=false}
function V.flaskUpd()
    if not V.flaskState.LaserOn then return end
    local c = V.LP.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local closest, minD = nil, math.huge
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not V.isK(p) then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < minD then minD = d; closest = p end
        end
    end
    if not closest then if V.flaskState.LaserPart then V.flaskState.LaserPart.Transparency = 1 end; return end
    local hand = c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm")
    local origin = hand and hand.Position or hrp.Position
    local target = closest.Character.HumanoidRootPart.Position
    if not V.flaskState.LaserPart then
        local l = Instance.new("Part"); l.Name = "ValzFlaskLaser"; l.Anchored = true; l.CanCollide = false; l.CanTouch = false; l.CastShadow = false
        l.Material = Enum.Material.Neon; l.Color = Color3.fromRGB(0,100,255); l.Parent = V.W; V.flaskState.LaserPart = l
    end
    local d = (target - origin).Magnitude
    if d > 0.1 then
        V.flaskState.LaserPart.Size = Vector3.new(0.16,0.16,d)
        V.flaskState.LaserPart.CFrame = CFrame.new((origin+target)/2, target)
        V.flaskState.LaserPart.Transparency = 0
    end
end
V.R.RenderStepped:Connect(function() if C.Flask and V.flaskState.LaserOn then pcall(V.flaskUpd) end end)

-- ═══ AIMBOT + AIMLOCK ═══
V.aimHold = false
V.R.RenderStepped:Connect(function()
    if C.Aim and V.role() == "Survivor" then
        if not C.AimRMB or V.aimHold then
            local cam = V.W.CurrentCamera; local r = V.root()
            if cam and r then
                local cp, cd = nil, math.huge
                for _, p in ipairs(V.P:GetPlayers()) do
                    if p ~= V.LP and V.isK(p) and p.Character then
                        local tr = p.Character:FindFirstChild("HumanoidRootPart")
                        if tr then
                            local d = (tr.Position - r.Position).Magnitude
                            if d < cd then cp = p; cd = d end
                        end
                    end
                end
                if cp and cp.Character then
                    local tr = cp.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local pos = tr.Position
                        if C.AimPred then pos = pos + tr.AssemblyLinearVelocity * 0.1 end
                        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), C.AimSm)
                    end
                end
            end
        end
    end
    if C.ALock then
        local c = V.LP.Character; local h = c and c:FindFirstChild("HumanoidRootPart")
        if h then
            local md = C.ALockR; local best, bd = nil, md + 1
            for _, p in ipairs(V.P:GetPlayers()) do
                if p ~= V.LP and p.Character and V.isS(p) and not V.down(p.Character) then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart")
                    local th = p.Character:FindFirstChildOfClass("Humanoid")
                    if tr and th and th.Health > 0 then
                        local d = (tr.Position - h.Position).Magnitude
                        if d <= md and d < bd then bd = d; best = tr end
                    end
                end
            end
            if best then local cam = V.W.CurrentCamera; cam.CFrame = CFrame.new(cam.CFrame.Position, best.Position) end
        end
    end
end)
V.U.InputBegan:Connect(function(i) if C.AimRMB and i.UserInputType == Enum.UserInputType.MouseButton2 then V.aimHold = true end end)
V.U.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then V.aimHold = false end end)

-- ═══ KILLER FEATURES ═══
V.hooking = false
V.R.Heartbeat:Connect(function()
    if C.Atk and V.role() == "Killer" then
        local r = V.root()
        if r then
            for _, p in ipairs(V.P:GetPlayers()) do
                if p ~= V.LP and V.isS(p) and p.Character then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart"); local th = p.Character:FindFirstChildOfClass("Humanoid")
                    if tr and th and th.Health > 0 and th.Health/th.MaxHealth > 0.25 and (tr.Position - r.Position).Magnitude <= C.AtkR then
                        pcall(function()
                            local rem = V.RS:FindFirstChild("Remotes"); local a = rem and rem:FindFirstChild("Attacks"); local b = a and a:FindFirstChild("BasicAttack")
                            if b then b:FireServer(false) end
                        end)
                        break
                    end
                end
            end
        end
    end
    if C.Hitbox and V.role() == "Killer" then
        for _, p in ipairs(V.P:GetPlayers()) do
            if p ~= V.LP and V.isS(p) and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart"); local h = p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then r.Size = Vector3.new(C.HitboxS, C.HitboxS, C.HitboxS) end
            end
        end
    end
    if C.AutoHook and V.role() == "Killer" and not V.hooking then
        local r = V.root(); local c = V.LP.Character
        if r and c and not (c:GetAttribute("IsCarrying") or c:GetAttribute("isCarrying")) then
            local dwn, bd = nil, math.huge
            for _, p in ipairs(V.P:GetPlayers()) do
                if p ~= V.LP and V.isS(p) and p.Character then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart"); local th = p.Character:FindFirstChildOfClass("Humanoid")
                    if tr and th and th.Health > 0 and th.Health/th.MaxHealth <= 0.25 then
                        local d = (tr.Position - r.Position).Magnitude
                        if d < bd then bd = d; dwn = tr end
                    end
                end
            end
            if dwn then
                V.hooking = true
                task.spawn(function()
                    r.CFrame = CFrame.new(dwn.Position + Vector3.new(0,3,0), dwn.Position); task.wait(0.3)
                    pcall(function()
                        local cf = V.RS:FindFirstChild("Remotes"); local ca = cf and cf:FindFirstChild("Carry"); local ev = ca and ca:FindFirstChild("CarrySurvivorEvent")
                        if ev then ev:FireServer(dwn.Parent) end
                    end)
                    task.wait(1); V.hooking = false
                end)
            end
        end
    end
end)
V.basicAtk = function()
    pcall(function()
        local rem = V.RS:FindFirstChild("Remotes"); local a = rem and rem:FindFirstChild("Attacks"); local b = a and a:FindFirstChild("BasicAttack")
        if b then b:FireServer(false) end
    end)
end

-- ═══ ESP ═══
V.HL, V.BB = {}, {}
V.OC = V.OC or {G={}, P={}, W={}, GT={}, H={}}
function V.mkHL(o, c)
    if not o or not o.Parent then return end
    if V.HL[o] and V.HL[o].Parent then V.HL[o].FillColor = c; V.HL[o].OutlineColor = c; return end
    local h = Instance.new("Highlight"); h.Name = "ValzHL"; h.Adornee = o; h.FillColor = c; h.OutlineColor = c
    h.FillTransparency = 0.5; h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.Parent = o; V.HL[o] = h
end
function V.rmHL(o) if V.HL[o] then pcall(function() V.HL[o]:Destroy() end); V.HL[o] = nil end; local e = o and o:FindFirstChild("ValzHL"); if e then e:Destroy() end end
-- ESP labels intentionally disabled: highlight-only mode.
function V.mkBB(o, t, c)
    if o and V.BB[o] then pcall(function() V.BB[o]:Destroy() end); V.BB[o] = nil end
    local e = o and o:FindFirstChild("ValzBB")
    if e then pcall(function() e:Destroy() end) end
end
function V.rmBB(o) if V.BB[o] then pcall(function() V.BB[o]:Destroy() end); V.BB[o] = nil end; local e = o and o:FindFirstChild("ValzBB"); if e then e:Destroy() end end
function V.clearESP() for o in pairs(V.HL) do V.rmHL(o) end for o in pairs(V.BB) do V.rmBB(o) end V.HL, V.BB = {}, {} end
-- Clean up leftover ESP name/distance labels from older UI versions.
task.defer(function()
    for _, obj in ipairs(V.W:GetDescendants()) do
        if obj.Name == "ValzBB" then pcall(function() obj:Destroy() end) end
    end
end)

function V.classObj(o)
    if not o or not o.Name or o.Name == "" then return nil end
    if not (o:IsA("BasePart") or o:IsA("Model")) then return nil end
    local n = string.lower(o.Name)
    if n == "generator" or string.find(n,"generator",1,true) then return "G" end
    if n == "pallet" or n == "palletwrong" or string.find(n,"pallet",1,true) then return "P" end
    if n == "window" or string.find(n,"window",1,true) then return "W" end
    if n == "gate" or string.find(n,"gate",1,true) then return "GT" end
    if n == "hook" or string.find(n,"hook",1,true) then return "H" end
    return nil
end
function V.addOC(o)
    local c = V.classObj(o); if not c then return end
    local a = o.Parent
    while a and a ~= V.W do
        if a:IsA("Model") or a:IsA("BasePart") then local ac = V.classObj(a) if ac == c then return end end
        a = a.Parent
    end
    local l = V.OC[c]; for _, e in ipairs(l) do if e == o then return end end
    table.insert(l, o)
end
task.spawn(function()
    task.wait(3)
    for _, o in ipairs(V.W:GetDescendants()) do V.addOC(o) end
    print(string.format("[Valz] Cache G=%d P=%d W=%d GT=%d H=%d", #V.OC.G, #V.OC.P, #V.OC.W, #V.OC.GT, #V.OC.H))
end)
V.W.DescendantAdded:Connect(function(o) task.defer(function() if o and o.Parent then V.addOC(o) end end) end)
function V.getVal(o, n)
    if not o then return nil end
    local a = o:GetAttribute(n); if a ~= nil then return a end
    local c = o:FindFirstChild(n); if c then local ok, v = pcall(function() return c.Value end); if ok then return v end end
    return nil
end
function V.getPos(o)
    if not o then return nil end
    if o:IsA("BasePart") then return o.Position end
    if o:IsA("Model") then
        local ok, p = pcall(function() return o:GetPivot().Position end); if ok then return p end
        local pp = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart"); return pp and pp.Position
    end
end
V.espTick = 0
V.R.Heartbeat:Connect(function()
    V.espTick = V.espTick + 1; if V.espTick % 12 ~= 0 then return end
    local r = V.root(); if not r then return end
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character and p.Team then
            local tn = p.Team.Name
            local c = Color3.fromRGB(255,60,60); local t = "[KILLER]"; local en = C.ESPK
            if tn == "Survivors" then c = Color3.fromRGB(60,200,100); t = "[SURV]"; en = C.ESPS end
            if en then V.mkHL(p.Character, c); V.mkBB(p.Character, nil, c)
            else V.rmHL(p.Character); V.rmBB(p.Character) end
        end
    end
    local cats = {{"P", V.OC.P, C.ESPP}, {"W", V.OC.W, C.ESPW}, {"GT", V.OC.GT, C.ESPGate}, {"H", V.OC.H, C.ESPH}}
    for _, cd in ipairs(cats) do
        for _, o in ipairs(cd[2]) do
            if cd[3] then
                local p = V.getPos(o)
                if p and (p - r.Position).Magnitude <= C.ESPD then
                    local col, txt
                    if cd[1] == "P" then col, txt = Color3.fromRGB(255,220,60), "Pallet"
                    elseif cd[1] == "W" then col, txt = Color3.fromRGB(173,216,230), "Window"
                    elseif cd[1] == "GT" then col, txt = Color3.fromRGB(255,255,255), "Gate"
                    else col, txt = Color3.fromRGB(255,80,80), "Hook" end
                    V.mkHL(o, col); V.mkBB(o, nil, col)
                else V.rmHL(o); V.rmBB(o) end
            else V.rmHL(o); V.rmBB(o) end
        end
    end
    if C.ESPG then
        for _, g in ipairs(V.OC.G) do
            if g and g.Parent then
                local pct = V.getVal(g, "RepairProgress") or V.getVal(g, "Progress") or 0
                if pct >= 0 and pct <= 1.001 then pct = pct * 100 end
                local col = Color3.fromRGB(203,132,66):Lerp(Color3.fromRGB(0,255,120), math.clamp(pct,0,100)/100)
                V.mkHL(g, col)
            end
        end
    else for _, g in ipairs(V.OC.G) do V.rmHL(g) end end
end)

-- ═══ RADAR ═══
V.rGui, V.rFrame = nil, nil
V.rDots, V.rObjs = {}, {}
function V.mkRadar()
    local par = V.parent(); if not par then return false end
    if V.rGui then pcall(function() V.rGui:Destroy() end) end
    V.rGui = Instance.new("ScreenGui", par); V.rGui.Name = "ValzRadar"; V.rGui.ResetOnSpawn = false; V.rGui.IgnoreGuiInset = true
    V.rFrame = Instance.new("Frame", V.rGui)
    V.rFrame.Size = UDim2.new(0, C.RadSize, 0, C.RadSize); V.rFrame.Position = UDim2.new(0,10,0,200)
    V.rFrame.BackgroundColor3 = Color3.fromRGB(10,10,10); V.rFrame.BackgroundTransparency = 0.2; V.rFrame.BorderSizePixel = 0
    V.rFrame.Active = true; V.rFrame.Draggable = true
    Instance.new("UICorner", V.rFrame).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", V.rFrame); s.Color = Color3.fromRGB(255,0,0); s.Thickness = 2
    V.rDots, V.rObjs = {}, {}
    for i = 1, 30 do
        local d = Instance.new("Frame", V.rFrame); d.Size = UDim2.new(0,6,0,6); d.BackgroundColor3 = Color3.fromRGB(255,65,65); d.BorderSizePixel = 0; d.Visible = false
        Instance.new("UICorner", d).CornerRadius = UDim.new(1,0); table.insert(V.rDots, d)
    end
    for i = 1, 80 do
        local d = Instance.new("Frame", V.rFrame); d.Size = UDim2.new(0,4,0,4); d.BackgroundColor3 = Color3.fromRGB(255,180,50); d.BorderSizePixel = 0; d.Visible = false
        Instance.new("UICorner", d).CornerRadius = UDim.new(1,0); table.insert(V.rObjs, d)
    end
    return true
end
V.R.Heartbeat:Connect(function()
    if not C.Radar then if V.rGui then V.rGui.Enabled = false end; return end
    if not V.rGui or not V.rGui.Parent then if not V.mkRadar() then return end end
    V.rGui.Enabled = true
    local cam = V.W.CurrentCamera; local r = V.root(); if not cam or not r then return end
    for _, d in ipairs(V.rDots) do d.Visible = false end
    for _, d in ipairs(V.rObjs) do d.Visible = false end
    local half = C.RadSize / 2; local u = half - 5; local sc = u / C.RadRange
    local cl = cam.CFrame.LookVector; local pa = math.atan2(-cl.X, -cl.Z)
    local ca, sa = math.cos(pa), math.sin(pa); local pp = r.Position
    local function w2r(wp)
        local dx, dz = wp.X - pp.X, wp.Z - pp.Z
        if math.sqrt(dx*dx + dz*dz) > C.RadRange then return nil end
        local rx, rz = dx*ca - dz*sa, dx*sa + dz*ca
        return Vector2.new(half + math.clamp(rx*sc, -u+4, u-4), half + math.clamp(rz*sc, -u+4, u-4))
    end
    local di, oi = 1, 1
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character then
            local rr = p.Character:FindFirstChild("HumanoidRootPart")
            if rr then
                local isk = V.isK(p)
                if (isk and C.RadK) or (not isk and C.RadS) then
                    local pos = w2r(rr.Position)
                    if pos and di <= #V.rDots then
                        local d = V.rDots[di]
                        d.Size = UDim2.new(0, isk and 7 or 6, 0, isk and 7 or 6)
                        d.Position = UDim2.new(0, pos.X-(isk and 3.5 or 3), 0, pos.Y-(isk and 3.5 or 3))
                        d.BackgroundColor3 = isk and Color3.fromRGB(255,0,0) or Color3.fromRGB(255,165,0)
                        d.Visible = true; di = di + 1
                    end
                end
            end
        end
    end
    local function addD(l, c, sh) if not sh then return end for _, e in ipairs(l) do local p = V.getPos(e); local pos = p and w2r(p)
        if pos and oi <= #V.rObjs then local d = V.rObjs[oi]; d.Size = UDim2.new(0,5,0,5); d.Position = UDim2.new(0, pos.X-2.5, 0, pos.Y-2.5); d.BackgroundColor3 = c; d.Visible = true; oi = oi + 1 end
    end end
    addD(V.OC.G, Color3.fromRGB(255,140,0), C.RadG); addD(V.OC.P, Color3.fromRGB(53,189,166), C.RadP)
    addD(V.OC.H, Color3.fromRGB(252,116,116), C.RadH); addD(V.OC.GT, Color3.fromRGB(100,200,255), C.RadGate); addD(V.OC.W, Color3.fromRGB(80,160,255), C.RadW)
end)

-- ═══ MOVEMENT + MOONWALK ═══
V.origCol = {}
V.mState = {Last=false, Yaw=nil, Sway=0}
V.R.Heartbeat:Connect(function(dt)
    local c = V.LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then
        if C.Speed and h.WalkSpeed ~= C.SpeedV then h.WalkSpeed = C.SpeedV end
        if C.Jump and h.JumpPower ~= C.JumpV then h.JumpPower = C.JumpV end
    end
    local r = c and c:FindFirstChild("HumanoidRootPart"); local cam = V.W.CurrentCamera
    if C.Moonwalk ~= V.mState.Last then
        if h then h.AutoRotate = not C.Moonwalk end; V.mState.Last = C.Moonwalk
        if C.Moonwalk and r then local _, y = r.CFrame:ToEulerAnglesYXZ(); V.mState.Yaw = math.deg(y) end
    end
    if C.Moonwalk and r and h and cam and h.Health > 0 then
        h.AutoRotate = false
        local look = cam.CFrame.LookVector; local ty = math.deg(math.atan2(look.X, look.Z)) + 180
        local cy = V.mState.Yaw or ty
        cy = cy + ((ty - cy + 180) % 360 - 180) * (0.22 * math.clamp((dt or 1/60)*60, 0, 3))
        V.mState.Yaw = cy
        local moving = h.MoveDirection.Magnitude > 0.01
        local ts = moving and (math.sin(tick() * (C.MoonSpeed or 11)) * 48) or 0
        V.mState.Sway = (V.mState.Sway or 0) + (ts - (V.mState.Sway or 0)) * 0.38
        r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.rad(cy + V.mState.Sway), 0)
        if moving then h:Move(h.MoveDirection * (C.MoonBoost or 1.08), false) end
    end
end)
V.U.JumpRequest:Connect(function()
    local c = V.LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
    if C.InfJump and h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
V.R.Stepped:Connect(function()
    if C.Noclip then local c = V.LP.Character
        if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then if V.origCol[d] == nil then V.origCol[d] = d.CanCollide end; d.CanCollide = false end end end
    end
end)

-- ═══ VISUAL ═══
V.R.Heartbeat:Connect(function()
    if C.FB then
        V.L.Brightness = 2; V.L.ClockTime = 14; V.L.GlobalShadows = false; V.L.OutdoorAmbient = Color3.fromRGB(128,128,128)
        if C.NoFog then V.L.FogStart = 0; V.L.FogEnd = 1e6 end
        for _, v in pairs(V.L:GetChildren()) do if v:IsA("Atmosphere") then v.Density = 0 end if v:IsA("BlurEffect") then v.Size = 0 end end
    elseif C.NoFog then V.L.FogStart = 0; V.L.FogEnd = 1e6 end
end)
V.R.RenderStepped:Connect(function()
    local cam = V.W.CurrentCamera; if not cam then return end
    if C.CamFOV and cam.FieldOfView ~= C.CamFOVV then cam.FieldOfView = C.CamFOVV end
    if C.InfZ then V.LP.CameraMaxZoomDistance = math.huge; V.LP.CameraMinZoomDistance = 0 end
    if C.Shift then
        local c = V.LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
        if h then h.AutoRotate = false end
        if r then local lv = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            if lv.Magnitude > 0.001 then r.CFrame = CFrame.new(r.Position, r.Position + lv.Unit) end end
    end
    if C.TP3 and V.role() == "Killer" then
        local c = V.LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
        if cam.CameraType ~= Enum.CameraType.Custom then cam.CameraType = Enum.CameraType.Custom end
        if h and h.CameraOffset.Y < 5 then h.CameraOffset = Vector3.new(2,1,8) end
    end
end)
V.chGui = nil
function V.updCH()
    if V.chGui then pcall(function() V.chGui:Destroy() end); V.chGui = nil end
    if not C.Cross then return end
    local par = V.parent(); if not par then return end
    V.chGui = Instance.new("ScreenGui", par); V.chGui.Name = "ValzCH"; V.chGui.DisplayOrder = 999999; V.chGui.IgnoreGuiInset = true
    local cf = Instance.new("Frame", V.chGui); cf.BackgroundTransparency = 1; cf.Position = UDim2.new(0.5,0,0.5,0); cf.Size = UDim2.new(0,0,0,0)
    if C.CrossStyle == "Dot" then
        local d = Instance.new("Frame", cf); d.AnchorPoint = Vector2.new(0.5,0.5); d.Size = UDim2.new(0, C.CrossS*2, 0, C.CrossS*2)
        d.BackgroundColor3 = C.CrossColor; d.BorderSizePixel = 0; Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
    else
        local len = C.CrossS * 3
        for i = 1, 4 do
            local l = Instance.new("Frame", cf); l.AnchorPoint = Vector2.new(0.5,0.5); l.BackgroundColor3 = C.CrossColor; l.BorderSizePixel = 0
            local a = (i-1) * 90; if C.CrossStyle == "X" then a = a + 45 end
            l.Rotation = a; l.Size = UDim2.new(0, len, 0, C.CrossT)
            local rad = math.rad(a); local d = C.CrossG + len/2
            l.Position = UDim2.new(0, math.floor(math.cos(rad)*d+0.5), 0, math.floor(math.sin(rad)*d+0.5))
        end
    end
end

-- ═══ TELEPORT ═══
V.safeTP = function(t, off)
    local r = V.root(); if not r then return end
    off = off or Vector3.new(0, C.TPOff, 0)
    if C.TPSafe then for _, p in ipairs(V.LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    r.CFrame = t + off
    if C.TPSafe then task.delay(0.5, function() for _, p in ipairs(V.LP.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = true end end end) end
end
V.tpNearest = function(name)
    local r = V.root(); if not r then return end
    local b, d0 = nil, math.huge
    for _, o in ipairs(V.W:GetDescendants()) do
        if (o:IsA("BasePart") or o:IsA("Model")) and string.find(string.lower(o.Name), string.lower(name)) then
            local p = o:IsA("Model") and o:GetPivot().Position or o.Position
            local d = (p - r.Position).Magnitude
            if d < d0 then d0 = d; b = o end
        end
    end
    if b then V.safeTP(CFrame.new(b:IsA("Model") and b:GetPivot().Position or b.Position)) end
end
V.tpFinish = function()
    local r = V.root(); if not r then return end
    for _, o in ipairs(V.W:GetDescendants()) do
        local ln = string.lower(o.Name)
        if (ln == "fininshline" or ln == "finishline") and o:IsA("BasePart") then V.safeTP(o.CFrame, Vector3.new(0,5,0)); break end
    end
end

-- ═══ SURVIVOR REMOTES + EXTRAS ═══
V.SU = {W=false, OC=nil, Off=5}
function V.isHk()
    local c = V.LP.Character; if not c then return false end
    for _, a in ipairs({"Hooked","IsHooked","IsGrabbed","IsSpiked","Carried","HookedState"}) do if c:GetAttribute(a) == true then return true end end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then local s = h:GetState() if s == Enum.HumanoidStateType.PlatformStanding or s == Enum.HumanoidStateType.Physics then return true end end
    return false
end
function V.setColl(cc) local c = V.LP.Character; if not c then return end for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then pcall(function() v.CanCollide = cc end) end end end
function V.nearKR()
    local c = V.LP.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return nil end
    local b, bd = nil, 300
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and V.isK(p) and p.Character then
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            if pr then local d = (pr.Position - r.Position).Magnitude if d < bd then bd = d; b = pr end end
        end
    end
    return b
end
task.spawn(function()
    while true do
        task.wait()
        if not C.SelfUnhook then
            if V.SU.W then V.setColl(true); V.SU.W = false; V.SU.OC = nil end
        else
            local c = V.LP.Character
            if c then local r = c:FindFirstChild("HumanoidRootPart")
                if r then
                    if V.isHk() then
                        if not V.SU.W then V.SU.W = true; V.SU.OC = r.CFrame; V.setColl(false) end
                        local kr = V.nearKR(); if kr then pcall(function() r.CFrame = kr.CFrame - Vector3.new(0, V.SU.Off, 0) end) end
                    elseif V.SU.W then V.setColl(true); if V.SU.OC then pcall(function() r.CFrame = V.SU.OC end) end; V.SU.W = false; V.SU.OC = nil end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if C.AutoMed then
            local c = V.LP.Character
            if c then local h = c:FindFirstChildOfClass("Humanoid")
                if h and h.Health < h.MaxHealth * 0.6 then
                    for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and string.find(string.lower(t.Name), "med") then pcall(function() t:Activate() end); break end end
                end
            end
        end
        if C.AutoWiggle then
            local c = V.LP.Character
            if c then local car = c:FindFirstChild("IsCarried") and c.IsCarried.Value
                if car then local r = V.RS:FindFirstChild("Remotes"); local ca = r and r:FindFirstChild("Carry"); local ev = ca and ca:FindFirstChild("SelfUnHookEvent")
                    if ev then for _ = 1, 5 do pcall(function() ev:FireServer() end) end end end
            end
        end
    end
end)
V.healConn = nil
V.healSet = function(on)
    C.HealAura = on
    if V.healConn then V.healConn:Disconnect(); V.healConn = nil end
    if not on then return end
    local act = false
    V.healConn = V.R.Heartbeat:Connect(function()
        local c = V.LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid"); if not h then return end
        local hr = V.RS:FindFirstChild("Remotes"); local hf = hr and hr:FindFirstChild("Healing"); local he = hf and hf:FindFirstChild("HealEvent")
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not he or not hrp then return end
        if h.Health >= h.MaxHealth * 0.9 then if act then act = false; pcall(function() he:FireServer(hrp, false) end) end; return end
        if not act then act = true; pcall(function() he:FireServer(hrp, true) end) end
    end)
end
V.healAllSet = function(on)
    C.HealAll = on
    if V.healAllConn then V.healAllConn:Disconnect(); V.healAllConn = nil end
    if not on then return end
    local act = {}
    V.healAllConn = V.R.Heartbeat:Connect(function()
        local hr = V.RS:FindFirstChild("Remotes"); local hf = hr and hr:FindFirstChild("Healing"); local he = hf and hf:FindFirstChild("HealEvent")
        if not he then return end
        for _, p in ipairs(V.P:GetPlayers()) do
            if p ~= V.LP and p.Character then
                local h = p.Character:FindFirstChildOfClass("Humanoid"); local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if h and hrp and h.Health > 0 and h.Health < h.MaxHealth * 0.9 then
                    if not act[p] then act[p] = true; pcall(function() he:FireServer(hrp, true) end) end
                elseif act[p] then act[p] = nil; pcall(function() he:FireServer(hrp, false) end) end
            end
        end
    end)
end
V.invNV = {Active=false, Seat=nil, OrigSpeed=nil, Pos=Vector3.new(-25.95,84,3537.55)}
V.invNVSet = function(on)
    C.InvNV = on
    local c = V.LP.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); local r = c:FindFirstChild("HumanoidRootPart"); local t = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    if not h or not r or not t then return end
    if on then
        if V.invNV.Active then h.WalkSpeed = C.InvNVSpeed or 16; return end
        V.invNV.Active = true; V.invNV.OrigSpeed = h.WalkSpeed
        local saved = r.CFrame; c:MoveTo(V.invNV.Pos); task.wait(0.15)
        local seat = Instance.new("Seat"); seat.Name = "ValzInvSeat"; seat.Anchored = false; seat.CanCollide = false
        seat.Transparency = 1; seat.CFrame = CFrame.new(V.invNV.Pos); seat.Parent = V.W
        local weld = Instance.new("Weld"); weld.Part0 = seat; weld.Part1 = t; weld.Parent = seat
        V.invNV.Seat = seat; task.wait(); seat.CFrame = saved
        for _, d in ipairs(c:GetDescendants()) do if (d:IsA("BasePart") or d:IsA("Decal")) and d.Name ~= "HumanoidRootPart" then pcall(function() d.Transparency = 0.5 end) end end
        h.WalkSpeed = C.InvNVSpeed or 16
    else
        V.invNV.Active = false
        if V.invNV.Seat and V.invNV.Seat.Parent then pcall(function() V.invNV.Seat:Destroy() end) end
        for _, d in ipairs(c:GetDescendants()) do if (d:IsA("BasePart") or d:IsA("Decal")) and d.Name ~= "HumanoidRootPart" then pcall(function() d.Transparency = 0 end) end end
        if V.invNV.OrigSpeed then h.WalkSpeed = V.invNV.OrigSpeed end
    end
end
V.gateOrig = setmetatable({}, {__mode = "k"})
V.R.Heartbeat:Connect(function()
    if not C.BypassGate then
        for part, props in pairs(V.gateOrig) do if part and part.Parent then pcall(function() part.Transparency = props.T; part.CanCollide = props.C end) end end
        V.gateOrig = setmetatable({}, {__mode = "k"}); return
    end
    local n = tick(); if n - (V._lastGate or 0) < 1 then return end
    V._lastGate = n
    for _, g in ipairs(V.W:GetDescendants()) do
        if g:IsA("Model") and g.Name == "Gate" then
            for _, nm in ipairs({"LeftGate","RightGate"}) do
                local p = g:FindFirstChild(nm)
                if p and not V.gateOrig[p] then V.gateOrig[p] = {T = p.Transparency, C = p.CanCollide}; p.Transparency = 1; p.CanCollide = false end
            end
        end
    end
end)
V.W.ChildAdded:Connect(function(child)
    if not child or child.Name ~= "Spearprojectile" or not C.DodgeSpear or V.role() ~= "Survivor" then return end
    task.spawn(function()
        if V._dodging then return end
        local r = V.root(); if not r then return end
        task.wait(0.05)
        local mp = child:FindFirstChild("Hitbox") or child:FindFirstChild("Spear1") or child.PrimaryPart
        if not mp then return end
        task.wait()
        if mp.CFrame.UpVector:Dot((r.Position - mp.Position).Unit) > 0.85 then
            V._dodging = true; local orig = r.CFrame
            r.CFrame = r.CFrame + (r.CFrame.RightVector * 8)
            V.N("Auto Dodge", "Spear detected", 2); task.wait(1)
            if V.root() then V.root().CFrame = orig end
            V._dodging = false
        end
    end)
end)
V.R.Heartbeat:Connect(function()
    if not C.FleeKiller or V.role() ~= "Survivor" then return end
    local r = V.root(); if not r then return end
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and V.isK(p) then
            local kr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position - r.Position).Magnitude <= (C.FleeDist or 40) then
                local d = (r.Position - kr.Position).Unit
                r.CFrame = CFrame.new(r.Position + d * ((C.FleeDist or 40) + 15), r.Position + d * 100); break
            end
        end
    end
end)
V.autoCrouchCD = 0
V.R.Heartbeat:Connect(function()
    if not C.AutoCrouch or V.role() ~= "Survivor" then return end
    local n = tick(); if n - V.autoCrouchCD < 1.2 then return end
    local mc = V.LP.Character; local mr = mc and mc:FindFirstChild("HumanoidRootPart"); if not mr then return end
    local near = false
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and V.isK(p) and p.Character then
            local kr = p.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position - mr.Position).Magnitude <= 40 then near = true; break end
        end
    end
    if near then
        V.autoCrouchCD = n
        pcall(function()
            mc:SetAttribute("Crouching", true)
            local rem = V.RS:FindFirstChild("Remotes"); local mech = rem and rem:FindFirstChild("Mechanics"); local ch = mech and mech:FindFirstChild("ChangeAttribute")
            if ch then ch:FireServer("Crouchingserver", true) end
            local h = mc:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Landed) end
        end)
        task.delay(1.2, function()
            pcall(function()
                mc:SetAttribute("Crouching", false)
                local rem = V.RS:FindFirstChild("Remotes"); local mech = rem and rem:FindFirstChild("Mechanics"); local ch = mech and mech:FindFirstChild("ChangeAttribute")
                if ch then ch:FireServer("Crouchingserver", false) end
            end)
        end)
    end
end)
V.lastPal = 0
V.R.Heartbeat:Connect(function()
    if not C.PalletReflex or V.role() ~= "Survivor" then return end
    local n = tick(); if n - V.lastPal < 2.5 then return end
    local c = V.LP.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
    local killer = nil
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and V.isK(p) and p.Character then
            local kr = p.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position - r.Position).Magnitude <= (C.PalletR or 20) then killer = kr; break end
        end
    end
    if not killer then return end
    local rem = V.RS:FindFirstChild("Remotes"); local pf = rem and rem:FindFirstChild("Pallet"); local de = pf and pf:FindFirstChild("PalletDropEvent")
    if not de then return end
    local bpal, bd = nil, 8
    for _, pal in ipairs(V.OC.P) do
        local ref = pal:FindFirstChild("PalletPointSlide") or pal:FindFirstChild("PalletPoint")
        if ref then local d = (r.Position - ref.Position).Magnitude if d < bd then bd = d; bpal = ref end end
    end
    if bpal then pcall(function() de:FireServer(bpal) end); V.lastPal = tick() end
end)
V.origLunge = nil
V.R.Heartbeat:Connect(function()
    local c = V.LP.Character; if not c then return end
    if C.InfLunge then if c:GetAttribute("lungeboost") ~= 999999 then V.origLunge = c:GetAttribute("lungeboost") or 1; c:SetAttribute("lungeboost", 999999) end
    else if V.origLunge then c:SetAttribute("lungeboost", V.origLunge); V.origLunge = nil end end
end)
V.beat = {SDone=false, KTarget=nil}
V.R.Heartbeat:Connect(function()
    if C.BeatSurv and V.role() == "Survivor" and not V.beat.SDone then
        local r = V.root(); if not r then return end
        local ep, fp = nil, nil
        for _, o in ipairs(V.W:GetDescendants()) do
            local ln = string.lower(o.Name)
            if (ln == "fininshline" or ln == "finishline") and o:IsA("BasePart") then fp = o; ep = o.Position; break end
        end
        if ep then
            V.beat.SDone = true
            task.spawn(function()
                task.delay(4, function() V.beat.SDone = false end)
                for i = 1, 10 do
                    if not r or not r.Parent then break end
                    pcall(function()
                        local ev = V.RS:FindFirstChild("Remotes"); local g = ev and ev:FindFirstChild("Game"); local pa = g and g:FindFirstChild("PlayerActionEvent")
                        if pa then if pa:IsA("RemoteEvent") then pa:FireServer("ESCAPED", 200) elseif pa:IsA("BindableEvent") then pa:Fire("ESCAPED", 200) end end
                    end)
                    if firetouchinterest and fp then
                        pcall(function() firetouchinterest(r, fp, 0) end); pcall(function() firetouchinterest(r, fp, 1) end)
                    end
                    if i == 1 then r.Velocity = Vector3.zero; r.CFrame = CFrame.new(ep + Vector3.new(0,3,0)) end
                    pcall(function() local h = V.LP.Character and V.LP.Character:FindFirstChildOfClass("Humanoid"); if h then h:MoveTo(ep) end end)
                    task.wait(0.2)
                end
            end)
        end
    end
    if C.BeatKiller and V.role() == "Killer" then
        local r = V.root(); if not r then return end
        local t = V.beat.KTarget; local needNew = true
        if t and t.Character then
            local tr = t.Character:FindFirstChild("HumanoidRootPart"); local th = t.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.MaxHealth > 0 and th.Health/th.MaxHealth > 0.25 then needNew = false else V.beat.KTarget = nil end
        end
        if needNew then
            local cands = {}
            for _, p in ipairs(V.P:GetPlayers()) do
                if p ~= V.LP and V.isS(p) and p.Character then
                    local pr = p.Character:FindFirstChild("HumanoidRootPart"); local ph = p.Character:FindFirstChildOfClass("Humanoid")
                    if pr and ph and ph.MaxHealth > 0 and ph.Health/ph.MaxHealth > 0.25 then table.insert(cands, p) end
                end
            end
            if #cands > 0 then
                local best, bd = nil, math.huge
                for _, p in ipairs(cands) do local pr = p.Character:FindFirstChild("HumanoidRootPart"); local d = (pr.Position - r.Position).Magnitude if d < bd then bd = d; best = p end end
                V.beat.KTarget = best; t = best
            else V.beat.KTarget = nil; return end
        end
        if t and t.Character then
            local tr = t.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for _, p in ipairs(V.LP.Character:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide = false end) end end
                local dir = (r.Position - tr.Position).Unit
                if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1,0,0) end
                r.CFrame = CFrame.new(tr.Position + dir * 3 + Vector3.new(0,1,0), tr.Position)
                pcall(function()
                    local rem = V.RS:FindFirstChild("Remotes"); local a = rem and rem:FindFirstChild("Attacks"); local b = a and a:FindFirstChild("BasicAttack")
                    if b then b:FireServer(false) end
                end)
            end
        end
    end
    if C.FakeAttack then
        local c = V.LP.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid"); local anim = hum and hum:FindFirstChildOfClass("Animator"); local mr = c:FindFirstChild("HumanoidRootPart")
            if anim and mr then
                local near = false
                for _, p in ipairs(V.P:GetPlayers()) do
                    if p ~= V.LP and p.Team and p.Team.Name == "Survivors" then
                        local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if r and (mr.Position - r.Position).Magnitude <= 15 then near = true; break end
                    end
                end
                if near then pcall(function()
                    local bait = Instance.new("Animation"); bait.AnimationId = "rbxassetid://117042998468241"
                    local t = anim:LoadAnimation(bait); t:Play(); t:AdjustWeight(0); task.wait(0.05); t:Stop()
                end) end
            end
        end
    end
end)

-- ═══ BUTTONS: ALBtn + Moonwalk + Myers ═══
V.ALBtn = {UI=nil, Btn=nil, Label=nil, Drg=false, DS=nil, DP=nil}
V.ALRefresh = function()
    if not V.ALBtn.Btn then return end
    local on = C.ALock
    V.ALBtn.Btn.BackgroundColor3 = on and Color3.fromRGB(185,50,50) or Color3.fromRGB(20,0,30)
    if V.ALBtn.Label then V.ALBtn.Label.Text = on and "ON" or "OFF" end
end
function V.ALMake()
    local old = V.PG:FindFirstChild("ValzALBtn"); if old then old:Destroy() end
    local ui = Instance.new("ScreenGui", V.PG); ui.Name = "ValzALBtn"; ui.ResetOnSpawn = false; ui.IgnoreGuiInset = true
    local b = Instance.new("ImageButton", ui)
    b.Size = UDim2.new(0,60,0,60); b.Position = UDim2.new(0.88,0,0.55,0); b.AnchorPoint = Vector2.new(0.5,0.5)
    b.BackgroundColor3 = Color3.fromRGB(20,0,30); b.BackgroundTransparency = 0.15; b.Visible = C.ALBtn
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(255,70,70); s.Thickness = 2
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "OFF"; l.TextColor3 = Color3.new(1,1,1); l.TextScaled = true; l.Font = Enum.Font.GothamBlack
    V.ALBtn.UI, V.ALBtn.Btn, V.ALBtn.Label = ui, b, l
    b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then V.ALBtn.Drg = true; V.ALBtn.DS = i.Position; V.ALBtn.DP = b.Position end end)
    b.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then V.ALBtn.Drg = false end end)
    b.MouseButton1Click:Connect(function() C.ALock = not C.ALock; V.ALRefresh() end)
    V.ALRefresh()
end
V.U.InputChanged:Connect(function(i) if V.ALBtn.Drg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - V.ALBtn.DS; V.ALBtn.Btn.Position = UDim2.new(V.ALBtn.DP.X.Scale, V.ALBtn.DP.X.Offset+d.X, V.ALBtn.DP.Y.Scale, V.ALBtn.DP.Y.Offset+d.Y) end end)
V.mBtnData = {UI=nil, Btn=nil, Label=nil}
function V.mMake()
    local old = V.PG:FindFirstChild("ValzMoonBtn"); if old then old:Destroy() end
    local ui = Instance.new("ScreenGui", V.PG); ui.Name = "ValzMoonBtn"; ui.ResetOnSpawn = false; ui.IgnoreGuiInset = true
    local b = Instance.new("ImageButton", ui)
    b.Size = UDim2.new(0,54,0,54); b.Position = UDim2.new(1,-38,0.48,0); b.AnchorPoint = Vector2.new(0.5,0.5)
    b.BackgroundColor3 = Color3.fromRGB(20,0,30); b.BackgroundTransparency = 0.15
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(255,0,255); s.Thickness = 2
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "MW"; l.TextColor3 = Color3.new(1,1,1); l.TextScaled = true; l.Font = Enum.Font.GothamBlack
    V.mBtnData.UI, V.mBtnData.Btn, V.mBtnData.Label = ui, b, l
    b.MouseButton1Click:Connect(function() C.Moonwalk = not C.Moonwalk; l.Text = C.Moonwalk and "ON" or "MW" end)
end
V.MyersD = {UI=nil, Btn=nil, Enabled=false}
function V.myersMake()
    local old = V.PG:FindFirstChild("ValzMyersUI"); if old then old:Destroy() end
    local ui = Instance.new("ScreenGui", V.PG); ui.Name = "ValzMyersUI"; ui.ResetOnSpawn = false; ui.IgnoreGuiInset = true
    local b = Instance.new("ImageButton", ui)
    b.Size = UDim2.new(0,60,0,60); b.Position = UDim2.new(0.7,0,0.75,0); b.AnchorPoint = Vector2.new(0.5,0.5)
    b.BackgroundColor3 = Color3.fromRGB(20,0,30); b.BackgroundTransparency = 0.15; b.Visible = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(255,0,255); s.Thickness = 2
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "GRAB"; l.TextColor3 = Color3.new(1,1,1); l.TextScaled = true; l.Font = Enum.Font.GothamBlack
    V.MyersD.UI, V.MyersD.Btn = ui, b
    b.MouseButton1Click:Connect(function()
        if not V.MyersD.Enabled then return end
        local c = V.LP.Character; local mh = c and c:FindFirstChild("HumanoidRootPart"); if not mh then return end
        local best, bd = nil, math.huge
        for _, p in ipairs(V.P:GetPlayers()) do
            if p ~= V.LP and p.Character then
                local h = p.Character:FindFirstChild("HumanoidRootPart"); local hm = p.Character:FindFirstChildOfClass("Humanoid")
                if h and hm and hm.Health > 0 then local d = (h.Position - mh.Position).Magnitude if d < bd then bd = d; best = p end end
            end
        end
        if best and best.Character then
            pcall(function()
                local rem = V.RS:FindFirstChild("Remotes"); local kr = rem and rem:FindFirstChild("Killers"); local st = kr and kr:FindFirstChild("Stalker"); local gr = st and st:FindFirstChild("grab")
                if gr then gr:FireServer(best.Character) end
            end)
        end
    end)
end
V.ALMake(); V.mMake(); V.myersMake()
V.U.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.H and V.MyersD.Enabled then
        local c = V.LP.Character; local mh = c and c:FindFirstChild("HumanoidRootPart"); if mh then
            local best, bd = nil, math.huge
            for _, p in ipairs(V.P:GetPlayers()) do
                if p ~= V.LP and p.Character then
                    local h = p.Character:FindFirstChild("HumanoidRootPart"); local hm = p.Character:FindFirstChildOfClass("Humanoid")
                    if h and hm and hm.Health > 0 then local d = (h.Position - mh.Position).Magnitude if d < bd then bd = d; best = p end end
                end
            end
            if best and best.Character then
                pcall(function()
                    local rem = V.RS:FindFirstChild("Remotes"); local kr = rem and rem:FindFirstChild("Killers"); local st = kr and kr:FindFirstChild("Stalker"); local gr = st and st:FindFirstChild("grab")
                    if gr then gr:FireServer(best.Character) end
                end)
            end
        end
    end
end)
V.LP.CharacterAdded:Connect(function() task.wait(0.5); V.ALMake(); V.mMake(); V.myersMake() end)

-- ═══ GC FEATURES ═══
V.hasGC = function()
    return type(getgc) == "function" and type(islclosure) == "function"
        and type(debug) == "table" and debug.getconstants and debug.getupvalues and debug.setupvalue
end
V.AbyssConn = nil
function V.startAbyss()
    if not V.hasGC() then V.N("Abyss", "No getgc"); return end
    local fn
    local n = 0
    for _, v in pairs(getgc(true)) do
        n = n + 1; if n > 60000 then break end
        if type(v) == "function" and islclosure(v) then
            local ok, cs = pcall(debug.getconstants, v)
            if ok and cs then
                local hc, hi = false, false
                for _, c in ipairs(cs) do if c == "corrupt" then hc = true end if c == "Immobile" then hi = true end end
                if hc and hi then fn = v; break end
            end
        end
    end
    if not fn then V.N("Abyss", "Func not found"); return end
    if V.AbyssConn then V.AbyssConn:Disconnect() end
    V.AbyssConn = V.R.Heartbeat:Connect(function()
        if not C.InfAbyss then return end
        pcall(function()
            for i, v in pairs(debug.getupvalues(fn)) do
                if type(v) == "boolean" and v == false then debug.setupvalue(fn, i, true) end
            end
        end)
    end)
    V.N("Abyss", "ON")
end
V.HidConn = nil
function V.startHidden()
    if not V.hasGC() then V.N("Hidden", "No getgc"); return end
    local leap, m2
    local n = 0
    for _, v in pairs(getgc(true)) do
        n = n + 1; if n > 60000 then break end
        if type(v) == "function" and islclosure(v) then
            local ok, info = pcall(debug.getinfo, v)
            if ok and info then
                if info.name == "tryActivate" then leap = v end
                if info.name == "playM2Animation" then m2 = v end
            end
        end
        if leap and m2 then break end
    end
    if not (leap or m2) then V.N("Hidden", "Funcs not found"); return end
    if V.HidConn then V.HidConn:Disconnect() end
    V.HidConn = V.R.Heartbeat:Connect(function()
        if not C.InfHidden then return end
        pcall(function()
            if leap then for i, v in pairs(debug.getupvalues(leap)) do if type(v) == "boolean" and v == true then debug.setupvalue(leap, i, false) end end end
            if m2 then for i, v in pairs(debug.getupvalues(m2)) do if type(v) == "boolean" and v == true then debug.setupvalue(m2, i, false) end end end
        end)
    end)
    V.N("Hidden", "ON")
end
V.JeffT = nil
function V.startJeff()
    if V.JeffT then return end
    C.InfJeff = true
    V.JeffT = task.spawn(function()
        while task.wait() do
            if not C.InfJeff then break end
            pcall(function() local c = V.LP.Character; if c and c:GetAttribute("Frenzy") ~= true then c:SetAttribute("Frenzy", true) end end)
        end
        V.JeffT = nil
    end)
    V.N("Frenzy", "ON")
end
V.stopJeff = function()
    C.InfJeff = false
    pcall(function()
        local c = V.LP.Character
        if c and c:GetAttribute("Frenzy") == true then
            c:SetAttribute("Frenzy", false)
            local rem = V.RS:FindFirstChild("Remotes"); local kr = rem and rem:FindFirstChild("Killers"); local kf = kr and kr:FindFirstChild("Killer")
            local d = kf and kf:FindFirstChild("Deactivatefromclient"); if d then d:FireServer() end
        end
    end)
end
V.SlashT = nil
pcall(function()
    local b = true; local mt = debug.getmetatable(b)
    if not mt then mt = {}; debug.setmetatable(b, mt) end
    if setreadonly then setreadonly(mt, false) end
    mt.__div = function() return 0 end; mt.__mul = function() return 0 end; mt.__add = function() return 0 end; mt.__sub = function() return 0 end
    if setreadonly then setreadonly(mt, true) end
end)
function V.startSlasher()
    if not V.hasGC() then V.N("Jason", "No getgc"); return end
    local tog, pur
    local n = 0
    for _, v in pairs(getgc(true)) do
        n = n + 1; if n > 60000 then break end
        if type(v) == "function" and islclosure(v) then
            local ok, cs = pcall(debug.getconstants, v)
            if ok and cs then
                local o, li, ac, tw, pu, ws = false, false, false, false, false, false
                for _, c in ipairs(cs) do
                    if c == "Offset" then o = true end; if c == "Linear" then li = true end
                    if c == "action" then ac = true end; if c == "TweenInfo" then tw = true end
                    if c == "Pursuit" then pu = true end; if c == "WalkSpeed" then ws = true end
                end
                if o and li and ac and tw and not pu then tog = v end
                if pu and tw and ac and ws then pur = v end
            end
        end
        if tog and pur then break end
    end
    if not (tog or pur) then V.N("Jason", "Funcs not found"); return end
    if V.SlashT then return end
    V.SlashT = task.spawn(function()
        while task.wait(0.1) do
            if not (C.InfLake or C.InfPursuit) then break end
            pcall(function()
                if tog and C.InfLake then for i, v in pairs(debug.getupvalues(tog)) do if type(v) == "boolean" and v == true then debug.setupvalue(tog, i, false) end end end
                if pur and C.InfPursuit then for i, v in pairs(debug.getupvalues(pur)) do if type(v) == "boolean" and v == true then debug.setupvalue(pur, i, false) end end end
            end)
        end
        V.SlashT = nil
    end)
    V.N("Jason", "ON")
end

-- ═══ EMOTE SYSTEM ═══
V.Emotes = {
    ["Friday Night"] = {a = "rbxassetid://83229063951016", s = "rbxassetid://85355610204255"},
    ["WarCry"] = {a = "rbxassetid://82600868380136", s = "rbxassetid://120101930689931"},
    ["24 Hour Cinderella"] = {a = "rbxassetid://137195203725366", s = "rbxassetid://121099446613414"},
    ["Applause"] = {a = "rbxassetid://96328361165090", s = "rbxassetid://115490787020749"},
    ["Arm Swing"] = {a = "rbxassetid://80552139463944", s = "rbxassetid://74216458932348"},
    ["Backflip"] = {a = "rbxassetid://74705617908505"},
    ["California Girls"] = {a = "rbxassetid://123552803041504", s = "rbxassetid://87899327891544"},
    ["Christmas Spirit"] = {a = "rbxassetid://137859761110514"},
    ["Floating Rest"] = {a = "rbxassetid://114593021219597"},
    ["Ghoul"] = {a = "rbxassetid://130415594909401", s = "rbxassetid://123004139176580"},
    ["Griddy"] = {a = "rbxassetid://75586690784894"},
    ["Kyoufuu"] = {a = "rbxassetid://137322894494527", s = "rbxassetid://129064643026442"},
    ["OnePlays"] = {a = "rbxassetid://140625405103474", s = "rbxassetid://94749073728335"},
    ["Vulnerable"] = {a = "rbxassetid://121773684313913", s = "rbxassetid://135265751184744"},
}
C.SelectedEmote = "Friday Night"
V.EmoteT, V.EmoteS = nil, nil
V.playEmote = function()
    local c = V.LP.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); local hrp = c:FindFirstChild("HumanoidRootPart"); if not h or not hrp then return end
    if V.EmoteT then pcall(function() V.EmoteT:Stop() end); V.EmoteT = nil end
    if V.EmoteS then pcall(function() V.EmoteS:Destroy() end); V.EmoteS = nil end
    local e = V.Emotes[C.SelectedEmote] or V.Emotes["Friday Night"]
    if e.a then local an = Instance.new("Animation"); an.AnimationId = e.a; V.EmoteT = h:LoadAnimation(an); V.EmoteT.Looped = true; V.EmoteT:Play() end
    if e.s then V.EmoteS = Instance.new("Sound"); V.EmoteS.SoundId = e.s; V.EmoteS.Looped = true; V.EmoteS.Volume = 2; V.EmoteS.Parent = hrp; V.EmoteS:Play() end
end
V.stopEmote = function()
    if V.EmoteT then pcall(function() V.EmoteT:Stop() end); V.EmoteT = nil end
    if V.EmoteS then pcall(function() V.EmoteS:Destroy() end); V.EmoteS = nil end
end

-- ═══ AVATAR ═══
V.KorlessConn = nil
V.korlessApply = function()
    local function morph()
        repeat task.wait() until V.LP.Character and V.LP.Character:FindFirstChild("HumanoidRootPart") and V.LP.Character:FindFirstChild("Right Leg")
        task.wait(0.1)
        local c = V.LP.Character
        pcall(function()
            c.Head.Transparency = 1
            local f = c.Head:FindFirstChild("face"); if f then f:Destroy() end
            c["Right Leg"].Transparency = 1
            local m = Instance.new("MeshPart"); m.Name = "KorlessHead"; m.Size = Vector3.new(1.5,1.5,1.5); m.CanCollide = false
            m.MeshId = "rbxassetid://902942096"; m.TextureID = "rbxassetid://902843398"
            m.CFrame = c["Right Leg"].CFrame * CFrame.new(0, 0.5, 0); m.Parent = c
            local w = Instance.new("WeldConstraint"); w.Part0 = c["Right Leg"]; w.Part1 = m; w.Parent = m
        end)
    end
    morph()
    if V.KorlessConn then V.KorlessConn:Disconnect() end
    V.KorlessConn = V.LP.CharacterAdded:Connect(function() task.wait(1); morph() end)
end
V.korlessReset = function()
    if V.KorlessConn then V.KorlessConn:Disconnect(); V.KorlessConn = nil end
    pcall(function() local k = V.LP.Character and V.LP.Character:FindFirstChild("KorlessHead"); if k then k:Destroy() end end)
end
V.CopyA = {Saved=false, Cache={}, HeadSM=nil}
V.stdParts = {Head=true, Torso=true, ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true, HumanoidRootPart=true, UpperTorso=true, LowerTorso=true, LeftUpperArm=true, LeftLowerArm=true, LeftHand=true, RightUpperArm=true, RightLowerArm=true, RightHand=true, LeftUpperLeg=true, LeftLowerLeg=true, LeftFoot=true, RightUpperLeg=true, RightLowerLeg=true, RightFoot=true}
V.saveAvatar = function()
    if V.CopyA.Saved then return end
    local c = V.LP.Character; if not c then return end
    for _, o in ipairs(c:GetChildren()) do
        if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") or o:IsA("CharacterMesh") or o:IsA("BodyColors") then
            table.insert(V.CopyA.Cache, o:Clone())
        elseif o:IsA("BasePart") and not V.stdParts[o.Name] and o.Name ~= "FakeCopiedHead" then
            table.insert(V.CopyA.Cache, o:Clone())
        end
    end
    local h = c:FindFirstChild("Head")
    if h then
        local sm = h:FindFirstChildOfClass("SpecialMesh"); if sm then V.CopyA.HeadSM = sm.Scale end
        for _, v in ipairs(h:GetChildren()) do if v:IsA("Decal") or v:IsA("Texture") then table.insert(V.CopyA.Cache, v:Clone()) end end
    end
    V.CopyA.Saved = true
end
V.accLocal = function(char, acc)
    local handle = acc:FindFirstChild("Handle"); if not handle then return end
    local accAtt; for _, v in ipairs(handle:GetChildren()) do if v:IsA("Attachment") then accAtt = v; break end end
    if not accAtt then return end
    local charAtt, tp
    local fh = char:FindFirstChild("FakeCopiedHead")
    if fh then local a = fh:FindFirstChild(accAtt.Name); if a and a:IsA("Attachment") then charAtt = a; tp = fh end end
    if not charAtt then
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and p.Name ~= "FakeCopiedHead" then
                local a = p:FindFirstChild(accAtt.Name); if a and a:IsA("Attachment") then charAtt = a; tp = p; break end
            end
        end
    end
    if not charAtt then return end
    for _, v in ipairs(handle:GetChildren()) do if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end
    acc.Parent = char
    local w = Instance.new("Weld"); w.Part0 = handle; w.Part1 = tp; w.C0 = accAtt.CFrame; w.C1 = charAtt.CFrame; w.Parent = handle
end
V.applyAvatar = function(tc)
    local mc = V.LP.Character; if not mc or not tc then return end
    for _, o in ipairs(mc:GetChildren()) do
        if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") or o:IsA("CharacterMesh") or o:IsA("BodyColors") then o:Destroy()
        elseif o:IsA("BasePart") and not V.stdParts[o.Name] and o.Name ~= "FakeCopiedHead" then o:Destroy() end
    end
    local mh = mc:FindFirstChild("Head")
    if mh then for _, v in ipairs(mh:GetChildren()) do if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end end
    local th = tc:FindFirstChild("Head")
    if th and mh then
        mh.Transparency = 1
        local old = mc:FindFirstChild("FakeCopiedHead"); if old then old:Destroy() end
        local fh = th:Clone(); fh.Name = "FakeCopiedHead"; fh.CanCollide = false; fh.Massless = true
        local tbc = tc:FindFirstChildOfClass("BodyColors"); fh.Color = tbc and tbc.HeadColor3 or th.Color
        local mySm = mh:FindFirstChildOfClass("SpecialMesh"); if mySm then mySm.Scale = Vector3.new(0,0,0) end
        mh.LocalTransparencyModifier = 1
        for _, v in ipairs(fh:GetChildren()) do if v:IsA("Motor6D") or v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end
        fh.Parent = mc
        local hw = Instance.new("Weld"); hw.Part0 = mh; hw.Part1 = fh; hw.Parent = fh
    end
    for _, o in ipairs(tc:GetChildren()) do
        if o:IsA("Accessory") or o:IsA("Hat") then V.accLocal(mc, o:Clone())
        elseif o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") or o:IsA("CharacterMesh") or o:IsA("BodyColors") then o:Clone().Parent = mc
        elseif o:IsA("BasePart") and not V.stdParts[o.Name] and o.Name ~= "FakeCopiedHead" then
            local cl = o:Clone()
            for _, v in ipairs(cl:GetDescendants()) do if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end
            local tr = tc:FindFirstChild("HumanoidRootPart") or tc:FindFirstChild("Torso") or tc:FindFirstChild("UpperTorso")
            local mr = mc:FindFirstChild("HumanoidRootPart") or mc:FindFirstChild("Torso") or mc:FindFirstChild("UpperTorso")
            if tr and mr then
                local off = tr.CFrame:Inverse() * o.CFrame; cl.CFrame = mr.CFrame * off
                local w = Instance.new("WeldConstraint"); w.Part0 = cl; w.Part1 = mr; w.Parent = cl
            end
            cl.Parent = mc
        end
    end
end
V.resetAvatar = function()
    local c = V.LP.Character; if not c or not V.CopyA.Saved then return end
    for _, o in ipairs(c:GetChildren()) do if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") or o:IsA("CharacterMesh") or o:IsA("BodyColors") then o:Destroy() end end
    local h = c:FindFirstChild("Head")
    if h then
        local f = h:FindFirstChildOfClass("Decal"); if f then f:Destroy() end
        local of = c:FindFirstChild("FakeCopiedHead"); if of then of:Destroy() end
        h.Transparency = 0; h.LocalTransparencyModifier = 0
        local sm = h:FindFirstChildOfClass("SpecialMesh")
        if sm and V.CopyA.HeadSM then sm.Scale = V.CopyA.HeadSM elseif sm then sm.Scale = Vector3.new(1.25,1.25,1.25) end
    end
    for _, obj in ipairs(V.CopyA.Cache) do
        local cl = obj:Clone()
        if cl:IsA("Decal") then if h then cl.Parent = h end
        elseif cl:IsA("Accessory") then V.accLocal(c, cl)
        else cl.Parent = c end
    end
end
V.hideName = function(on)
    if V.HideNameC then V.HideNameC:Disconnect(); V.HideNameC = nil end
    local pg = V.LP:FindFirstChildOfClass("PlayerGui"); if not pg then return end
    local function proc(o)
        local ok, isT = pcall(function() return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") end)
        if not ok or not isT then return end
        local t = ""; pcall(function() t = tostring(o.Text or "") end)
        if t == V.LP.Name or t == V.LP.DisplayName or t:find(V.LP.Name, 1, true) then o.Visible = not on end
    end
    for _, d in ipairs(pg:GetDescendants()) do proc(d) end
    if on then V.HideNameC = pg.DescendantAdded:Connect(function(o) task.defer(proc, o) end) end
end
V.spoof = function(lv, g, s)
    pcall(function()
        V.LP:SetAttribute("Level", tonumber(lv) or 0)
        V.LP:SetAttribute("Gears", tonumber(g) or 0)
        V.LP:SetAttribute("Screws", tonumber(s) or 0)
    end)
    V.N("Spoof", "Applied")
end
V.flingNearest = function()
    if not C.Fling then return end
    local r = V.root(); if not r then return end
    local best, bd = nil, math.huge
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then local d = (tr.Position - r.Position).Magnitude if d < bd then bd = d; best = p end end
        end
    end
    if best and best.Character then
        local tr = best.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local orig = r.CFrame
            for _ = 1, 10 do r.CFrame = tr.CFrame; r.Velocity = Vector3.new(10000,5000,10000); r.RotVelocity = Vector3.new(9999,9999,9999); task.wait() end
            r.CFrame = orig; r.Velocity = Vector3.zero; r.RotVelocity = Vector3.zero
        end
    end
end
V.flingAll = function()
    if not C.Fling then return end
    local r = V.root(); if not r then return end
    local orig = r.CFrame
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then for _ = 1, 5 do r.CFrame = tr.CFrame; r.Velocity = Vector3.new(10000,5000,10000); r.RotVelocity = Vector3.new(9999,9999,9999); task.wait() end end
        end
    end
    r.CFrame = orig; r.Velocity = Vector3.zero; r.RotVelocity = Vector3.zero
end

-- ═══ WEATHER ═══
V.WeatherPresets = {
    ["Default"] = {}, ["Christmas (Snow)"] = {FogColor = Color3.fromRGB(150,180,220), FogEnd = 200, ClockTime = 8},
    ["Heavy Rain (Storm)"] = {FogColor = Color3.fromRGB(50,50,60), FogEnd = 150, ClockTime = 12},
    ["Autumn"] = {FogColor = Color3.fromRGB(200,150,80), FogEnd = 500, ClockTime = 16.5},
    ["Sakura"] = {FogColor = Color3.fromRGB(255,200,220), FogEnd = 600, ClockTime = 9},
    ["Sunset"] = {FogColor = Color3.fromRGB(255,120,50), FogEnd = 1200, ClockTime = 17.5},
    ["Blood Moon"] = {FogColor = Color3.fromRGB(150,10,10), FogEnd = 500, ClockTime = 0, Brightness = 0.3},
    ["Toxic"] = {FogColor = Color3.fromRGB(80,150,50), FogEnd = 250, ClockTime = 12},
    ["Vaporwave"] = {FogColor = Color3.fromRGB(200,50,255), FogEnd = 500, ClockTime = 20},
    ["Midnight"] = {FogColor = Color3.fromRGB(0,0,0), FogEnd = 100, ClockTime = 0, Brightness = 0},
}
V.origL = {B = V.L.Brightness, C = V.L.ClockTime, FE = V.L.FogEnd, FS = V.L.FogStart, GS = V.L.GlobalShadows, OA = V.L.OutdoorAmbient}
V.setWeather = function(name)
    local t = V.WeatherPresets[name]
    if not t or not next(t) then
        V.L.Brightness = V.origL.B; V.L.ClockTime = V.origL.C; V.L.FogEnd = V.origL.FE; V.L.FogStart = V.origL.FS; V.L.GlobalShadows = V.origL.GS; V.L.OutdoorAmbient = V.origL.OA
        return
    end
    for k, v in pairs(t) do pcall(function() V.L[k] = v end) end
end

-- ═══ ANIM LOGGER ═══
V.AL = {Log={}, Unique={}, Hooks={}, Max=200}
V.alTime = function()
    local t = tick() % 86400
    return string.format("%02d:%02d:%02d", math.floor(t/3600), math.floor((t%3600)/60), math.floor(t%60))
end
V.alAdd = function(id, kName)
    if not id or V.KA[id] then return end
    local isNew = not V.AL.Unique[id]; if isNew then V.AL.Unique[id] = true end
    table.insert(V.AL.Log, 1, {t = V.alTime(), id = id, k = kName or "?", n = isNew})
    while #V.AL.Log > V.AL.Max do table.remove(V.AL.Log) end
    if V._alRefresh then V._alRefresh() end
end
V.alHook = function(k)
    if not k or not k.Character then return end
    local c = k.Character; if V.AL.Hooks[c] then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    local a = h:FindFirstChildOfClass("Animator")
    if not a then task.delay(1, function() if k.Character and not V.AL.Hooks[k.Character] then V.alHook(k) end end); return end
    V.AL.Hooks[c] = true
    a.AnimationPlayed:Connect(function(tr)
        if not C.ALEnabled then return end
        local an = tr.Animation; if not an then return end
        local n = an.AnimationId:match("%d+"); if n then V.alAdd(n, k.Name) end
    end)
end
task.spawn(function() while task.wait(0.5) do if C.ALEnabled then for _, p in ipairs(V.P:GetPlayers()) do if p ~= V.LP and p.Character and V.isK(p) then V.alHook(p) end end end end end)

-- ═══ UI BUILD: VALZZHUB BLUE NEON ═══
local C_BG = Color3.fromRGB(8, 13, 23)
local C_PANEL = Color3.fromRGB(12, 22, 38)
local C_HEADER = Color3.fromRGB(10, 19, 34)
local C_ACCENT = Color3.fromRGB(0, 110, 255)
local C_TEXT = Color3.fromRGB(232, 241, 255)
local C_SUB = Color3.fromRGB(137, 170, 210)
local C_OFF = Color3.fromRGB(16, 29, 48)
local C_STR = Color3.fromRGB(28, 55, 88)

local SG = Instance.new("ScreenGui")
SG.Name = "ValzzHub"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; SG.Parent = V.parent()
local MF = Instance.new("Frame", SG)
MF.Name = "MainWindow"
MF.Size = UDim2.new(0.43, 0, 0.64, 0)
MF.Position = UDim2.new(0.5, 0, 0.5, 0); MF.AnchorPoint = Vector2.new(0.5, 0.5)
MF.BackgroundColor3 = C_BG; MF.BorderSizePixel = 0; MF.ClipsDescendants = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 14)
local sizeLimit = Instance.new("UISizeConstraint", MF)
sizeLimit.MinSize = Vector2.new(310, 330); sizeLimit.MaxSize = Vector2.new(520, 540)
local ms = Instance.new("UIStroke", MF); ms.Color = Color3.fromRGB(35, 92, 160); ms.Thickness = 1; ms.Transparency = 0.28

local HD = Instance.new("Frame", MF)
HD.Size = UDim2.new(1, 0, 0, 62); HD.BackgroundColor3 = C_HEADER; HD.BorderSizePixel = 0
local logo = Instance.new("TextLabel", HD)
logo.Size = UDim2.new(0, 42, 0, 42); logo.Position = UDim2.new(0, 14, 0, 10)
logo.BackgroundTransparency = 1; logo.Text = "V"; logo.TextColor3 = C_ACCENT
logo.Font = Enum.Font.GothamBlack; logo.TextSize = 36
local ttl = Instance.new("TextLabel", HD); ttl.Text = "ValzzHub"
ttl.Size = UDim2.new(0, 180, 0, 28); ttl.Position = UDim2.new(0, 62, 0, 10)
ttl.BackgroundTransparency = 1; ttl.TextColor3 = C_TEXT; ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 21; ttl.TextXAlignment = Enum.TextXAlignment.Left
local sb = Instance.new("TextLabel", HD); sb.Text = "Compact Interface"
sb.Size = UDim2.new(0, 240, 0, 18); sb.Position = UDim2.new(0, 63, 0, 35)
sb.BackgroundTransparency = 1; sb.TextColor3 = C_SUB; sb.Font = Enum.Font.Gotham
sb.TextSize = 10; sb.TextXAlignment = Enum.TextXAlignment.Left
local mn = Instance.new("TextButton", HD); mn.Text = "—"
mn.Size = UDim2.new(0, 34, 0, 32); mn.Position = UDim2.new(1, -78, 0, 15)
mn.BackgroundColor3 = C_OFF; mn.BorderSizePixel = 0; mn.TextColor3 = C_TEXT
mn.Font = Enum.Font.GothamBold; mn.TextSize = 18
Instance.new("UICorner", mn).CornerRadius = UDim.new(0, 7)
local close = Instance.new("TextButton", HD); close.Text = "×"
close.Size = UDim2.new(0, 34, 0, 32); close.Position = UDim2.new(1, -38, 0, 15)
close.BackgroundColor3 = C_OFF; close.BorderSizePixel = 0; close.TextColor3 = C_TEXT
close.Font = Enum.Font.Gotham; close.TextSize = 22
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

local SBAR = Instance.new("Frame", MF)
SBAR.Size = UDim2.new(0, 88, 1, -62); SBAR.Position = UDim2.new(0, 0, 0, 62)
SBAR.BackgroundColor3 = Color3.fromRGB(9, 17, 29); SBAR.BorderSizePixel = 0
local tabLayout = Instance.new("UIListLayout", SBAR)
tabLayout.Padding = UDim.new(0, 6); tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
local tabPad = Instance.new("UIPadding", SBAR)
tabPad.PaddingTop = UDim.new(0, 12); tabPad.PaddingLeft = UDim.new(0, 7); tabPad.PaddingRight = UDim.new(0, 7)
local CT = Instance.new("Frame", MF)
CT.Size = UDim2.new(1, -96, 1, -76); CT.Position = UDim2.new(0, 94, 0, 70)
CT.BackgroundTransparency = 1

local PG2, TBtns = {}, {}
function V.mkPage(name)
    local p = Instance.new("ScrollingFrame", CT)
    p.Name = name .. "Page"; p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = C_ACCENT; p.CanvasSize = UDim2.new(0,0,0,0); p.Visible = false
    local l = Instance.new("UIListLayout", p); l.Padding = UDim.new(0,7); l.SortOrder = Enum.SortOrder.LayoutOrder
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize = UDim2.new(0,0,0,l.AbsoluteContentSize.Y+12) end)
    local pad = Instance.new("UIPadding", p); pad.PaddingRight = UDim.new(0,5); pad.PaddingTop = UDim.new(0,3)
    PG2[name] = p; return p
end
function V.mkTab(name, order, label)
    local b = Instance.new("TextButton", SBAR)
    b.Size = UDim2.new(1,0,0,36); b.BackgroundColor3 = C_OFF; b.BorderSizePixel = 0
    b.Text = "  " .. (label or name); b.TextColor3 = C_SUB; b.Font = Enum.Font.GothamMedium
    b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left; b.LayoutOrder = order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(PG2) do p.Visible = false end
        PG2[name].Visible = true
        for n, btn in pairs(TBtns) do
            btn.BackgroundColor3 = (n == name) and C_ACCENT or C_OFF
            btn.TextColor3 = (n == name) and Color3.new(1,1,1) or C_SUB
        end
    end)
    TBtns[name] = b; return b
end
function V.mkSec(txt, order, par)
    local s = Instance.new("TextLabel", par); s.Size = UDim2.new(1,0,0,22)
    s.BackgroundTransparency = 1; s.Text = string.upper(txt); s.TextColor3 = C_SUB
    s.Font = Enum.Font.GothamBold; s.TextSize = 11; s.TextXAlignment = Enum.TextXAlignment.Left; s.LayoutOrder = order
end
function V.mkTog(txt, order, par, cb, init)
    local b = Instance.new("TextButton", par); b.Size = UDim2.new(1,0,0,34)
    b.BackgroundColor3 = C_OFF; b.BorderSizePixel = 0
    b.Text = "  " .. txt; b.TextColor3 = C_TEXT
    b.Font = Enum.Font.GothamMedium; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left; b.LayoutOrder = order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    local st = Instance.new("UIStroke", b); st.Color = C_STR; st.Thickness = 1; st.Transparency = 0.62
    local sw = Instance.new("TextLabel", b); sw.Name = "State"; sw.AnchorPoint = Vector2.new(1,0.5)
    sw.Position = UDim2.new(1,-8,0.5,0); sw.Size = UDim2.new(0,42,0,21)
    sw.BackgroundColor3 = init and C_ACCENT or Color3.fromRGB(32,43,58); sw.BorderSizePixel = 0
    sw.Text = init and "ON" or "OFF"; sw.TextColor3 = C_TEXT
    sw.Font = Enum.Font.GothamBold; sw.TextSize = 9
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0,6)
    local on = init or false
    b.MouseButton1Click:Connect(function()
        on = not on
        sw.Text = on and "ON" or "OFF"
        sw.BackgroundColor3 = on and C_ACCENT or Color3.fromRGB(32,43,58)
        st.Color = on and C_ACCENT or C_STR
        cb(on)
    end)
end
function V.mkSld(txt, mnv, mxv, def, order, par, cb)
    local f = Instance.new("Frame", par); f.Size = UDim2.new(1,0,0,52)
    f.BackgroundColor3 = C_OFF; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", f); s.Color = C_STR; s.Thickness = 1; s.Transparency = 0.35
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,-80,0,20); l.Position = UDim2.new(0,10,0,5)
    l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = C_TEXT; l.Font = Enum.Font.GothamMedium; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    local v = Instance.new("TextLabel", f); v.Size = UDim2.new(0,60,0,20); v.Position = UDim2.new(1,-70,0,5)
    v.BackgroundTransparency = 1; v.Text = tostring(def); v.TextColor3 = C_ACCENT; v.Font = Enum.Font.GothamBold; v.TextSize = 12; v.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("TextButton", f); bar.Text = ""; bar.Size = UDim2.new(1,-20,0,7); bar.Position = UDim2.new(0,10,0,34)
    bar.BackgroundColor3 = Color3.fromRGB(27,42,61); bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,4)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((def-mnv)/(mxv-mnv),0,1,0); fill.BackgroundColor3 = C_ACCENT; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,4)
    local dr = false
    local function upd(i)
        local r = math.clamp((i.Position.X-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local n = math.floor(mnv+(mxv-mnv)*r); fill.Size = UDim2.new(r,0,1,0); v.Text = tostring(n); cb(n)
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr=true; upd(i) end end)
    bar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr=false end end)
    V.U.InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
end
function V.mkBtn(txt, order, par, cb)
    local b = Instance.new("TextButton", par); b.Size = UDim2.new(1,0,0,35)
    b.BackgroundColor3 = C_OFF; b.BorderSizePixel = 0; b.Text = "  " .. txt
    b.TextColor3 = C_TEXT; b.Font = Enum.Font.GothamMedium; b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left; b.LayoutOrder = order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", b); s.Color = C_ACCENT; s.Thickness = 1; s.Transparency = 0.45
    b.MouseButton1Click:Connect(function()
        local old = b.BackgroundColor3; b.BackgroundColor3 = Color3.fromRGB(20,55,100)
        task.delay(0.15,function() if b and b.Parent then b.BackgroundColor3=old end end); cb()
    end)
    return b
end
V.PG2 = PG2

-- ═══ TAB BUILDS ═══
local SP = V.mkPage("Survivor"); V.mkTab("Survivor", 1, "Survivor")
V.mkSec("Auto Parry", 1, SP)
V.mkTog("Enable Auto Parry", 2, SP, function(v) C.Parry = v end, false)
V.mkTog("Anti Fake Hit", 3, SP, function(v) C.AntiFake = v end, true)
V.mkTog("Show Ring", 4, SP, function(v) C.Ring = v end, true)
V.mkTog("Ignore Abysswalker", 5, SP, function(v) C.IgAbyss = v end, true)
V.mkTog("Ignore Masked", 6, SP, function(v) C.IgMask = v end, true)
V.mkSld("Parry Radius", 3, 25, 8, 7, SP, function(v) C.ParryR = v end)
V.mkSec("Auto Parry V2", 8, SP)
V.mkTog("Enable Parry V2", 9, SP, function(v) C.ParryV2 = v end, false)
V.mkSld("Parry V2 Radius", 3, 25, 8, 10, SP, function(v) C.ParryV2R = v end)
V.mkSec("Skill Check", 11, SP)
V.mkTog("Auto Skill Check", 12, SP, function(v) C.SC = v end, false)
local scb
scb = V.mkBtn("Mode: Perfect", 13, SP, function()
    C.SCMode = (C.SCMode == "Perfect") and "Normal" or "Perfect"
    scb.Text = "  Mode: " .. C.SCMode
end)
V.mkTog("Hide Skill UI", 14, SP, function(v) C.HideSC = v end, false)
V.mkSec("Fake Actions", 15, SP)
V.mkTog("Fake Parry (V)", 16, SP, function(v) C.FP = v; if V.FPD.Btn then V.FPD.Btn.Visible = v end end, false)
local fpb
local fpAnimOptions = {"Enten", "Stopwatch", "Fih", "BloodShield"}
if not C.FPAnim then C.FPAnim = "Enten" end
fpb = V.mkBtn("Anim: " .. tostring(C.FPAnim or "Enten"), 17, SP, function()
    local i = 1
    for k, name in ipairs(fpAnimOptions) do
        if name == C.FPAnim then i = k; break end
    end
    i = (i % #fpAnimOptions) + 1
    C.FPAnim = fpAnimOptions[i]
    fpb.Text = "  Anim: " .. C.FPAnim
end)
V.mkTog("Fake Generator (B)", 18, SP, function(v) C.FG = v; if V.FGD.Btn then V.FGD.Btn.Visible = v end end, false)
V.mkSec("Fake Perks", 19, SP)
V.mkTog("Flowstate", 20, SP, function(v) C.FPFlow = v; V.setPerk("Flowstate", v) end, false)
V.mkTog("Quick Recovery", 21, SP, function(v) C.FPQuick = v; V.setPerk("QuickRecovery", v) end, false)
V.mkTog("Perfect Landing", 22, SP, function(v) C.FPLand = v; V.setPerk("PerfectLanding", v) end, false)
V.mkTog("Adrenaline Rush", 23, SP, function(v) C.FPAdren = v; V.setPerk("AdrenalineRush", v) end, false)
V.mkSld("Perk Cooldown", 0, 60, 10, 24, SP, function(v) C.FPCD = v end)
V.mkSec("Movement", 25, SP)
V.mkTog("Speed Hack", 26, SP, function(v) C.Speed = v end, false)
V.mkSld("Speed Value", 16, 200, 16, 27, SP, function(v) C.SpeedV = v end)
V.mkTog("Jump Power", 28, SP, function(v) C.Jump = v end, false)
V.mkSld("Jump Value", 50, 300, 50, 29, SP, function(v) C.JumpV = v end)
V.mkTog("Infinite Jump", 30, SP, function(v) C.InfJump = v end, false)
V.mkTog("Noclip", 31, SP, function(v) C.Noclip = v end, false)
V.mkTog("Moonwalk", 32, SP, function(v) C.Moonwalk = v end, false)
V.mkSld("Zigzag Speed", 1, 30, 11, 33, SP, function(v) C.MoonSpeed = v end)
V.mkSld("Boost x100", 100, 200, 108, 34, SP, function(v) C.MoonBoost = v/100 end)
V.mkSec("Survivor Extras", 35, SP)
V.mkTog("First Person", 36, SP, function(v) C.FirstPerson = v end, false)
V.mkTog("Anti Fall Damage", 37, SP, function(v) C.AntiFall = v end, false)
V.mkTog("Anti AFK", 38, SP, function(v) C.AntiAFK = v end, false)
V.mkTog("Auto Wiggle", 39, SP, function(v) C.AutoWiggle = v end, false)
V.mkTog("Self Unhook", 40, SP, function(v) C.SelfUnhook = v end, false)
V.mkSld("Unhook Offset", 2, 15, 5, 41, SP, function(v) V.SU.Off = v end)
V.mkTog("Auto Medkit", 42, SP, function(v) C.AutoMed = v end, false)
V.mkTog("Auto Crouch BETA", 43, SP, function(v) C.AutoCrouch = v end, false)
V.mkTog("Pallet Reflex", 44, SP, function(v) C.PalletReflex = v end, false)
V.mkSld("Pallet Trigger Range", 5, 50, 20, 45, SP, function(v) C.PalletR = v end)
V.mkTog("Anti Knock", 46, SP, function(v) C.AntiKnock = v end, false)
V.mkTog("Aura Heal (Self)", 47, SP, function(v) V.healSet(v) end, false)
V.mkTog("Aura Heal All", 48, SP, function(v) V.healAllSet(v) end, false)
V.mkTog("Invisible Not Visual", 49, SP, function(v) V.invNVSet(v) end, false)
V.mkSld("Inv Speed", 1, 999, 5, 50, SP, function(v) C.InvNVSpeed = v end)
V.mkTog("Bypass Gate", 51, SP, function(v) C.BypassGate = v end, false)
V.mkTog("Flee Killer", 52, SP, function(v) C.FleeKiller = v end, false)
V.mkSld("Flee Distance", 15, 80, 40, 53, SP, function(v) C.FleeDist = v end)
V.mkTog("Auto Dodge Spear", 54, SP, function(v) C.DodgeSpear = v end, false)
V.mkTog("Beat Survivor (Auto Escape)", 55, SP, function(v) C.BeatSurv = v end, false)
V.mkTog("No Cutscene", 56, SP, function(v) C.NoCut = v end, false)
V.mkSec("Swift Vault", 57, SP)
V.mkTog("Swift Vault V1", 58, SP, function(v) C.SwiftV1 = v end, false)
V.mkTog("Swift Vault V2", 59, SP, function(v) C.SwiftV2 = v end, false)
V.mkSld("Vault Speed", 10, 20, 13, 60, SP, function(v) C.VaultSpeed = v end)

local AP = V.mkPage("Aim"); V.mkTab("Aim", 2, "Combat")
V.mkSec("Aimbot", 1, AP)
V.mkTog("Enable Aimbot", 2, AP, function(v) C.Aim = v end, false)
V.mkTog("Use RMB", 3, AP, function(v) C.AimRMB = v end, false)
V.mkTog("Visibility Check", 4, AP, function(v) C.AimVis = v end, false)
V.mkTog("Prediction", 5, AP, function(v) C.AimPred = v end, false)
V.mkSld("FOV", 20, 400, 120, 6, AP, function(v) C.AimFOV = v end)
V.mkSld("Smoothness x10", 1, 10, 3, 7, AP, function(v) C.AimSm = v/10 end)
V.mkSec("AimLock", 8, AP)
V.mkTog("AimLock", 9, AP, function(v) C.ALock = v; V.ALRefresh() end, false)
V.mkSld("AimLock Range", 10, 200, 50, 10, AP, function(v) C.ALockR = v end)
V.mkTog("Show AimLock Button", 11, AP, function(v) C.ALBtn = v; if V.ALBtn.Btn then V.ALBtn.Btn.Visible = v end end, false)
V.mkSec("Silent Aim ToF", 12, AP)
V.mkTog("Enable ToF Silent Aim", 13, AP, function(v) V.tofSet(v) end, false)
V.mkTog("ToF Laser", 14, AP, function(v) C.ToFLaser = v end, true)
V.mkTog("ToF Wall Check", 15, AP, function(v) C.ToFWall = v end, false)
local tmB = V.mkBtn("ToF Target: Killer", 16, AP, function() if C.ToFMode == "Killer" then C.ToFMode = "Survivors"; tmB.Text = "  ToF Target: Survivors" else C.ToFMode = "Killer"; tmB.Text = "  ToF Target: Killer" end end)
V.mkSec("Silent Aim Flashlight", 17, AP)
V.mkTog("Enable Flash Silent Aim", 18, AP, function(v) V.flashSet(v) end, false)
V.mkSld("Flash Range", 20, 250, 120, 19, AP, function(v) C.FlashRange = v end)
V.mkSld("Flash Smooth x100", 5, 100, 35, 20, AP, function(v) C.FlashSm = v/100 end)
V.mkSec("Silent Aim Flask", 21, AP)
V.mkTog("Enable Flask Silent Aim", 22, AP, function(v) C.Flask = v end, false)
V.mkTog("Flask Laser", 23, AP, function(v) V.flaskState.LaserOn = v end, false)

local KP = V.mkPage("Killer"); V.mkTab("Killer", 3, "Killer")
V.mkSec("Auto Attack", 1, KP)
V.mkTog("Auto Attack", 2, KP, function(v) C.Atk = v end, false)
V.mkSld("Attack Range", 5, 25, 12, 3, KP, function(v) C.AtkR = v end)
V.mkBtn("Basic Attack (Manual)", 4, KP, V.basicAtk)
V.mkSec("Hitbox", 5, KP)
V.mkTog("Hitbox Expand", 6, KP, function(v) C.Hitbox = v end, false)
V.mkSld("Hitbox Size", 5, 40, 15, 7, KP, function(v) C.HitboxS = v end)
V.mkSec("Utilities", 8, KP)
V.mkTog("Auto Hook", 9, KP, function(v) C.AutoHook = v end, false)
V.mkTog("Anti Blind", 10, KP, function(v) C.AntiBlind = v end, false)
V.mkTog("Infinite Lunge", 11, KP, function(v) C.InfLunge = v end, false)
V.mkTog("Fake Attack (Bait)", 12, KP, function(v) C.FakeAttack = v end, false)
V.mkTog("Beat Killer (Auto Kill)", 13, KP, function(v) C.BeatKiller = v end, false)
V.mkTog("Third Person", 14, KP, function(v) C.TP3 = v end, false)
V.mkTog("No Slowdown Extended", 15, KP, function(v) C.NoSlow = v end, false)
V.mkSec("Killer Remotes", 16, KP)
V.mkTog("Destroy Pallets (Auto)", 17, KP, function(v) C.DestroyPal = v end, false)
V.mkTog("Auto Kick Generator", 18, KP, function(v) C.AutoBreakGen = v end, false)
V.mkTog("Block All Vaults", 19, KP, function(v) C.BlockVaults = v end, false)
V.mkTog("Break All Pallets (TP)", 20, KP, function(v) C.BreakAllPal = v end, false)
V.mkSec("Advanced", 21, KP)
V.mkTog("Infinite Abyssal Burst (Abyss)", 22, KP, function(v) C.InfAbyss = v; if v then V.startAbyss() end end, false)
V.mkTog("Infinite Skill (Hidden)", 23, KP, function(v) C.InfHidden = v; if v then V.startHidden() end end, false)
V.mkTog("Infinite Frenzy (Jeff)", 24, KP, function(v) if v then V.startJeff() else V.stopJeff() end end, false)
V.mkTog("Infinite Lake Mist (Jason)", 25, KP, function(v) C.InfLake = v; if v then V.startSlasher() end end, false)
V.mkTog("Infinite Pursuit (Jason)", 26, KP, function(v) C.InfPursuit = v; if v then V.startSlasher() end end, false)
V.mkTog("Infinite Grab (Myers)", 27, KP, function(v) V.MyersD.Enabled = v; if V.MyersD.Btn then V.MyersD.Btn.Visible = v end end, false)
V.mkTog("Bypass Veil Cooldown", 28, KP, function(v) C.BypassVeilCD = v end, false)
V.mkBtn("Check GC Support", 29, KP, function() V.N("GC", V.hasGC() and "Supported ✓" or "Not Supported ✗") end)

local EP = V.mkPage("ESP"); V.mkTab("ESP", 4, "Tracker")
V.mkSec("Player ESP", 1, EP)
V.mkTog("Killer ESP (Merah)", 2, EP, function(v) C.ESPK = v end, false)
V.mkTog("Survivor ESP (Hijau)", 3, EP, function(v) C.ESPS = v end, false)
V.mkSec("Object ESP", 4, EP)
V.mkTog("Generator", 5, EP, function(v) C.ESPG = v end, false)
V.mkTog("Pallet", 6, EP, function(v) C.ESPP = v end, false)
V.mkTog("Window", 7, EP, function(v) C.ESPW = v end, false)
V.mkTog("Gate", 8, EP, function(v) C.ESPGate = v end, false)
V.mkTog("Hook", 9, EP, function(v) C.ESPH = v end, false)
V.mkSld("ESP Range", 100, 1000, 500, 10, EP, function(v) C.ESPD = v end)
V.mkBtn("Clear Highlights", 11, EP, V.clearESP)
V.mkSec("Radar", 12, EP)
V.mkTog("Radar Enabled", 13, EP, function(v) C.Radar = v end, false)
V.mkTog("Show Killer", 14, EP, function(v) C.RadK = v end, true)
V.mkTog("Show Survivor", 15, EP, function(v) C.RadS = v end, false)
V.mkTog("Show Generator", 16, EP, function(v) C.RadG = v end, false)
V.mkTog("Show Pallet", 17, EP, function(v) C.RadP = v end, false)
V.mkTog("Show Hook", 18, EP, function(v) C.RadH = v end, false)
V.mkTog("Show Gate", 19, EP, function(v) C.RadGate = v end, false)
V.mkTog("Show Window", 20, EP, function(v) C.RadW = v end, false)
V.mkSld("Radar Size", 100, 300, 150, 21, EP, function(v) C.RadSize = v end)
V.mkSld("Radar Range", 50, 500, 250, 22, EP, function(v) C.RadRange = v end)

local VP = V.mkPage("Visual"); V.mkTab("Visual", 5, "World")
V.mkSec("Lighting", 1, VP)
V.mkTog("Fullbright", 2, VP, function(v) C.FB = v end, false)
V.mkTog("No Fog", 3, VP, function(v) C.NoFog = v end, false)
local weathers = {"Default","Christmas (Snow)","Heavy Rain (Storm)","Autumn","Sakura","Sunset","Blood Moon","Toxic","Vaporwave","Midnight"}
local wIdx = 1
V.mkBtn("Weather: Default", 4, VP, function() wIdx = wIdx + 1; if wIdx > #weathers then wIdx = 1 end; V.setWeather(weathers[wIdx]); V.N("Weather", weathers[wIdx]) end)
V.mkSec("Day Set", 5, VP)
local daySets = {
    {name="Day", time=14, brightness=2, fog=100000},
    {name="Sunset", time=18, brightness=1.5, fog=100000},
    {name="Night", time=21, brightness=1, fog=100000},
    {name="Midnight", time=0, brightness=0.6, fog=100000},
}
local dayIdx = 1
local dayBtn
dayBtn = V.mkBtn("Day Set: Day", 6, VP, function()
    dayIdx = dayIdx + 1; if dayIdx > #daySets then dayIdx = 1 end
    local preset = daySets[dayIdx]
    pcall(function() V.L.ClockTime = preset.time; V.L.Brightness = preset.brightness; V.L.FogEnd = preset.fog; V.L.GlobalShadows = true end)
    dayBtn.Text = "  Day Set: " .. preset.name
    V.N("Day Set", preset.name)
end)
V.mkSec("Crosshair", 7, VP)
V.mkTog("Enable Crosshair", 8, VP, function(v) C.Cross = v; V.updCH() end, false)
local cst = V.mkBtn("Style: Dot", 9, VP, function() local o = {"Dot","Plus","X"}; local i = 1; for k, x in ipairs(o) do if x == C.CrossStyle then i = k; break end end; i = i + 1; if i > #o then i = 1 end; C.CrossStyle = o[i]; cst.Text = "  Style: "..C.CrossStyle; V.updCH() end)
V.mkSld("Cross Size", 1, 20, 3, 10, VP, function(v) C.CrossS = v; V.updCH() end)
V.mkSld("Cross Thickness", 1, 10, 4, 11, VP, function(v) C.CrossT = v; V.updCH() end)
V.mkSld("Cross Gap", 0, 30, 6, 12, VP, function(v) C.CrossG = v; V.updCH() end)
local cols = {{"White", Color3.new(1,1,1)}, {"Green", Color3.fromRGB(0,255,0)}, {"Cyan", Color3.fromRGB(0,255,255)}, {"Red", Color3.fromRGB(255,0,0)}, {"Yellow", Color3.fromRGB(255,255,0)}}
local ci = 1
V.mkBtn("Color: White", 13, VP, function() ci = ci + 1; if ci > #cols then ci = 1 end; C.CrossColor = cols[ci][2]; V.updCH() end)
V.mkSec("Camera", 14, VP)
V.mkTog("Camera FOV Override", 15, VP, function(v) C.CamFOV = v end, false)
V.mkSld("Camera FOV", 30, 140, 90, 16, VP, function(v) C.CamFOVV = v end)
V.mkTog("Shift Lock", 17, VP, function(v) C.Shift = v end, false)
V.mkTog("Infinity Zoom", 18, VP, function(v) C.InfZ = v; V.LP.CameraMaxZoomDistance = v and math.huge or 128; V.LP.CameraMinZoomDistance = v and 0 or 0.5 end, false)
V.mkSec("UI Displays", 19, VP)
V.mkTog("Anim Logger UI", 20, VP, function(v)
    C.ALEnabled = v
    if v then
        if V.AL.Main then V.AL.Main.Visible = true end
        for _, p in ipairs(V.P:GetPlayers()) do if p ~= V.LP and p.Character and V.isK(p) then V.alHook(p) end end
    else if V.AL.Main then V.AL.Main.Visible = false end end
end, false)

local AVP = V.mkPage("Avatar"); V.mkTab("Avatar", 6, "Player")
V.mkSec("Avatar Tools", 1, AVP)
V.mkBtn("Apply Korless Morph", 2, AVP, function() V.korlessApply(); V.N("Avatar", "Korless applied") end)
V.mkBtn("Reset Korless", 3, AVP, function() V.korlessReset(); V.N("Avatar", "Korless reset") end)
V.mkSec("Copy Avatar", 4, AVP)
V.mkBtn("Save Original Avatar", 5, AVP, function() V.saveAvatar(); V.N("Avatar", "Original saved") end)
V.mkBtn("Copy Nearest Player", 6, AVP, function()
    local c = V.LP.Character; if not c then return end
    local mr = c:FindFirstChild("HumanoidRootPart"); if not mr then return end
    local best, bd = nil, 100
    for _, p in ipairs(V.P:GetPlayers()) do
        if p ~= V.LP and p.Character then
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            if pr then local d = (pr.Position - mr.Position).Magnitude if d < bd then bd = d; best = p.Character end end
        end
    end
    if not best then V.N("Avatar", "No nearby player"); return end
    V.saveAvatar(); V.applyAvatar(best); V.N("Avatar", "Applied")
end)
V.mkBtn("Copy Killer Avatar", 7, AVP, function()
    for _, p in ipairs(V.P:GetPlayers()) do if p ~= V.LP and V.isK(p) and p.Character then V.saveAvatar(); V.applyAvatar(p.Character); V.N("Avatar", "Copied: "..p.Name); return end end
    V.N("Avatar", "No killer")
end)
V.mkBtn("Reset Avatar", 8, AVP, function() V.resetAvatar(); V.N("Avatar", "Reset") end)
V.mkSec("Emote", 9, AVP)
V.mkTog("Enable Emote", 10, AVP, function(v) C.EmoteEnabled = v; if v then V.playEmote() else V.stopEmote() end end, false)
local emoteList = {"Friday Night","WarCry","24 Hour Cinderella","Applause","Arm Swing","Backflip","California Girls","Christmas Spirit","Floating Rest","Ghoul","Griddy","Kyoufuu","OnePlays","Vulnerable"}
local eIdx = 1
V.mkBtn("Emote: Friday Night", 11, AVP, function() eIdx = eIdx + 1; if eIdx > #emoteList then eIdx = 1 end; C.SelectedEmote = emoteList[eIdx]; if C.EmoteEnabled then V.playEmote() end; V.N("Emote", emoteList[eIdx]) end)
V.mkSec("Misc", 12, AVP)
V.mkTog("Hide My Name", 13, AVP, function(v) V.hideName(v) end, false)
V.mkTog("Fling", 14, AVP, function(v) C.Fling = v end, false)
V.mkBtn("Fling Nearest", 15, AVP, V.flingNearest)
V.mkBtn("Fling All", 16, AVP, V.flingAll)
V.mkBtn("Spoof Level 999", 17, AVP, function() V.spoof(999, 0, 0) end)
V.mkBtn("Spoof Rich Stats", 18, AVP, function() V.spoof(999, 9999, 999999) end)

local TP = V.mkPage("Teleport"); V.mkTab("Teleport", 7, "Teleport")
V.mkSec("Quick TP", 1, TP)
V.mkBtn("TP to Nearest Generator", 2, TP, function() V.tpNearest("Generator") end)
V.mkBtn("TP to Nearest Exit", 3, TP, function() V.tpNearest("Exit") end)
V.mkBtn("TP to Nearest Window", 4, TP, function() V.tpNearest("Window") end)
V.mkBtn("TP to Nearest Pallet", 5, TP, function() V.tpNearest("Pallet") end)
V.mkBtn("TP to Nearest Hook", 6, TP, function() V.tpNearest("Hook") end)
V.mkBtn("TP to Finish Line", 7, TP, V.tpFinish)
V.mkSec("Settings", 8, TP)
V.mkSld("Height Offset", 0, 10, 3, 9, TP, function(v) C.TPOff = v end)
V.mkTog("Safe Teleport", 10, TP, function(v) C.TPSafe = v end, true)

PG2["Survivor"].Visible = true
TBtns["Survivor"].BackgroundColor3 = C_ACCENT
TBtns["Survivor"].TextColor3 = Color3.new(1,1,1)
close.MouseButton1Click:Connect(function() SG:Destroy() end)

local MinIcon = Instance.new("TextButton", SG)
MinIcon.Size = UDim2.new(0,48,0,48); MinIcon.Position = UDim2.new(0,18,0.5,-24)
MinIcon.BackgroundColor3 = C_BG; MinIcon.Text = "V"; MinIcon.TextColor3 = C_ACCENT
MinIcon.Font = Enum.Font.GothamBlack; MinIcon.TextSize = 24; MinIcon.BorderSizePixel = 0; MinIcon.Visible = false
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(0,24)
local isr = Instance.new("UIStroke", MinIcon); isr.Color = C_ACCENT; isr.Thickness = 2
local function drag(f, t)
    local dr, di, ds, sp
    local function upd(i) local d = i.Position - ds; f.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y) end
    t.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true; ds = i.Position; sp = f.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dr = false end end) end end)
    t.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
    V.U.InputChanged:Connect(function(i) if i == di and dr then upd(i) end end)
end
drag(MF, HD); drag(MinIcon, MinIcon)
mn.MouseButton1Click:Connect(function() MF.Visible = false; MinIcon.Visible = true end)
MinIcon.MouseButton1Click:Connect(function() MF.Visible = true; MinIcon.Visible = false end)

print("[ValzHub v6.0] FULL 69 features loaded.")
print("[ValzHub] Tabs: Survivor | Aim | Killer | ESP | Visual | Avatar | Teleport")
