local INJURY = Clockwork.injury:New();
INJURY.name = "Severe Bleed";
INJURY.delay = 30;
INJURY.decay = 0;
INJURY.description = "A large opening in the body. There's an alarming amount of blood exiting the wound.";
INJURY.victim = "You feel your skin get ripped open, leaving a large open wound. Copious amounts of viscous blood seep out of the wound.";
INJURY.defaultData = {hasInfection = false, nextBleedTime = 0, bone = nil};
INJURY.limit = 3;
INJURY.icon = "wtt/status/effect_heavy_bleeding.png";

function INJURY:OnThink(player, data)
	if (CurTime() >= data.nextBleedTime) then
		data.nextBleedTime = CurTime() + 3;

		local ent = player:GetRagdollEntity() or player;

		local bleedstart = ent:GetPos();
		local scale = 7;

		if (data.bone) then
			local boneID = ent:LookupBone(bone);
			local boneMat = boneID and ent:GetBoneMatrix(boneID) or false;

			bleedstart = boneMat and boneMat:GetTranslation() or bleedstart;

			scale = boneMat and 3 or scale;
		end;

		for i = 1, math.random(3, 5) do
			util.Decal( "Blood", bleedstart + Vector(math.Rand(-i*scale, i*scale), math.Rand(-i*scale, i*scale), 0), bleedstart - Vector(0, 0, 300), ent );
		end;

		util.Decal( "Blood", bleedstart, bleedstart - Vector(0, 0, 300) );
		
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

		local nick = player:Nick();

		local chance = math.random(1, 100);
		local maxChance = 50;

		local info = {maxChance};

		Clockwork.plugin:Call("PlayerAdjustTreatInfectionChance", player, data, treater, info);

		maxChance = info[1];

		if (chance <= maxChance) then
			timer.Simple(math.random(120, 300), function()
				if (player and player:Alive() and player:Nick() == nick) then
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
			data.infectionChance = data.infectionChance + 5
		end;
	else
		data.infectionChance = 5;
	end;
end;

INJURY:Register();

