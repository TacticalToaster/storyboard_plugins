local playerMeta = FindMetaTable("Player");

function playerMeta:GetInjuries()
	return Clockwork.player:GetInjuries(self);
end;

function playerMeta:GetInjury(injury)
	return Clockwork.player:GetInjury(self, injury);
end;

function playerMeta:HasInjury(injury)
	local injuries = self:GetInjuries();
	local injuryTable = Clockwork.injury:FindByID(injury);

	for i,v in pairs(injuries) do
		if (v.type == injury or v.type == string.lower(injuryTable.name)) then return true end;
	end;

	return false;
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

	return timeMod;
end;