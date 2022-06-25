--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Burn Gel";
ITEM.uniqueID = "burn_gel";
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = .2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Burns"
//ITEM.fieldMed = true;
ITEM.combatMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small tube of blue gel. It feels cool to the touch.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("burn wound")) then
			local applyTime = math.random(4, 8);
			applyTime = applyTime * player:GetActionTimeModifier();

			info = {
				applyTime = applyTime
			};

			Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, target, self, info);

			applyTime = info.applyTime;
			
			Clockwork.player:SetAction(player, "applyingBurnGel", applyTime);

			Clockwork.player:EntityConditionTimer(player, target, entity, applyTime, 192, function() if (player:Alive() and (target:HasInjury("burn wound"))) then return true end end, function(success)
				if (success) then
					target:TreatInjury("burn wound", player);
					Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully alleviated the patient's pain!");
					player:TakeItem(self);
				end;

				Clockwork.player:SetAction(player, "applyingBurnGel", false);

			end);

			return false;

			/*
			target:TreatInjuries("burn wound");
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully alleviated the patient's pain!");
			*/
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to be burned!");
			return false;
		end;
	else
		if (player:HasInjury("burn wound")) then
			local applyTime = math.random(4, 8);
			applyTime = applyTime * player:GetActionTimeModifier();

			info = {
				applyTime = applyTime
			};

			print(info.applyTime, "BEFORE")

			Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, player, self, info);

			print(info.applyTime, "AFTER")

			applyTime = info.applyTime;
			
			Clockwork.player:SetAction(player, "applyingBurnGel", applyTime);

			Clockwork.player:ConditionTimer(player, applyTime, function() if (player:Alive() and (player:HasInjury("burn wound"))) then return true end end, function(success)
				if (success) then
					player:TreatInjury("burn wound", player);
					Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully alleviated your pain!");
					player:TakeItem(self);
				end;

				Clockwork.player:SetAction(player, "applyingBurnGel", false);

			end);

			return false;

			/*
			player:TreatInjuries("burn wound");
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully alleviated your pain!");
			*/
		else
			Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them, and you don't need to be treated!");
			return false;
		end;
	end;

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
