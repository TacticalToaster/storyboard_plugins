local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("ToggleOpFor");
COMMAND.tip = "Enable or disable OpFor Mode";
COMMAND.text = "";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:Alive()) then
		if (player.opforMode) then
			player.opforMode = false;
			Clockwork.player:Notify(player, "OpFor Mode has been toggled off for you.");
		else
			player.opforMode = true;
			Clockwork.player:Notify(player, "OpFor Mode has been toggled on for you.");
		end;
	end;
end;

COMMAND:Register();