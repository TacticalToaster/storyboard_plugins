local INJURY = Clockwork.injury:New();
INJURY.name = "Severe Bleed";
INJURY.delay = 30;
INJURY.decay = 0;
INJURY.description = "A large opening in the body. There's an alarming amount of blood exiting the wound.";
INJURY.victim = "You feel your skin get ripped open, leaving a large open wound. Copious amounts of viscous blood seep out of the wound.";
INJURY.defaultData = {hasInfection = false, nextBleedTime = 0};
INJURY.limit = 2;
INJURY.icon = "nscp/status/effect_heavy_bleeding.png";

function INJURY:OnThink(player, data)
	if (CurTime() >= data.nextBleedTime) then
		data.nextBleedTime = CurTime() + 3;

		for i = 1, math.random(3, 5) do
			util.Decal( "Blood", player:GetPos() + Vector(math.Rand(-i*7, i*7), math.Rand(-i*7, i*7), 0), player:GetPos() - Vector(0, 0, 300), player );
		end;

		
	end;
end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 12);
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 8);

	if (!treater) then return end;

	if (treater.glovesPatient != player:Name() or treater.glovesTime < CurTime()) then
		treater.glovesTime = 1;

		local chance = math.random(1, 100);
		local maxChance = 80;

		Clockwork.plugin:Call("PlayerAdjustTreatInfectionChance", player, data, treater, maxChance);

		if (chance <= maxChance) then
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive()) then
					player:GiveWoundInfection("bacterial infection");
				end;
			end);
		end;
	end;

	treater.glovesPatient = player:Name();

	//player:GiveInjury("laceration")
end;

function INJURY:OnDelay(player, data)
	local blood = player:GetCharacterData("blood");
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("blood", blood - 10);
	player:SetCharacterData("pain", pain + 5);

	if (data.infectionChance and (!data.hasInfection or !player:HasInjury("bacterial infection"))) then
		if (data.infectionChance >= math.random(1, 100)) then
			data.hasInfection = true;
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive()) then
					player:GiveWoundInfection("bacterial infection");
				end;
			end);
		else
			data.infectionChance = data.infectionChance + 8
		end;
	else
		data.infectionChance = 10;
	end;
end;

INJURY:Register();

