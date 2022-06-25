local PLUGIN = PLUGIN;
local cwPlayer = player;
local cwDisease = Clockwork.disease;

cwDisease:NewSymptom("cough", function(player)
	local symptomInfo = player:GetCharacterData("symptomInfo")["cough"];


	if (!symptomInfo) then return end;
	if (player:IsNoClipping() or ((player:GetRagdollEntity() or player:GetSharedVar("spectating")) and player:GetObserverMode(OBS_MODE_ROAMING))) then return end;
	if (math.Rand(0, 1) > symptomInfo) then return end;

	player:EmitSound("ambient/voices/cough"..math.random(1,4)..".wav");

	local radius = Clockwork.config:Get("talk_radius"):Get() * 2 * (symptomInfo + .15);

	if (symptomInfo < .5) then
		Clockwork.chatBox:AddInTargetRadius(player, "me", "lets out a quick cough.", player:GetPos(), radius);
	else
		Clockwork.chatBox:AddInTargetRadius(player, "me", "lets out a small series of serious coughs.", player:GetPos(), radius);

		timer.Simple(math.Rand(1.6, 3), function()
			if (IsValid(player) and player:Alive() and !player:IsNoClipping()) then
				player:EmitSound("ambient/voices/cough"..math.random(1,4)..".wav");
			end;
		end);
	end;


	symptomInfo = symptomInfo + .15;

	for i,v in pairs(cwPlayer.GetAll()) do
		
		local diff = (v:GetShootPos() - player:GetShootPos()):GetNormalized();
		local dot = player:GetAimVector():Dot(diff); // / diff:Length()

		if (dot > 0 and player != v) then

			if (v:GetPos():Distance(Clockwork.Client:GetPos()) <= (52 * 6 * dot * symptomInfo)) then
				for _,v2 in pairs(player:GetDiseases()) do
					if (table.HasValue(cwDisease.stored.diseases[v2], "cough")) then
						v:AddDisease(v2);
					end;
				end;
			end;

		end;
	end;

end);