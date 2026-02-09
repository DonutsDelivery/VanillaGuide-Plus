
local TurtleGuide = TurtleGuide
local ww = WidgetWarlock

local title

local NUMROWS, COLWIDTH = 16, 210
local ROWHEIGHT = 305 / NUMROWS

local offset = 0
local rows = {}

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
		-- Right-click: Branch to this guide (saves current progress)
		local text = f.guide
		if text then
			TurtleGuide:BranchToGuide(text)
			TurtleGuide:UpdateGuideListPanel()
		end
	else
		-- Left-click: Load guide normally
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

-- Fill in the frame with "guides' CheckButtons"
for i = 1, NUMROWS * 3 do
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
	row:SetHighlightTexture(highlight)
	row:SetCheckedTexture(highlight)

	local text = ww.SummonFontString(row, nil, "GameFontWhite", nil, "LEFT", 6, 0)
	local fontname, fontheight, fontflags = title:GetFont()
	text:SetFont(fontname, 11, fontflags)
	text:SetTextColor(.79, .79, .79, 1)

	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row:SetScript("OnClick", OnClick)
	row:SetScript("OnEnter", ShowTooltip)
	row:SetScript("OnLeave", HideTooltip)

	row.text = text
	rows[i] = row
end

frame:SetScript("OnShow", function()
	local quad, vhalf, hhalf = TurtleGuide.GetQuadrant(TurtleGuide.statusframe)
	local anchpoint = (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
	this:ClearAllPoints()
	this:SetPoint(quad, TurtleGuide.statusframe, anchpoint)
	TurtleGuide:UpdateGuideListPanel()
	this:SetAlpha(0)
	this:SetScript("OnUpdate", ww.FadeIn)
end)

-- Filtered guide list (excludes route pack guides like Optimized/ and RXP/)
local filteredGuides = {}

frame:EnableMouseWheel()
frame:SetScript("OnMouseWheel", function()
	local f, val = this, arg1
	offset = offset - val * NUMROWS
	if (offset + NUMROWS * 2) > table.getn(filteredGuides) then offset = offset - NUMROWS end
	if offset < 0 then offset = 0 end
	TurtleGuide:UpdateGuideListPanel()
end)

ww.SetFadeTime(frame, 0.7)

table.insert(UISpecialFrames, "TurtleGuideGuideList")

function TurtleGuide:UpdateGuideListPanel()
	if not frame or not frame:IsVisible() then return end

	-- Update title to show branch status
	if self.db.char.isbranching then
		frame.title:SetText("Guide List |cff00ff00(Branching)|r")
	else
		frame.title:SetText("Guide List")
	end

	-- Build filtered list (exclude route pack guides)
	for k in pairs(filteredGuides) do filteredGuides[k] = nil end
	for _, name in ipairs(self.guidelist) do
		if not self:IsRoutePackGuide(name) then
			table.insert(filteredGuides, name)
		end
	end

	for i, row in ipairs(rows) do
		row.i = i + offset + 1

		local name = filteredGuides[i + offset + 1]
		local complete = self.db.char.currentguide == name and (self.current - 1) / table.getn(self.actions) or self.db.char.completion[name]
		row.guide = name

		local r, g, b = self.ColorGradient(complete or 0)
		local text = complete and complete ~= 0 and string.format("|cff%02x%02x%02x%s", r * 255, g * 255, b * 255, name) or name

		-- Mark saved main route when branching
		if self.db.char.isbranching and self.db.char.branchsavedguide == name then
			text = "|cff00ff00[Main]|r " .. text
		end

		row.text:SetText(text)
		row:SetChecked(self.db.char.currentguide == name)
	end
end
