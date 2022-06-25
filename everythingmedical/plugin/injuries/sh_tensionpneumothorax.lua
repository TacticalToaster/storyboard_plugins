local INJURY = Clockwork.injury:New();
INJURY.name = "Tension Pneumothorax";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "An air build-up in the pleural space, causing a collapsed lung.";
INJURY.victim = "You feel a strong pressure building in your chest. Within a few short breaths, you begin to lose the ability to breathe.";
INJURY.limit = 1;
INJURY.icon = "wtt/status/skills/skill_physical_endurance_buff_breath.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
	local respiration = player:GetCharacterData("respiration");

	player:SetCharacterData("respiration", respiration - 15);
end;

INJURY:Register();

