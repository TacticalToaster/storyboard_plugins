local INJURY = Clockwork.injury:New();
INJURY.name = "Damaged Chest";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Massive damage to the thorax that is permanent.";
INJURY.victim = "Repeated injury to your chest has caused permanent damage, weakening your entire thorax.";
INJURY.limit = 1;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 15);
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
end;

INJURY:Register();

