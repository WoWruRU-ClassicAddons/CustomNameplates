local showPets = false;
local Enabled = true; 

local Players = {};
local Targets = {};
local Icons = {
	["DRUID"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Druid",
	["HUNTER"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Hunter",
	["MAGE"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Mage",
	["PALADIN"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Paladin",
	["PRIEST"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Priest",
	["ROGUE"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Rogue",
	["SHAMAN"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Shaman",
	["WARLOCK"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Warlock",
	["WARRIOR"] = "Interface\\AddOns\\CustomNameplates\\Class\\ClassIcon_Warrior",
}

local function IsNamePlateFrame(frame)
	local overlayRegion = frame:GetRegions()
	if not overlayRegion or overlayRegion:GetObjectType() ~= "Texture" or overlayRegion:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
		return false
	end
	return true
end

local function isPet(name)
	PetsRU = {"Рыжая полосатая кошка", "Серебристая полосатая кошка", "Бомбейская кошка", "Корниш-рекс",
		"Ястребиная сова", "Большая рогатая сова", "Макао", "Сенегальский попугай", "Черная королевская змейка",
		"Бурая змейка", "Багровая змейка", "Луговая собачка", "Тараканище", "Анконская курица", "Щенок ворга",
		"Паучок Дымной Паутины", "Механическая курица", "Птенец летучего хамелеона", "Зеленокрылый ара", "Гиацинтовый ара",
		"Маленький темный дракончик", "Маленький изумрудный дракончик", "Маленький багровый дракончик", "Сиамская кошка",
		"Пещерная крыса без сознания", "Механическая белка", "Крошечная ходячая бомба", "Крошка Дымок", "Механическая жаба", "Заяц-беляк"};
	for _, petName in pairs(PetsRU) do
		if name == petName then
			return true; 
		end
	end
	PetsENG = {"Orange Tabby", "Silver Tabby", "Bombay", "Cornish Rex", "Hawk Owl", "Great Horned Owl",
		"Cockatiel", "Senegal", "Black Kingsnake", "Brown Snake", "Crimson Snake", "Prairie Dog", "Cockroach",
		"Ancona Chicken", "Worg Pup", "Smolderweb Hatchling", "Mechanical Chicken", "Sprite Darter", "Green Wing Macaw",
		"Hyacinth Macaw", "Tiny Black Whelpling", "Tiny Emerald Whelpling", "Tiny Crimson Whelpling", "Siamese",
		"Unconscious Dig Rat", "Mechanical Squirrel", "Pet Bombling", "Lil' Smokey", "Lifelike Mechanical Toad"}
	for _, petName in pairs(PetsENG) do
		if name == petName then
			return true; 
		end
	end
	return false;
end

local function fillPlayerDB(name)
	if Targets[name] == nil then
		TargetByName(name, true);
		table.insert(Targets, name);
		Targets[name] = "ok"
		if UnitIsPlayer("target") then
			local _,class = UnitClass("target");
			table.insert(Players, name)
			Players[name] = {["class"] = class};
		end		
	end
end

function CustomNameplates_OnUpdate()
	
	local frames = { WorldFrame:GetChildren() };
	for _, namePlate in ipairs(frames) do
		if IsNamePlateFrame(namePlate) then
			local HealthBar = namePlate:GetChildren();
			local Border, Glow, Name, Level = namePlate:GetRegions();
			
			HealthBar:SetStatusBarTexture("Interface\\AddOns\\CustomNameplates\\barSmall");
			HealthBar:ClearAllPoints();
			HealthBar:SetPoint("CENTER", namePlate, "CENTER", 0, -10);
			HealthBar:SetWidth(100);
			HealthBar:SetHeight(4);
			HealthBar:SetAlpha(0.85);
			
			if HealthBar.bg == nil then
				HealthBar.bg = HealthBar:CreateTexture(nil, "BORDER")
				HealthBar.bg:SetTexture(0,0,0,0.85)
				HealthBar.bg:ClearAllPoints();
				HealthBar.bg:SetPoint("CENTER", namePlate, "CENTER", 0, -10);
				HealthBar.bg:SetWidth(HealthBar:GetWidth() + 1.5);
				HealthBar.bg:SetHeight(HealthBar:GetHeight() + 1.5);
			end
			
			if namePlate.classIcon == nil then
				namePlate.classIcon = namePlate:CreateTexture(nil, "BORDER")
				namePlate.classIcon:SetTexture(0,0,0,0)
				namePlate.classIcon:ClearAllPoints();
				namePlate.classIcon:SetPoint("RIGHT", Name, "LEFT", -3, -1);
				namePlate.classIcon:SetWidth(12);
				namePlate.classIcon:SetHeight(12);
			end		
			
			if namePlate.classIconBorder == nil then
				namePlate.classIconBorder = namePlate:CreateTexture(nil, "BACKGROUND")
				namePlate.classIconBorder:SetTexture(0,0,0,0.9)
				namePlate.classIconBorder:SetPoint("CENTER", namePlate.classIcon, "CENTER", 0, 0);
				namePlate.classIconBorder:SetWidth(13.5);
				namePlate.classIconBorder:SetHeight(13.5);
			end		
			namePlate.classIconBorder:Hide();
			-- namePlate.classIconBorder:SetTexture(0,0,0,0)
			namePlate.classIcon:SetTexture(0,0,0,0);
			Border:Hide();
			Glow:Hide();
			
			--Name:SetFontObject(GameFontNormal);
			Name:SetFontObject(GameFontNormal);
			Name:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",13);
			Name:SetPoint("BOTTOM", namePlate, "CENTER", 0, -5);
			
			Level:SetFontObject(GameFontNormal);
			Level:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Helvetica_Neue_LT_Com_77_Bold_Condensed.ttf",11); --
			Level:SetPoint("TOPLEFT", Name, "RIGHT", 2, 3.5);
			
			HealthBar:Show();
			Name:Show();
			Level:Show();
			
			if showPets ~= true then
				if isPet(Name:GetText()) then
					HealthBar:Hide();
					Name:Hide();
					Level:Hide();
				end
			end
			
			local red, green, blue, _ = Name:GetTextColor()
			-- Print(red.." "..green.." "..blue)
			if red > 0.99 and green == 0 and blue == 0 then
				Name:SetTextColor(1,0.4,0.2,0.85);
			elseif red > 0.99 and green > 0.81 and green < 0.82 and blue == 0 then
				Name:SetTextColor(1,1,1,0.85);
			end
			
			local red, green, blue, _ = HealthBar:GetStatusBarColor()
			if blue > 0.99 and red == 0 and green == 0 then
				HealthBar:SetStatusBarColor(0.2,0.6,1,0.85);
			elseif red == 0 and green > 0.99 and blue == 0 then
				HealthBar:SetStatusBarColor(0.6,1,0,0.85);
			end
			
			local red, green, blue, _ = Level:GetTextColor()
			
			if red > 0.99 and green == 0 and blue == 0 then
				Level:SetTextColor(1,0.4,0.2,0.85);
			elseif red > 0.99 and green > 0.81 and green < 0.82 and blue == 0 then
				Level:SetTextColor(1,1,1,0.85);
			end
			
			local name = Name:GetText();
			if  Players[name] == nil and UnitName("target") == nil and string.find(name, "%s") == nil and string.len(name) <= 12 and Targets[name] == nil then
				fillPlayerDB(name);
				ClearTarget();
			end
			
			if  Players[name] ~= nil and namePlate.classIcon:GetTexture() == "Solid Texture" and string.find(namePlate.classIcon:GetTexture(), "Interface") == nil then
				namePlate.classIcon:SetTexture(Icons[Players[name]["class"]]);
				namePlate.classIcon:SetTexCoord(.078, .92, .079, .937)
				namePlate.classIcon:SetAlpha(0.9);
				namePlate.classIconBorder:Show();
			end
		end
	end  
end

local f = CreateFrame("frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:SetScript("OnEvent", function()
	if (Enabled) then
		ShowNameplates();
		ShowFriendNameplates();
	else
		HideNameplates();
		HideFriendNameplates();
	end
end)
f:SetScript("OnUpdate",CustomNameplates_OnUpdate)
