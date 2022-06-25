--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Sterile Bandage";
ITEM.uniqueID = "sterile_bandage";
ITEM.model = "models/illusion/eftcontainers/bandage.mdl";
ITEM.weight = .1;
ITEM.useText = "Wrap";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
ITEM.totalUses = 1;
ITEM.timeMin = 4;
ITEM.timeMax = 6;
ITEM.injuries = {
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "finishes wrapping a bandage around the open wound."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "finishes wrapping a bandage around the open laceration."}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small sealed bandage for quick application on minor wounds.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();