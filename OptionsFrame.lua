
local TurtleGuide = TurtleGuide
local L = TurtleGuide.Locale
local ww = WidgetWarlock

function TurtleGuide:CreateConfigPanel()
	local frame = CreateFrame("Frame", "TurtleGuideOptions", UIParent)
	TurtleGuide.optionsframe = frame
	frame:SetFrameStrata("DIALOG")
	frame:SetWidth(310)
	frame:SetHeight(16 + 28 * 8)
	frame:SetPoint("TOPRIGHT", TurtleGuide.statusframe, "BOTTOMRIGHT")
	frame:SetBackdrop(ww.TooltipBorderBG)
	frame:SetBackdropColor(0.09, 0.09, 0.19, 1)
	frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.5)
	frame:Hide()

	local closebutton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	closebutton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	local title = ww.SummonFontString(frame, nil, "SubZoneTextFont", nil, "BOTTOMLEFT", frame, "TOPLEFT", 5, 0)
	local fontname, fontheight, fontflags = title:GetFont()
	title:SetFont(fontname, 18, fontflags)
	title:SetText("Options")

	local qtrack = ww.SummonCheckBox(22, frame, "TOPLEFT", 5, -5)
	ww.SummonFontString(qtrack, "OVERLAY", "GameFontNormalSmall", L["Automatically track quests"], "LEFT", qtrack, "RIGHT", 5, 0)
	qtrack:SetScript("OnClick", function() self.db.char.trackquests = not self.db.char.trackquests end)

	local qskipfollowups = ww.SummonCheckBox(22, qtrack, "TOPLEFT", 0, -20)
	ww.SummonFontString(qskipfollowups, "OVERLAY", "GameFontNormalSmall", L["Automatically skip suggested follow-ups"], "LEFT", qskipfollowups, "RIGHT", 5, 0)
	qskipfollowups:SetScript("OnClick", function() self.db.char.skipfollowups = not self.db.char.skipfollowups end)

	local mapmetamap = ww.SummonCheckBox(22, qskipfollowups, "TOPLEFT", 0, -20)
	ww.SummonFontString(mapmetamap, "OVERLAY", "GameFontNormalSmall", L["Map MetaMap/BWP"], "LEFT", mapmetamap, "RIGHT", 5, 0)
	mapmetamap:SetScript("OnClick", function() self.db.char.mapmetamap = not self.db.char.mapmetamap end)

	local mapbwp = ww.SummonCheckBox(22, mapmetamap, "TOPLEFT", 0, -20)
	ww.SummonFontString(mapbwp, "OVERLAY", "GameFontNormalSmall", L["Use BWP arrow"], "LEFT", mapbwp, "RIGHT", 5, 0)
	mapbwp:SetScript("OnClick", function() self.db.char.mapbwp = not self.db.char.mapbwp end)

	local autobranch = ww.SummonCheckBox(22, mapbwp, "TOPLEFT", 0, -20)
	ww.SummonFontString(autobranch, "OVERLAY", "GameFontNormalSmall", "Auto-branch to Turtle WoW zones", "LEFT", autobranch, "RIGHT", 5, 0)
	autobranch:SetScript("OnClick", function() self.db.char.autobranch = not self.db.char.autobranch end)

	-- Route selector button
	local routeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	routeBtn:SetWidth(150)
	routeBtn:SetHeight(22)
	routeBtn:SetPoint("TOPLEFT", autobranch, "BOTTOMLEFT", 0, -10)
	routeBtn:SetText("Change Route")
	routeBtn:SetScript("OnClick", function()
		frame:Hide()
		TurtleGuide:ShowRouteSelector()
	end)

	local branchBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	branchBtn:SetWidth(150)
	branchBtn:SetHeight(22)
	branchBtn:SetPoint("TOPLEFT", routeBtn, "BOTTOMLEFT", 0, -6)
	branchBtn:SetText("Branch to Zone")
	branchBtn:SetScript("OnClick", function()
		frame:Hide()
		TurtleGuide:ShowGuideList(true)
	end)
	frame.branchBtn = branchBtn

	local returnMainBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	returnMainBtn:SetWidth(130)
	returnMainBtn:SetHeight(22)
	returnMainBtn:SetPoint("LEFT", branchBtn, "RIGHT", 6, 0)
	returnMainBtn:SetText("Return to Main")
	returnMainBtn:SetScript("OnClick", function()
		TurtleGuide:ReturnFromBranch()
		frame:Hide()
	end)
	frame.returnMainBtn = returnMainBtn

	local refreshBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	refreshBtn:SetWidth(150)
	refreshBtn:SetHeight(22)
	refreshBtn:SetPoint("TOPLEFT", branchBtn, "BOTTOMLEFT", 0, -6)
	refreshBtn:SetText("Rescan Progress")
	refreshBtn:SetScript("OnClick", function()
		TurtleGuide:QueryServerCompletedQuests(true)
	end)

	local errorBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	errorBtn:SetWidth(130)
	errorBtn:SetHeight(22)
	errorBtn:SetPoint("LEFT", refreshBtn, "RIGHT", 6, 0)
	errorBtn:SetText("Error Log")
	errorBtn:SetScript("OnClick", function()
		frame:Hide()
		TurtleGuide:ShowErrorLog()
	end)

	frame.qtrack = qtrack
	frame.qskipfollowups = qskipfollowups
	frame.mapmetamap = mapmetamap
	frame.mapbwp = mapbwp
	frame.autobranch = autobranch

	local function OnShow(f)
		f = f or this
		local quad, vhalf, hhalf = self.GetQuadrant(self.statusframe)
		local anchpoint = (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
		f:ClearAllPoints()
		f:SetPoint(quad, self.statusframe, anchpoint)
		local title_point, title_anchor, title_x, title_y
		if quad == "TOPLEFT" then
			title_point, title_anchor, title_x, title_y = "BOTTOMRIGHT", "TOPRIGHT", -5, 0
		else
			title_point, title_anchor, title_x, title_y = "BOTTOMLEFT", "TOPLEFT", 5, 0
		end
		title:ClearAllPoints()
		title:SetPoint(title_point, f, title_anchor, title_x, title_y)

		f.qtrack:SetChecked(self.db.char.trackquests)
		f.qskipfollowups:SetChecked(self.db.char.skipfollowups)
		f.mapmetamap:SetChecked(self.db.char.mapmetamap)
		f.mapbwp:SetChecked(self.db.char.mapbwp)
		f.autobranch:SetChecked(self.db.char.autobranch)

		-- Enable/disable return button based on branch status
		if self.db.char.isbranching then
			f.returnMainBtn:Enable()
			f.returnMainBtn:SetText("Return to Main")
		else
			f.returnMainBtn:Disable()
			f.returnMainBtn:SetText("(Not branching)")
		end
		f:SetAlpha(0)
		f:SetScript("OnUpdate", ww.FadeIn)
	end

	frame:SetScript("OnShow", OnShow)
	ww.SetFadeTime(frame, 0.5)
	OnShow(frame)
end

table.insert(UISpecialFrames, "TurtleGuideOptions")
