local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CheckGloves");
COMMAND.tip = "Check to see if you're wearing gloves, and whether they're clean or not.";
COMMAND.text = "<None>";
COMMAND.flags = CMD_DEFAULT;
//COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player.glovesTime != 0) then
		if (player.glovesPatient == "" and player.glovesTime >= CurTime()) then
			Clockwork.player:Notify(player, "You check your gloves to see that they're completely clean.");
		elseif (player.glovesPatient != "" and player.glovesTime >= CurTime()) then
			Clockwork.player:Notify(player, "You check your gloves to see that they're covered in blood.");
		elseif (player.glovesPatient == "" and player.glovesTime < CurTime()) then
			Clockwork.player:Notify(player, "You check your gloves to find that they have some debris from the environment on them.");
		else
			Clockwork.player:Notify(player, "You check your gloves to see they're coverd in blood and debris from the environment.");
		end;
	else
		Clockwork.player:Notify(player, "You aren't wearing any gloves.");
	end;
end;

COMMAND:Register();