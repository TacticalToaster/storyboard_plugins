--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Nasopharyngeal Airway";
ITEM.uniqueID = "airway";
ITEM.model = "models/gibs/scanner_gib04.mdl";
ITEM.weight = 0.3;
ITEM.useText = "Apply";
ITEM.category = "Medical - Respiration"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A way to open someone's airways.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("unconsciousness") and !target:GetInjury("unconsciousness").airway) then
			if (player:GetCharacterData("medic") < 1) then
				if (math.random(0, 1) == 1) then
					target:SetInjuryData("unconsciousness", "airway", true);
					Clockwork.chatBox:Add(player, nil, "treat", "* You have applied the airway successfully!");
				else
					Clockwork.chatBox:Add(player, nil, "injury", "* You failed to properly apply the airway and have hurt the patient!");
					target:SetCharacterData("pain", pain + 5);
				end;
			else
				target:SetInjuryData("unconsciousness", "airway", true);
				Clockwork.chatBox:Add(player, nil, "treat", "* You have applied the airway successfully!");
			end;
		else
			Clockwork.player:Notify(player, "The patient doesn't need an airway!");
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