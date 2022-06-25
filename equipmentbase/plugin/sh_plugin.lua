local PLUGIN = PLUGIN;

PLUGIN:SetGlobalAlias("EQUIPMENT");

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");

Clockwork.EquipmentBase = {};
Clockwork.EquipmentBase.AmmoPen = {
	["Buckshot"] = 3,
	["pistol"] = 10,
	["9mmRound"] = 10,
	["AlyxGun"] = 15,
	["SMG1"] = 30,
	["357"] = 23,
	["AR2"] = 43,
	["XBowBolt"] = 40,
	["SniperRound"] = 54,
	["SniperPenetratedRound"] = 65,
	["AirboatGun"] = 36,
	["StriderMinigun"] = 45,
	["StriderMinigunDirect"] = 38,
	["CombineCannon"] = 75,
	["CombineHeavyCannon"] = 100,
	["HelicopterGun"] = 37,
};