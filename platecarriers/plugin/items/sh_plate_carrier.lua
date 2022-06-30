local ITEM = Clockwork.item:New("equipment_base");

ITEM.name = "Standard Plate Carrier";
ITEM.uniqueID = "plate_carrier";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Vest";
ITEM.equipmentSlot = "vest";
ITEM.openedSlots = {
	["plates"] = true
};
ITEM.weight = 2;
ITEM.business = false;
ITEM.model = "models/pmcsimp/quad1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/quad.mdl";
ITEM.isBonemerged = true;
ITEM.description = "A basic plate carrier that allows the insertion of protective armored plates.";

function ITEM:OnAccessoryEquip(player)
	Clockwork.player:CreateGearBM(player, "vest", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	Clockwork.player:RemoveGear(player, "vest");
end;

ITEM:Register();