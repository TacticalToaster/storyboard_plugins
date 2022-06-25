--[[
	© 2015 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ChangeFilter");
COMMAND.tip = "Change a mask's filter.";
COMMAND.text = "<string UniqueID> [string ItemID] <string UniqueID> [string ItemID]";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 4;
//COMMAND.optionalArguments = 4;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local maskTable = player:FindItemByID(arguments[1], tonumber(arguments[2]));

	print("m", maskTable, arguments[1], arguments[2], arguments[3], arguments[4])


	if (maskTable and arguments[3] == "") then
		local filter = maskTable:GetData("Filter");

		maskTable:SetData("Filter", {nil, 0});

		if (filter[1]) then
			local newFilter = player:GiveItem(filter[1], true);
			newFilter:SetData("Condition", filter[2]);
		end;

		return;
	else
		if (!maskTable) then
			Clockwork.player:Notify(player, "You do not own this mask!");
		end;
	end;

	local filterTable = player:FindItemByID(arguments[3], tonumber(arguments[4]));

	print("f", filterTable)
	
	if (maskTable and filterTable) then
		local filter = maskTable:GetData("Filter");

		maskTable:SetData("Filter", {filterTable("uniqueID"), filterTable:GetData("Condition")});

		if (filter[1]) then
			local newFilter = player:GiveItem(filter[1], true);
			newFilter:SetData("Condition", filter[2]);
		end;

		player:TakeItem(filterTable);
	else
		Clockwork.player:Notify(player, "You do not own this mask/filter!");
	end;
end;

COMMAND:Register();