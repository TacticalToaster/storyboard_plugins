local INJURY = Clockwork.injury:New();
INJURY.name = "Damaged Voice";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Massive damage to the mouth or voicebox.";
INJURY.victim = "Trauma to your head and neck have damaged your mouth and voicebox permanently.";
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

