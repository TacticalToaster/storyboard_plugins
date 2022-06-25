--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Decompression Kit";
ITEM.uniqueID = "decompression_kit";
ITEM.model = "models/health/medkit.mdl";
ITEM.weight = 1;
ITEM.useText = "Apply";
ITEM.category = "Medical - Decompression"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A package containing a decompression needle and a plastic catheter.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (player:GetCharacterData("medic") < 3) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end
	
	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local respiration = target:GetCharacterData("respiration");

		if (target:HasInjury("tension pneumothorax")) then
			local applyTime = math.random(15, 20);
			applyTime = applyTime * player:GetActionTimeModifier();
			
			Clockwork.player:SetAction(player, "decompressionKit", applyTime);

			Clockwork.player:EntityConditionTimer(player, target, entity, applyTime, 192, function() if (player:Alive() and (target:HasInjury("tension pneumothorax"))) then return true end end, function(success)
				if (success) then
					target:TreatInjuries("tension pneumothorax", player);
					target:SetCharacterData("respiration", respiration + 50);
					Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully used the decompression kit!");
					Clockwork.chatBox:Add(target, nil, "treat", "* The medic forces a needle into your chest, and immediately you have an easier time breathing.");

					player:TakeItem(self);
				end;

				Clockwork.player:SetAction(player, "decompressionKit", false);

			end);

			return false;
			/*
			target:TreatInjuries("tension pneumothorax");
			target:SetCharacterData("respiration", respiration + 50);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully used the decompression kit!");
			Clockwork.chatBox:Add(target, nil, "treat", "* The medic forces a needle into your chest, and immediately you have an easier time breathing.");
			*/
		else
			Clockwork.player:Notify(player, "The patient doesn't need the kit!");
			return false;
		end;
	else
		Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them!");
		return false;
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
