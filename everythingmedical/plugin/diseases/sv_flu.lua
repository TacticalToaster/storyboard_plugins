local PLUGIN = PLUGIN;
local cwPlayer = player;
local cwDisease = Clockwork.disease;

cwDisease:New("flu");

cwDisease:NewSymptom("flu", function(player)
	local diseaseInfo = player:GetCharacterData("diseaseInfo")["flu"];

	local startTime = diseaseInfo["start"];
	local peakTime = startTime + 3*24*60*60;
	local feverEnd = peakTime + 4*24*60*60
	local endTime = startTime + 14*24*60*60;
	local ostime = os.time();

	if (ostime >= endTime) then
		player:CureDisease("flu");
		return;
	end;

	for i,v in pairs(cwDisease:GetSymptoms("flu")) do
		if (ostime < peakTime) then
			diseaseInfo["symptoms"][i] = Lerp( (ostime - startTime)/(peakTime - startTime), 0, 1 );
		elseif (ostime < feverEnd) then
			diseaseInfo["symptoms"][i] = 1;
		else
			diseaseInfo["symptoms"][i] = Lerp( (ostime - feverEnd)/(endTime - feverEnd), 1, 0 );
		end;
	end;

	if (ostime < peakTime) then
		diseaseInfo["symptoms"]["fever"] = Lerp( (ostime - startTime)/(peakTime - startTime), 0, 1 );
	elseif (ostime < feverEnd) then
		diseaseInfo["symptoms"]["fever"] = Lerp( (ostime - peakTime)/(feverEnd - peakTime), 1, 0 );
	else
		diseaseInfo["symptoms"]["fever"] = 0;
	end;

	if (ostime < peakTime) then
		diseaseInfo["symptoms"]["cough"] = Lerp( (ostime - startTime)/(peakTime - startTime), 0, 1 );
	elseif (ostime < feverEnd) then
		diseaseInfo["symptoms"]["cough"] = 1;
	else
		diseaseInfo["symptoms"]["cough"] = Lerp( (ostime - feverEnd)/(endTime - feverEnd), 1, 0 );
	end;

	local dInfo = player:GetCharacterData("diseaseInfo");
	dInfo["flu"] = diseaseInfo;

	player:SetCharacterData("diseaseInfo", dInfo);

end);

cwDisease:AddSymptom("flu", "flu");
cwDisease:AddSymptom("flu", "congestion");
cwDisease:AddSymptom("flu", "cough");
cwDisease:AddSymptom("flu", "sorethroat");
cwDisease:AddSymptom("flu", "headache");
cwDisease:AddSymptom("flu", "fever");

