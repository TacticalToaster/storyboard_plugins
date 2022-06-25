local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSetMedic");
COMMAND.tip = "Set a player's medical skill. (EMT-B = 1, EMT-I = 2, Paramedic = 3, Surgeon = 4)";
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
			target:SetCharacterData( "medic", tonumber(amount) )
			//target.nextHunger = CurTime() + 1;
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." has set your medical level to "..amount..".");
				Clockwork.player:Notify(player, "You have set "..target:Name().."'s medical level to "..amount..".");
			else
				Clockwork.player:Notify(player, "You have set your own medical level to "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
end;

COMMAND:Register();