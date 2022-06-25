local ITEM = Clockwork.item:New("equipment_base");

ITEM.name = "PNV-10T NVD";
ITEM.uniqueID = "nv";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Head Mount";
ITEM.equipmentSlot = "nvg";
ITEM.nvgMaskOverlay = Material( "OIIJIOT/respiratordmxmd" );
ITEM.cost = 15;
ITEM.weight = 2.5;
ITEM.business = false;
ITEM.description = "A cheap NVD that uses one monocle split between both eyes.";

ITEM.model = "models/pmcsimp/dual1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/dual.mdl";
ITEM.isBonemerged = true;


function ITEM:OnAccessoryEquip(player)
	player:SetSharedVar("nvdType", "nv");
	Clockwork.player:CreateGearBM(player, "nvg", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	player:SetSharedVar("nvdType", "");
	Clockwork.player:RemoveGear(player, "nvg");
end;

ITEM:Register();