--[[
	This project is created with the Clockwork framework by Cloud Sixteen.
	http://cloudsixteen.com
--]]

local TRAIT = Clockwork.trait:New();

TRAIT.description = "Some part of your hearing is damaged noticeably.";
TRAIT.name = "Damaged Hearing";
TRAIT.uniqueID = "damhearing";
TRAIT.image = "wtt/sliced/barbox";
TRAIT.points = -1;

TRAIT_DAMHEARING = Clockwork.trait:Register(TRAIT);