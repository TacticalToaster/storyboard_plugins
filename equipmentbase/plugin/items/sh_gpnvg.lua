local ITEM = Clockwork.item:New("equipment_base");

ITEM.name = "GPNVG-18";
ITEM.uniqueID = "gpnvg";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Head Mount";
ITEM.equipmentSlot = "nvg";
ITEM.nvgMaskOverlay = Material( "wtt/mask/mask_anvis.png" );
ITEM.cost = 15;
ITEM.weight = 3;
ITEM.business = false;
ITEM.model = "models/pmcsimp/quad1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/quad.mdl";
ITEM.isBonemerged = true;
ITEM.description = "Panoramic night vision goggles GPNVG-18 (Ground Panoramic Night Vision Goggle). The cardinal difference of this NVG from the others is the presence of four separate EOP, two for each eye. Two Central EOPs are directed forward, while two more are directed outward from the center. This innovative solution allowed to expand the scope of the review to 97 degrees.";

function ITEM:OnAccessoryEquip(player)
	player:SetSharedVar("nvdType", "blu");
	Clockwork.player:CreateGearBM(player, "nvg", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	player:SetSharedVar("nvdType", "");
	Clockwork.player:RemoveGear(player, "nvg");
end;

ITEM:Register();