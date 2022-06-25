--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Burn Gel";
ITEM.uniqueID = "burn_gel";
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = .2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Burns"
ITEM.combatMed = true;
ITEM.totalUses = 2;
ITEM.timeMin = 4;
ITEM.timeMax = 8;
ITEM.injuries = {
	["burn wound"] = {["applyMod"] = 1, ["heal"] = 8, ["treatText"] = "applies relieving gel across a burn wound."}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingBurnGel";
ITEM.applyTextPatient = "applyingBurnGel";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small tube of blue gel. It feels cool to the touch.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();