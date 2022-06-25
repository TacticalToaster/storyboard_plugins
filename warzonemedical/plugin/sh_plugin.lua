Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");

Clockwork.plugin:AddExtra("/injuries/");
Clockwork.plugin:AddExtra("/meta/");
Clockwork.plugin:AddExtra("/derma/");

PLUGIN:SetGlobalAlias("MEDICAL");

function PLUGIN:GetActionTimeModifier(player)
	local timeMod = 1;
	local blood = tonumber(player:GetCharacterData("blood"));
	local pain = tonumber(player:GetCharacterData("pain"));
	local respiration = tonumber(player:GetCharacterData("respiration"));

	if (player:HasInjury("damaged arm")) then
		timeMod = timeMod + .25;
	end;

	if (player:HasInjury("concussion")) then
		timeMod = timeMod + .1;
	end;

	if (player:HasInjury("traumatic brain injury")) then
		timeMod = timeMod + .15;
	end;

	if (pain >= 30) then
		timeMod = timeMod + .1;
	end;

	if (respiration <= 80) then
		timeMod = timeMod + .1;
	end;

	return timeMod;
end;

local ENTITYMT = FindMetaTable("Entity");
ENTITYMT.oldFireBullets = ENTITYMT.oldFireBullets or ENTITYMT.FireBullets;

function ENTITYMT:FireBullets(bullet, suppress)

	local oldCallback = bullet.Callback;
	bullet.Callback = function(attacker, tr, dmgInfo)
		if (oldCallback) then
			oldCallback(attacker, tr, dmgInfo);
		end;
		Clockwork.plugin:Call("OnCWFireBullets", bullet, attacker, tr, dmgInfo);	
	end;

	return self:oldFireBullets(bullet, suppress);
end;

function PLUGIN:OnCWFireBullets(bullet, attacker, tr, dmgInfo)
	if (SERVER) then
		local hitPos = tr.HitPos;

		for i, v in pairs(ents.FindInSphere(hitPos, 128)) do
			if (v:IsPlayer() and v:Alive()) then
				v:ViewPunch(Angle(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5)));
				Clockwork.datastream:Start(v, "Suppression", .2);
			end;
		end;
	end;
end;