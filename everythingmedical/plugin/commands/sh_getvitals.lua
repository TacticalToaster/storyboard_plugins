local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharGetVitals");
COMMAND.tip = "Get a player's vitals.";
COMMAND.text = "<string Name>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		local respiration = target:GetCharacterData( "respiration" );
		local blood = target:GetCharacterData( "blood" );
		local pain = target:GetCharacterData( "pain" );
		//target.nextHunger = CurTime() + 1;
		Clockwork.player:Notify(player, target:Name().."'s vitals: Blood - "..blood.." Pain - "..pain.." Respiration - "..respiration..".");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();