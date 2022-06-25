--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("mask_base");
ITEM.name = "Gasmask";
ITEM.uniqueID = "gasmask";
ITEM.weight = 1;
ITEM.category = "Equipment"
ITEM.equippedCategory = "Mask";
ITEM.equipmentSlot = "mask";
ITEM.showCondition = true;
ITEM.maxCondition = 20;
ITEM.conditionDMGTypes = {DMG_BULLET, DMG_BLAST, DMG_ACID, DMG_PLASMA, DMG_BUCKSHOT, DMG_CLUB};
ITEM.hitGroups = {HITGROUP_HEAD};
ITEM.radiationProtection = .8;
ITEM.noFilterProtection = .1;
ITEM.gasProtection = 1;
ITEM.exposureAlways = true;
ITEM.resistance = 1;
//ITEM.pocketSpace = 4;
ITEM.description = "A simple gasmask with a basic filter.";
ITEM.maskOverlay = Material( "OIIJIOT/respiratordmxmd" );
ITEM.smudge = Material("wtt/mask/screenscratches_gud.png");
ITEM.canTakeDamage = true;
ITEM.damageChance = 100;

ITEM.model = "models/pmcsimp/mask1_prop.mdl";
ITEM.attachmentModel = "models/pmcsimp/bio_mask.mdl";
ITEM.isBonemerged = true;

ITEM:AddData("Bodygroups", {4, 2}, true);
ITEM:AddData("Filter", {nil, 0}, true);

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
	Clockwork.player:CreateGearBM(player, "mask", self, true);

	if (player.cwGearTab["mask"]) then
		player.cwGearTab["mask"]:SetBodygroup(0, 1);
	end;
end;

function ITEM:OnAccessoryUnequip(player)
	Clockwork.player:RemoveGear(player, "mask");
end;

function ITEM:OnTakeDamage(player, damageInfo, hitGroup)
	//print("GAS", damageInfo:IsDamageType(DMG_NERVEGAS), self:GetGasProtection(player))

	if (damageInfo and damageInfo:IsDamageType(DMG_NERVEGAS)) then
		damageInfo:ScaleDamage(1 - self:GetGasProtection(player));
	end;

end;

function ITEM:PlayerShouldTakeDamage(player, damageInfo)
	if (damageInfo and damageInfo:IsDamageType(DMG_NERVEGAS) and 1 - self:GetGasProtection(player) <= 0) then
		return false;
	end;
end;

ITEM:Register();