--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Medical Base";
ITEM.uniqueID = "medical_base";
ITEM.model = "models/illusion/eftcontainers/bandage.mdl";
ITEM.weight = .1;
ITEM.useText = "Wrap";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
ITEM.totalUses = 1;
ITEM.timeMin = 2;
ITEM.timeMax = 3;
ITEM.injuries = {
	["gunshot wound"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "finishes wrapping a bandage around the open wound."},
	["laceration"] = {["applyMod"] = 1, ["heal"] = 5, ["treatText"] = "finishes wrapping a bandage around the open laceration."}
};
ITEM.treatCompletely = false;
ITEM.treatSelf = true;
ITEM.applyTextSelf = "applyingBandageSelf";
ITEM.applyTextPatient = "applyingBandagePatient";
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small sealed bandage for quick application on minor wounds.";

ITEM:AddData("Uses", 0, true);

function ITEM:OnTreat(player, itemEntity, target, entity)
	for i2,v2 in pairs(self.injuries) do
		if (target:HasInjury(i2)) then
			if self.treatCompletely then
				target:TreatInjuries(i2, player);
				//success = true;
			else
				target:TreatInjury(i2, player);
				if v2.replaceInjury then target:GiveInjury(v2.replaceInjury) end;
				if v2.treatText then Clockwork.chatBox:AddInTargetRadius(player, "me", v2.treatText, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2) end;
				if v2.heal and target:IsPlayer() then target:SetHealth( math.Clamp( target:Health() + v2.heal, 0, target:GetMaxHealth() ) ) end;
				//success = true;
				break;
			end;
		end;
	end;

	if self.treatText then Clockwork.chatBox:AddInTargetRadius(player, "me", self.treatText, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2) end;
	if self.heal and target:IsPlayer() then target:SetHealth( math.Clamp( target:Health() + self.heal, 0, target:GetMaxHealth() ) ) end;

	return true;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (entity and (target or (entity.CanReceiveTreatment and entity:CanReceiveTreatment(self, player))) and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if entity.CanReceiveTreatment then target = entity end;
	elseif (self.treatSelf) then
		entity = player;
		target = player;
	else
		Clockwork.player:Notify(player, "You aren't close enough to someone who needs treatment!");
		return false;
	end;

	local foundInjury = false;

	for i,v in pairs(self.injuries) do
		if (target:HasInjury(i)) then
			foundInjury = v;
		end;
	end;

	if !foundInjury then
		Clockwork.player:Notify(player, "No injuries to treat were found!");
		return false;
	else
		applyTime = math.random(self.timeMin, self.timeMax) * foundInjury.applyMod;

		info = {
			applyTime = applyTime
		};

		Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, target, self, info);

		applyTime = info.applyTime;

		local actionText = self.applyTextPatient;

		if entity == player then actionText = self.applyTextSelf end;

		Clockwork.player:SetAction(player, actionText, applyTime);

		local conditionCheckFunction = function()
			if (player:Alive() and player:HasItemInstance(self)) then
				for i2,v2 in pairs(self.injuries) do
					if (target:HasInjury(i2)) then return true end;
				end;
		   	end;
		end

		local conditionSuccessFunction = function(success)
			if (success) then
				if target.OnTreat then
					success = entity:OnTreat(self, player);
					if item.EntityTreat then
						item:EntityTreat(entity, player);
					end;
				end;

				/*for i2,v2 in pairs(self.injuries) do
					if self.treatCompletely then
						target:TreatInjuries(i2, player);
						success = true;
					else
						target:TreatInjury(i2, player);
						if v2.treatText then Clockwork.chatBox:AddInTargetRadius(player, "me", v2.treatText, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2) end;
						if v2.heal and IsPlayer(target) then target:SetHealth( math.Clamp( target:Health() + v2.heal, 0, target:GetMaxHealth() ) ) end;
						success = true;
						break;
					end;
				end;*/

				if self.OnTreat then
					success = self:OnTreat(player, itemEntity, target, entity)
				end;

				//if self.treatText then Clockwork.chatBox:AddInTargetRadius(player, "me", self.treatText, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2) end;
				//if self.heal and IsPlayer(target) then target:SetHealth( math.Clamp( target:Health() + self.heal, 0, target:GetMaxHealth() ) ) end;

				//success = true;

				if (success) then
					local currentUses = self:GetData("Uses");

					if (currentUses + 1 < self.totalUses) then
						self:SetData("Uses", currentUses + 1);
					else
						player:TakeItem(self);
					end;
				end;
			end;

			Clockwork.player:SetAction(player, actionText, false);
		end;

		if (player == target) then
			Clockwork.player:ConditionTimer(player, applyTime, conditionCheckFunction, conditionSuccessFunction);
		else
			Clockwork.player:EntityConditionTimer(player, target, entity, applyTime, 192, conditionCheckFunction, conditionSuccessFunction);
		end;

		return false;
	end;

	/*local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("gunshot wound")) then
			target:TreatInjury("gunshot wound");
			target:SetHealth( math.Clamp( target:Health() + 15, 0, target:GetMaxHealth() ) );
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped bleeding from a gunshot wound in the patient!");
		elseif (target:HasInjury("laceration")) then
			target:TreatInjury("laceration");
			target:SetHealth( math.Clamp( target:Health() + 15, 0, target:GetMaxHealth() ) );
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped bleeding from a laceration in the patient!");
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to be bleeding!");
			return false;
		end;
	else
		if (player:HasInjury("gunshot wound")) then
			player:TreatInjury("gunshot wound");
			player:SetHealth( math.Clamp( player:Health() + 15, 0, player:GetMaxHealth() ) );
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped your bleeding from a gunshot wound!");
		elseif (player:HasInjury("laceration")) then
			player:TreatInjury("laceration");
			player:SetHealth( math.Clamp( player:Health() + 15, 0, player:GetMaxHealth() ) );
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped your bleeding from a laceration!");
		else
			Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them, and you don't need to be treated!");
			return false;
		end;
	end;*/

	/*local currentUses = self:GetData("Uses");

	if (currentUses + 1 < self.totalUses) then
		self:SetData("Uses", currentUses + 1);
		return true;
	end;*/
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local markupText = "";

		markupText = Clockwork.kernel:AddMarkupLine(markupText, "Uses left: "..self.totalUses - self:GetData("Uses") or 1);

		markupText = Clockwork.kernel:AddMarkupLine(markupText, "Treats:");

		for i,v in pairs(self.injuries) do
			markupText = Clockwork.kernel:AddMarkupLine(markupText, " - "..Clockwork.injury:FindByID(i).name);
		end;
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Total health amount: ".. self.totalHeal or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Time to heal: ".. self.totalTime or 1);

		return (markupText != "" and markupText);
	end;
end;

ITEM:Register();