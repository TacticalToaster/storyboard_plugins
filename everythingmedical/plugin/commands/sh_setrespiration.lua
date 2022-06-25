local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSetRespiration");
COMMAND.tip = "Set a player's respiration level.";
COMMAND.text = "<string Name> <number Amount>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local amount = arguments[2];
	
	if (!amount) then
		amount = 100;
	end;
	
		if (target) then
			target:SetCharacterData( "respiration", tonumber(amount) )
			//target.nextHunger = CurTime() + 1;
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." has set your respiration to "..amount..".");
				Clockwork.player:Notify(player, "You have set "..target:Name().."'s respiration to "..amount..".");
			else
				Clockwork.player:Notify(player, "You have set your own respiration to "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
end;

COMMAND:Register();