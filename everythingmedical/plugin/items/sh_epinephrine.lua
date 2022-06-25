--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Epinephrine Autoinjector";
ITEM.uniqueID = "epinephrine";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/adrenaline.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Inject";
ITEM.category = "Medical - Injectors";
ITEM.fieldMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small syringe with a tiny label.";

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
		if (target:HasInjury("unconsciousness")) then
			target.reviveTime = CurTime() + 3;
			target.combatBoost = CurTime() + 60;
			target:SetCharacterData("pain", pain - 10);
			//target:SetCharacterData("respiration", respiration - 5);
			target:SetHealth( math.Clamp( target:Health() + 5, 0, target:GetMaxHealth() ) );
			Clockwork.chatBox:Add(player, nil, "treat", "* You have administered the epinephrine to the patient!");
			Clockwork.chatBox:Add(target, nil, "treat", "* In a span of a few seconds you're able to get up, adrenaline pumping in your veins.");
		else
			Clockwork.player:Notify(player, "The patient can't take the injector while conscious!");
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