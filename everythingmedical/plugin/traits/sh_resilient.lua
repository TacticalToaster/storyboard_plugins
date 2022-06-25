--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "You won't go down without a fight. You fight pain faster than most.";
TRAIT.name = "Resilient";
TRAIT.uniqueID = "resilient";
TRAIT.image = "wtt/sliced/barbox";
TRAIT.points = 2;

TRAIT_RESILIENT = Clockwork.trait:Register(TRAIT);