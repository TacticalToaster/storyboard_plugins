--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Makeshift Filter";
ITEM.uniqueID = "filter_makeshift";
ITEM.cost = 10;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 1;
ITEM.access = "1";
//ITEM.useText = "Consumables";
ITEM.business = true;
ITEM.category = "Filters";
ITEM.description = "A small container that's been converted into use as a filter with activated charcoal.";
ITEM.maxCondition = 900;

ITEM:AddData("Condition", ITEM.maxCondition, true);

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = "";
		local condition = self:GetData("Condition");
		
		if (condition) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Filter Condition: "..string.ToMinutesSeconds(condition).." Left");
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();