--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Opaque Dressing";
ITEM.uniqueID = "opaque_dressing";
ITEM.model = "models/props_wasteland/prison_toiletchunk01a.mdl";
ITEM.weight = .3;
ITEM.useText = "Apply";
ITEM.category = "Medical - Decompression"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A plastic, opaque dressing that has an adhesive applied to one side.";

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
		if (target:HasInjury("sucking chest wound")) then
			target:TreatInjuries("sucking chest wound", player);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully applied the opaque dressing!");
		else
			Clockwork.player:Notify(player, "The patient doesn't need the dressing!");
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