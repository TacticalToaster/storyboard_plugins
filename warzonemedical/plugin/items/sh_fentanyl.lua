--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Fentanyl Syringe";
ITEM.uniqueID = "fentanyl";
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.4;
ITEM.useText = "Inject";
ITEM.category = "Medical - Injectors";
ITEM.combatMed = true;
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A syringe containing a staggeringly powerful opioid meant to be injected intravenously. It comes with a small IV kit, making basic training required to use.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	//if (player:GetCharacterData("medic") < 3) then
	if (Clockwork.attributes:Fraction(player, ATB_COMBATMEDICINE, 1, 0) < .25) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		local pain = target:GetCharacterData("pain");
		local respiration = target:GetCharacterData("respiration");

		target:SetCharacterData("pain", pain - 40);
		//target:SetCharacterData("respiration", respiration - 20);
		target.combatBoost = CurTime() + 180;
		target:SetHealth( math.Clamp( target:Health() + 20, 0, target:GetMaxHealth() ) );
		Clockwork.chatBox:Add(player, nil, "treat", "* You have injected the fentanyl into the patient!");
		Clockwork.chatBox:Add(target, nil, "treat", "* You feel your pain lessen significantly, but you also feel really fuzzy and breathing feels more difficult.");
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