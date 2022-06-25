local ITEM = Clockwork.item:New("equipment_base");

ITEM.name = "Armasight N-15 NVG";
ITEM.uniqueID = "n15";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Head Mount";
ITEM.equipmentSlot = "nvg";
ITEM.nvgMaskOverlay = Material( "wtt/mask/mask_binocular.png" );
ITEM.cost = 15;
ITEM.weight = 1;
ITEM.business = false;
ITEM.model = "models/pmcsimp/dual1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/dual.mdl";
ITEM.isBonemerged = true;
ITEM.description = "Armasight N-15-NVG binocular. Civilian alternative to contract military devices installed in a compact and ergonomic body.";

function ITEM:OnAccessoryEquip(player)
	player:SetSharedVar("nvdType", "blu");
	Clockwork.player:CreateGearBM(player, "nvg", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	player:SetSharedVar("nvdType", "");
	Clockwork.player:RemoveGear(player, "nvg");
end;

ITEM:Register();