-- Navigation.lua
-- TomTom integration wrapper for TurtleGuide

local L = TurtleGuide.Locale

local zonei, zonec, zonenames = {}, {}, {}
for ci, c in pairs{GetMapContinents()} do
	zonenames[ci] = {GetMapZones(ci)}
	for zi, z in pairs(zonenames[ci]) do
		zonei[z], zonec[z] = zi, ci
	end
end

local cache = {}

-- Set a waypoint using TomTom
local function MapPoint(zone, x, y, desc)
	TurtleGuide:Debug(string.format("Mapping %q - %s (%.2f, %.2f)", desc, zone, x, y))
	local zi, zc = zone and zonei[zone], zone and zonec[zone]
	if not zi then
		if zone then TurtleGuide:Print(string.format(L["Cannot find zone %q, using current zone."], zone))
		else TurtleGuide:Print(L["No zone provided, using current zone."]) end

		zi, zc = GetCurrentMapZone(), GetCurrentMapContinent()
		zone = zonenames[zc][zi]
	end

	local opts = {title = "[TG] " .. desc}
	if TomTom then
		TomTom:AddMFWaypoint(zc, zi, x / 100, y / 100, opts)
	elseif Cartographer_Waypoints then
		local pt = NotePoint:new(zone, x / 100, y / 100, "[TG] " .. desc)
		Cartographer_Waypoints:AddWaypoint(pt)
		table.insert(cache, pt.WaypointID)
	end
end

-- Set waypoint from coordinates
function TurtleGuide:SetWaypoint(x, y, zone, description)
	self:ClearWaypoint()
	MapPoint(zone, x, y, description or "TurtleGuide Waypoint")
end

-- Clear all TurtleGuide waypoints
function TurtleGuide:ClearWaypoint()
	if TomTom then
		if TomTom.waypoints then
			for k, wp in ipairs(TomTom.waypoints) do
				if wp.title and string.sub(wp.title, 1, 5) == "[TG] " then
					self:Debug(string.format("Removing %q from TomTom", wp.title))
					TomTom:RemoveWaypoint(wp, true)
				end
			end
		end
	elseif Cartographer_Waypoints then
		while cache[1] do
			local pt = table.remove(cache)
			Cartographer_Waypoints:CancelWaypoint(pt)
		end
	end
end

-- Map NPC location using pfQuest database
function TurtleGuide:MapPfQuestNPC(qid, action)
	if not self.db.char.mapquestgivers then return end
	if not qid then return false end
	if not pfDB then return false end

	local unitId, objectId = "UNKNOWN", "UNKNOWN"
	local loc, qid = GetLocale(), tonumber(qid)

	local qLookup = pfDB["quests"]["data"]
	if not qLookup or not qLookup[qid] then return false end

	local title = pfDB.quests.loc[qid] and pfDB.quests.loc[qid]["T"] or "Unknown Quest"

	if action == "ACCEPT" then
		if qLookup[qid]["start"] then
			if qLookup[qid]["start"]["U"] then
				for _, uid in pairs(qLookup[qid]["start"]["U"]) do
					unitId = uid
				end
			elseif qLookup[qid]["start"]["O"] then
				for _, oid in pairs(qLookup[qid]["start"]["O"]) do
					objectId = oid
				end
			end
		end
	else
		if qLookup[qid]["end"] then
			if qLookup[qid]["end"]["U"] then
				for _, uid in pairs(qLookup[qid]["end"]["U"]) do
					unitId = uid
				end
			elseif qLookup[qid]["end"]["O"] then
				for _, oid in pairs(qLookup[qid]["end"]["O"]) do
					objectId = oid
				end
			end
		end
	end
	self:Debug(string.format("pfQuest lookup A:%s U:%s O:%s", action, unitId, objectId))

	if unitId ~= "UNKNOWN" then
		local unitLookup = pfDB["units"]["data"]
		if unitLookup[unitId] and unitLookup[unitId]["coords"] then
			for _, data in pairs(unitLookup[unitId]["coords"]) do
				local x, y, zone, _ = unpack(data)
				MapPoint(pfDB.zones.loc[zone], x, y, title .. " (" .. pfDB.units.loc[unitId] .. ")")
				return true
			end
		end
	elseif objectId ~= "UNKNOWN" then
		local objectLookup = pfDB["objects"]["data"]
		if objectLookup[objectId] and objectLookup[objectId]["coords"] then
			for _, data in pairs(objectLookup[objectId]["coords"]) do
				local x, y, zone, _ = unpack(data)
				MapPoint(pfDB.zones.loc[zone], x, y, title .. " (" .. pfDB.objects.loc[objectId] .. ")")
				return true
			end
		end
	end
	self:Debug(string.format("%s: No NPC or Object information found for %s!", action, title))
	return false
end

-- Parse coordinates from note text and create waypoints
function TurtleGuide:ParseAndMapCoords(qid, action, note, desc, zone)
	-- Clear existing waypoints first
	self:ClearWaypoint()

	if note and string.find(note, L.COORD_MATCH) then
		for x, y in string.gfind(note, L.COORD_MATCH) do
			MapPoint(zone, tonumber(x), tonumber(y), desc)
		end
	elseif (action == "ACCEPT" or action == "TURNIN") then
		if pfQuest or pfDB then
			self:MapPfQuestNPC(qid, action)
		end
	end
end

-- Auto-update waypoint when step changes
function TurtleGuide:UpdateWaypoint()
	if not TomTom and not Cartographer_Waypoints then return end

	local action, quest, fullquest = self:GetObjectiveInfo()
	if not action then return end

	local note = self:GetObjectiveTag("N")
	local qid = self:GetObjectiveTag("QID")
	local zonename = self:GetObjectiveTag("Z") or self.zonename

	self:ParseAndMapCoords(qid, action, note, quest, zonename)
end
