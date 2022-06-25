local PLUGIN = PLUGIN;

function Clockwork.player:CreateGearBM(player, gearClass, itemTable, mustHave, forcedModel)
	if (!player.cwGearTab) then
		player.cwGearTab = {};
	end;
	
	if (IsValid(player.cwGearTab[gearClass])) then
		player.cwGearTab[gearClass]:Remove();
	end;
	
	if (itemTable("isBonemerged")) then
		local position = player:GetPos();
		local angles = player:GetAngles();
		local model = itemTable("attachmentModel", itemTable("model"));
		
		player.cwGearTab[gearClass] = ents.Create("cw_gear_bm");

		if (forcedModel) then
			player.cwGearTab[gearClass]:SetModel(forcedModel);
		else
			player.cwGearTab[gearClass]:SetModel(model);
		end;
		//player.cwGearTab[gearClass]:SetAngles(angles);
		//player.cwGearTab[gearClass]:SetPos(position);
		player.cwGearTab[gearClass]:SetParent(player, 0);
		player.cwGearTab[gearClass]:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL)); //bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES)
		player.cwGearTab[gearClass]:Spawn();
		
		
		if (itemTable("attachmentMaterial")) then
			player.cwGearTab[gearClass]:SetMaterial(itemTable("attachmentMaterial"));
		end;
		
		if (itemTable("attachmentColor")) then
			player.cwGearTab[gearClass]:SetColor(
				cwKernel:UnpackColor(itemTable("attachmentColor"))
			);
		else
			player.cwGearTab[gearClass]:SetColor(Color(255, 255, 255, 255));
		end;
		
		if (IsValid(player.cwGearTab[gearClass])) then
			player.cwGearTab[gearClass]:SetOwner(player);
			player.cwGearTab[gearClass]:SetMustHave(mustHave);
			player.cwGearTab[gearClass]:SetItemTable(gearClass, itemTable);
			player.cwGearTab[gearClass].ForcedModel = forcedModel;
		end;
	end;
end;