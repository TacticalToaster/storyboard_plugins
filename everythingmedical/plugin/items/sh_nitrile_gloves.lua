--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Nitrile Gloves";
ITEM.uniqueID = "nitrile_gloves";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/bandage.mdl";
ITEM.weight = .1;
ITEM.useText = "Wear";
ITEM.category = "Medical - Misc."
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A pair of thin, tan gloves that seem rather stretchy.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	
	if (!player.glovesTime or player.glovesTime == 0) then
		local applyTime = math.random(1, 2);
		applyTime = applyTime * player:GetActionTimeModifier();

		info = {
			applyTime = applyTime
		};

		Clockwork.plugin:Call("PlayerAdjustMedicalApplyTime", player, target, self, info);

		applyTime = info.applyTime;
		
		Clockwork.player:SetAction(player, "wearingGloves", applyTime);

		Clockwork.player:ConditionTimer(player, applyTime, function() if (player:Alive()) then return true end end, function(success)
			if (success) then
				player.glovesPatient = "";
				player.glovesTime = CurTime() + math.random(600, 720);

				player:TakeItem(self);
			end;

			Clockwork.player:SetAction(player, "wearingGloves", false);

		end);

		return false;
	else
		Clockwork.player:Notify(player, "You already are wearing a pair of gloves.");
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