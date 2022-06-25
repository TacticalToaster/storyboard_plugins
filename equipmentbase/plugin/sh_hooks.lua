local PLUGIN = PLUGIN;

function PLUGIN:PlayerRagdolled(player, state, ragdoll)
	if (player.cwGearTab and IsValid(ragdoll.entity)) then
		//print("here we go, Im falling")
		for i, v in pairs(player.cwGearTab) do
			
			if (IsValid(v)) then
				v:SetParent(ragdoll.entity, 0);
				//v:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL));
			end;

		end;
	end;
end;

function PLUGIN:PlayerUnragdolled(player, state, ragdoll)
	if (player.cwGearTab and IsValid(player)) then
		//print("here we go, im getting up")
		for i, v in pairs(player.cwGearTab) do
			
			if (IsValid(v)) then
				v:SetParent(player, 0);
				//v:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL));
			end;

		end;
	end;
end;