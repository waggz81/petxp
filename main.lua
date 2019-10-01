
local currXP, nextXP = GetPetExperience()

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_PET_EXPERIENCE")
f:SetScript("OnEvent", function(self, event)
	C_Timer.After(2,updatePetXP)
end)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("PET_BAR_UPDATE")
f2:RegisterEvent("UNIT_PET")
f2:SetScript("OnEvent", function(self, event)
	if event == "UNIT_PET" then
		updatePetXP()
	end
	hunterPetActive()
end)

local frame = CreateFrame("Frame", "DragFrame2", UIParent)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame.text = frame:CreateFontString(nil,"ARTWORK") 
frame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
frame.text:SetPoint("LEFT",0,0)

-- The code below makes the frame visible, and is not necessary to enable dragging.
frame:SetPoint("CENTER")
frame:SetWidth(100)
frame:SetHeight(10)


function printPetXP ()
	local percent = string.format("%2.2f", (currXP / nextXP) * 100)
	local level = UnitLevel("pet")
	local text = "PetXP: " .. currXP .. " / " .. nextXP .. " (Lvl " .. level .. " - " .. percent .. "%)"
	--print(text)
	frame.text:SetText(text)
end

function updatePetXP ()
	currXP, nextXP = GetPetExperience()
	printPetXP()
end

function hunterPetActive ()
	local hasUI, isHunterPet = HasPetUI();
	frame:Hide()
	if hasUI then
		if isHunterPet then
			printPetXP()
			frame:Show()
		end
	end
end

printPetXP()
hunterPetActive()