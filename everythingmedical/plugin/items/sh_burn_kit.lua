--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Burn Kit";
ITEM.uniqueID = "burn_kit";
ITEM.model = "models/illusion/eftcontainers/sicccase.mdl";
ITEM.weight = 1.2;
ITEM.useText = "Open";
ITEM.category = "Medical - Kits"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A package containing two tubes of Burn-Gel, Morphine auto-injectors, and sterile bandages.";
//ITEM.totalUses = 2;

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("burn_gel"), true);
	player:GiveItem(Clockwork.item:CreateInstance("burn_gel"), true);
	player:GiveItem(Clockwork.item:CreateInstance("morphine"), true);
	player:GiveItem(Clockwork.item:CreateInstance("morphine"), true);
	player:GiveItem(Clockwork.item:CreateInstance("sterile_gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("sterile_gauze"), true);

	/*
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);

	if (player:GetCharacterData("medic") < 2) then
		Clockwork.player:Notify(player, "You aren't trained to use this item!");
		return false;
	end

	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("burn wound")) then
			target:TreatInjuries("burn wound");
			Clockwork.chatBox:Add(player, nil, "treat", "* You have successfully alleviated the pain!");
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to be burned!");
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
	*/
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();