
local TurtleGuide = TurtleGuide
local ww = WidgetWarlock

local title

local NUMROWS, COLWIDTH = 16, 210
local ROWHEIGHT = 305 / NUMROWS
local TOTALROWS = NUMROWS * 3

local offset = 0
local rows = {}
local displayList = {}
local levelFilterOn = false

local function HideTooltip()
	if GameTooltip:IsOwned(this) then
		GameTooltip:Hide()
	end
end

local function ShowTooltip()
	local f = this
	GameTooltip:SetOwner(f, "ANCHOR_RIGHT")

	local lines = {}
	table.insert(lines, "Left-click: Load this guide")
	table.insert(lines, "Right-click: Branch to this guide")

	if TurtleGuide.db.char.completion[f.guide] == 1 then
		table.insert(lines, "Shift-click: Reset progress")
	end

	if TurtleGuide.db.char.isbranching and TurtleGuide.db.char.branchsavedguide == f.guide then
		table.insert(lines, "|cff00ff00(Your saved main route)|r")
	end

	GameTooltip:SetText(table.concat(lines, "\n"), nil, nil, nil, nil, true)
end

local function OnClick()
	local f = this
	local btn = arg1
	if IsShiftKeyDown() then
		TurtleGuide.db.char.completion[f.guide] = nil
		TurtleGuide.db.char.turnins[f.guide] = {}
		TurtleGuide:UpdateGuideListPanel()
		GameTooltip:Hide()
	elseif btn == "RightButton" then
		local text = f.guide
		if text then
			TurtleGuide:BranchToGuide(text)
			TurtleGuide:UpdateGuideListPanel()
		end
	else
		local text = f.guide
		if not text then f:SetChecked(false)
		else
			TurtleGuide:LoadGuide(text)
			TurtleGuide:UpdateStatusFrame()
			TurtleGuide:UpdateGuideListPanel()
		end
	end
end

local frame = CreateFrame("Frame", "TurtleGuideGuideList", TurtleGuide.statusframe)
TurtleGuide.guidelistframe = frame
frame:SetFrameStrata("DIALOG")
frame:SetWidth(660)
frame:SetHeight(320 + 28)
frame:SetPoint("TOPRIGHT", TurtleGuide.statusframe, "BOTTOMRIGHT")
frame:SetBackdrop(ww.TooltipBorderBG)
frame:SetBackdropColor(0.09, 0.09, 0.19, 1)
frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.5)
frame:Hide()

local closebutton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closebutton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
frame.closebutton = closebutton

local title = ww.SummonFontString(frame, nil, "SubZoneTextFont", nil, "BOTTOM", frame, "TOP")
local fontname, fontheight, fontflags = title:GetFont()
title:SetFont(fontname, 18, fontflags)
title:SetText("Guide List")
frame.title = title

-- Level filter checkbox
local filterCheck = ww.SummonCheckBox(18, frame, "TOPLEFT", 15, -6)
local filterLabel = ww.SummonFontString(filterCheck, "OVERLAY", "GameFontNormalSmall", "Level filter (+/-5)", "LEFT", filterCheck, "RIGHT", 2, 0)
filterCheck:SetScript("OnClick", function()
	levelFilterOn = not levelFilterOn
	filterCheck:SetChecked(levelFilterOn)
	offset = 0
	TurtleGuide:UpdateGuideListPanel()
end)

-- Return to Main button
local returnBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
returnBtn:SetWidth(120)
returnBtn:SetHeight(20)
returnBtn:SetPoint("LEFT", filterCheck, "RIGHT", 120, 0)
returnBtn:SetText("Return to Main")
returnBtn:SetScript("OnClick", function()
	TurtleGuide:ReturnFromBranch()
	TurtleGuide:UpdateGuideListPanel()
end)
frame.returnBtn = returnBtn

-- Fill in the frame with guide CheckButtons (3-column layout)
for i = 1, TOTALROWS do
	local anchor, point = rows[i - 1], "BOTTOMLEFT"
	if i == 1 then anchor, point = frame, "TOPLEFT"
	elseif i == (NUMROWS + 1) then anchor, point = rows[1], "TOPRIGHT"
	elseif i == (NUMROWS * 2 + 1) then anchor, point = rows[NUMROWS + 1], "TOPRIGHT" end

	local row = CreateFrame("CheckButton", nil, frame)
	if i == 1 then row:SetPoint("TOPLEFT", anchor, point, 15, -30)
	else row:SetPoint("TOPLEFT", anchor, point) end
	row:SetHeight(ROWHEIGHT)
	row:SetWidth(COLWIDTH)

	local highlight = ww.SummonTexture(row, nil, nil, nil, "Interface\\HelpFrame\\HelpFrameButton-Highlight")
	highlight:SetTexCoord(0, 1, 0, 0.578125)
	highlight:SetAllPoints()
	highlight:SetAlpha(0.5)
	row:SetHighlightTexture(highlight)
	row:SetCheckedTexture(highlight)

	local text = ww.SummonFontString(row, nil, "GameFontWhite", nil, "LEFT", 6, 0)
	local fn, fh, ff = title:GetFont()
	text:SetFont(fn, 11, ff)
	text:SetTextColor(.79, .79, .79, 1)

	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row:SetScript("OnClick", OnClick)
	row:SetScript("OnEnter", ShowTooltip)
	row:SetScript("OnLeave", HideTooltip)

	row.text = text
	rows[i] = row
end

frame:SetScript("OnShow", function()
	offset = 0
	local quad, vhalf, hhalf = TurtleGuide.GetQuadrant(TurtleGuide.statusframe)
	local anchpoint = (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
	this:ClearAllPoints()
	this:SetPoint(quad, TurtleGuide.statusframe, anchpoint)
	TurtleGuide:UpdateGuideListPanel()
	this:SetAlpha(0)
	this:SetScript("OnUpdate", ww.FadeIn)
end)

frame:EnableMouseWheel()
frame:SetScript("OnMouseWheel", function()
	local val = arg1
	offset = offset - val * NUMROWS
	local maxOffset = math.max(0, table.getn(displayList) - TOTALROWS)
	if offset > maxOffset then offset = maxOffset end
	if offset < 0 then offset = 0 end
	TurtleGuide:UpdateGuideListPanel()
end)

ww.SetFadeTime(frame, 0.7)

table.insert(UISpecialFrames, "TurtleGuideGuideList")

-- Public API: open guide list with optional level filter preset
function TurtleGuide:ShowGuideList(withLevelFilter)
	if withLevelFilter then
		levelFilterOn = true
	end
	self.guidelistframe:Show()
end

function TurtleGuide:UpdateGuideListPanel()
	if not frame or not frame:IsVisible() then return end

	-- Update title to show branch status
	if self.db.char.isbranching then
		frame.title:SetText("Guide List |cff00ff00(Branching)|r")
	else
		frame.title:SetText("Guide List")
	end

	-- Show/hide Return to Main button
	if self.db.char.isbranching then
		frame.returnBtn:Show()
		frame.returnBtn:Enable()
	else
		frame.returnBtn:Hide()
	end

	-- Update level filter checkbox state
	filterCheck:SetChecked(levelFilterOn)

	-- Build categorized display list (fresh table each time)
	displayList = {}

	local playerLevel = UnitLevel("player") or 0
	local margin = 5

	local turtleGuides = {}
	local zoneGuides = {}

	for _, name in ipairs(self.guidelist) do
		if not self:IsRoutePackGuide(name) then
			local include = true
			if levelFilterOn then
				local minLevel, maxLevel = self:ParseGuideLevelRange(name)
				if minLevel and maxLevel then
					if playerLevel < (minLevel - margin) or playerLevel > (maxLevel + margin) then
						include = false
					end
				end
			end
			if include then
				local cat = self:GetGuideCategory(name)
				if cat == "turtle" then
					table.insert(turtleGuides, name)
				else
					table.insert(zoneGuides, name)
				end
			end
		end
	end

	table.sort(turtleGuides)
	table.sort(zoneGuides)

	if table.getn(turtleGuides) > 0 then
		table.insert(displayList, {header = true, text = "--- TurtleWoW Zones ---"})
		for _, name in ipairs(turtleGuides) do
			table.insert(displayList, {guide = name})
		end
	end

	if table.getn(zoneGuides) > 0 then
		table.insert(displayList, {header = true, text = "--- Zone Guides ---"})
		for _, name in ipairs(zoneGuides) do
			table.insert(displayList, {guide = name})
		end
	end

	-- Clamp offset
	local maxOffset = math.max(0, table.getn(displayList) - TOTALROWS)
	if offset > maxOffset then offset = maxOffset end
	if offset < 0 then offset = 0 end

	-- Update rows (never hide — just clear text for unused slots, matching original pattern)
	for i, row in ipairs(rows) do
		local entry = displayList[i + offset]
		if entry and entry.header then
			row.text:SetText("|cffffd100" .. entry.text .. "|r")
			row.guide = nil
			row:SetChecked(false)
			row:Enable()
		elseif entry and entry.guide then
			row:Enable()
			local name = entry.guide
			row.guide = name

			-- Color by level range: green = in range, yellow = +-5, red = out of range
			local minLevel, maxLevel = self:ParseGuideLevelRange(name)
			local colorCode
			if minLevel and maxLevel then
				if playerLevel >= minLevel and playerLevel <= maxLevel then
					colorCode = "|cff00ff00"  -- green: in range
				elseif playerLevel >= (minLevel - 5) and playerLevel <= (maxLevel + 5) then
					colorCode = "|cffffff00"  -- yellow: within 5 levels
				else
					colorCode = "|cffff4444"  -- red: out of range
				end
			else
				colorCode = "|cffcccccc"  -- gray: no level info
			end

			-- Completion percentage
			local complete
			if self.db.char.currentguide == name and self.current and self.actions then
				complete = (self.current - 1) / table.getn(self.actions)
			else
				complete = self.db.char.completion[name]
			end

			local text
			if complete and complete ~= 0 then
				local pct = math.floor(complete * 100)
				text = string.format("%s%s (%d%%)|r", colorCode, name, pct)
			else
				text = colorCode .. name .. "|r"
			end

			if self.db.char.isbranching and self.db.char.branchsavedguide == name then
				text = "|cff00ff00[Main]|r " .. text
			end

			row.text:SetText(text)
			row:SetChecked(self.db.char.currentguide == name)
		else
			row.guide = nil
			row.text:SetText("")
			row:SetChecked(false)
			row:Enable()
		end
	end
end
