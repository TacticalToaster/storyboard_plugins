--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Suturing Kit";
ITEM.uniqueID = "suturing_kit";
ITEM.model = "models/illusion/eftcontainers/ifak.mdl";
ITEM.weight = 2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Bleeds"
ITEM.combatMed = true;
ITEM.surgery = true;
ITEM.totalUses = 5;
ITEM.timeMin = 9;
ITEM.timeMax = 15;
ITEM.injuries = {
	["severe bleed"] = {["applyMod"] = 1.3, ["heal"] = 25, ["treatText"] = "finishes treating a severe wound with various sutures."},
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 15, ["treatText"] = "finishes treating an open wound with various sutures."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 15, ["treatText"] = "finishes treating an open laceration with various sutures."}
};
ITEM.treatCompletely = true;
ITEM.treatSelf = false;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A complex kit containing various stitches and needles meant to stop bleeding.";

ITEM:AddData("Uses", 0, true);

ITEM:Register();