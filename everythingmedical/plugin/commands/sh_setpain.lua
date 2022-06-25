local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSetPain");
COMMAND.tip = "Set a player's pain level.";
COMMAND.text = "<string Name> <number Amount>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local amount = arguments[2];
	
	if (!amount) then
		amount = 0;
	end;
	
		if (target) then
			target:SetCharacterData( "pain", tonumber(amount) )
			//target.nextHunger = CurTime() + 1;
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." has set your pain to "..amount..".");
				Clockwork.player:Notify(player, "You have set "..target:Name().."'s pain to "..amount..".");
			else
				Clockwork.player:Notify(player, "You have set your own pain to "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
end;

COMMAND:Register();