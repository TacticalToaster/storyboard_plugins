local PLUGIN = PLUGIN;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["blood"] ) then
		data["blood"] = 100;
	end;
	if ( !data["pain"] ) then
		data["pain"] = 0;
	end;
	if ( !data["respiration"] ) then
		data["respiration"] = 100;
	end;
	if ( !data["injuries"] ) then
		data["injuries"] = {};
	end;
	if ( !data["diseaseInfo"] ) then
		data["diseaseInfo"] = {};
	end;
	if ( !data["symptomInfo"] ) then
		data["symptomInfo"] = {};
	end;
	if ( !data["medic"] ) then
		data["medic"] = 0;
	end;
	/*if ( !data["radiation"] ) then
		data["radiation"] = 0;
	end;*/
end;

PLUGIN.ampThresholds = {
	[HITGROUP_HEAD] = 20,
	[HITGROUP_CHEST] = 30,
	[HITGROUP_STOMACH] = 30,
	[HITGROUP_LEFTARM] = 15,
	[HITGROUP_RIGHTARM] = 15,
	[HITGROUP_LEFTLEG] = 15,
	[HITGROUP_RIGHTLEG] = 15
};


PLUGIN.amputationTable = {
	["lforearm"] = {"ValveBiped.Bip01_L_Forearm"},
	["rforearm"] = {"ValveBiped.Bip01_R_Forearm"},
	["lshoulder"] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Shoulder"},
	["rshoulder"] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Shoulder"},
	["lleg"] = {"ValveBiped.Bip01_L_Thigh"},
	["rleg"] = {"ValveBiped.Bip01_R_Thigh"},
	["lknee"] = {"ValveBiped.Bip01_L_Calf"},
	["rknee"] = {"ValveBiped.Bip01_R_Calf"},
	["head"] = {"ValveBiped.Bip01_Head1"}
};

PLUGIN.ampStencilTable = {
	["lforearm"] = {},
	["rforearm"] = {"ValveBiped.Bip01_R_Forearm"},
	["lshoulder"] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Shoulder"},
	["rshoulder"] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Shoulder"},
	["lleg"] = {"ValveBiped.Bip01_L_Thigh"},
	["rleg"] = {"ValveBiped.Bip01_R_Thigh"},
	["lknee"] = {"ValveBiped.Bip01_L_Calf"},
	["rknee"] = {"ValveBiped.Bip01_R_Calf"},
	["head"] = {"ValveBiped.Bip01_Head1"}
}

function PLUGIN.GetAllChildBones(ent, boneID, bones)
	local bonecount = ent:GetBoneCount();
	if (!boneID) then return end;
	if ( bonecount == 0 || bonecount < boneID ) then return end;

	bones = bones or {};

	table.insert( bones, boneID );

	for k = 0, bonecount - 1 do
		if ( ent:GetBoneParent( k ) != boneID ) then continue end;
		table.insert( bones, k );
		PLUGIN.GetAllChildBones(ent, k, bones);
	end;

	return bones;

end;

function PLUGIN:PlayerCharacterCreated(player, character)
	if ( istable(character.data.Traits) and table.HasValue(character.data.Traits, TRAIT_DAMVOICE) ) then
		if (!character.data.injuries) then
			character.data.injuries = {};
		end;

		local injuryTable = Clockwork.injury:FindByID("damaged voice");

		local newInjury = {};
		newInjury.type = injuryTable.name;
		newInjury.delay = CurTime() + injuryTable.delay;


		if injuryTable.defaultData then
			for i,v in pairs(injuryTable.defaultData) do
				newInjury[i] = v;
			end;
		end;

		table.insert(character.data.injuries, newInjury);
	end;

	if ( istable(character.data.Traits) and table.HasValue(character.data.Traits, TRAIT_DAMHEARING) ) then
		if (!character.data.injuries) then
			character.data.injuries = {};
		end;

		local injuryTable = Clockwork.injury:FindByID("damaged hearing");

		local newInjury = {};
		newInjury.type = injuryTable.name;
		newInjury.delay = CurTime() + injuryTable.delay;


		if injuryTable.defaultData then
			for i,v in pairs(injuryTable.defaultData) do
				newInjury[i] = v;
			end;
		end;

		table.insert(character.data.injuries, newInjury);
	end;

	if ( istable(character.data.Traits) and table.HasValue(character.data.Traits, TRAIT_TBI) ) then
		if (!character.data.injuries) then
			character.data.injuries = {};
		end;

		local injuryTable = Clockwork.injury:FindByID("traumatic brain injury");

		local newInjury = {};
		newInjury.type = injuryTable.name;
		newInjury.delay = CurTime() + injuryTable.delay;


		if injuryTable.defaultData then
			for i,v in pairs(injuryTable.defaultData) do
				newInjury[i] = v;
			end;
		end;

		table.insert(character.data.injuries, newInjury);
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "blood", math.Clamp(player:GetCharacterData("blood"), 0, 100));
	player:SetSharedVar( "pain", math.Clamp(player:GetCharacterData("pain"), 0, 100));
	player:SetSharedVar( "respiration", math.Clamp(player:GetCharacterData("respiration"), 0, 100));
	player:SetSharedVar( "combatBoost", player.combatBoost);
	player:SetSharedVar( "combatBoostCooldown", player.combatBoostCooldown);

	//print(player.combatBoost, player.combatBoostCooldown)

	local shVars, shTables = Clockwork.kernel:GetSharedVars();

	Clockwork.datastream:Start(player, "UpdateInjuries", {player:GetCharacterData("injuries"), player:GetCharacterData("Diseases")});

	//print(player:GetCharacterData("injuries"))

	/*
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		if (player:GetCharacterData("hydration") == 100) then
			player:BoostAttribute("Hydration", ATB_ACROBATICS, -40);
			player:BoostAttribute("Hydration", ATB_ENDURANCE, -40);
			player:BoostAttribute("Hydration", ATB_STRENGTH, -40);
			player:BoostAttribute("Hydration", ATB_AGILITY, -40);
			player:BoostAttribute("Hydration", ATB_DEXTERITY, -40);
			player:BoostAttribute("Hydration", ATB_MEDICAL, -40);
		else
			player:BoostAttribute("Hydration", ATB_ACROBATICS, false);
			player:BoostAttribute("Hydration", ATB_ENDURANCE, false);
			player:BoostAttribute("Hydration", ATB_STRENGTH, false);
			player:BoostAttribute("Hydration", ATB_AGILITY, false);
			player:BoostAttribute("Hydration", ATB_DEXTERITY, false);
			player:BoostAttribute("Hydration", ATB_MEDICAL, false);
		end;
	end;
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		if (tonumber(player:GetCharacterData("hunger")) >= 70) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -10);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -10);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -10);
			player:BoostAttribute("Hunger", ATB_AGILITY, -10);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -10);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -10);
		elseif (tonumber(player:GetCharacterData("hunger")) >= 80) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -25);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -25);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -25);
			player:BoostAttribute("Hunger", ATB_AGILITY, -25);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -25);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -25);
		elseif (tonumber(player:GetCharacterData("hunger")) >= 90) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -30);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -30);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -30);
			player:BoostAttribute("Hunger", ATB_AGILITY, -30);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -30);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -30);
		else
			player:BoostAttribute("Hunger", ATB_ACROBATICS, false);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, false);
			player:BoostAttribute("Hunger", ATB_STRENGTH, false);
			player:BoostAttribute("Hunger", ATB_AGILITY, false);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, false);
			player:BoostAttribute("Hunger", ATB_MEDICAL, false);
		end;
	end;
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		if (tonumber(player:GetCharacterData("radiation")) >= 50) then
			player:BoostAttribute("Radiation", ATB_ACROBATICS, -25);
			player:BoostAttribute("Radiation", ATB_ENDURANCE, -25);
			player:BoostAttribute("Radiation", ATB_STRENGTH, -25);
			player:BoostAttribute("Radiation", ATB_AGILITY, -25);
			player:BoostAttribute("Radiation", ATB_DEXTERITY, -25);
			player:BoostAttribute("Radiation", ATB_MEDICAL, -25);
		end;
	end;*/
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local alive = player:Alive();
	local faction = player:GetFaction();
	local curTime = CurTime();

	player:SetCharacterData("blood", math.Clamp(player:GetCharacterData("blood"), 0, 100));
	player:SetCharacterData("pain", math.Clamp(player:GetCharacterData("pain"), 0, 100));
	player:SetCharacterData("respiration", math.Clamp(player:GetCharacterData("respiration"), 0, 100));

	local blood = tonumber(player:GetCharacterData("blood"));
	local pain = tonumber(player:GetCharacterData("pain"));
	local respiration = tonumber(player:GetCharacterData("respiration"));
	local injuries = player:GetInjuries();

	if (!player.reviveTime) then
		player.reviveTime = 0;
	end;

	if (!player.ragdollJitter) then
		player.ragdollJitter = 0;
	end;

	if (!player.statRegenTime) then
		player.statRegenTime = CurTime();
	end;

	for i,v in pairs(injuries) do
		local injuryTable = Clockwork.injury:FindByID(v.type);

		if (injuryTable) then
			if (injuryTable.OnDelay) then
				if (v.delay <= CurTime()) then
					injuryTable:OnDelay(player, v);
					v.delay = CurTime() + injuryTable.delay;
				end;
			end;

			if (injuryTable.OnThink) then
				injuryTable:OnThink(player, v);
			end;
		end;
	end;

	if ( player:Alive() ) then
		//blood
		if (blood <= 0 and !player.dyingBlood) then
			player.dyingBlood = true;
			Clockwork.chatBox:Add(player, nil, "injurykill", "** Your body fails, as there is not enough blood to supply it properly. You die soon after.");
			timer.Simple(5, function()
				if (player:Alive()) then
					player.deathIsPK = true;
					player:Kill();
					Clockwork.player:NotifyAdmins("o", player:Name().." has died due to bloodloss!", "death");
					/*if (!Clockwork.player:IsProtected(player)) then
						Clockwork.player:SetBanned(player, true);
					end;*/
					//player:KillSilent();
				end;
			end);
		elseif (blood <= 30 and !player:HasInjury("unconsciousness") and !player.dyingBlood) then
			//player.knockedBlood = true;
			Clockwork.chatBox:Add(player, nil, "injury", "** You feel extremely tired, and in short time you fall unconscious.");
			if (player:Alive()) then
				//Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil);
				player:GiveInjury("unconsciousness");
				player.reviveTime = CurTime() + 180;
			end;
		end;

		//pain
		if (pain >= 80 and !player:HasInjury("unconsciousness")) then
			//player.knockedPain = true;
			Clockwork.chatBox:Add(player, nil, "injury", "** Everything aches and feels numb at the same time as you drift into unconscious.");
			if (player:Alive()) then
				//Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil);
				player:GiveInjury("unconsciousness");
				player.reviveTime = CurTime() + 180;
			end;
		elseif (pain >= 50 and !player.immobilizedPain and !player:HasInjury("unconsciousness") and (player.combatBoost <= CurTime() or player.combatBoostCooldown >= CurTime())) then //GOTO check this
			player.immobilizedPain = true;
			Clockwork.chatBox:Add(player, nil, "injury", "** Your pain grows in strength, hurting everytime you move. You're effectively immobilized.");
			timer.Simple(2, function()
				if (player:Alive()) then
					Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil);
					player:SetSharedVar("FallenOver", false);
				end;
			end);
		end;

		//respiration
		if (respiration <= 0 and !player.dyingRespiration) then
			player.dyingRespiration = true;
			Clockwork.chatBox:Add(player, nil, "injurykill", "** Life itself fades away as you suffocate to death.");
			timer.Simple(5, function()
				if (player:Alive()) then
					player.deathIsPK = true;
					player:Kill();
					Clockwork.player:NotifyAdmins("o", player:Name().." has died due to suffocation!", "death");
					/*if (!Clockwork.player:IsProtected(player)) then
						Clockwork.player:SetBanned(player, true);
					end;*/
				end;
			end);
		elseif (respiration <= 50 and !player:HasInjury("unconsciousness") and !player.dyingRespiration) then
			player.knockedRespiration = true;
			Clockwork.chatBox:Add(player, nil, "injury", "** As it becomes increasingly harder to breathe, you drift into an unconscious state.");
			if (player:Alive()) then
				//Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil);
				player:GiveInjury("unconsciousness");
			end;
		end;

		if (respiration > 50 and blood > 30 and pain < 80 and player:HasInjury("unconsciousness") and CurTime() >= player.reviveTime) then
			player:TreatInjuries("unconsciousness");
			Clockwork.chatBox:Add(player, nil, "treat", "** You come back to your senses, taking in the environment. You feel better then before.");
		end;

		if (respiration > 50 and blood > 30 and pain < 50 and player:GetRagdollState() == RAGDOLL_FALLENOVER and player:GetSharedVar("FallenOver") == false) then
			player.immobilizedPain = false;
			player:SetSharedVar("FallenOver", true);
			Clockwork.chatBox:Add(player, nil, "treat", "** As your pain lessens, you're once again able to move freely.");
		end;

		local bPlayerBreathSnd = false;

		if (!player:HasInjury("unconsciousness") and (respiration <= 80 and respiration > 50 and Clockwork.event:CanRun("sounds", "breathing") or (player:GetCharacterData("Stamina") and player:GetCharacterData("Stamina") <= 30))) then
			bPlayerBreathSnd = true;
		end;

		if (!player.nextRespirationSound or curTime >= player.nextRespirationSound) then
			if (!Clockwork.player:IsNoClipping(player)) then
				player.nextRespirationSound = curTime + 2;

				if (bPlayerBreathSnd) then
					local volume = 20 + respiration;
					local painRandom = math.random(1, 5);


					player:EmitSound("player/focus_gasp_0"..painRandom..".wav", 75);
					//Clockwork.player:StartSound(player, "Respiration", "player/focus_gasp_0"..painRandom..".wav", volume / 100);
				else
					Clockwork.player:StopSound(player, "Respiration", 1);
				end;
			end;
		end;

		local bPlayerPainSnd = false;

		if (!player:HasInjury("unconsciousness") and !bPlayerBreathSnd and (pain >= 20 and pain < 80 and Clockwork.event:CanRun("sounds", "pain"))) then
			bPlayerPainSnd = true;
		end;

		if (!player.nextPainSound or curTime >= player.nextPainSound) then
			if (!Clockwork.player:IsNoClipping(player)) then
				player.nextPainSound = curTime + math.random(4, 7);

				if (bPlayerPainSnd) then
					local painSound = "vo/npc/male01/moan01.wav";
					local painRandom = math.random(1, 5);
					local volume = 20 + pain;

					if (player:GetGender() == GENDER_MALE) then
						painSound = "player/damage/pl_damage_minor_0"..painRandom..".wav";
					else
						painSound = "vo/npc/female01/moan0"..painRandom..".wav";
					end;

					if (pain >= 45) then
						painRandom = math.random(1, 9);
						player.nextPainSound = curTime + math.Rand(1, 3);

						if (player:GetGender() == GENDER_MALE) then
							painRandom = math.random(1, 17);

							if painRandom < 10 then
								painRandom = "0"..painRandom
							end;

							player:EmitSound("player/damage/pl_deathshout_"..painRandom..".wav", 90);
						else
							player:EmitSound("vo/npc/female01/pain0"..painRandom..".wav", 90);
						end;
					else
						Clockwork.player:StartSound(player, "Pain", painSound, volume / 100);
					end;
				else
					Clockwork.player:StopSound(player, "Pain", 1);
				end;
			end;
		end;

		if (CurTime() >= player.statRegenTime) then
			local info = {
				blood = .033,
				pain = .1,
				respiration = .1
			};

			Clockwork.plugin:Call("PlayerAdjustMedStatRegen", player, infoTable, info, injuries, blood, pain, respiration);

			player:SetCharacterData("respiration", math.Clamp(respiration + info.respiration, 0, 100));
			player:SetCharacterData("blood", math.Clamp(blood + info.blood, 0, 100));
			player:SetCharacterData("pain", math.Clamp(pain - info.pain, 0, 100));

			if (player:HasTrait(TRAIT_RESILIENT) and player.immobilizedPain) then
				player:SetCharacterData("pain", math.Clamp(pain - info.pain * 1.25, 0, 100));
			end;

			player.statRegenTime = player.statRegenTime + 1;
		end;

		/*if (player:Health() <= 15 and !player:HasInjury("unconsciousness")) then
			player:GiveInjury("unconsciousness");
			player:SetHealth(50);
		end;*/

		// TODO: Move all of the modifiers to applying upon an injury reseting (and removing movement mods afterward injury is lost)

		local medSpeedMod = 1;
		local medWeightMod = 1;

		if (player:HasInjury("damaged leg")) then
			medSpeedMod = medSpeedMod * .75;
		end;

		if (player:HasInjury("damaged chest")) then
			medWeightMod = medWeightMod * .75;
		end;

		if (player.combatBoost >= CurTime() and player.combatBoostCooldown <= CurTime()) then
			if (player:HasTrait(TRAIT_ADRJUNK)) then
				medSpeedMod = medSpeedMod * 1.2
			else
				medSpeedMod = medSpeedMod * 1.35
			end;
		end;

		infoTable.walkSpeed = infoTable.walkSpeed * medSpeedMod;
		infoTable.runSpeed = infoTable.runSpeed * medSpeedMod;
		infoTable.jumpPower = infoTable.jumpPower * medSpeedMod;

		infoTable.inventoryWeight = infoTable.inventoryWeight * medWeightMod;
	end;
end;

function PLUGIN:ChatBoxAdjustInfo(info)
	local speaker = info.speaker;
	local talkRadius = Clockwork.config:Get("talk_radius"):Get();
	local newListeners = {};
	//local newListenersHearing = {};

	if (speaker and (info.class == "ic" or info.class == "yell" or info.class == "whisper")) then
		if (speaker:HasInjury("damaged voice")) then
			local text = info.text;
			local textLength = string.len(text);
			local randomCharacters = math.ceil(textLength/3);
			local textTable = string.ToTable(text);

			for i=1, randomCharacters do
				if (math.random(0, 1) == 1) then
					table.insert(textTable, math.random(2, #textTable), string.char(math.random(97, 122)));
				end;
			end;

			info.text = table.concat(textTable, "");
		end;
	end;

	if (info.class == "ic" or info.class == "yell") then
		local radius = talkRadius;

		if (info.class == "yell") then
			radius = radius * 2;
		end;

		if (speaker) then
			if (speaker:HasInjury("damaged voice")) then
				radius = radius * .75;
			end;
		end;

		for k, v in pairs(info.listeners) do
			if (v:HasInitialized()) then
				local listenerRadius = radius;

				if (v:HasInjury("damaged hearing")) then
					listenerRadius = listenerRadius * .6;
				end;

				if (speaker:GetPos():Distance(v:GetPos()) <= listenerRadius) then
					newListeners[#newListeners + 1] = v;
				end;
			end;
		end;

		info.listeners = newListeners;
	end;
end;

function PLUGIN:PlayerShouldStaminaRegenerate(player)
	local faction = player:GetFaction();
	if ( tonumber(player:GetCharacterData("respiration")) <= 60 ) then
		return false;
	end;
end;

-- Called when a player uses an item.
function PLUGIN:PlayerUseItem(player, itemTable, itemEntity)
	if itemTable.blood then
		player:SetCharacterData( "blood", math.Clamp(player:GetCharacterData("blood") + itemTable.blood, 0, 100) );
	end;

	if itemTable.pain then
		player:SetCharacterData( "pain", math.Clamp(player:GetCharacterData("pain") - itemTable.pain, 0, 100) );
	end;

	if itemTable.respiration then
		player:SetCharacterData( "respiration", math.Clamp(player:GetCharacterData("respiration") + itemTable.respiration, 0, 100) );
	end;
end;

function PLUGIN:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local armorItem = player:GetClothesItem();
	local armorStopped = false;

	player:SetLastHitGroup(hitGroup);

	//print("AH IM BOOOOSTIN22e2114G", damageInfo:GetDamage() >= 5, !player:HasInjury("unconsciousness"), CurTime() + 30 >= player.combatBoost)

	if (damageInfo:GetDamage() >= 3 and !player:HasInjury("unconsciousness") and CurTime() + 30 >= player.combatBoost) then
		if (player:HasTrait(TRAIT_ADRJUNK)) then
			player.combatBoost = CurTime() + 50;
		else
			player.combatBoost = CurTime() + 30;
		end;
	end;

	local shouldInjure = Clockwork.plugin:Call("PlayerShouldInjureFromDamage", player, attacker, hitGroup, damageInfo, baseDamage);

	if (shouldInjure == false) then
		armorStopped = true;
	end;

	if (armorStopped) then
		Clockwork.datastream:Start(player, "TookDamage", 1.2);
	else
		Clockwork.datastream:Start(player, "TookDamage", 1);
	end;

	if (!armorStopped and hitgroup == HITGROUP_HEAD and player:IsRagdolled()) then
		damageInfo:ScaleDamage(100);
	end;

	if (hitgroup == HITGROUP_CHEST and player:HasInjury("damaged chest")) then
		damageInfo:ScaleDamage(1.5);
	elseif (hitgroup == HITGROUP_STOMACH and player:HasInjury("damaged stomach")) then
		damageInfo:ScaleDamage(1.1);
	elseif (hitgroup == HITGROUP_LEFTARM and player:HasInjury("damaged arm")) then
		damageInfo:ScaleDamage(1.1);
	elseif (hitgroup == HITGROUP_RIGHTARM and player:HasInjury("damaged arm")) then
		damageInfo:ScaleDamage(1.1);
	elseif (hitgroup == HITGROUP_LEFTLEG and player:HasInjury("damaged leg")) then
		damageInfo:ScaleDamage(1.2);
	elseif (hitgroup == HITGROUP_RIGHTLEG and player:HasInjury("damaged leg")) then
		damageInfo:ScaleDamage(1.2);
	end;

	local permInjNum = math.random(1, 100);
	local permInjChance = 3;

	if (player:HasTrait(TRAIT_WEAK)) then
		permInjChance = 7;
	end;

	if (permInjNum <= permInjChance and !armorStopped) then
		if (hitgroup == HITGROUP_CHEST) then
			player:GiveInjury("damaged chest");
		elseif (hitgroup == HITGROUP_STOMACH) then
			player:GiveInjury("damaged stomach");
		elseif (hitgroup == HITGROUP_HEAD) then
			local headChance = math.random(1, 3);
			if (headChance == 1) then
				player:GiveInjury("damaged voice");
			elseif (headchance == 2) then
				player:GiveInjury("damaged hearing");
			elseif (headchance == 3) then
				player:GiveInjury("damaged voice"); //GOTO Change this back to vision once it's finished
			end;
		elseif (hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			player:GiveInjury("damaged arm");
		elseif (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) then
			player:GiveInjury("damaged leg");
		end;
	end;

	if (damageInfo:IsBulletDamage() and armorStopped and hitgroup == HITGROUP_HEAD) then
		local chance = math.random(1, 100);
		local injChanceMod = 1;

		if (player:HasTrait(TRAIT_WEAK)) then
			injChanceMod = 2;
		end;

		if (chance <= 30 * injChanceMod) then
			player:GiveInjury("concussion");
		end;
	end;

	if (damageInfo:IsBulletDamage() and !armorStopped) then
		local chance = math.random(1, 100);
		local injChanceMod = 1;

		if (player:HasTrait(TRAIT_WEAK)) then
			injChanceMod = 2;
		end;

		if (hitGroup and self.ampThresholds[hitGroup] and self.ampThresholds[hitGroup] <= damageInfo:GetDamage()) then
			self:AmputateLimb(player, hitGroup, damageInfo);
		end;

		if (hitGroup == HITGROUP_CHEST and chance <= 10 * injChanceMod) then
			player:GiveInjury("gunshot wound");
			//player:GiveInjury("sucking chest wound");
		elseif ((hitgroup != HITGROUP_HEAD or hitgroup != HITGROUP_CHEST) and chance <= 15 * injChanceMod) then
			player:GiveInjury("severe bleed");
		elseif (hitgroup == HITGROUP_HEAD) then
			player:GiveInjury("concussion");
		elseif chance <= 25 * injChanceMod then
			player:GiveInjury("gunshot wound");
		end;
	elseif (damageInfo:IsDamageType(DMG_SLASH)) then
		//if (hitGroup != HITGROUP_CHEST) then
			player:GiveInjury("laceration");
		//end;
	elseif (damageInfo:IsDamageType(DMG_BURN)) then
		if (math.random(0, 1) == 1) then
			player:GiveInjury("burn wound");
		end;
	elseif (damageInfo:IsDamageType(DMG_BLAST)) then
		player:GiveInjury("burn wound");

		if (math.random(0, 1) == 1) then
			player:GiveInjury("laceration");
		end;

		if (damageInfo:GetDamage() >= 8 and !player:IsRagdolled()) then
			Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil, nil, damageInfo:GetDamageForce());
			player:SetSharedVar("FallenOver", true);
		end;
	end;
end;

function PLUGIN:AmputateLimb(player, hitGroup, damageInfo)
	if (hitGroup == HITGROUP_LEFTARM) then
		local bone = player:LookupBone("ValveBiped.Bip01_L_UpperArm");

		if (bone) then
			local ef = EffectData();
			local mat = player:GetBoneMatrix(bone);
			local pos, ang = mat:GetTranslation(), mat:GetAngles();
			ef:SetOrigin(pos);
			ef:SetStart(pos);
			ef:SetAngles(ang);
			ef:SetEntity(player);
			//ef:SetAttachment(bone);
			util.Effect("BloodImpact", ef, true, true);
			util.Effect("bloodspray", ef, true, true);
		end;

		player.amputationSide = 0;
		player.amputationBleed = true;
		player:GiveInjury("dismembered arm");
	elseif (hitGroup == HITGROUP_RIGHTARM) then
		local bone = player:LookupBone("ValveBiped.Bip01_R_UpperArm");

		if (bone) then
			local ef = EffectData();
			local mat = player:GetBoneMatrix(bone);
			local pos, ang = mat:GetTranslation(), mat:GetAngles();
			ef:SetOrigin(pos);
			ef:SetStart(pos);
			ef:SetAngles(ang);
			ef:SetEntity(player);
			//ef:SetAttachment(bone);
			util.Effect("BloodImpact", ef, true, true);
			util.Effect("bloodspray", ef, true, true);
		end;

		player.amputationSide = 1;
		player.amputationBleed = true;
		player:GiveInjury("dismembered arm");
	elseif (hitGroup == HITGROUP_LEFTLEG) then

	elseif (hitGroup == HITGROUP_RIGHTLEG) then

	elseif (hitGroup == HITGROUP_HEAD) then
		local bone = player:LookupBone("ValveBiped.Bip01_Head1");

		if (bone) then
			local ef = EffectData();
			local mat = player:GetBoneMatrix(bone);
			local pos, ang = mat:GetTranslation(), mat:GetAngles();
			ef:SetOrigin(pos);
			ef:SetStart(pos);
			ef:SetAngles(ang);
			ef:SetEntity(player);
			//ef:SetAttachment(bone);
			util.Effect("BloodImpact", ef, true, true);
			util.Effect("bloodspray", ef, true, true);
		end;

		player.amputationSide = nil;
		player.ampDecapitated = true;
		//player.amputationBleed = true;
		//player:GiveInjury("dismembered arm");
	end;
end;

function PLUGIN:PlayerNameChanged(player, previousName, newName)
	player:UpdateAmputations();
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	player.dyingRespiration = false;
	player.dyingBlood = false;
	player.immobilizedPain = false;

	local pkDeathsOnly = Clockwork.config:Get("med_pk_deaths"):Get();

	//print("Im a virgin", !lightSpawn, !changeClass, player:GetFaction() != FACTION_OPFOR, !lightSpawn and !changeClass and !player:GetFaction() != FACTION_OPFOR)

	if (!lightSpawn and !changeClass and !player.opforMode) then
		//print("Ah fuck ", player.deathCount % 2 != 0)
		if ( (player.deathCount % 2 != 0 and !player.deathIsPK) or (pkDeathsOnly and !player.deathIsPK) ) then
			if (player.deathPos) then
				player:SetPos(player.deathPos);
				player:SetAngles(player.deathAng);
				//print("Moving player to "..player.deathPos)
			end;
			if (player.immobilizedSpawn) then
				player.immobilizedSpawn = false;
				player:SetCharacterData( "pain", 65 );
				player.immobilizedPain = true;
				Clockwork.chatBox:Add(player, nil, "injury", "** Your pain grows in strength, hurting everytime you move. You're effectively immobilized.");
				Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil);
				player:SetSharedVar("FallenOver", false);
			end;
		else
			player:TreatInjury("unconsciousness");

			local injuries = player:GetInjuries();

			if (injuries and istable(injuries)) then
				for i,v in pairs(injuries) do
					local injuryTable = Clockwork.injury:FindByID(v.type);

					if (injuryTable.OnEnd) then
						injuryTable:OnEnd(player);
					end;
				end;
			end;

			player:SetCharacterData( "injuries", {} );
			player:SetCharacterData( "pain", 0 );
			player:SetCharacterData( "respiration", 100 );
			player:SetCharacterData( "blood", 100 );
		end;
	end;

	player.deathIsPK = false;

	if (player.opforMode and !lightSpawn) then
		player:SetCharacterData("blood", 100);
		player:SetCharacterData("respiration", 100);
		player:SetCharacterData("pain", 0);

		local injuries = player:GetInjuries();

		for i,v in pairs(injuries) do
			local injuryTable = Clockwork.injury:FindByID(v.type);

			if (injuryTable.OnEnd) then
				injuryTable:OnEnd(player, v);
			end;
		end;

		player:SetCharacterData( "injuries", {} )

		player:SetPos(player.deathPos);
		player:SetAngles(player.deathAng);

		cwObserverMode:MakePlayerEnterObserverMode(player);
	end;

	if (player:GetCharacterData("blood") <= 0) then
		player:SetCharacterData("blood", 20);
	end;

	if (player:GetCharacterData("respiration") <= 0) then
		player:SetCharacterData("respiration", 20);
	end;

	player:ClearAmputations();
	player:UpdateAmputations();

	player:ResetInjuries();
end;

function PLUGIN:DoPlayerDeath(player, attacker, damageInfo)
	player.deathPos = player:GetPos() + Vector(0, 0, 8);
	player.deathAng = player:GetAngles();

	local ragdoll = player:GetRagdollEntity();

	local pkDeathsOnly = Clockwork.config:Get("med_pk_deaths"):Get();

	if (IsValid(ragdoll)) then
		player.deathPos = ragdoll:GetPos() + Vector(0, 0, 2);
		player.deathAng = ragdoll:GetAngles();
	end;

	if (player.deathCount) then
		player.deathCount = player.deathCount + 1;
	else
		player.deathCount = 1;
	end

	player.combatBoost = 0;

	if (!player:HasInjury("unconsciousness") and !player.immobilizedPain) then
		local deathTypeText = "";

		if (Clockwork.config:Get("med_pain_death"):Get()) then
			deathTypeText = "immobilized";
			player.immobilizedSpawn = true;
		else
			deathTypeText = "unconscious";
			player:GiveInjury("unconsciousness");
			Clockwork.chatBox:Add(player, nil, "injury", "** Your body becomes overwhelmed from the injuries it sustains, and you lose consciousness.");
		end;
		player.reviveTime = CurTime() + 30;
		if (attacker:IsPlayer()) then
			Clockwork.player:NotifyAdmins("o", player:Name().." has died from low health and is now "..deathTypeText.."! "..attacker:Name().." killed them!", "death");
		else
			Clockwork.player:NotifyAdmins("o", player:Name().." has died from low health and is now "..deathTypeText.."!", "death");
		end;

		local permInjNum = math.random(1, 100);
		local permInjChance = 15;

		if (player:HasTrait(TRAIT_WEAK)) then
			permInjChance = 25;
		end;

		local injTable = {
			"damaged chest",
			"damaged stomach",
			"damaged voice",
			"damaged hearing",
			"damaged arm",
			"damaged leg",
			"traumatic brain injury",
			"concussion"
		};

		if (permInjNum <= permInjChance) then
			player:GiveInjury(injTable[math.random(1, #injTable)]);
		end;
	else
		player.deathIsPK = true; // GOTO make this a config option for whether double taps are always PKs or not
		player.reviveTime = math.Clamp(player.reviveTime + 30, CurTime() + 30, math.huge);
		Clockwork.chatBox:Add(player, nil, "injury", "** Your body is damaged severely while you're immobilized.");
		if (attacker:IsPlayer()) then
			Clockwork.player:NotifyAdmins("o", player:Name().." has been double tapped while immobilized by "..attacker:Name().."!", "death");
		else
			Clockwork.player:NotifyAdmins("o", player:Name().." has died while immobilized!", "death");
		end;
	end;

	if ((player.deathCount >= 2 and !player.opforMode) or player.deathIsPK) then
		if (player.deathCount % 2 != 0 and !player.deathIsPK) then
			Clockwork.player:NotifyAdmins("o", player:Name().." has died "..player.deathCount.." times!", "death");
		elseif ((pkDeathsOnly and player.deathIsPK) or (!pkDeathsOnly and player.deathCount % 2 == 0 or player.deathIsPK)) then
			Clockwork.player:NotifyAdmins("o", player:Name().." has died "..player.deathCount.." times and will respawn at their default respawn location. This should be a PK.", "death");
		end;
	end;
end;

function PLUGIN:PlayerDeath(player, inflictor, attacker, damageInfo)
	local ragdoll = player:GetRagdollEntity();

	if (IsValid(ragdoll)) then
		ragdoll:SetRenderMode(RENDERMODE_NORMAL);
	end;

	local pkDeathsOnly = Clockwork.config:Get("med_pk_deaths"):Get();

	if (IsValid(ragdoll) and ((!pkDeathsOnly and player.deathCount % 2 != 0 and !player.deathIsPK) or (pkDeathsOnly and !player.deathIsPK)) and !player:GetCharacterData("CharBanned") and !player.opforMode) then
		print(pkDeathsOnly, player.deathCount, player.deathIsPK, player.opforMode)
		ragdoll:Remove();
	elseif (IsValid(ragdoll)) then
		local addAmps = {};

		if (player.ampDecapitated or player:LastHitGroup() == HITGROUP_HEAD and damageInfo:GetDamage() >= self.ampThresholds[HITGROUP_HEAD]) then
			player.ampDecapitated = false;
			table.insert(addAmps, {["amp"] = "head", ["render"] = "ValveBiped.Bip01_Head1", ["norender"] = "ValveBiped.Bip01_Head1", ["ent"] = player})
		end;

		player:CopyAmputationsToEnt(ragdoll, addAmps);
		Clockwork.plugin:Call("LeaveCorpse", ragdoll, player, inflictor, attacker, damageInfo);
	end;
end;

function PLUGIN:PlayerCanDeathDropInventory(player, inflictor, attacker, damageInfo)
	local pkDeathsOnly = Clockwork.config:Get("med_pk_deaths"):Get();
	if (((!pkDeathsOnly and player.deathCount % 2 == 0) or player.deathIsPK) or player:GetCharacterData("CharBanned")) then
		return true;
	else
		return false;
	end;
end;

function PLUGIN:PlayerCharacterLoaded(player)
	player.reviveTime = 0;
	player.ragdollJitter = 0;
	player.combatBoost = 0;
	player.combatBoostCooldown = 0;
	player.deathPos = nil;
	player.deathAng = nil;
	player.deathCount = 0;
	player.deathIsPK = false;
	player.dyingRespiration = false;
	player.dyingBlood = false;
	player.immobilizedPain = false;
	player.sterileWounds = {};
	player.antibioticTime = 0;
	player.glovesPatient = "";
	player.glovesTime = 0;
end;
