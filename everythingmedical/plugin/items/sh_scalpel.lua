--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Scalpel";
ITEM.uniqueID = "scalpel";
ITEM.model = "models/gibs/metal_gib5.mdl";
ITEM.weight = 1;
ITEM.useText = "Apply";
ITEM.category = "Medical - Decompression"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A thin metal instrument.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (player:GetCharacterData("medic") < 2) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end
	
	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local respiration = target:GetCharacterData("respiration");
		local pain = target:GetCharacterData("pain");

		if (target:HasInjury("tension pneumothorax")) then
			target:TreatInjuries("tension pneumothorax", player);
			target:SetCharacterData("pain", pain + 30);
			target:SetCharacterData("respiration", respiration + 50);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully performed a finger thoracostomy!");
			Clockwork.chatBox:Add(target, nil, "treat", "* You feel the medic cut into your side and put his finger inside you. Breathing is much easier, but the pain makes you feel like a little bitch.");
		else
			Clockwork.player:Notify(player, "The patient doesn't need the procedure!");
			return false;
		end;
	else
		Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them!");
		return false;
	end;

	return true;

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
