/*Clockwork.config:AddToSystem("Hunger Tick Time", "stats_hunger_tick", "Tick time (in seconds) for checking/changing hunger.");
Clockwork.config:AddToSystem("Hydration Tick Time", "stats_hydration_tick", "Tick time (in seconds) for checking/changing hydration.");
Clockwork.config:AddToSystem("Toxicity Tick Time", "stats_toxicity_tick", "Tick time (in seconds) for checking/changing toxicity.");
Clockwork.config:AddToSystem("Radiation Tick Time", "stats_radiation_tick", "Tick time (in seconds) for checking/changing radiation.");*/

local PLUGIN = PLUGIN;

Clockwork.config:AddToSystem("Enable Pain Immobilization on Death", "med_pain_death", "Replaces unconciousness on death with max pain instead.", 0, 1);
Clockwork.config:AddToSystem("Only use PKable Deaths", "med_pk_deaths", "Instead of resetting the player every two health deaths, instead only PKable deaths caused by stat loss or double tapping will be counted.", 0, 1);

PLUGIN.localInjuries = {};

PLUGIN.nextInjuryNotification = 0;

PLUGIN.suppression = 0;

PLUGIN.nextChatQuit = 0;

PLUGIN.amputationData = {};

PLUGIN.ampModels = {};

PLUGIN.amputationTable = {
	["lforearm"] = {"ValveBiped.Bip01_L_Forearm"},
	["rforearm"] = {"ValveBiped.Bip01_R_Forearm"},
	["larm"] = {"ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Shoulder"},
	["rarm"] = {"ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Shoulder"}
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

	//table.insert( bones, boneID );

	for k = 0, bonecount - 1 do
		if ( ent:GetBoneParent( k ) != boneID ) then continue end;
		//print("new bone", k);
		table.insert( bones, k );
		//PrintTable(bones);
		PLUGIN.GetAllChildBones(ent, k, bones);
	end;

	return bones;

end;

Clockwork.datastream:Hook("TookDamage", function(data)
	PLUGIN.painSize = data;
	PLUGIN.painAlpha = 255
end);

Clockwork.datastream:Hook("Suppression", function(data)
	local curTime = CurTime();
	local combatBoost = Clockwork.Client:GetSharedVar("combatBoost");
	local combatBoostCooldown = Clockwork.Client:GetSharedVar("combatBoostCooldown");
	local isBoosted = (combatBoost > curTime and combatBoostCooldown < curTime);

	PLUGIN.suppression = math.Clamp(PLUGIN.suppression + data, 0, 4);

	if (!isBoosted and curTime >= PLUGIN.nextChatQuit) then
		if (Clockwork.chatBox:IsOpen()) then
			local text = Clockwork.chatBox.textEntry:GetValue();
			
			if (text != "" and string.utf8sub(text, 1, 2) != "//" and string.utf8sub(text, 1, 3) != ".//"
			and string.utf8sub(text, 1, 2) != "[[") then
				Clockwork.chatBox.textEntry:SetRealValue(string.utf8sub(text, 0, string.utf8len(text) - 1).."-");
				Clockwork.chatBox.textEntry:OnEnter();
			end;
		end;
	end;

	PLUGIN.nextChatQuit = curTime + 15;
end);

Clockwork.datastream:Hook("EntityClearAmputation", function(data)
	if (!data) then return end;
	PLUGIN.amputationData[data] = {};
end);

Clockwork.datastream:Hook("EntityAmputation", function(data)
	if (!data or !data.ent) then return end;
	PLUGIN.amputationData[data.ent] = PLUGIN.amputationData[data.ent] or {};
	PLUGIN.amputationData[data.ent][data.amp] = {["render"] = data.render, ["norender"] = data.norender};

	/*if (data.amp == "rarm") then
		local newModel = ClientsideModel("models/hunter/plates/plate05.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_R_Forearm"), ["pos"] = Vector(2,0,0), ["ang"] = Angle(0, 0, 90), ["model"] = newModel});

		newModel = ClientsideModel("models/hunter/plates/plate075.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), ["pos"] = Vector(2,0,0), ["ang"] = Angle(0, 0, 90), ["model"] = newModel});

		newModel = ClientsideModel("models/Gibs/HGIBS.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_R_Hand"), ["pos"] = Vector(1,0,0), ["ang"] = Angle(0, 0, 0), ["model"] = newModel});
	end;

	if (data.amp == "larm") then
		local newModel = ClientsideModel("models/hunter/plates/plate05.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_L_Forearm"), ["pos"] = Vector(2,0,0), ["ang"] = Angle(0, 0, 90), ["model"] = newModel});

		newModel = ClientsideModel("models/hunter/plates/plate075.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), ["pos"] = Vector(2,0,0), ["ang"] = Angle(0, 0, 90), ["model"] = newModel});

		newModel = ClientsideModel("models/Gibs/HGIBS.mdl");
		if (IsValid(data.ent)) then
			newModel:SetOwner(data.ent)
		end;
		newModel:SetNoDraw(true)
		newModel:DrawShadow(false)
		newModel:SetModelScale(1, 0)
		newModel:SetRenderBounds(Vector(-32, -32, -32), Vector(32, 32, 32))

		table.insert(PLUGIN.amputationData[data.ent].wounds, {["bone"] = data.ent:LookupBone("ValveBiped.Bip01_L_Hand"), ["pos"] = Vector(1,0,0), ["ang"] = Angle(0, 0, 0), ["model"] = newModel});
	end;*/
end);

Clockwork.chatBox:RegisterClass("injury", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	if (CurTime() >= PLUGIN.nextInjuryNotification) then
		PLUGIN.nextInjuryNotification = CurTime() + .3;

		Clockwork.chatBox:SetMultiplier(.7);
		
		Clockwork.chatBox:Add(info.filtered, "clandestine/icon16/injury.png", Color(204, 113, 88, 255), info.text);
	end;
end);

Clockwork.chatBox:RegisterClass("injurydiagnose", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	Clockwork.chatBox:SetMultiplier(.7);
	
	Clockwork.chatBox:Add(info.filtered, "clandestine/icon16/injury.png", Color(204, 113, 88, 255), info.text);
end);

Clockwork.chatBox:RegisterClass("injurykill", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	Clockwork.chatBox:Add(info.filtered, "clandestine/icon16/death.png", Color(176, 97, 76, 255), info.text);
end);

Clockwork.chatBox:RegisterClass("treat", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);
	
	Clockwork.chatBox:SetMultiplier(.7);

	Clockwork.chatBox:Add(info.filtered, "clandestine/icon16/treat.png", Color(150, 204, 41, 255), info.text);
end);

Clockwork.datastream:Hook("UpdateInjuries", function(data)
	if (istable(data[1])) then
		PLUGIN.localInjuries = data[1];
	end;
	if (istable(data[2])) then
		PLUGIN.localDiseases = data[2];
	end;
end)