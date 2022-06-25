local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharGiveInjury");
COMMAND.tip = "Give a player an injury.";
COMMAND.text = "<string Name> <string Injury>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		local text = table.concat(arguments, " ", 2);

		local success = target:GiveInjury(text);
		if (success) then
			if ( player != target )	then
				//Clockwork.player:Notify(target, player:Name().." has treated your injuries.");
				Clockwork.player:Notify(player, "You have given an injury to "..target:Name()..".");
			else
				Clockwork.player:Notify(player, "You have given yourself an injury.");
			end;
		else
			Clockwork.player:Notify(player, text.." is not a valid injury or this player has the max of this injury!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();