local PLUGIN = PLUGIN;

Clockwork.player = Clockwork.player;

function Clockwork.player:GetInjuries(player)
	return player:GetCharacterData("injuries", {});
end;

function Clockwork.player:GetInjury(player, injury)
	local injuries = player:GetCharacterData("injuries");
	local injuryTable = Clockwork.injury:FindByID(injury);

	if (injuryTable) then
		for i,v in pairs(injuries) do
			if (v.type == injury or v.type == string.lower(injuryTable.name)) then

				return v;
			end;
		end;
	end;

	return false;
end;

if (CLIENT) then
	function Clockwork.player:GetInjuries(player)
		//print(player:GetSharedVar("injuries"))
		return PLUGIN.localInjuries;
	end;
end;

if (SERVER) then

	function Clockwork.player:TreatInjury(player, injury, treater)
		local injuries = player:GetCharacterData("injuries");
		local injuryTable = Clockwork.injury:FindByID(injury);

		if (injuryTable) then
			for i,v in pairs(injuries) do
				if (v.type == injury or v.type == string.lower(injuryTable.name)) then
					if (injuryTable.OnEnd) then
						injuryTable:OnEnd(player, v, treater);
					end;

					Clockwork.plugin:Call("OnTreatedInjury", player, injury, treater);

					injuries[i] = nil;

					player:SetCharacterData("injuries", injuries);

					return true;
				end;
			end;
		end;

		return false;
	end;

	function Clockwork.player:TreatInjuries(player, injury, treater)
		local injuries = player:GetCharacterData("injuries");
		local injuryTable = Clockwork.injury:FindByID(injury);

		if (injuryTable) then
			for i,v in pairs(injuries) do
				if (v.type == injury or v.type == string.lower(injuryTable.name)) then
					if (injuryTable.OnEnd) then
						injuryTable:OnEnd(player, v, treater);
					end;

					Clockwork.plugin:Call("OnTreatedInjury", player, injury, treater);

					injuries[i] = nil;

					player:SetCharacterData("injuries", injuries);
				end;
			end;
		end;
	end;

	function Clockwork.player:GiveInjury(player, injury, isSilent)
		local injuries = self:GetInjuries(player);
		local injuryTable = Clockwork.injury:FindByID(injury);

		isSilent = isSilent or false;

		if (injuryTable) then
			if (injuryTable.limit) then
				local injuryCount = 0;
				for i,v in pairs(injuries) do
					if (v.type == injury or v.type == string.lower(injuryTable.name)) then
						injuryCount = injuryCount + 1;
					end;
				end;

				if (injuryCount + 1 > injuryTable.limit) then
					return false;
				end
			end;

			local newInjury = {};
			newInjury.type = string.lower(injuryTable.name);
			newInjury.delay = CurTime() + injuryTable.delay;
			

			if injuryTable.defaultData then
				for i,v in pairs(injuryTable.defaultData) do
					newInjury[i] = v;
				end;
			end;

			Clockwork.plugin:Call("AdjustDefaultInjuryData", player, injuryTable, newInjury, isSilent);

			table.insert(injuries, newInjury);

			if (injuryTable.OnAcquire) then
				local result = injuryTable:OnAcquire(player, newInjury);

				if (result == false) then
					return false;
				end;
			end;

			player:SetCharacterData("injuries", injuries);

			print("Gave a "..injury)

			if (injuryTable.victim and !isSilent) then
				Clockwork.chatBox:Add(player, nil, "injury", "** "..injuryTable.victim);
			end;

			Clockwork.plugin:Call("OnGiveInjury", player, injury, isSilent);

			return newInjury;
		end;

		return false;
	end;

	function Clockwork.player:SetInjuryData(player, injury, key, value)
		local injuries = player:GetCharacterData("injuries");
		local injuryTable = Clockwork.injury:FindByID(injury);

		if (injuryTable) then
			for i,v in pairs(injuries) do
				if (v.type == injury or v.type == string.lower(injuryTable.name)) then

					v[key] = value;

					return true;
				end;
			end;
		end;

		return false;
	end;

end;