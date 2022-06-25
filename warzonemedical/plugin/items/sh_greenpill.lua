--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Codenine Pill";
ITEM.uniqueID = "greenpill";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/analgin.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Take";
ITEM.category = "Medical - Oral"
ITEM.fieldMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "An oral-based opiate meant to treat minor to moderate pain. It's a small green pill.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	/*if (player:GetCharacterData("medic") < 1) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end*/

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local pain = target:GetCharacterData("pain");
		if (!target:HasInjury("unconsciousness")) then
			target:SetCharacterData("pain", pain - 15);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have given the patient the pill!");
		else
			Clockwork.player:Notify(player, "The patient can't take the pill while unconscious!");
			return false;
		end;
	else
		local pain = player:GetCharacterData("pain");
		player:SetCharacterData("pain", pain - 15);
		Clockwork.chatBox:Add(player, nil, "treat", "* You have taken the pill!");
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