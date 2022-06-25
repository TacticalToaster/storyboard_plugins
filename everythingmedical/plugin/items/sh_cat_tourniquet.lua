--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "CAT Tourniquet";
ITEM.uniqueID = "cat_tourniquet";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/alusplint.mdl";
ITEM.weight = .1;
ITEM.useText = "Wrap";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
ITEM.totalUses = 1;
ITEM.timeMin = 5;
ITEM.timeMax = 8;
ITEM.injuries = {
	["severe bleed"] = {["applyMod"] = 1, ["heal"] = 10, ["treatText"] = "tightens down a tourniquet above the severe wound.", ["replaceInjury"] = "tourniquet with severe bleed"},
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "tightens down a tourniquet above the open wound.", ["replaceInjury"] = "tourniquet with gunshot wound"},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "tightens down a tourniquet above the open laceration.", ["replaceInjury"] = "tourniquet with laceration"}
};
ITEM.treatCompletely = false;
ITEM.applyTextSelf = "applyingTourniquetSelf";
ITEM.applyTextPatient = "applyingTourniquetPatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "An orange elastic band with a small rod that clips it in place.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();