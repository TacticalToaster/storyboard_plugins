local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RemoveTourniquets");
COMMAND.tip = "Take off all tourniquets either on yourself or someone else.";
COMMAND.text = "<None>";
COMMAND.flags = CMD_DEFAULT;
//COMMAND.access = "a";
//COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local entity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.entity:GetPlayer(entity);
	
	if (target and entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
		if (target:HasInjury("tourniquet with severe bleed") or target:HasInjury("tourniquet with laceration") or target:HasInjury("tourniquet with gunshot wound")) then
			target:TreatInjuries("tourniquet with severe bleed");
			target:TreatInjuries("tourniquet with laceration");
			target:TreatInjuries("tourniquet with gunshot wound");
			Clockwork.chatBox:Add(player, nil, "treat", "You remove the patients tourniquets one by one.");
			Clockwork.chatBox:Add(target, nil, "treat", "Your tourniquets are removed one by one.");
		else
			Clockwork.player:Notify(player, "The patient doesn't seem to have any tourniquets!");
		end;
	else
		if (player:HasInjury("tourniquet with severe bleed") or player:HasInjury("tourniquet with laceration") or player:HasInjury("tourniquet with gunshot wound")) then
			player:TreatInjuries("tourniquet with severe bleed");
			player:TreatInjuries("tourniquet with laceration");
			player:TreatInjuries("tourniquet with gunshot wound");
			Clockwork.chatBox:Add(player, nil, "treat", "You remove your tourniquets one by one.");
		else
			Clockwork.player:Notify(player, "You don't seem to have any tourniquets!");
		end;
	end;
end;

COMMAND:Register();