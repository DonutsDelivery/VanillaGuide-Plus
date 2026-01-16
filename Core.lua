local L = TURTLEGUIDE_LOCALE
TURTLEGUIDE_LOCALE = nil

TurtleGuide = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0", "AceEvent-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
local D = AceLibrary("Dewdrop-2.0")
local DF = AceLibrary("Deformat-2.0")
local T = AceLibrary("Tablet-2.0")
local gratuity = AceLibrary("Gratuity-2.0")

TurtleGuide.guides = {}
TurtleGuide.guidelist = {}
TurtleGuide.nextzones = {}
TurtleGuide.Locale = L
TurtleGuide.myfaction = UnitFactionGroup("player")

-- Race-based route definitions
TurtleGuide.routes = {}

TurtleGuide.icons = setmetatable({
	ACCEPT = "Interface\\GossipFrame\\AvailableQuestIcon",
	COMPLETE = "Interface\\Icons\\Ability_DualWield",
	TURNIN = "Interface\\GossipFrame\\ActiveQuestIcon",
	KILL = "Interface\\Icons\\Ability_Creature_Cursed_02",
	RUN = "Interface\\Icons\\Ability_Tracking",
	MAP = "Interface\\Icons\\Ability_Spy",
	FLY = "Interface\\Icons\\Ability_Rogue_Sprint",
	SETHEARTH = "Interface\\AddOns\\TurtleGuide\\media\\resting.tga",
	HEARTH = "Interface\\Icons\\INV_Misc_Rune_01",
	NOTE = "Interface\\Icons\\INV_Misc_Note_01",
	GRIND = "Interface\\Icons\\INV_Stone_GrindingStone_05",
	USE = "Interface\\Icons\\INV_Misc_Bag_08",
	BUY = "Interface\\Icons\\INV_Misc_Coin_01",
	BOAT = "Interface\\Icons\\Ability_Druid_AquaticForm",
	GETFLIGHTPOINT = "Interface\\Icons\\Ability_Hunter_EagleEye",
	PET = "Interface\\Icons\\Ability_Hunter_BeastCall02",
	DIE = "Interface\\AddOns\\TurtleGuide\\media\\dead.tga",
	TRAIN = "Interface\\GossipFrame\\TrainerGossipIcon",
}, {__index = function() return "Interface\\Icons\\INV_Misc_QuestionMark" end})

local defaults = {
	debug = false,
	hearth = UNKNOWN,
	turnins = {},
	cachedturnins = {},
	trackquests = true,
	completion = {},
	currentguide = "No Guide",
	currentroute = nil,
	routeselected = false,
	mapquestgivers = true,
	mapnotecoords = true,
	showstatusframe = true,
	showuseitem = true,
	showuseitemcomplete = true,
	skipfollowups = true,
	petskills = {},
	completedquests = {},
}

local options = {
	type = "group",
	handler = TurtleGuide,
	args = {
		TrackQuests = {
			name = "Auto Track",
			desc = L["Automatically track quests"],
			type = "toggle",
			get = function() return TurtleGuide.db.char.trackquests end,
			set = function(newValue)
				TurtleGuide.db.char.trackquests = newValue
				if TurtleGuide.optionsframe then
					TurtleGuide.optionsframe.qtrack:SetChecked(TurtleGuide.db.char.trackquests)
				end
			end,
			order = 1,
		},
		SkipFollowUps = {
			name = "Auto Skip Followups",
			desc = L["Automatically skip suggested follow-ups"],
			type = "toggle",
			get = function() return TurtleGuide.db.char.skipfollowups end,
			set = function(newValue)
				TurtleGuide.db.char.skipfollowups = newValue
				if TurtleGuide.optionsframe then
					TurtleGuide.optionsframe.qskipfollowups:SetChecked(TurtleGuide.db.char.skipfollowups)
				end
			end,
			order = 2,
		},
		StatusFrame = {
			name = "Toggle Status",
			desc = "Show/Hide Status Frame",
			type = "toggle",
			get = function() return TurtleGuide.statusframe:IsVisible() end,
			set = "OnClick",
			order = 3,
		},
		SelectRoute = {
			name = "Select Route",
			desc = "Choose a different leveling route",
			type = "execute",
			func = function() TurtleGuide:ShowRouteSelector() end,
			order = 4,
		},
	},
}

---------
-- FuBar
---------
TurtleGuide.hasIcon = [[Interface\QuestFrame\UI-QuestLog-BookIcon]]
TurtleGuide.title = "TurtleGuide"
TurtleGuide.defaultMinimapPosition = 215
TurtleGuide.defaultPosition = "CENTER"
TurtleGuide.cannotDetachTooltip = true
TurtleGuide.tooltipHiddenWhenEmpty = false
TurtleGuide.hideWithoutStandby = true
TurtleGuide.independentProfile = true

function TurtleGuide:OnInitialize()
	self:RegisterDB("TurtleGuideDB")
	self:RegisterDefaults("char", defaults)
	self:RegisterChatCommand({"/tg", "/turtleguide"}, options)
	self.OnMenuRequest = options
	if not FuBar then
		self.OnMenuRequest.args.hide.guiName = L["Hide minimap icon"]
		self.OnMenuRequest.args.hide.desc = L["Hide minimap icon"]
	end
	self.cachedturnins = self.db.char.cachedturnins
	if self.myfaction == nil then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
	self:PositionStatusFrame()
	self:CreateConfigPanel()
end

function TurtleGuide:OnEnable()
	local _, title = GetAddOnInfo("TurtleGuide")
	local author, version = GetAddOnMetadata("TurtleGuide", "Author"), GetAddOnMetadata("TurtleGuide", "Version")

	if self.db.char.debug then self:SetDebugging(true)
	else self:SetDebugging(false) end

	if self.myfaction == nil then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		self:InitializeRoute()
	end
end

function TurtleGuide:InitializeRoute()
	-- If no route selected yet, show race selector on first login
	if not self.db.char.routeselected then
		-- Auto-detect race and suggest route
		local _, race = UnitRace("player")
		if race and self.routes[race] then
			self.db.char.currentroute = race
			self.db.char.routeselected = true
			-- Load the first guide in the route
			local route = self.routes[race]
			if route and route[1] and route[1].guide then
				self.db.char.currentguide = route[1].guide
			end
			self:Print(string.format(L["You have been assigned the %s leveling route."], race))
		else
			-- Fallback to default start guides
			local startguides = {
				Orc = "Durotar (1-12)", Troll = "Durotar (1-12)",
				Tauren = "Mulgore (1-12)", Undead = "Tirisfal Glades (1-12)",
				Dwarf = "Dun Morogh (1-11)", Gnome = "Dun Morogh (1-11)",
				Human = "Elwynn Forest (1-12)", NightElf = "Teldrassil (1-12)"
			}
			self.db.char.currentguide = startguides[race] or self.guidelist[1]
			self.db.char.routeselected = true
		end
	end

	self.db.char.currentguide = self.db.char.currentguide or self.guidelist[1]
	self:LoadGuide(self.db.char.currentguide)
	self.initializeDone = true
	for _, event in pairs(self.TrackEvents) do self:RegisterEvent(event) end
	self:RegisterEvent("QUEST_COMPLETE", "UpdateStatusFrame")
	self:RegisterEvent("QUEST_DETAIL", "UpdateStatusFrame")
	self.TrackEvents = nil
	self:UpdateStatusFrame()
	self.enableDone = true
end

function TurtleGuide:OnDisable()
	self:UnregisterAllEvents()
end

function TurtleGuide:OnTooltipUpdate()
	local hint = "\nClick to show/hide the Status\nRight-click for Options"
	T:SetHint(hint)
end

function TurtleGuide:OnTextUpdate()
	self:SetText("TurtleGuide")
end

function TurtleGuide:OnClick()
	if TurtleGuide.statusframe:IsVisible() then
		HideUIPanel(TurtleGuide.statusframe)
	else
		ShowUIPanel(TurtleGuide.statusframe)
	end
end

function TurtleGuide:PLAYER_ENTERING_WORLD()
	self.myfaction = UnitFactionGroup("player")
	-- load static guides
	for i, t in ipairs(self.deferguides) do
		local name, nextzone, faction, sequencefunc = t[1], t[2], t[3], t[4]
		if faction == self.myfaction or faction == "Both" then
			self.guides[name] = sequencefunc
			self.nextzones[name] = nextzone
			table.insert(self.guidelist, name)
		end
	end
	self.deferguides = {}
	-- deferred Initialize (VARIABLES_LOADED)
	if not self.initializeDone then
		self:InitializeRoute()
	end
	-- deferred Enable (PLAYER_LOGIN)
	if not self.enableDone then
		for _, event in pairs(self.TrackEvents) do self:RegisterEvent(event) end
		self:RegisterEvent("QUEST_COMPLETE", "UpdateStatusFrame")
		self:RegisterEvent("QUEST_DETAIL", "UpdateStatusFrame")
		self.TrackEvents = nil
		self:UpdateStatusFrame()
	end
	self.initializeDone = true
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end


function TurtleGuide:RegisterGuide(name, nextzone, faction, sequencefunc)
	if self.myfaction == nil then
		self.deferguides = self.deferguides or {}
		table.insert(self.deferguides, {name, nextzone, faction, sequencefunc})
	else
		if faction ~= "Both" then if faction ~= self.myfaction then return end end
		self.guides[name] = sequencefunc
		self.nextzones[name] = nextzone
		table.insert(self.guidelist, name)
	end
end

-- Register a race-based route
function TurtleGuide:RegisterRoute(race, route)
	self.routes[race] = route
end


function TurtleGuide:LoadNextGuide()
	self:LoadGuide(self.nextzones[self.db.char.currentguide] or "No Guide", true)
	self:UpdateGuideListPanel()
	return true
end


function TurtleGuide:GetQuestLogIndexByName(name)
	name = name or self.quests[self.current]
	name = string.gsub(name, L.PART_GSUB, "")
	for i = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader = GetQuestLogTitle(i)
		title = string.gsub(title, "%[[0-9%+%-]+]%s", "")
		if not isHeader and title == name then return i end
	end
end

function TurtleGuide:GetQuestDetails(name)
	if not name then return end
	local i = self:GetQuestLogIndexByName(name)
	if not i or i < 1 then return end
	local _, _, _, _, _, isComplete = GetQuestLogTitle(i)
	local complete = i and isComplete == 1

	return i, complete
end


function TurtleGuide:FindBagSlot(itemid)
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag, slot)
			if item and string.find(item, "item:" .. itemid) then return bag, slot end
		end
	end
	return false
end


function TurtleGuide:GetObjectiveInfo(i)
	local i = i or self.current
	if not self.actions[i] then return end

	return self.actions[i], string.gsub(self.quests[i], "@.*@", ""), self.quests[i] -- Action, display name, full name
end


function TurtleGuide:GetObjectiveStatus(i)
	local i = i or self.current
	if not self.actions[i] then return end

	return self.turnedin[self.quests[i]], self:GetQuestDetails(self.quests[i]) -- turnedin, logi, complete
end


function TurtleGuide:SetTurnedIn(i, value, noupdate)
	if not i then
		i = self.current
		value = true
	end

	if value then value = true else value = nil end -- Cleanup to minimize savedvar data

	self.turnedin[self.quests[i]] = value
	self:Debug(string.format("Set turned in %q = %s", self.quests[i], tostring(value)))
	if not noupdate then self:UpdateStatusFrame()
	else self.updatedelay = i end
end


function TurtleGuide:CompleteQuest(name, noupdate)
	if not self.current then
		self:Debug(string.format("Cannot complete %q, no guide loaded", name))
		return
	end

	local action, quest
	for i in ipairs(self.actions) do
		action, quest = self:GetObjectiveInfo(i)
		self:Debug(string.format("Action %q Quest %q", action, quest))
		if action == "TURNIN" and not self:GetObjectiveStatus(i) and name == string.gsub(quest, L.PART_GSUB, "") then
			self:Debug(string.format("Saving quest turnin %q", quest))
			return self:SetTurnedIn(i, true, noupdate)
		end
	end
	self:Debug(string.format("Quest %q not found!", name))
end


---------------------------------
--      Route Functions        --
---------------------------------

-- Show route selection UI
function TurtleGuide:ShowRouteSelector()
	if not self.routeSelectorFrame then
		self:CreateRouteSelectorFrame()
	end
	self.routeSelectorFrame:Show()
end

function TurtleGuide:CreateRouteSelectorFrame()
	local f = CreateFrame("Frame", "TurtleGuideRouteSelectorFrame", UIParent)
	f:SetWidth(300)
	f:SetHeight(400)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = {left = 11, right = 12, top = 12, bottom = 11}
	})
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() this:StartMoving() end)
	f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
	f:SetFrameStrata("DIALOG")

	local title = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP", f, "TOP", 0, -20)
	title:SetText(L["Select Your Race"])

	local desc = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	desc:SetPoint("TOP", title, "BOTTOM", 0, -10)
	desc:SetWidth(260)
	desc:SetText(L["Choose a leveling route based on your race:"])

	-- Create race buttons
	local races = {}
	if self.myfaction == "Alliance" then
		races = {"Human", "Dwarf", "NightElf", "Gnome"}
	else
		races = {"Orc", "Troll", "Tauren", "Undead"}
	end

	local lastButton
	for i, race in ipairs(races) do
		local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		btn:SetWidth(200)
		btn:SetHeight(30)
		if lastButton then
			btn:SetPoint("TOP", lastButton, "BOTTOM", 0, -10)
		else
			btn:SetPoint("TOP", desc, "BOTTOM", 0, -20)
		end
		btn:SetText(race)
		btn:SetScript("OnClick", function()
			TurtleGuide:SelectRoute(race)
			f:Hide()
		end)
		lastButton = btn
	end

	-- Close button
	local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)

	self.routeSelectorFrame = f
	f:Hide()
end

function TurtleGuide:SelectRoute(race)
	self.db.char.currentroute = race
	self.db.char.routeselected = true

	-- Load the first guide in the route
	local route = self.routes[race]
	if route and route[1] and route[1].guide then
		self.db.char.currentguide = route[1].guide
		self:LoadGuide(self.db.char.currentguide)
		self:Print(string.format(L["You have been assigned the %s leveling route."], race))
	end

	self:UpdateStatusFrame()
end

-- Get the next guide in the current route based on player level
function TurtleGuide:GetNextRouteGuide()
	local route = self.routes[self.db.char.currentroute]
	if not route then return nil end

	local playerLevel = UnitLevel("player")
	for i, zone in ipairs(route) do
		local minLevel = tonumber(string.match(zone.levels, "(%d+)%-")) or 1
		local maxLevel = tonumber(string.match(zone.levels, "%-(%d+)")) or 60
		if playerLevel >= minLevel and playerLevel <= maxLevel + 2 then
			return zone.guide
		end
	end
	return nil
end


---------------------------------
--      Utility Functions      --
---------------------------------

function TurtleGuide.select(index, ...)
	assert(tonumber(index) or index == "#", "Invalid argument #1 to select(). Usage: select(\"#\"|int,...)")
	if index == "#" then
		return tonumber(arg.n) or 0
	end
	for i = 1, index - 1 do
		table.remove(arg, 1)
	end
	return unpack(arg)
end

function TurtleGuide.join(delimiter, list)
	assert(type(delimiter) == "string" and type(list) == "table", "Invalid arguments to join(). Usage: string.join(delimiter, list)")
	local len = getn(list)
	if len == 0 then
		return ""
	end
	local s = list[1]
	for i = 2, len do
		s = string.format("%s%s%s", s, delimiter, list[i])
	end
	return s
end

function TurtleGuide.trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function TurtleGuide.split(...)
	assert(arg.n > 0 and type(arg[1]) == "string", "Invalid arguments to split(). Usage: string.split([separator], subject)")
	local sep, s = arg[1], arg[2]
	if s == nil then
		s, sep = sep, ":"
	end
	local fields = {}
	local pattern = string.format("([^%s]+)", sep)
	string.gsub(s, pattern, function(c) fields[table.getn(fields) + 1] = c end)
	return fields
end

function TurtleGuide.modf(f)
	if f > 0 then
		return math.floor(f), math.mod(f, 1)
	end
	return math.ceil(f), math.mod(f, 1)
end

function TurtleGuide.GetItemCount(itemID)
	local itemInfoTexture = TurtleGuide.select(9, GetItemInfo(itemID))
	if itemInfoTexture == nil then return 0 end
	local totalItemCount = 0
	for i = 0, NUM_BAG_FRAMES do
		local numSlots = GetContainerNumSlots(i)
		if numSlots > 0 then
			for k = 1, numSlots do
				local itemTexture, itemCount = GetContainerItemInfo(i, k)
				if itemInfoTexture == itemTexture then
					totalItemCount = totalItemCount + itemCount
				end
			end
		end
	end
	return totalItemCount
end

function TurtleGuide.ColorGradient(perc)
	if perc >= 1 then return 0, 1, 0
	elseif perc <= 0 then return 1, 0, 0 end

	local segment, relperc = TurtleGuide.modf(perc * 2)
	local r1, g1, b1, r2, g2, b2 = TurtleGuide.select((segment * 3) + 1, 1, 0, 0, 1, 0.82, 0, 0, 1, 0)
	return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

function TurtleGuide.GetQuadrant(frame)
	local x, y = frame:GetCenter()
	if not x or not y then return "BOTTOMLEFT", "BOTTOM", "LEFT" end
	local hhalf = (x > UIParent:GetWidth() / 2) and "RIGHT" or "LEFT"
	local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
	return vhalf .. hhalf, vhalf, hhalf
end

function TurtleGuide.GetUIParentAnchor(frame)
	local w, h, x, y = UIParent:GetWidth(), UIParent:GetHeight(), frame:GetCenter()
	local hhalf, vhalf = (x > w / 2) and "RIGHT" or "LEFT", (y > h / 2) and "TOP" or "BOTTOM"
	local dx = hhalf == "RIGHT" and math.floor(frame:GetRight() + 0.5) - w or math.floor(frame:GetLeft() + 0.5)
	local dy = vhalf == "TOP" and math.floor(frame:GetTop() + 0.5) - h or math.floor(frame:GetBottom() + 0.5)
	return vhalf .. hhalf, dx, dy
end

function TurtleGuide:DumpLoc()
	if IsShiftKeyDown() then
		if not self.db.global.savedpoints then self:Print("No saved points")
		else for t in string.gfind(self.db.global.savedpoints, "([^\n]+)") do self:Print(t) end end
	elseif IsControlKeyDown() then
		self.db.global.savedpoints = nil
		self:Print("Saved points cleared")
	else
		local _, _, x, y = Astrolabe:GetCurrentPlayerPosition()
		local s = string.format("%s, %s, (%.2f, %.2f) -- %s %s", GetZoneText(), GetSubZoneText(), x * 100, y * 100, self:GetObjectiveInfo())
		self.db.global.savedpoints = (self.db.global.savedpoints or "") .. s .. "\n"
		self:Print(s)
	end
end
