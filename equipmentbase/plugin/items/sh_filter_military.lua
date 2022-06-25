--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Military Filter";
ITEM.uniqueID = "filter_military";
ITEM.cost = 10;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 1;
ITEM.access = "1";
//ITEM.useText = "Consumables";
ITEM.business = true;
ITEM.category = "Filters";
ITEM.description = "A large green filter with white markings. It should fit on most masks.";
ITEM.maxCondition = 3600;

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

	function ITEM:GetEntityMenuOptions(menuPanel, options)
		if (self:GetData("Condition") and self:GetData("Condition") <= 0) then
			options["Convert to Makeshift Filter"] = function()
				Clockwork.datastream:Start("ConvertFilter", {self("uniqueID"), self("itemID")});
			end;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();