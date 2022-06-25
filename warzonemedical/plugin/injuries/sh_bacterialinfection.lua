local INJURY = Clockwork.injury:New();
INJURY.name = "Bacterial Infection";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "An infected wound. There's yellow-green pus, increased inflamation, and widespread redness around the wound. It's tender to touch.";
INJURY.victim = "One of your old wounds ooze a yellow-green pus. There's clear swelling at the site, with it being surrounded by red that hurts to touch.";
INJURY.limit = 1;
INJURY.icon = "nscp/status/effect_intoxication.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	if (player.antibioticTime >= CurTime()) then
		local chance = math.random(1, 100);

		if (chance <= 60) then
			return false;
		end;
	end;

	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 5);
end;

function INJURY:OnReset(player, data)
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + math.random(1, 3));

	if (player.antibioticTime >= CurTime()) then
		local chance = math.random(1, 100);

		if (chance <= 10) then
			player:TreatInjury("bacterial infection");
			Clockwork.chatBox:Add(player, nil, "treat", "* You start to feel much better. The swelling and redness around your wound dissipates, and it no longer hurts to touch.");
		end;
	end;
end;

INJURY:Register();

