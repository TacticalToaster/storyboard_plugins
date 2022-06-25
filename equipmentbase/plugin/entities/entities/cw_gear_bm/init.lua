--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE);
   	self:SetSolid(SOLID_NONE);
	self:SetNotSolid(true);
	self:DrawShadow(false);
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to get whether the entity should exist.
function ENT:GetShouldExist(player)
	local itemTable = self:GetItemTable();
	
	if (itemTable) then
		if (itemTable.GetAttachmentExists) then
			return itemTable:GetAttachmentExists(player, self);
		elseif (!self.ForcedEntity and Clockwork.item:IsWeapon(itemTable)) then
			if (player:IsRagdolled()) then
				return player:RagdollHasWeapon(itemTable("weaponClass"));
			else
				return player:HasWeapon(itemTable("weaponClass"));
			end;
		else
			return true;
		end;
	end;
end;

-- A function to get whether the entity is visible.
function ENT:GetIsVisible(player)
	local itemTable = self:GetItemTable();
	
	if (itemTable) then
		if (itemTable.GetAttachmentVisible) then
			return itemTable:GetAttachmentVisible(player, self);
		elseif (!self.ForcedEntity and Clockwork.item:IsWeapon(itemTable)) then
			return Clockwork.player:GetWeaponClass(player) != itemTable("weaponClass");
		else
			return true;
		end;
	end;
end;

-- A function to set whether the player must have the item.
function ENT:SetMustHave(bMustHave)
	self.cwMustHave = bMustHave;
end;

-- A function to set the entity's item.
function ENT:SetItemTable(gearClass, itemTable)
	self.cwGearClass = gearClass;
	self.cwItemTable = itemTable;
	self:SetDTInt(0, itemTable("index"));
end;

-- Called each frame.
function ENT:Think()
	local player = self:GetPlayer();
	
	if (!IsValid(player) or !self:GetShouldExist(player)) then
		self:Remove();
		return;
	end;
	
	local entityColor = self:GetColor();
	
	if (!self:GetIsVisible(player)) then
		self:SetColor(Color(entityColor.r, entityColor.g, entityColor.b, 0));
		self:SetNoDraw(true);
	else
		self:SetColor(Color(entityColor.r, entityColor.g, entityColor.b, 255));
		self:SetNoDraw(false);
	end;
	
	self:SetMaterial(player:GetMaterial());
	
	local model = self.cwItemTable(
		"attachmentModel", self.cwItemTable("model")
	);

	if (self.ForcedModel) then
		model = self.ForcedModel;
	end;

	if (!self.ForcedEntity and player:IsRagdolled()) then
		if (self:GetParent() != player:GetRagdollEntity()) then
			self:SetParent(player:GetRagdollEntity(), 0);
		end; 
	end;
	
	if (self:GetModel() != model or (self.cwItemTable.ShouldGearRespawn
	and self.cwItemTable:ShouldGearRespawn(self))) then
		if (!self.ForcedEntity) then
			Clockwork.player:CreateGearBM(
				player, self.cwGearClass, self.cwItemTable
			)
		else
			Clockwork.entity:CreateGearBM(
			player, self.cwGearClass, self.cwItemTable
		)
		end;
	end;
	
	if (self.cwMustHave and ((!self.ForcedEntity and !player:HasItemInstance(self.cwItemTable)) or (self.ForcedEntity and ((player.GetInventory and !Clockwork.inventory:HasItemInstance(player:GetInventory(), self.cwItemTable)) or (player.cwInventory and !Clockwork.inventory:HasItemInstance(player.cwInventory, self.cwItemTable)))))) then
		Clockwork.player:RemoveGear(
			player, self.cwGearClass
		);
	end;
end;