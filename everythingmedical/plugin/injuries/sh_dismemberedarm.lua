local PLUGIN = PLUGIN;

local INJURY = Clockwork.injury:New();
INJURY.name = "Dismembered Arm";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "A large wound sits where your shoulder would've been.";
INJURY.victim = "You feel a heavy ripping sensation where your shoulder should be.";
INJURY.limit = 2;
INJURY.arm = 1;

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 35);

	if player.amputationSide then
		data.side = player.amputationSide;
		player.amputationSide = nil;
	end;

	//Clockwork.datastream:Start(nil, "EntityAmputation", {["amp"] = "rarm", ["render"] = "ValveBiped.Bip01_R_UpperArm", ["norender"] = "ValveBiped.Bip01_R_Forearm", ["ent"] = player});
	player:UpdateAmputations();

	if (player.amputationBleed) then
		player.amputationBleed = nil;
		local bleed = player:GiveInjury("severe bleed");

		if (bleed) then bleed.bone = self:GetAmputation(player, data)["render"] end;
	end;
end;

function INJURY:OnReset(player, data)
	player:UpdateAmputations();
end;

function INJURY:GetAmputation(player, data)
	local lower = data.side == 1 and "r" or "l";
	local upper = data.side == 1 and "R" or "L";

	return {["amp"] = lower.."arm", ["render"] = "ValveBiped.Bip01_"..upper.."_UpperArm", ["norender"] = "ValveBiped.Bip01_"..upper.."_UpperArm", ["ent"] = player};
end;

function INJURY:OnEnd(player, data, treater)
end;

function INJURY:OnDelay(player, data)
end;

INJURY:Register();

