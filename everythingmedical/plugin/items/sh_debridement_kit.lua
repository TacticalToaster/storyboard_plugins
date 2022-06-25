--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Debridement Kit";
ITEM.uniqueID = "debridement_kit";
ITEM.model = "models/health/medkit.mdl";
ITEM.weight = 2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Burns"
ITEM.combatMed = true;
ITEM.totalUses = 4;
ITEM.timeMin = 4;
ITEM.timeMax = 8;
ITEM.injuries = {
	["burn wound"] = {["applyMod"] = 1, ["heal"] = 8, ["treatText"] = "applies relieving gel across a burn wound."}
};
ITEM.treatCompletely = true;
ITEM.treatSelf = false;
ITEM.applyTextSelf = "applyingBurnGel";
ITEM.applyTextPatient = "applyingBurnGel";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A package of medical supplies, containing forceps, fentanyl auto-injectors, sterile bandages, scalpels, and other sharp instruments.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();