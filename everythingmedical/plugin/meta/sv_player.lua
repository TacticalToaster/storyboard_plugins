local playerMeta = FindMetaTable("Player");

function playerMeta:GetInjuries()
	return Clockwork.player:GetInjuries(self);
end;

function playerMeta:GetInjury(injury)
	return Clockwork.player:GetInjury(self, injury);
end;

function playerMeta:SetInjuryData(injury, key, value)
	return Clockwork.player:SetInjuryData(self, injury, key, value);
end;

function playerMeta:HasInjury(injury)
	local injuries = self:GetInjuries();
	local injuryTable = Clockwork.injury:FindByID(injury);

	for i,v in pairs(injuries) do
		if (v.type == injury or v.type == string.lower(injuryTable.name)) then return true end;
	end;

	return false;
end;

function playerMeta:GiveInjury(injury, isSilent)
	return Clockwork.player:GiveInjury(self, injury, isSilent);
end;

function playerMeta:GiveWoundInfection(injury, isSilent)
	return Clockwork.player:GiveInjury(self, injury, isSilent);
end;

function playerMeta:TreatInjury(injury, treater)
	return Clockwork.player:TreatInjury(self, injury, treater);
end;

function playerMeta:TreatInjuries(injury, treater)
	return Clockwork.player:TreatInjuries(self, injury, treater);
end;

function playerMeta:ResetInjuries()
	for i,v in pairs(self:GetInjuries()) do
		local injuryTable = Clockwork.injury:FindByID(v.type);

		if (injuryTable) then
			if (injuryTable.OnReset) then
				injuryTable:OnReset(self, v);
			end;
		end;
	end;
end;

function playerMeta:UpdateAmputations()
	for i,v in pairs(self:GetInjuries()) do
		local injuryTable = Clockwork.injury:FindByID(v.type);

		if (injuryTable) then
			if (injuryTable.GetAmputation) then
				local dataTable = {};
				dataTable.ent = self;
				table.Merge(dataTable, injuryTable:GetAmputation(self, v));
				Clockwork.datastream:Start(nil, "EntityAmputation", dataTable);
			end;
		end;
	end;
end;

function playerMeta:GetAmputations()
	local ampTable = {};

	for i,v in pairs(self:GetInjuries()) do
		local injuryTable = Clockwork.injury:FindByID(v.type);

		if (injuryTable) then
			if (injuryTable.GetAmputation) then
				local dataTable = {};
				dataTable.ent = self;
				table.Merge(dataTable, injuryTable:GetAmputation(self, v));
				table.insert(ampTable, dataTable);
			end;
		end;
	end;

	return ampTable;
end;

function playerMeta:ClearAmputations()
	Clockwork.datastream:Start(nil, "EntityClearAmputation", self);
end;

function playerMeta:CopyAmputationsToEnt(ent, additionalAmps)
	local ampTable = self:GetAmputations();
	if (additionalAmps) then table.Merge(ampTable, additionalAmps) end;

	for i,v in pairs(ampTable) do
		v.ent = ent;
		Clockwork.datastream:Start(nil, "EntityAmputation", v);
	end;
end;

function playerMeta:GetDiseases()
	return Clockwork.player:GetDiseases(self);
end;

function playerMeta:HasDiseases()
	return Clockwork.player:HasDiseases(self);
end;

function playerMeta:GetSymptoms()
	return Clockwork.player:GetSymptoms(self);
end;

function playerMeta:AddDisease(uniqueID)
	local diseaseInfo = self:GetCharacterData("diseaseInfo");

	Clockwork.player:AddDisease(self, uniqueID);

	if (!diseaseInfo[uniqueID]) then
		diseaseInfo[uniqueID] = {};
		diseaseInfo[uniqueID]["start"] = os.time();
		diseaseInfo[uniqueID]["symptoms"] = {};
	end;

	self:SetCharacterData("diseaseInfo", diseaseInfo);
end;

function playerMeta:CureAllDisease()
	Clockwork.player:CureAll(self);
	self:SetCharacterData("diseaseInfo", {});
	self:SetCharacterData("symptomInfo", {});
end;

function playerMeta:CureDisease(uniqueID)
	local diseaseInfo = self:GetCharacterData("diseaseInfo");

	Clockwork.player:Cure(self, uniqueID);

	if (diseaseInfo[uniqueID]) then
		diseaseInfo[uniqueID] = nil;
	end;

	self:SetCharacterData("diseaseInfo", diseaseInfo);
	
	self:CalculateSymptomInfo()
end;

function playerMeta:CalculateSymptomInfo()
	local diseaseInfo = self:GetCharacterData("diseaseInfo");
	local symptomInfo = {};

	for i,v in pairs(diseaseInfo) do
		if (v.symptoms) then
			for i2,v2 in pairs(v.symptoms) do
				if (symptomInfo[i2]) then
					symptomInfo[i2] = math.max(symptomInfo[i2], v2);
				else
					symptomInfo[i2] = v2;
				end;
			end;
		end;
	end;

	self:SetCharacterData("symptomInfo", symptomInfo);
end;

function playerMeta:GetActionTimeModifier()
	local timeMod = 1;
	local blood = tonumber(self:GetCharacterData("blood"));
	local pain = tonumber(self:GetCharacterData("pain"));
	local respiration = tonumber(self:GetCharacterData("respiration"));

	if (self:HasInjury("damaged arm")) then
		timeMod = timeMod + .25;
	end;

	if (self:HasInjury("concussion")) then
		timeMod = timeMod + .1;
	end;

	if (self:HasInjury("traumatic brain injury")) then
		timeMod = timeMod + .15;
	end;

	if (pain >= 30) then
		timeMod = timeMod + .1;
	end;

	if (respiration <= 80) then
		timeMod = timeMod + .1;
	end;

	Clockwork.plugin:Call("PlayerAdjustActionTimeModifier", self, timeMod);

	return timeMod;
end;