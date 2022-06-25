--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "You are more susceptible to receiving injuries.";
TRAIT.name = "Weakling";
TRAIT.uniqueID = "weak";
TRAIT.image = "wtt/sliced/barbox";
TRAIT.points = -2;

TRAIT_WEAK = Clockwork.trait:Register(TRAIT);