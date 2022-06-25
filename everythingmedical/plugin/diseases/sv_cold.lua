local PLUGIN = PLUGIN;
local cwPlayer = player;
local cwDisease = Clockwork.disease;

cwDisease:New("cold");

cwDisease:NewSymptom("cold", function(player)
	local diseaseInfo = player:GetCharacterData("diseaseInfo")["cold"];

	local startTime = diseaseInfo["start"];
	local peakTime = startTime + 5*24*60*60;
	local endTime = startTime + 8*24*60*60;

	if (os.time() >= endTime) then
		player:CureDisease("cold");
		return;
	end;

	for i,v in pairs(cwDisease:GetSymptoms("cold")) do
		if (os.time() < peakTime) then
			diseaseInfo["symptoms"][i] = Lerp( (os.time() - startTime)/(peakTime - startTime), 0, 1 );
		elseif (os.time() < endTime) then
			diseaseInfo["symptoms"][i] = Lerp( (os.time() - peakTime)/(endTime - peakTime), 1, 0 );
		end;
	end;

	local dInfo = player:GetCharacterData("diseaseInfo");
	dInfo["cold"] = diseaseInfo;

	player:SetCharacterData("diseaseInfo", dInfo);

end);

cwDisease:AddSymptom("cold", "cold");
cwDisease:AddSymptom("cold", "congestion");
cwDisease:AddSymptom("cold", "cough");
cwDisease:AddSymptom("cold", "sorethroat");
cwDisease:AddSymptom("cold", "headache");
cwDisease:AddSymptom("cold", "congestion");

