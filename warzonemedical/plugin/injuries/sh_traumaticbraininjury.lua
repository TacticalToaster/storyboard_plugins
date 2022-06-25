local INJURY = Clockwork.injury:New();
INJURY.name = "Traumatic Brain Injury";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Major injury to the brain, possibly altering behavior, mood, and perception.";
INJURY.victim = "Your mind becomes shrouded further as your head pulses for a moment. From here on out, you have permanent brain damage that will alter your perception, mood, and personality.";
INJURY.limit = 1;
INJURY.icon = "nscp/status/effect_tbi.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 5);

	player:SetDSP(22);

	timer.Simple(math.random(20, 40), function()
		if (player and player:Alive()) then
			player:SetDSP(0);
		end;
	end);
end;

function INJURY:OnEnd(player, data, treater)
	if (player and player:Alive()) then
		player:SetDSP(0);
	end;
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	if (math.random(1, 10) <= 6) then
		player:SetCharacterData("pain", pain + 4);
		Clockwork.chatBox:Add(player, nil, "injury", "** Your head throbs violently as you suffer through a migrane.");

		player:SetDSP(22);

		timer.Simple(math.random(30, 55), function()
			if (player and player:Alive()) then
				player:SetDSP(0);
			end;
		end);
	end;
end;

INJURY:Register();

