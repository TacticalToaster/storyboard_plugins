--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Bleed-Stop Kit";
ITEM.uniqueID = "bleed_kit";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/salewa.mdl";
ITEM.weight = 1;
ITEM.useText = "Open";
ITEM.category = "Medical - Kits"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small kit that includes QuikClot Hemostatic Combat Gauze and an Isreali Emergency Pressure Bandage.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	
	player:GiveItem(Clockwork.item:CreateInstance("israeli_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("israeli_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("quikclot_gauze"), true);
	/*local currentUses = self:GetData("Uses");

	if (currentUses + 1 < self.totalUses) then
		self:SetData("Uses", currentUses + 1);
		return true;
	end;*/
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;
/*
if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local markupText = "";
		
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Uses left: ".. self:GetData("Uses") or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Total health amount: ".. self.totalHeal or 1);
		//markupText = Clockwork.kernel:AddMarkupLine(markupText, "Time to heal: ".. self.totalTime or 1);

		return (markupText != "" and markupText);
	end;
end;*/

ITEM:Register();