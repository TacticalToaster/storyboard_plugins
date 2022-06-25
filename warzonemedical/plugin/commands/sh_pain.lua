local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Pain");
COMMAND.tip = "Check your pain.";
COMMAND.text = "<None>";
COMMAND.flags = CMD_DEFAULT;
//COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local pain = player:GetCharacterData("pain");
	
	if (pain >= 50) then
		Clockwork.chatBox:Add(player, nil, "injury", "Your pain is only describeable as being off the scale. You're most likely screaming right now.");
	else
		Clockwork.chatBox:Add(player, nil, "treat", "You describe your pain as a "..math.Round(pain/5).."/10.");
	end
end;

COMMAND:Register();