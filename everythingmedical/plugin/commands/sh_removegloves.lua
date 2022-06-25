local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RemoveGloves");
COMMAND.tip = "Take off your nitrile gloves.";
COMMAND.text = "<None>";
COMMAND.flags = CMD_DEFAULT;
//COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player.glovesTime != 0) then
		if (player.glovesPatient == "" and player.glovesTime >= CurTime()) then
			player:GiveItem(Clockwork.item:CreateInstance("nitrile_gloves"), true);
			Clockwork.player:Notify(player, "You have taken your nitrile gloves off. They are clean and reusable.");
		elseif (player.glovesPatient != "") then
			Clockwork.player:Notify(player, "You have taken your nitrile gloves off. They are covered in someone's blood and can't be used again.");
		else
			Clockwork.player:Notify(player, "You have taken your nitrile gloves off. They aren't really clean, and shouldn't be used again.");
		end;

		player.glovesTime = 0;
		player.glovesPatient = "";
	else
		Clockwork.player:Notify(player, "You aren't wearing any gloves.");
	end;
end;

COMMAND:Register();