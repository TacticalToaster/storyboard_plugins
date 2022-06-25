local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("BloodPressure");
COMMAND.tip = "Check a character's blood pressure.";
COMMAND.text = "<None>";
COMMAND.flags = CMD_DEFAULT;
//COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		Clockwork.chatBox:Add(player, nil, "treat", "The patient's blood level is: "..target:GetCharacterData("blood").."/100.");
	else
		Clockwork.chatBox:Add(player, nil, "treat", "Your blood level is: "..player:GetCharacterData("blood").."/100.");
	end;
end;

COMMAND:Register();