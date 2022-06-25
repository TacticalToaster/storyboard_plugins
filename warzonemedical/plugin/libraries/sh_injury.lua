Clockwork.injury = Clockwork.kernel:NewLibrary("Injury");

Clockwork.injury.stored = Clockwork.injury.stored or {};

/* Define the base injury class */

local CLASS_TABLE = {__index = CLASS_TABLE};

CLASS_TABLE.name = "Injury Base";
CLASS_TABLE.delay = 60;
CLASS_TABLE.decay = 0;
CLASS_TABLE.description = "A generic injury.";

function CLASS_TABLE:Register()
	return Clockwork.injury:Register(self);
end;

-- A function to get a new item.
function Clockwork.injury:New()
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE);
		object.data = {};
	return object;
end;

-- A function to register a new item.
function Clockwork.injury:Register(injuryTable)
	injuryTable.uniqueID = string.lower(string.gsub(injuryTable.uniqueID or string.gsub(injuryTable.name, "%s", "_"), "['%.]", ""));
	injuryTable.index = Clockwork.kernel:GetShortCRC(injuryTable.uniqueID);
	self.stored[injuryTable.uniqueID] = injuryTable;
end;

function Clockwork.injury:FindByID(identifier)
	if (identifier) then
		local lowerName = string.lower(identifier);
		local injuryTable = nil;
		
		for k, v in pairs(self.stored) do
			local injuryName = v.name;
			
			if (string.find(string.lower(injuryName), lowerName)
			and (!injuryTable or string.utf8len(injuryName) < string.utf8len(injuryTable.name))) then
				injuryTable = v;
			end;
		end;
		
		return injuryTable;
	end;
end;
