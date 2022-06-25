local INJURY = Clockwork.injury:New();
INJURY.name = "Sucking Chest Wound";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "A hole in the lung that is releasing air.";
INJURY.victim = "You begin to experience slight trouble breathing, which grows worse over time.";
INJURY.limit = 1;
INJURY.defaultData = {hasInfection = false};
INJURY.icon = "wtt/status/skills/skill_physical_endurance_buff_breath.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local respiration = player:GetCharacterData("respiration");

	player:SetCharacterData("respiration", respiration - 5);

	timer.Simple(30, function()
		if (math.random(0, 1) == 1) then
			player:TreatInjury(self.name);
			player:GiveInjury("Tension Pneumothorax");
		end;
	end);
end;

function INJURY:OnEnd(player, data, treater)
	if (!treater) then return end;

	if (treater.glovesPatient != player:Name() or treater.glovesTime < CurTime()) then
		treater.glovesTime = 1;

		local chance = math.random(1, 100);

		if (chance <= 40) then
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
	local respiration = player:GetCharacterData("respiration");

	player:SetCharacterData("respiration", respiration - 10);

	if (data.infectionChance and (!data.hasInfection or !player:HasInjury("bacterial infection"))) then
		if (data.infectionChance >= math.random(1, 100)) then
			data.hasInfection = true;
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive()) then
					player:GiveWoundInfection("bacterial infection");
				end;
			end);
		else
			data.infectionChance = data.infectionChance + 3
		end;
	else
		data.infectionChance = 3;
	end;
end;

INJURY:Register();

