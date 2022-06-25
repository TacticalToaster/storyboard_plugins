--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "QuikClot Hemostatic Combat Gauze";
ITEM.uniqueID = "quikclot_gauze";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/bandage_army.mdl";
ITEM.weight = .1;
ITEM.useText = "Apply";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
ITEM.totalUses = 1;
ITEM.timeMin = 2;
ITEM.timeMax = 3;
ITEM.injuries = {
	["severe bleed"] = {["applyMod"] = 1.2, ["heal"] = 15, ["treatText"] = "finishes wrapping a bandage around the severe wound."},
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 10, ["treatText"] = "finishes wrapping a bandage around the open wound."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 10, ["treatText"] = "finishes wrapping a bandage around the open laceration."}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A green package containing a vacuum sealed gauze that leaves powder residue behind.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();