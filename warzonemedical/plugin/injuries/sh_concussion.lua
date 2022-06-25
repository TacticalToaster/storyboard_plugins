local INJURY = Clockwork.injury:New();
INJURY.name = "Concussion";
INJURY.delay = 60;
INJURY.decay = 0;
INJURY.description = "Injury to the brain that affects normal brain activity.";
INJURY.victim = "You take a strong blow to the head. The world grows fuzzy, and you feel confused and nauseous.";
INJURY.limit = 1;
INJURY.icon = "nscp/status/effect_contusion.png";

function INJURY:OnThink(player, data)

end;

function INJURY:OnAcquire(player, data)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain + 15);

	player:SetDSP(22);
	
	Clockwork.datastream:Start(player, "Concussion", 15);

	timer.Simple(math.random(8, 15), function()
		if (player and player:Alive()) then
			player:SetDSP(0);
		end;
	end);

	if (player:HasInjury("traumatic brain injury")) then
		return false;
	end;
end;

function INJURY:OnEnd(player, data, treater)
	local pain = player:GetCharacterData("pain");

	player:SetCharacterData("pain", pain - 5);
end;

function INJURY:OnDelay(player, data)
	local pain = player:GetCharacterData("pain");

	if (math.random(1, 100) <= 20) then
		Clockwork.chatBox:Add(player, nil, "injury", "** Your head feels slightly less pressured, and your mind becomes slightly less clouded.");
		player:TreatInjury("concussion");
		return;
	end;

	if (math.random(1, 100) <= 5) then
		player:TreatInjury("concussion");
		player:GiveInjury("traumatic brain injury");
		return;
	end;

	if (math.random(1, 10) <= 4) then
		player:SetCharacterData("pain", pain - 3);
		Clockwork.chatBox:Add(player, nil, "injury", "** You feel as if your head is shrinking around your skull and throbbing.");

		player:SetDSP(22);
		
		Clockwork.datastream:Start(player, "Concussion", 20);

		timer.Simple(math.random(15, 35), function()
			if (player and player:Alive()) then
				player:SetDSP(0);
			end;
		end);
	end;
end;

INJURY:Register();

