local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharMasterHeal");
COMMAND.tip = "Treat a player's injuries and set their vitals to perfect, along with health.";
COMMAND.text = "<string Name>";
COMMAND.flags = 0;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		local injuries = target:GetInjuries();

		for i,v in pairs(injuries) do
			local injuryTable = Clockwork.injury:FindByID(v.type);

			if (injuryTable.OnEnd) then
				injuryTable:OnEnd(target);
			end;
		end;

		target:SetCharacterData( "injuries", {} )
		target:SetHealth(target:GetMaxHealth());
		target:SetCharacterData( "pain", 0 )
		target:SetCharacterData( "respiration", 100 )
		target:SetCharacterData( "blood", 100 )
		if ( player != target )	then
			Clockwork.player:Notify(target, player:Name().." has treated your injuries.");
			Clockwork.player:Notify(player, "You have treated the injuries of "..target:Name()..".");
		else
			Clockwork.player:Notify(player, "You have treated your injuries.");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();