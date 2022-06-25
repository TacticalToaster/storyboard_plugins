--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Paracetamol Tablets";
ITEM.uniqueID = "paracetamol";
ITEM.model = "models/illusion/eftcontainers/painkiller.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Take";
ITEM.category = "Medical - Oral"
ITEM.fieldMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A pack containing 10 650mg tablets. The package instructs to one both every 8 hours.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local pain = target:GetCharacterData("pain");
		if (!target:HasInjury("unconsciousness")) then
			target:SetCharacterData("pain", pain - 8);
			Clockwork.chatBox:Add(player, nil, "treat", "* You have given the patient the tablets!");
		else
			Clockwork.player:Notify(player, "The patient can't take the pill while unconscious!");
			return false;
		end;
	else
		local pain = player:GetCharacterData("pain");
		player:SetCharacterData("pain", pain - 8);
		Clockwork.chatBox:Add(player, nil, "treat", "* You have taken the tablets!");
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