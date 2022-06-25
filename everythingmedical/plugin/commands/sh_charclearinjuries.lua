local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharClearInjuries");
COMMAND.tip = "Clear a player's injuries.";
COMMAND.text = "<string Name>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		target:SetCharacterData( "injuries", {} )
		if ( player != target )	then
			Clockwork.player:Notify(target, player:Name().." has cleared your injuries.");
			Clockwork.player:Notify(player, "You have cleared the injuries of "..target:Name()..".");
		else
			Clockwork.player:Notify(player, "You have cleared your injuries.");
		end;
	else
		Clockwork.player:Notify(player, arguments.." is not a valid player!");
	end;
end;

COMMAND:Register();