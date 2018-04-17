local last_update = GetTime()
local Players = {}

local function IsNamePlateFrame(f)
	if f:GetName() or not f:GetRegions() then return end
	
	local texture = f:GetRegions():GetTexture()
	if texture == 'Interface\\Tooltips\\Nameplate-Border' then
		return true
	end
	return false
end

local function fillPlayerDB(name)
	if Players[name] then return end
	TargetByName(name, true)
	if not UnitIsPlayer('target') then return end
	
	local _, class = UnitClass('target')
	table.insert(Players, name)
	Players[name] = class
end

function CustomNameplates_OnUpdate()
	if GetTime() - last_update < .1 then return end -- update nameplates every 0.1 seconds
	last_update = GetTime()
	
	local frames = { WorldFrame:GetChildren() }
	for _, namePlate in pairs(frames) do
		if not namePlate.frame and IsNamePlateFrame(namePlate) then
			local Border, Glow, Name, Level = namePlate:GetRegions()
			local HealthBar = namePlate:GetChildren()
			
			HealthBar:SetStatusBarTexture('Interface\\AddOns\\CustomNameplates\\barSmall')
			HealthBar:ClearAllPoints()
			HealthBar:SetPoint('CENTER', namePlate, 'CENTER', 0, -10)
			HealthBar:SetWidth(100)
			HealthBar:SetHeight(4)
			HealthBar:SetAlpha(.85)
			
			if not HealthBar.bg then
				HealthBar.bg = HealthBar:CreateTexture(nil, 'BORDER')
				HealthBar.bg:SetTexture(0, 0, 0, .85)
				HealthBar.bg:ClearAllPoints()
				HealthBar.bg:SetPoint('CENTER', namePlate, 'CENTER', 0, -10)
				HealthBar.bg:SetWidth(HealthBar:GetWidth() + 1.5)
				HealthBar.bg:SetHeight(HealthBar:GetHeight() + 1.5)
			end
			
			if not namePlate.classIcon then
				namePlate.classIcon = namePlate:CreateTexture(nil, 'BORDER')
				namePlate.classIcon:SetTexture(0, 0, 0, 0)
				namePlate.classIcon:ClearAllPoints()
				namePlate.classIcon:SetPoint('RIGHT', Name, 'LEFT', -3, -1)
				namePlate.classIcon:SetWidth(12)
				namePlate.classIcon:SetHeight(12)
			end		
			
			if not namePlate.classIconBorder then
				namePlate.classIconBorder = namePlate:CreateTexture(nil, 'BACKGROUND')
				namePlate.classIconBorder:SetTexture(0, 0, 0, .9)
				namePlate.classIconBorder:SetPoint('CENTER', namePlate.classIcon, 'CENTER', 0, 0)
				namePlate.classIconBorder:SetWidth(13.5)
				namePlate.classIconBorder:SetHeight(13.5)
			end		
			namePlate.classIconBorder:Hide()
			-- namePlate.classIconBorder:SetTexture(0, 0, 0, 0)
			namePlate.classIcon:SetTexture(0, 0, 0, 0)
			Border:Hide()
			Glow:Hide()
			
			Name:SetFontObject(GameFontNormal)
			Name:SetFont('Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf', 13)
			Name:SetPoint('BOTTOM', namePlate, 'CENTER', 0, -5)
			
			Level:SetFontObject(GameFontNormal)
			Level:SetFont('Interface\\AddOns\\CustomNameplates\\Fonts\\Helvetica_Neue_LT_Com_77_Bold_Condensed.ttf', 11)
			Level:SetPoint('TOPLEFT', Name, 'RIGHT', 2, 3.5)
			
			HealthBar:Show()
			Name:Show()
			Level:Show()
			
			local red, green, blue = Name:GetTextColor()
			if red > .99 and green == 0 and blue == 0 then
				Name:SetTextColor(1, .4, .2, .85)
				Level:SetTextColor(1, .4, .2, .85)
			elseif red > .99 and green > .81 and green < .82 and blue == 0 then
				Name:SetTextColor(1, 1, 1, .85)
				Level:SetTextColor(1, 1, 1, .85)
			end
			
			local red, green, blue = HealthBar:GetStatusBarColor()
			if blue > .99 and red == 0 and green == 0 then
				HealthBar:SetStatusBarColor(.2, .6, 1, .85)
			elseif red == 0 and green > .99 and blue == 0 then
				HealthBar:SetStatusBarColor(.6, 1, 0, .85)
			end
			
			local name = Name:GetText()
			if string.len(name) <= 12 and not (Players[name] or UnitName('target') or string.find(name, '%s')) then
				fillPlayerDB(name)
				ClearTarget()
			end
			if Players[name] and namePlate.classIcon:GetTexture() == 'Solid Texture' and not string.find(namePlate.classIcon:GetTexture(), 'Interface') then
				namePlate.classIcon:SetTexture('Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_'..Players[name])
				namePlate.classIcon:SetTexCoord(.078, .92, .079, .937)
				namePlate.classIcon:SetAlpha(.9)
				namePlate.classIconBorder:Show()
			end
		end
	end  
end

local f = CreateFrame('frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', UpdateNameplates) -- Blizzard function for update nameplates
f:SetScript('OnUpdate', CustomNameplates_OnUpdate)
