
PetXP = { }

local currXP, nextXP = GetPetExperience()
local prevXP = nil

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_PET_EXPERIENCE")
f:SetScript("OnEvent", function(self, event)
	--C_Timer.After(2,updatePetXP)
	PetXP:updatePetXP(false)
end)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("PET_BAR_UPDATE")
f2:RegisterEvent("UNIT_PET")
f2:SetScript("OnEvent", function(self, event)
	if event == "UNIT_PET" then
		PetXP:updatePetXP(true)
	end
	PetXP:hunterPetActive()
end)

local frame = CreateFrame("Frame", "DragFrame2", UIParent)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetPoint("CENTER")
frame:SetWidth(100)
frame:SetHeight(10)
frame.text = frame:CreateFontString(nil,"ARTWORK") 
frame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
frame.text:SetPoint("TOPLEFT")
frame.text:SetJustifyH("LEFT")




function PetXP:printPetXP (prevXP)
	local percent = string.format("%2.2f", (currXP / nextXP) * 100)
	local level = UnitLevel("pet")
	local text = "PetXP: " .. currXP .. " / " .. nextXP .. " (Lvl " .. level .. " - " .. percent .. "%)"
	if prevXP then
		local gains = math.ceil((nextXP - currXP) / (currXP - prevXP))
		text = text .. "\nXP gains req: " .. gains
	end
	frame.text:SetText(text)
end

function PetXP:updatePetXP (init)
	if not init then
		prevXP = currXP
	else 
		prevXP = nil
	end
	currXP, nextXP = GetPetExperience()
	PetXP:printPetXP(prevXP)
end

function PetXP:hunterPetActive ()
	local hasUI, isHunterPet = HasPetUI();
	frame:Hide()
	if hasUI then
		if isHunterPet then
			PetXP:printPetXP(prevXP)
			frame:Show()
		end
	end
end

PetXP:printPetXP()
PetXP:hunterPetActive()