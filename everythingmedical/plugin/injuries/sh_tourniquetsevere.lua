local INJURY = Clockwork.injury:New();
INJURY.name = "Tourniquet with Severe Bleed";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "A tourniquet wrapped around a limb. It's stopping a severe bleed currently.";
INJURY.victim = "You feel painful pressure clamping down on one of your limbs as a tourniquet is wrapped around it. Blood flow is not fully halted but greatly reduced from your wound.";
INJURY.icon = "wtt/status/effect_wound.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 6);
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 5);

	player:GiveInjury("severe bleed")
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 2);

	if (data.infectionChance and (!data.hasInfection or !player:HasInjury("bacterial infection"))) then
		if (data.infectionChance >= math.random(1, 100)) then
			data.hasInfection = true;
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive() and !player:HasInjury("bacterial infection")) then
					player:GiveInjury("bacterial infection");
				end;
			end);
		else
			data.infectionChance = data.infectionChance + 2
		end;
	else
		data.infectionChance = 2;
	end;
end;

INJURY:Register();

