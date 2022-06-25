local INJURY = Clockwork.injury:New();
INJURY.name = "Damaged Hearing";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Massive damage to the outer or inner ear that reduces hearing.";
INJURY.victim = "Trauma to your head has damaged your ears and hearing.";
INJURY.limit = 1;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 10);

	player:SetDSP(30);
end;

function INJURY:OnReset(player, data)
	player:SetDSP(30);
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
end;

INJURY:Register();

