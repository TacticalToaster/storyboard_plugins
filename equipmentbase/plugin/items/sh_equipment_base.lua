local ITEM = Clockwork.item:New("accessory_base", true);
ITEM.name = "Equipment Base";
ITEM.uniqueID = "equipment_base";
ITEM.category = "Equipment";
ITEM.equippedCategory = "Headgear";
ITEM.weight = 1;
ITEM.description = "A simple gasmask with a basic filter.";
ITEM.wearingTakesSpace = false;
ITEM.showCondition = false;
ITEM.maxCondition = 100;
ITEM.resistance = 1; // damage * resistance = condition damage taken, so 1 = 100% damage taken to condition
ITEM.conditionDMGTypes = {DMG_BULLET, DMG_BLAST, DMG_ACID, DMG_PLASMA, DMG_BUCKSHOT};
ITEM.hitGroups = {};
ITEM.canTakeDamage = false;
ITEM.damageChance = 30;
ITEM.equipmentSlot = "headgear";
//ITEM.canTakeDamage = true;
//ITEM.damagePerCondition = 5;

ITEM:AddData("Condition", false, true);
ITEM:AddData("Damage", {}, true);

-- Called when a player wears the accessory.
function ITEM:OnWearAccessory(player, isWearing)
	if (isWearing) then
		if (SERVER) then
			for i,v in pairs(player:GetAccessoryData()) do
				local itemTable = player:FindItemByID(v, i);
				//print(self.equipmentSlot, itemTable.equipmentSlot, itemTable.equipmentSlot == self.equipmentSlot)
				if (self.equipmentSlot and itemTable and itemTable.equipmentSlot and itemTable.equipmentSlot == self.equipmentSlot) then
					local itemInstance = player:GetItemInstance(string.lower(v), i);

					//print(self, itemInstance)

					if (itemInstance != self) then
						player:RemoveAccessory(itemInstance);
					end;
				end;
			end;
		end;
		if (self.OnAccessoryEquip) then
			self:EquipEffects(player);
			self:OnAccessoryEquip(player);
		end;
	else
		if (self.OnAccessoryUnequip) then
			self:UnequipEffects(player);
			self:OnAccessoryUnequip(player);
		end;
	end;
end;

function ITEM:EquipEffects(player)
	player:ApplyMovementMultiplier(self.wearSpeedMod);
end;

function ITEM:UnequipEffects(player)
	player:ApplyMovementMultiplier(1 / self.wearSpeedMod);
end;

function ITEM:CanPlayerWear(player, itemEntity)
	local accessoryData = player:GetAccessoryData();

	if (self.CanEquip and !self:CanEquip(player, itemEntity, accessoryData)) then return false end;

	local hasRequiredItem = false;
	local hasRequiredOpenedSlot = false;
	local openSlots = true;
	for i,v in pairs(player:GetAccessoryData()) do
		local itemTable = player:FindItemByID(v, i);

		if (itemTable("incompatibleSlots") and itemTable("incompatibleSlots")[self.equipmentSlot]) then return false end;

		if (self("incompatibleSlots") and self("incompatibleSlots")[itemTable.equipmentSlot]) then return false end;

		if (self.requiredOpenedSlot and itemTable("openedSlots")[self.requiredOpenedSlot]) then
			hasRequiredOpenedSlot = true;
		end;

		if (self.requiredWearItem and self.requiredWearItem == itemTable("uniqueID")) then
			hasRequiredItem = true;
		end;
	end;

	return ((!self.requiredWearItem) or (self.requiredWearItem and hasRequiredItem)) and ((!self.requiredOpenedSlot) or (self.requiredOpenedSlot and hasRequiredItem));

	/*if (self.requiredWearItem) then
		local hasWearItem = false;

		for i,v in pairs(accessoryData) do
			local itemTable = player:FindItemByID(v, i);
			if (self.requiredWearItem == itemTable("uniqueID")) then
				return true;
			end;
		end;

		return false;
	end;

	if (self.incompatibleSlots) then
		for k,b in pairs(self.incompatibleSlots) do
			for i,v in pairs(accessoryData) do
				local itemTable = player:FindItemByID(v, i);
				if (k == itemTable("equipmentSlot")) then
					return false;
				end;
			end;
		end;
	end;*/
end;

function ITEM:OnInstantiated()
	if (SERVER and !self:GetData("Condition")) then
		self:SetData("Condition", self.maxCondition);
	end;

	//print(self.wearingTakesSpace, self.wearPocketSpace, self("weight"))

	if (self.wearingTakesSpace == false and !self.wearPocketSpace) then
		self.wearPocketSpace = self("weight");
	end;
end;

function ITEM:GetCondition()
	return self:GetData("Condition");
end;

function ITEM:DamageCondition(player, damageInfo, hitGroup)
	local oldCond = self:GetCondition();
	local newCond = math.Clamp(oldCond-(self.resistance*damageInfo:GetDamage()), 0, math.huge);

	self:SetData("Condition", newCond);
end;

function ITEM:GetMaxDamage()
	local dmgModifier = Clockwork.config:Get("scale_chest_dmg"):Get();

	/*if (ConVarExists("ehl2w_damage_scale")) then
		dmgModifier = dmgModifier * GetConVar("ehl2w_damage_scale"):GetFloat();
	end;*/

	//print("Max damage is ", self.maxDamage * dmgModifier)

	return self.maxDamage * dmgModifier;
end;

function ITEM:CanDamageCondition(player, damageInfo, hitGroup)
	local correctDMGType = false;
	local correctHitGroup = false;

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

function ITEM:TakeDamage(player, damageInfo, hitGroup)
	local canDamageCondition = false;

	if (self.CanDamageCondition and self:CanDamageCondition(player, damageInfo, hitGroup)) then
		canDamageCondition = true;
	end;

	if (canDamageCondition) then
		self:DamageCondition(player, damageInfo, hitGroup);
	end;

	//print(self.canTakeDamage, self:CanDamageCondition(player, damageInfo, hitGroup), "YEAH YELLOW STREAM")

	if (self.canTakeDamage and canDamageCondition and math.random(1, 100) <= self.damageChance) then
		//print("LETS DOOOO IIIIT")

		local tbl = self:GetData("Damage");
		local shatter = "decals/glass/shot"..tostring(math.random(1, 5));

		table.insert(tbl, {material = shatter, x = math.Rand(.026, .885), y = math.Rand(.046, .852), size = math.Rand(.185, .463)});
		self:SetData("Damage", tbl);

		local snd = Sound("physics/glass/glass_impact_bullet"..tostring(math.random(1,4))..".wav")

		player:EmitSound(snd);
	end;

	if (self.OnTakeDamage) then
		self:OnTakeDamage(player, damageInfo, hitGroup);
	end;

	Clockwork.item:SendUpdate(self, self.data);
end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local markupText = "";

		if self.equipmentSlot then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Equipment Slot: "..self.equipmentSlot:gsub("^%l", string.upper));
		end;

		if self("incompatibleSlots") then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Incompatible Slots:");
			for i, v in pairs(self("incompatibleSlots")) do
				markupText = Clockwork.kernel:AddMarkupLine(markupText, " - "..i:gsub("^%l", string.upper));
			end;
		end;

		if self.armorClass then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Armor Rating: "..self.armorClass);
		end;

		if self.showCondition then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Condition: ".. math.Round(self:GetData("Condition")).. "/"..self.maxCondition);
		end;

		if self.wearPocketSpace and !self.wearingTakesSpace then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Capacity: "..self.wearPocketSpace.."kg");
		end;

		if self.wearSpeedMod then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Speed Modifier: "..(self.wearSpeedMod * 100).."% Move Speed");
		end;

		if self.ExtraClientSideInfo and self:ExtraClientSideInfo(markupText) then
			markupText = self:ExtraClientSideInfo(markupText);
		end;

		/*if (Clockwork.player:IsWearingItem(self)) then
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Wearing: Yes");
		else
			markupText = Clockwork.kernel:AddMarkupLine(markupText, "Wearing: No");
		end;*/

		return (markupText != "" and markupText);
	end;
end;

ITEM:Register();
