--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

include("shared.lua")

-- Called each frame.
function ENT:Think()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		Clockwork.entity:FetchItemData(self);
		return;
	end;
	
	local playerEyePos = Clockwork.Client:EyePos();
	local player = self:GetPlayer();
	local eyePos = EyePos();
	
	if (IsValid(player)) then
		local isPlayer = player:IsPlayer();
		
		if ((eyePos:Distance(playerEyePos) > 10 or GetViewEntity() != Clockwork.Client
		or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive())) then
			self:SetNoDraw(false);
		else
			self:SetNoDraw(true);
		end;

		if (player:IsPlayer() and player:IsRagdolled()) then
			self:SetNoDraw(false);
		end;
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		return;
	end;

	local playerEyePos = Clockwork.Client:EyePos();
	local colorTable = self:GetColor();
	local itemTable = Clockwork.entity:FetchItemTable(self);
	local modelScale = itemTable("attachmentModelScale", Vector(1, 1, 1));
	local bDrawModel = false;
	local eyePos = EyePos();
	local player = self:GetPlayer();
	local ragdolled = false;
	local isPlayer = player:IsPlayer();

	if (isPlayer) then
		ragdolled = player:IsRagdolled();
	else
		if (IsValid(player)) then
			bDrawModel = true;
		end;
	end;
	
	if (IsValid(player) and isPlayer and (player:GetMoveType() == MOVETYPE_WALK
	or ragdolled or player:InVehicle())) then
		
		if (itemTable.GetAttachmentModelScale) then
			modelScale = itemTable:GetAttachmentModelScale(player, self) or modelScale;
		end;

		if (ragdolled) then
			bDrawModel = true;
		end;
		
		if ((eyePos:Distance(playerEyePos) > 10 or GetViewEntity() != Clockwork.Client
		or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive()) and colorTable.a > 0) then
			bDrawModel = true;
		end;
	end;

	if (false) then
		local entityMatrix = Matrix();
			entityMatrix:Scale(modelScale);
		self:EnableMatrix("RenderMultiply", entityMatrix);
	end;
	
	if (bDrawModel and Clockwork.plugin:Call("GearEntityDraw", self) != false) then
		self:SetupBones();
		self:DrawModel();
	end;
end;