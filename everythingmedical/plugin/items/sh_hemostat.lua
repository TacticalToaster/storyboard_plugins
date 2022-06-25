--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Hemostat";
ITEM.uniqueID = "hemostat";
ITEM.model = "models/props_c17/tools_pliers01a.mdl";
ITEM.weight = .2;
ITEM.useText = "Apply";
ITEM.category = "Medical - Bleeds"
ITEM.combatMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A semi-reusable pair of surgical forceps. Some training is required to use.";
ITEM.totalUses = 3;

ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	//if (player:GetCharacterData("medic") < 2) then
	if (Clockwork.attributes:Fraction(player, ATB_COMBATMEDICINE, 1, 0) < .3) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("gunshot wound") or target:HasInjury("laceration")) then
			target:TreatInjuries("gunshot wound", player);
			target:TreatInjuries("laceration", player);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully stopped all bleeding!");
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to be bleeding!");
			return false;
		end;
	else
		Clockwork.player:Notify(player, "You aren't close enough to somebody to treat them!");
		return false;
	end;

	local currentUses = self:GetData("Uses");

	if (currentUses + 1 < self.totalUses) then
		self:SetData("Uses", currentUses + 1);
		return true;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local markupText = "";
		
		markupText = Clockwork.kernel:AddMarkupLine(markupText, "Uses left: "..self.totalUses - self:GetData("Uses") or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Total health amount: ".. self.totalHeal or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Time to heal: ".. self.totalTime or 1);

		return (markupText != "" and markupText);
	end;
end;

ITEM:Register();