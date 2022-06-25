local INJURY = Clockwork.injury:New();
INJURY.name = "Damaged Sight";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Massive damage to the optic nerve or eye.";
INJURY.victim = "Trauma to your head has damaged your eye sight permanently.";
INJURY.limit = 1;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 10);
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
end;

INJURY:Register();

