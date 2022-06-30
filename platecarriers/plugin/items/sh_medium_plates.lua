--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("armor_equipment_base");
ITEM.name = "Medium Armor Plates";
ITEM.uniqueID = "medium_plates";
ITEM.description = "Medium ceramic plates, balancing protection with weight.";
ITEM.weight = 5;
ITEM.wearPocketSpace = 3;
ITEM.category = "Armor";
ITEM.equippedCategory = "Plates";
ITEM.equipmentSlot = "plates";
ITEM.requiredOpenedSlot = "plates"; // another item must open this slot for this to be wearable

ITEM.wearSpeedMod = .8;

ITEM.showCondition = true;
ITEM.conditionDMGTypes = {DMG_BULLET, DMG_BLAST, DMG_ACID, DMG_PLASMA, DMG_BUCKSHOT};
ITEM.hitGroups = {HITGROUP_CHEST, HITGROUP_STOMACH};
ITEM.resistance = 1;
ITEM.retention = .3; // measures how well a piece of armor maintains protection when damaged
ITEM.protectionLevel = 48;
ITEM.blunt = .05;
ITEM.maxCondition = 75;
ITEM.armorClass = "NIJ 3";


-- Called when a player changes clothes.
/*function ITEM:OnChangedClothes(player, bIsWearing)
	local bodygroups = ITEM:GetData("Bodygroups");

	if (bIsWearing) then
		bodygroups[4] = player:GetBodygroup(4);
		player:SetBodygroup(4, 2);
		self:SetData("Bodygroups", bodygroups);
	else
		player:SetBodygroup(4, bodygroups[4]);
	end;
end;*/

function ITEM:OnAccessoryEquip(player)
	//Clockwork.player:CreateGearBM(player, "vest", self, true);
end;

function ITEM:OnAccessoryUnequip(player)
	//Clockwork.player:RemoveGear(player, "vest");
end;

ITEM:Register();