--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Israeli Bandage";
ITEM.uniqueID = "israeli_bandage";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/bandage.mdl";
ITEM.weight = .2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
ITEM.totalUses = 1;
ITEM.timeMin = 2;
ITEM.timeMax = 3;
ITEM.injuries = {
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 15, ["treatText"] = "finishes wrapping a bandage around the open wound."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 15, ["treatText"] = "finishes wrapping a bandage around the open laceration."}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small, clear package containing an individual, rolled bandage. On the bandage is instructions on how to use it.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();