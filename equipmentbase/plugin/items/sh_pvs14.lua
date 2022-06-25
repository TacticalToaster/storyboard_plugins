local ITEM = Clockwork.item:New("equipment_base");

ITEM.name = "AN/PVS-14 NVM";
ITEM.uniqueID = "pvs14";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Head Mount";
ITEM.equipmentSlot = "nvg";
ITEM.nvgMaskOverlay = Material( "wtt/mask/mask_old_monocular.png" );
ITEM.cost = 15;
ITEM.weight = 1;
ITEM.business = false;
ITEM.model = "models/pmcsimp/dual1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/dual.mdl";
ITEM.isBonemerged = true;
ITEM.description = "AN/PVS-14 Monocular Night Vision Device. Army/Navy Portable Visual Search device allows nighttime detection of targets on distances of up to 350m with 40° FOV and adjustable brightness.";

function ITEM:OnAccessoryEquip(player)
	player:SetSharedVar("nvdType", "nv");
	Clockwork.player:CreateGearBM(player, "nvg", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	player:SetSharedVar("nvdType", "");
	Clockwork.player:RemoveGear(player, "nvg");
end;

ITEM:Register();