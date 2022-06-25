local INJURY = Clockwork.injury:New();
INJURY.name = "Unconsciousness";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "State where there is no ability to maintain awareness of self and environment.";
INJURY.limit = 1;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil);
	player.combatBoost = 0;
end;

function INJURY:OnReset(player, data)
	Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil);
	player.combatBoost = 0;
end;

function INJURY:OnEnd(player, data, treater)
	Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
	//player.combatBoost = 0;
end;

function INJURY:OnDelay(player, data)
	local respiration = player:GetCharacterData("respiration");
	local airway = data.airway;

	if (airway) then return true end;

	player:SetCharacterData("respiration", respiration - 10);
end;

INJURY:Register();

