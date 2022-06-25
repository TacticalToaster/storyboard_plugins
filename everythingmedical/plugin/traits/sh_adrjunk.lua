--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "The effects of adrenaline last longer, but their actual effect is reduced.";
TRAIT.name = "Adrenaline Junkie";
TRAIT.uniqueID = "adrjunk";
TRAIT.image = "wtt/sliced/barbox";

TRAIT_ADRJUNK = Clockwork.trait:Register(TRAIT);