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

Clockwork.chatBox:RegisterClass("injury", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	if (CurTime() >= PLUGIN.nextInjuryNotification) then
		PLUGIN.nextInjuryNotification = CurTime() + .3;

		Clockwork.chatBox:SetMultiplier(.7);
		
		Clockwork.chatBox:Add(info.filtered, "icon16/injury.png", Color(204, 113, 88, 255), info.text);
	end;
end);

Clockwork.chatBox:RegisterClass("injurydiagnose", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	Clockwork.chatBox:SetMultiplier(.7);
	
	Clockwork.chatBox:Add(info.filtered, "icon16/injury.png", Color(204, 113, 88, 255), info.text);
end);

Clockwork.chatBox:RegisterClass("injurykill", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);

	Clockwork.chatBox:Add(info.filtered, "icon16/death.png", Color(176, 97, 76, 255), info.text);
end);

Clockwork.chatBox:RegisterClass("treat", "ic", function(info)
	//local localized = Clockwork.chatBox:LangToTable("ChatPlayerDisconnect", Color(200, 150, 200, 255), info.text);
	
	Clockwork.chatBox:SetMultiplier(.7);

	Clockwork.chatBox:Add(info.filtered, "icon16/treat.png", Color(150, 204, 41, 255), info.text);
end);

Clockwork.datastream:Hook("UpdateInjuries", function(data)
	if (istable(data[1])) then
		PLUGIN.localInjuries = data[1];
	end;
end)