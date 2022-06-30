local PLUGIN = PLUGIN;

function PLUGIN:LeaveCorpse(ragdoll, player)
	//Clockwork.entity:CopyGearBM(player, ragdoll, false, false);
end;

function PLUGIN:EntityRemoved(ent)
	if (ent.cwGearTab) then
		for i, v in pairs(ent.cwGearTab) do
			if IsValid(v) then
				v:Remove();
				ent.cwGearTab[i] = nil;
			end;
		end;
	end;
end;

function PLUGIN:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local clothes = player:GetClothesItem();
	local accessories = player:GetAccessoryData();

	if (clothes and clothes.TakeDamage) then
		clothes:TakeDamage(player, damageInfo, hitGroup);
	end;

	for i, v in pairs(accessories) do
		local itemTable = player:FindItemByID(v, i)
		//print(itemTable, itemTable.TakeDamage, itemTable.OnTakeDamage)

		if (itemTable.TakeDamage) then
			itemTable:TakeDamage(player, damageInfo, hitGroup);
		end;
	end;

	if damageInfo:GetDamage() == 0 then return false end;
end;

function PLUGIN:PlayerShouldTakeDamage(player, attacker, inflictor, damageInfo)
	local clothes = player:GetClothesItem();
	local accessories = player:GetAccessoryData();
	local shouldTakeDamage = true;

	if (clothes and clothes.PlayerShouldTakeDamage) then
		shouldTakeDamage = clothes:PlayerShouldTakeDamage(player, damageInfo);
		if !shouldTakeDamage then return false end;
	end;

	for i, v in pairs(accessories) do
		local itemTable = player:FindItemByID(v, i)
		//print(itemTable, itemTable.TakeDamage, itemTable.OnTakeDamage)

		if (itemTable.PlayerShouldTakeDamage) then
			shouldTakeDamage = itemTable:PlayerShouldTakeDamage(player, damageInfo);
			if !shouldTakeDamage then return false end;
		end;
	end;
end;

function PLUGIN:PlayerShouldInjureFromDamage(player, attacker, hitGroup, damageInfo, baseDamage)
	local clothes = player:GetClothesItem();
	local accessories = player:GetAccessoryData();
	local shouldTakeDamage = true;

	if (clothes and clothes.PlayerShouldInjureFromDamage) then
		shouldTakeDamage = clothes:PlayerShouldInjureFromDamage(player, attacker, hitGroup, damageInfo, baseDamage);
		if !shouldTakeDamage then return false end;
	end;

	for i, v in pairs(accessories) do
		local itemTable = player:FindItemByID(v, i)
		//print(itemTable, itemTable.TakeDamage, itemTable.OnTakeDamage)
		if itemTable then
			if (itemTable.PlayerShouldInjureFromDamage) then
				shouldTakeDamage = itemTable:PlayerShouldInjureFromDamage(player, attacker, hitGroup, damageInfo, baseDamage);
				if shouldTakeDamage != nil and !shouldTakeDamage then return false end;
			end;
		end;
	end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
	// TODO: Moving exposure and playerthink checks for accessories to timers

	if not player.nextExposureTime then player.nextExposureTime = 0 end;

	local clothes = player:GetClothesItem();
	local accessories = player:GetAccessoryData();

	if (clothes and clothes.OnPlayerThink) then
		clothes:OnPlayerThink(player, infoTable);
	end;

	if (player.nextExposureTime <= curTime) then
		if (clothes and clothes.Exposure and clothes.exposureAlways) then
			clothes:Exposure(player, 1);
		end;
	end;

	for i, v in pairs(accessories) do
		local itemTable = player:FindItemByID(v, i)

		if itemTable then
			if itemTable.wearPocketSpace then
				infoTable.inventoryWeight = infoTable.inventoryWeight + itemTable.wearPocketSpace;
			end;

			if itemTable.wearSpeedMod then
				local info = {};
				info.speedMod = itemTable.wearSpeedMod;

				Clockwork.plugin:Call("PlayerAdjustEquipmentSpeedMod", player, infoTable, info);

				infoTable.walkSpeed = infoTable.walkSpeed * info.speedMod;//itemTable.wearSpeedMod;
				infoTable.runSpeed = infoTable.runSpeed * info.speedMod;//itemTable.wearSpeedMod;
			end;

			if (itemTable.OnPlayerThink) then
				itemTable:OnPlayerThink(player, infoTable);
			end;

			if (player.nextExposureTime <= curTime) then
				if (itemTable.Exposure and itemTable.exposureAlways) then
					itemTable:Exposure(player, 1);
				end;
			end;
		end;
	end;

	if (player.nextExposureTime <= curTime) then
		player.nextExposureTime = curTime + 1;
	end;

end;
