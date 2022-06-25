local INJURY = Clockwork.injury:New();
INJURY.name = "Tourniquet with Laceration";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "A tourniquet wrapped around a limb. It's stopping a bleed from a laceration currently.";
INJURY.victim = "You feel painful pressure clamping down on one of your limbs as a tourniquet is wrapped around it. Blood quickly stops seeping from your wound.";
INJURY.defaultData = {gotLimbDamage = false};
INJURY.icon = "wtt/status/effect_wound.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 6);

	data.startTime = CurTime();
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 5);

	player:GiveInjury("gunshot wound")
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 2);

	if (data.startTime and data.startTime + math.random(1800, 2700) <= CurTime()) then
		if (!data.gotLimbDamage) then
			if !player:HasInjury("damaged arm") then
				player:GiveInjury("damaged arm");
			elseif (!player:HasInjury("damaged leg")) then
				player:GiveInjury("damaged leg");
			end;

			data.gotLimbDamage = true;
		end;
	end;

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

