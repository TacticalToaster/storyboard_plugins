local INJURY = Clockwork.injury:New();
INJURY.name = "Blunt Trauma";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Physical trauma caused by some sort of impact.";
INJURY.victim = "Something slams into your body with extreme force. You feel a welt rising, and the area grows tender to the touch.";

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
end;

INJURY:Register();

