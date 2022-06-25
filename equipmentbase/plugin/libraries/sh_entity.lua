local PLUGIN = PLUGIN;

function Clockwork.entity:CreateGearBM(entity, gearClass, itemTable, mustHave, forcedModel)
	if (!entity.cwGearTab) then
		entity.cwGearTab = {};
	end;
	
	if (IsValid(entity.cwGearTab[gearClass])) then
		entity.cwGearTab[gearClass]:Remove();
	end;
	
	if (itemTable("isBonemerged")) then
		local position = entity:GetPos();
		local angles = entity:GetAngles();
		local model = itemTable("attachmentModel", itemTable("model"));
		
		entity.cwGearTab[gearClass] = ents.Create("cw_gear_bm");

		if (forcedModel) then
			entity.cwGearTab[gearClass]:SetModel(forcedModel);
		else
			entity.cwGearTab[gearClass]:SetModel(model);
		end;
		//entity.cwGearTab[gearClass]:SetAngles(angles);
		//entity.cwGearTab[gearClass]:SetPos(position);
		entity.cwGearTab[gearClass]:SetParent(entity, 0);
		entity.cwGearTab[gearClass]:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL)); //bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES)
		entity.cwGearTab[gearClass]:Spawn();
		
		
		if (itemTable("attachmentMaterial")) then
			entity.cwGearTab[gearClass]:SetMaterial(itemTable("attachmentMaterial"));
		end;
		
		if (itemTable("attachmentColor")) then
			entity.cwGearTab[gearClass]:SetColor(
				cwKernel:UnpackColor(itemTable("attachmentColor"))
			);
		else
			entity.cwGearTab[gearClass]:SetColor(Color(255, 255, 255, 255));
		end;
		
		if (IsValid(entity.cwGearTab[gearClass])) then
			entity.cwGearTab[gearClass]:SetOwner(entity);
			entity.cwGearTab[gearClass]:SetMustHave(mustHave);
			entity.cwGearTab[gearClass]:SetItemTable(gearClass, itemTable);
			entity.cwGearTab[gearClass].ForcedModel = forcedModel;
			entity.cwGearTab[gearClass].ForcedEntity = true;

			return entity.cwGearTab[gearClass];
		end;
	end;
end;

function Clockwork.entity:CopyGearBM(copyFrom, copyTo, saveHave, forceHave)
	if (copyFrom.cwGearTab) then
		for i, v in pairs(copyFrom.cwGearTab) do
			if (IsValid(v)) then
				if (forceHave != nil) then
					Clockwork.entity:CreateGearBM(copyTo, i, v:GetItemTable(), forceHave, v.ForcedModel);
				elseif (saveHave) then
					Clockwork.entity:CreateGearBM(copyTo, i, v:GetItemTable(), v.cwMustHave, v.ForcedModel);
				else
					Clockwork.entity:CreateGearBM(copyTo, i, v:GetItemTable(), false, v.ForcedModel);
				end;
			end;
		end;
	end;
end;