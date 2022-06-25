--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Sterile Bandage";
ITEM.uniqueID = "sterile_bandage";
ITEM.model = "models/illusion/eftcontainers/bandage.mdl";
ITEM.weight = .1;
ITEM.useText = "Wrap";
ITEM.category = "Medical - Bleeds"
ITEM.fieldMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small sealed bandage for quick application on minor wounds.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("gunshot wound") or target:HasInjury("laceration")) then
			local applyTime = math.random(2, 3);
			applyTime = applyTime * player:GetActionTimeModifier();

			info = {
				applyTime = applyTime
			};

			Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, target, self, info);

			applyTime = info.applyTime;

			Clockwork.player:SetAction(player, "applyingBandagePatient", applyTime);

			Clockwork.player:EntityConditionTimer(player, target, entity, applyTime, 192, function() if (player:Alive() and (target:HasInjury("gunshot wound") or target:HasInjury("laceration"))) then return true end end, function(success)
				if (success) then
					if (math.random(0, 1) == 1) then
						if (target:HasInjury("gunshot wound")) then
							target:TreatInjury("gunshot wound", player);
							target:SetHealth( math.Clamp( target:Health() + 3, 0, target:GetMaxHealth() ) );
							Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped bleeding from a gunshot wound in the patient!");
						elseif (target:HasInjury("laceration")) then
							target:TreatInjury("laceration", player);
							target:SetHealth( math.Clamp( target:Health() + 3, 0, target:GetMaxHealth() ) );
							Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped bleeding from a laceration in the patient!");
						end;
					else
						Clockwork.chatBox:Add(player, nil, "injury", "* The bandage failed to stop any bleeding!");
					end;

					player:TakeItem(self);
				end;

				Clockwork.player:SetAction(player, "applyingBandagePatient", false);

			end);

			return false;
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to be bleeding!");
			return false;
		end;
	else
		if (player:HasInjury("gunshot wound") or player:HasInjury("laceration")) then
			local applyTime = math.random(3, 4);
			applyTime = applyTime * player:GetActionTimeModifier();

			info = {
				applyTime = applyTime
			};

			Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, target, self, info);

			applyTime = info.applyTime;
			
			Clockwork.player:SetAction(player, "applyingBandageSelf", applyTime);

			Clockwork.player:ConditionTimer(player, applyTime, function() if (player:Alive() and (player:HasInjury("gunshot wound") or player:HasInjury("laceration"))) then return true end end, function(success)
				if (success) then
					if (math.random(0, 1) == 1) then
						if (player:HasInjury("gunshot wound")) then
							player:TreatInjury("gunshot wound", player);
							player:SetHealth( math.Clamp( player:Health() + 3, 0, player:GetMaxHealth() ) );
							Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped your bleeding from a gunshot wound!");
						elseif (player:HasInjury("laceration")) then
							player:TreatInjury("laceration", player);
							player:SetHealth( math.Clamp( player:Health() + 3, 0, player:GetMaxHealth() ) );
							Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped your bleeding from a laceration!");
						end;
					else
						Clockwork.chatBox:Add(player, nil, "injury", "* The bandage failed to stop any bleeding!");
					end;

					player:TakeItem(self);
				end;

				Clockwork.player:SetAction(player, "applyingBandageSelf", false);

			end);

			return false;
		else
			Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them, and you don't need to be treated.");
			return false;
		end;
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
/*
if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local markupText = "";
		
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Uses left: ".. self:GetData("Uses") or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Total health amount: ".. self.totalHeal or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Time to heal: ".. self.totalTime or 1);

		return (markupText != "" and markupText);
	end;
end;*/

ITEM:Register();