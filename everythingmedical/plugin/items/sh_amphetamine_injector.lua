--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Amphetamine Autoinjector";
ITEM.uniqueID = "amphetamine_injector";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/sj1.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Apply";
ITEM.category = "Medical - Injectors"
ITEM.fieldMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "An intramuscular autoinjector containing a cognitive and performance enhancing stimulant.";

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

		target:SetCharacterData("pain", pain - 15);
		//target:SetCharacterData("respiration", respiration - 5);
		target.combatBoost = CurTime() + 90;
		target:SetHealth( math.Clamp( target:Health() + 10, 0, target:GetMaxHealth() ) );
		Clockwork.chatBox:Add(player, nil, "treat", "* You have injected the amphetamine into the patient!");
		Clockwork.chatBox:Add(target, nil, "treat", "* You feel your pain lessen slightly and your mind sharpen rapidly.");
	else
		local pain = player:GetCharacterData("pain");
		local respiration = player:GetCharacterData("respiration");

		player:SetCharacterData("pain", pain - 15);
		//player:SetCharacterData("respiration", respiration - 5);
		player.combatBoost = CurTime() + 90;
		player:SetHealth( math.Clamp( player:Health() + 10, 0, player:GetMaxHealth() ) );
		Clockwork.chatBox:Add(player, nil, "treat", "* You have injected yourself with the amphetamine autoinjector. You feel your pain lessen slightly and your mind sharpen rapidly.");
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