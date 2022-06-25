local INJURY = Clockwork.injury:New();
INJURY.name = "Burn Wound";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Injury to the skin caused by a high amount of heat.";
INJURY.victim = "There’s a non-stop, extremely intense burning sensation. Checking your injury, you find your skin to be nearly charred.";
INJURY.limit = 3;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 10);
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 10);
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 10);
end;

INJURY:Register();

