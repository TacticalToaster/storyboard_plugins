local PLUGIN = PLUGIN;
local player = player;
local libPlayer = player;

local COMMAND = Clockwork.command:New("ClearAllKills");
COMMAND.tip = "Clear all players' deaths.";
COMMAND.text = "<None>";
COMMAND.flags = 0;
COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for i,v in pairs(libPlayer.GetAll()) do
		v.deathCount = 0;
	end;

	Clockwork.player:Notify(player, "You have cleared all death counts.");
end;

COMMAND:Register();