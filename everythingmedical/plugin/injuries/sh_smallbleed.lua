local INJURY = Clockwork.injury:New();
INJURY.name = "Small Bleed";
INJURY.delay = 30;
INJURY.decay = 0;
INJURY.description = "A small open wound that is draining blood.";
INJURY.victim = "Liquid can be felt as blood pours out of an open gash.";
INJURY.limit = 4;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 5);
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 5);

	if (!treater) then return end;

	if (treater.glovesPatient != player:Name() or treater.glovesTime < CurTime()) then
		treater.glovesTime = 1;

		local chance = math.random(1, 100);

		if (chance <= 60) then
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive()) then
					player:GiveWoundInfection("bacterial infection");
				end;
			end);
		end;
	end;

	treater.glovesPatient = player:Name();
end;

function INJURY:OnDelay(player, data)
	local blood = player:GetCharacterData("blood");

	player:SetCharacterData("blood", blood - 5);

	if (data.infectionChance and (!data.hasInfection or !player:HasInjury("bacterial infection"))) then
		if (data.infectionChance >= math.random(1, 100)) then
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive()) then
					player:GiveInjury("bacterial infection");
				end;
			end);
		else
			data.infectionChance = data.infectionChance + 5
		end;
	else
		data.infectionChance = 5;
	end;
end;

INJURY:Register();

