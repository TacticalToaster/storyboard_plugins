--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "The conflict in Tarkov has left you with a permanent TBI.";
TRAIT.name = "Traumatic Brain Injury";
TRAIT.uniqueID = "tbi";
TRAIT.image = "wtt/sliced/barbox";
TRAIT.points = -2;

TRAIT_TBI = Clockwork.trait:Register(TRAIT);