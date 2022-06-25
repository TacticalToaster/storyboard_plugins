--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "You are unable to talk normally, slurring your words and talking quieter than most.";
TRAIT.name = "Damaged Voice";
TRAIT.uniqueID = "damvoice";
TRAIT.image = "wtt/sliced/barbox";
TRAIT.points = -1;

TRAIT_DAMVOICE = Clockwork.trait:Register(TRAIT);