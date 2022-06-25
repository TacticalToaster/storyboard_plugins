--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Sterile Gauze";
ITEM.uniqueID = "sterile_gauze";
ITEM.model = "models/illusion/eftcontainers/galette.mdl";
ITEM.weight = .3;
ITEM.useText = "Wrap";
ITEM.category = "Medical - Bleeds"
ITEM.combatMed = true;
ITEM.totalUses = 4;
ITEM.timeMin = 5;
ITEM.timeMax = 7;
ITEM.injuries = {
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 8, ["treatText"] = "finishes wrapping some gauze around the open wound."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 8, ["treatText"] = "finishes wrapping some gauze around the open laceration."}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A roll of sterile gauze.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();