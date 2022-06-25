--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("equipment_base", true);
ITEM.name = "Mask Base";
ITEM.uniqueID = "mask_base";
ITEM.category = "Equipment"
ITEM.equippedCategory = "Headgear";
ITEM.equipmentSlot = "headgear";
ITEM.weight = 1;
ITEM.description = "A simple gasmask with a basic filter.";
ITEM.maskOverlay = Material( "OIIJIOT/respiratordmxmd" );
ITEM.radiationProtection = .8;
ITEM.noFilterProtection = .1;
ITEM.noConditionGasProtection = 0;
ITEM.gasProtection = 1;
ITEM.exposureAlways = true;
//ITEM.canTakeDamage = true;
//ITEM.damagePerCondition = 5;

ITEM:AddData("Filter", {nil, 0}, true);

function ITEM:GetEntityMenuOptions(menuPanel, options)
	options["Change Filter"] = {};

	if (CLIENT) then
		local inventory = Clockwork.inventory:GetClient();

		if (self:GetData("Filter")[1]) then
			options["Remove Filter"] = function()
				Clockwork.kernel:RunCommand("ChangeFilter", self("uniqueID"), tostring(self("itemID")), "", "");
			end;
		end;

		if (Clockwork.inventory:GetItemsByID(inventory, "filter_civilian")) then
			local index = 1;
			for i, v in pairs(Clockwork.inventory:GetItemsByID(inventory, "filter_civilian")) do
				options["Change Filter"]["Civilian Filter "..index.." - "..string.ToMinutesSeconds(v:GetData("Condition")).." Left"] = function()
					Clockwork.kernel:RunCommand("ChangeFilter", self("uniqueID"), tostring(self("itemID")), v("uniqueID"), tostring(v("itemID")));
				end;

				index = index + 1;
			end;
		end;

		if (Clockwork.inventory:GetItemsByID(inventory, "filter_military")) then
			local index = 1;
			for i, v in pairs(Clockwork.inventory:GetItemsByID(inventory, "filter_military")) do
				options["Change Filter"]["Military Filter "..index.." - "..string.ToMinutesSeconds(v:GetData("Condition")).." Left"] = function()
					Clockwork.kernel:RunCommand("ChangeFilter", self("uniqueID"), tostring(self("itemID")), v("uniqueID"), tostring(v("itemID")));
				end;

				index = index + 1;
			end;
		end;

		if (Clockwork.inventory:GetItemsByID(inventory, "filter_makeshift")) then
			local index = 1;
			for i, v in pairs(Clockwork.inventory:GetItemsByID(inventory, "filter_makeshift")) do
				options["Change Filter"]["Makeshift Filter "..index.." - "..string.ToMinutesSeconds(v:GetData("Condition")).." Left"] = function()
					Clockwork.kernel:RunCommand("ChangeFilter", self("uniqueID"), tostring(self("itemID")), v("uniqueID"), tostring(v("itemID")));
				end;

				index = index + 1;
			end;
		end;

	end;
end;

function ITEM:GetRadiationProtection(player)
	local filter = self:GetData("Filter");

	if (filter[1]) then
		if (filter[2] > 0) then
			return self.radiationProtection;
		else
			return self.noFilterProtection;
		end;
	else
		return self.noFilterProtection;
	end;
end;

function ITEM:GetGasProtection(player)
	local filter = self:GetData("Filter");

	if (self:GetCondition() <= 0) then
		return self.noConditionGasProtection;
	end;

	if (filter[1]) then
		if (filter[2] > 0) then
			return self.gasProtection;
		else
			return self.noFilterProtection;
		end;
	else
		return self.noFilterProtection;
	end;
end;

function ITEM:Exposure(player, time)
	if (!time) then
		time = 1;
	end;

	local filter = self:GetData("Filter");

	if (filter[1]) then
		filter[2] = math.Clamp(filter[2] - time, 0, 10800);
		self:SetData("Filter", filter);
		Clockwork.item:SendUpdate(self, self.data);
	end;
end;

function ITEM:DamageCondition(player, damageInfo, hitGroup)
	local oldCond = self:GetCondition();
	local newCond = math.Clamp(oldCond-(self.resistance*damageInfo:GetDamage()), 0, math.huge);

	if (oldCond > 0 and newCond <= 0) then
		local tbl = {};
		local shatter = "decals/glass/shot"..tostring(math.random(1, 5));

		table.insert(tbl, {material = shatter, x = math.Rand(.3, .7), y = math.Rand(.4, .5), size = math.Rand(1.5, 3)});
		self:SetData("Damage", tbl);

		local snd = Sound("physics/glass/glass_impact_bullet"..tostring(math.random(1,4))..".wav")

		player:EmitSound(snd);
	end;

	self:SetData("Condition", newCond);

	Clockwork.item:SendUpdate(self, self.data);
end;

function ITEM:CanDamageCondition(player, damageInfo, hitGroup)
	local correctDMGType = false;
	local correctHitGroup = false;

	if (self:GetCondition() <= 0) then
		return false;
	end;

	for i, v in pairs(self.conditionDMGTypes) do
		if (damageInfo:IsDamageType(v)) then
			correctDMGType = true;

			break;
		end;
	end;

	for i, v in pairs(self.hitGroups) do
		if (hitGroup == v) then
			correctHitGroup = true;

			break;
		end;
	end;

	return (correctDMGType and correctHitGroup);
end;

function ITEM:OnPlayerThink(player, infoTable)

end;

if (CLIENT) then
	function ITEM:ExtraClientSideInfo(markupText)
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = markupText or "";
		local filter = self:GetData("Filter");
		
		if (filter[1]) then
			if (filter[1] == "filter_civilian") then
				clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Civilian Filter: "..string.ToMinutesSeconds(filter[2]).." Left");
			elseif (filter[1] == "filter_military") then
				clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Military Filter: "..string.ToMinutesSeconds(filter[2]).." Left");
			elseif (filter[1] == "filter_makeshift") then
				clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Makeshift Filter: "..string.ToMinutesSeconds(filter[2]).." Left");
			end;
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

ITEM:Register();