--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Individual First Aid Kit (IFAK)";
ITEM.uniqueID = "ifak";
ITEM.model = "models/carlsmei/escapefromtarkov/medical/ifak.mdl";
ITEM.weight = 1;
ITEM.useText = "Open";
ITEM.category = "Medical - Kits"
//ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A small pouch refitted to carry medical equipment to treat hemorrhaging and clogged airways.";

//ITEM:AddData("Uses", 0, true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("airway"), true);
	player:GiveItem(Clockwork.item:CreateInstance("opaque_dressing"), true);
	player:GiveItem(Clockwork.item:CreateInstance("cat_tourniquet"), true);
	player:GiveItem(Clockwork.item:CreateInstance("israeli_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("sterile_gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("nitrile_gloves"), true);
	player:GiveItem(Clockwork.item:CreateInstance("morphine"), true);
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