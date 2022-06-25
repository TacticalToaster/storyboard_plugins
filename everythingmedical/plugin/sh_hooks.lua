local PLUGIN = PLUGIN;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	local sharedVars, sharedTables = Clockwork.kernel:GetSharedVars();
	playerVars:Number("blood", true);
	playerVars:Number("pain", true);
	playerVars:Number("respiration", true);
	playerVars:Number("medic", true);
	playerVars:Number("combatBoost", true);
	playerVars:Number("combatBoostCooldown", true);
	//playerVars:Entity("injuries", true);

	sharedTables["injuries"] = {};
	sharedTables["diseases"] = {};
end;