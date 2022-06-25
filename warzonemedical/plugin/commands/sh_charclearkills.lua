local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharClearKills");
COMMAND.tip = "Clear a player's deaths.";
COMMAND.text = "<string Name>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )

	if (target) then
		target.deathCount = 0;
		//target.nextHunger = CurTime() + 1;
		if ( player != target )	then
			//Clockwork.player:Notify(target, player:Name().." has cleared your deaths.");
			Clockwork.player:Notify(player, "You have cleared "..target:Name().."'s death count.");
		else
			Clockwork.player:Notify(player, "You have cleared your death count.");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();