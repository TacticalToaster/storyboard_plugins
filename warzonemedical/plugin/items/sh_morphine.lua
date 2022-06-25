--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Morphine Autoinjector";
ITEM.uniqueID = "morphine";
ITEM.model = "models/illusion/eftcontainers/medsyringe.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Inject";
ITEM.category = "Medical - Injectors"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "An intramuscular autoinjector containing a powerful opioid.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	/*if (player:GetCharacterData("medic") < 2) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end*/

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local pain = target:GetCharacterData("pain");
		local respiration = target:GetCharacterData("respiration");

		target:SetCharacterData("pain", pain - 20);
		//target:SetCharacterData("respiration", respiration - 10);
		target.combatBoost = CurTime() + 100;
		target:SetHealth( math.Clamp( target:Health() + 15, 0, target:GetMaxHealth() ) );
		Clockwork.chatBox:Add(player, nil, "treat", "* You have injected the morphine into the patient!");
		Clockwork.chatBox:Add(target, nil, "treat", "* You feel your pain lessen moderately, but you also feel a little fuzzy and breathing feels slightly more difficult.");
	else
		local pain = player:GetCharacterData("pain");
		local respiration = player:GetCharacterData("respiration");

		player:SetCharacterData("pain", pain - 20);
		//player:SetCharacterData("respiration", respiration - 10);
		player.combatBoost = CurTime() + 100;
		player:SetHealth( math.Clamp( player:Health() + 15, 0, player:GetMaxHealth() ) );
		Clockwork.chatBox:Add(player, nil, "treat", "* You have injected yourself with the morphine. You feel your pain lessen moderately, but you also feel a little fuzzy and breathing feels slightly more difficult.");
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