--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("equipment_base", true);
ITEM.name = "Armor Equipment Base";
ITEM.uniqueID = "armor_equipment_base";
ITEM.category = "Armor"
ITEM.equippedCategory = "Armor";
ITEM.equipmentSlot = "armor";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 1;
ITEM.wearingTakesSpace = false;
ITEM.description = "A piece of body armor.";

ITEM.resistance = 1;
ITEM.retention = .5; // measures how well a piece of armor maintains protection when damaged
ITEM.protectionLevel = 50;
ITEM.blunt = .05;
ITEM.maxCondition = 100;
ITEM.armorClass = "GOST 5";
//ITEM.canTakeDamage = true;
//ITEM.damagePerCondition = 5;

function ITEM:DamageCondition(player, damageInfo, hitGroup)
	local oldCond = self:GetCondition();
	local dmgAmount = damageInfo:GetDamage();

	print("DamageCondition!!!!")

	if (damageInfo:IsBulletDamage()) then
		local ammoPen = Clockwork.EquipmentBase.AmmoPen[game.GetAmmoName(damageInfo:GetAmmoType())] or 10;
		local penDif = self.protectionLevel * math.Clamp(oldCond * (self.retention + 1)/self.maxCondition, 0, 1) - ammoPen;
		//dmgAmount = self.maxCondition * (math.abs(penDif)/(protectionLevel * 2));

		if (penDif <= 0) then
			dmgAmount = (self.maxCondition * .08) + (20 * (ammoPen/(self.protectionLevel * 2)));
			//damageInfo:ScaleDamage( Lerp( math.Clamp( oldCond/self.maxCondition, 0, 1), 1, .8 ) );
		else
			dmgAmount = (self.maxCondition * .02) + (20 * (ammoPen/(self.protectionLevel * 3)));
			//damageInfo:SetDamageType(DMG_CLUB);
			//damageInfo:ScaleDamage(self.blunt);
			local soundNumber = math.random(1, 8);
			player:EmitSound("player/damage/pl_heavyarmor_damagebullet_0"..soundNumber..".wav", 130, 80, 1, CHAN_BODY);
		end;
	end;

	local newCond = math.Clamp(oldCond-(self.resistance*dmgAmount), 0, math.huge);

	self:SetData("Condition", newCond);

	Clockwork.item:SendUpdate(self, self.data);
end;

/* System based off of maxCondition rather then just durability in general
function ITEM:DamageCondition(player, damageInfo, hitGroup)
	local oldCond = self:GetCondition();
	local dmgAmount = damageInfo:GetDamage();

	if (damageInfo:IsBulletDamage()) then
		local ammoPen = Clockwork.EquipmentBase.AmmoPen[game.GetAmmoName(damageInfo:GetAmmoType())] or 10;
		local penDif = self.protectionLevel * math.Clamp(oldCond * (self.retention + 1)/self.maxCondition, 0, 1) - ammoPen;
		//dmgAmount = self.maxCondition * (math.abs(penDif)/(protectionLevel * 2));

		if (penDif <= 0) then
			dmgAmount = (self.maxCondition * .08) + (self.maxCondition * (math.abs(penDif)/(protectionLevel * 1.5)));
			damageInfo:ScaleDamage( Lerp( math.Clamp( oldCond/self.maxCondition, 0, 1), 1, .8 ) );
		else
			dmgAmount = (self.maxCondition * .02) + (self.maxCondition * (ammoPen/(protectionLevel * 3)));
			//damageInfo:SetDamageType(DMG_CLUB);
			//damageInfo:ScaleDamage(self.blunt);
		end;
	end;

	local newCond = math.Clamp(oldCond-(self.resistance*dmgAmount), 0, math.huge);

	self:SetData("Condition", newCond);

	Clockwork.item:SendUpdate(self, self.data);
end;
*/

/*function ITEM:OnTakeDamage(player, damageInfo, hitgroup)
	local oldCond = self:GetCondition();

	if (damageInfo:IsBulletDamage()) then
		local ammoPen = Clockwork.EquipmentBase.AmmoPen[game.GetAmmoName(damageInfo:GetAmmoType())] or 10;
		local penDif = self.protectionLevel - ammoPen;
		//dmgAmount = self.maxCondition * (math.abs(penDif)/(protectionLevel * 2));

		if (ammoPen >= protectionLevel) then

		else
			damageInfo:SetDamageType(DMG_CLUB);
			damageInfo:ScaleDamage()
		end;
end;*/

function ITEM:CanDamageCondition(player, damageInfo, hitGroup)
	local correctDMGType = false;
	local correctHitGroup = false;

	if (self:GetCondition() <= 0) then
		//print("WH WHHW PUSY ANCHOV")
		return false;
	end;

	for i, v in pairs(self.conditionDMGTypes) do
		if (damageInfo:IsDamageType(v)) then
			correctDMGType = true;

			break;
		end;
	end;

	for i, v in pairs(self.hitGroups) do
		if (hitGroup == v) then
			correctHitGroup = true;

			break;
		end;
	end;

	return (correctDMGType and correctHitGroup);
end;

function ITEM:PlayerShouldInjureFromDamage(player, attacker, hitGroup, damageInfo, baseDamage)
	print("SHOULDINJURE!!!")

	if (damageInfo:IsBulletDamage() and (self.CanDamageCondition and self:CanDamageCondition(player, damageInfo, hitGroup))) then
		local oldCond = self:GetCondition();
		local ammoPen = Clockwork.EquipmentBase.AmmoPen[game.GetAmmoName(damageInfo:GetAmmoType())] or 10;
		local penDif = self.protectionLevel * math.Clamp(oldCond * (self.retention + 1)/self.maxCondition, 0, 1) - ammoPen;

		if (penDif > 0) then
			if (Lerp(1 - (penDif/self.maxCondition), 0, self.maxCondition) <= math.random(oldCond, self.maxCondition)) then
				damageInfo:SetDamageType(DMG_CLUB);
				damageInfo:ScaleDamage(self.blunt);
				return false;
			else
				damageInfo:ScaleDamage( Lerp( math.Clamp( oldCond/self.maxCondition, 0, 1), 1, .8 ) );
			end; 
		end;
	end;
end;

function ITEM:OnPlayerThink(player, infoTable)

end;

if (CLIENT) then
	function ITEM:ExtraClientSideInfo(markupText)
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = markupText or "";
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

ITEM:Register();