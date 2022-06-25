--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;
local pairs = pairs;
local table = table;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(8);
 	self.panelList:SetSpacing(4);
 	self.panelList:StretchToParent(4, 4, 4, 4);
 	self.panelList:HideBackground();
	
	self:Rebuild();
end;

//print("POGGIES fucks")

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear();
	
	local categories = {};
	local injuryList = {};
	
	//print("INJUREDsssss", Clockwork.Client:GetInjuries())
	//PrintTable(Clockwork.Client:GetInjuries())

	for k, v in pairs(Clockwork.Client:GetInjuries() or {}) do
		//print("INJURED", k, v)
		//if (v:CanBeOrdered() and Clockwork.kernel:HasObjectAccess(Clockwork.Client, v)) then
			//if (Clockwork.plugin:Call("PlayerCanSeeBusinessItem", v)) then
				//local itemCategory = v("category");
				injuryList["Injuries"] = injuryList["Injuries"] or {};
				injuryList["Injuries"][#injuryList["Injuries"] + 1] = v;
			//end;
		//end;
	end;
	
	for k, v in pairs(injuryList) do
		categories[#categories + 1] = {
			injuryList = v,
			category = k
		};
	end;
	
	table.sort(categories, function(a, b)
		return a.category < b.category;
	end);

	local vitalsForm = vgui.Create("cwBasicForm", self);
	
	vitalsForm:SetPadding(8);
	vitalsForm:SetSpacing(8);
	vitalsForm:SetAutoSize(true);
	vitalsForm:SetText("Vitals", nil, "basic_form_highlight")
	
	local vitalsList = vgui.Create("DPanelList", vitalsForm);
	
	vitalsList:EnableHorizontal(true);
	vitalsList:SetAutoSize(true);
	vitalsList:SetPadding(4);
	vitalsList:SetSpacing(4);
	
	vitalsForm:AddItem(vitalsList);

	vitalsList:AddItem(vgui.Create("cwBlood", self));
	vitalsList:AddItem(vgui.Create("cwRespiration", self));
	vitalsList:AddItem(vgui.Create("cwPain", self));

	self.panelList:AddItem(vitalsForm);
	
	if (#categories == 0) then
		local label = vgui.Create("cwInfoText", self);
		
		label:SetText("You haven't sustained any major injuries!");
		label:SetInfoColor("red");
		
		self.panelList:AddItem(label);
		
		//Clockwork.plugin:Call("PlayerBusinessRebuilt", self, categories);
	else
		//Clockwork.plugin:Call("PlayerBusinessRebuilt", self, categories);
		
		for k, v in pairs(categories) do
			local categoryForm = vgui.Create("cwBasicForm", self);
			
			categoryForm:SetPadding(8);
			categoryForm:SetSpacing(8);
			categoryForm:SetAutoSize(true);
			categoryForm:SetText(v.category, nil, "basic_form_highlight")
			
			local categoryList = vgui.Create("DPanelList", categoryForm);
			
			categoryList:EnableHorizontal(true);
			categoryList:SetAutoSize(true);
			categoryList:SetPadding(4);
			categoryList:SetSpacing(4);
			
			categoryForm:AddItem(categoryList);
			
			table.sort(v.injuryList, function(a, b)
				local injuryTableA = a;
				local injuryTableB = b;
				//print(injuryTableA, injuryTableB)
				//PrintTable(injuryTableA)
				
				if (injuryTableA and injuryTableB) then
					return injuryTableA.type < injuryTableB.type;
				//else
					//return injuryTableA("cost") > itemTableB("cost");
				end;
			end);
			
			for k2, v2 in pairs(v.injuryList) do
				self.injuryData = {injuryTable = v2};
				
				categoryList:AddItem(vgui.Create("cwInjury", self));
			end;
			
			self.panelList:AddItem(categoryForm);
		end;
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:IsPanelActive(self)) then
		self:Rebuild();
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h) end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	DERMA_SLICED_BG:Draw(0, 0, w, h, 8, COLOR_WHITE);
	
	return true;
end;

vgui.Register("cwMedical", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 56);
	
	local toolTip = nil;

	
	local nameFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 25);
	local infoFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(56, 6);
	self.nameLabel:SetFont(nameFont);
	self.nameLabel:SetText("Blood Level:");
	self.nameLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color"));
	self.nameLabel:SizeToContents();
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(56, 6);
	self.infoLabel:SetFont(infoFont);
	self.infoLabel:SetText((Clockwork.Client:GetSharedVar("blood") or "Not Found").."/100");
	self.infoLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color_help"));
	self.infoLabel:SizeToContents();
	
	//self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	//self.spawnIcon:SetColor(customData.spawnIconColor);
	
	/*if (customData.cooldown) then
		self.spawnIcon:SetCooldown(
			customData.cooldown.expireTime,
			customData.cooldown.textureID
		);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (customData.Callback) then
			customData.Callback();
		end;
	end;
	
	self.spawnIcon:SetModel(customData.model, customData.skin);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetSize(48, 48);
	self.spawnIcon:SetPos(4, 4);*/
end;

function PANEL:Paint(width, height)
	//CUSTOM_BUSINESS_ITEM_BG:Draw(0, 0, width, height, 8, Color(255, 255, 255, 255));

	self.infoLabel:SetText((math.Round(Clockwork.Client:GetSharedVar("blood")) or "Not Found").."/100");
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self.infoLabel:SetPos(self.infoLabel.x, self:GetTall() - self.infoLabel:GetTall() - 6);
end;
	
vgui.Register("cwBlood", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 56);
	
	local toolTip = nil;

	
	local nameFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 25);
	local infoFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(56, 6);
	self.nameLabel:SetFont(nameFont);
	self.nameLabel:SetText("Breathing Level:");
	self.nameLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color"));
	self.nameLabel:SizeToContents();
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(56, 6);
	self.infoLabel:SetFont(infoFont);
	self.infoLabel:SetText((Clockwork.Client:GetSharedVar("respiration") or "Not Found").."/100");
	self.infoLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color_help"));
	self.infoLabel:SizeToContents();
	
	//self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	//self.spawnIcon:SetColor(customData.spawnIconColor);
	
	/*if (customData.cooldown) then
		self.spawnIcon:SetCooldown(
			customData.cooldown.expireTime,
			customData.cooldown.textureID
		);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (customData.Callback) then
			customData.Callback();
		end;
	end;
	
	self.spawnIcon:SetModel(customData.model, customData.skin);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetSize(48, 48);
	self.spawnIcon:SetPos(4, 4);*/
end;

function PANEL:Paint(width, height)
	//CUSTOM_BUSINESS_ITEM_BG:Draw(0, 0, width, height, 8, Color(255, 255, 255, 255));

	self.infoLabel:SetText((math.Round(Clockwork.Client:GetSharedVar("respiration")) or "Not Found").."/100");
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self.infoLabel:SetPos(self.infoLabel.x, self:GetTall() - self.infoLabel:GetTall() - 6);
end;
	
vgui.Register("cwRespiration", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 56);
	
	local toolTip = nil;

	
	local nameFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 25);
	local infoFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(56, 6);
	self.nameLabel:SetFont(nameFont);
	self.nameLabel:SetText("Pain Level:");
	self.nameLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color"));
	self.nameLabel:SizeToContents();
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(56, 6);
	self.infoLabel:SetFont(infoFont);
	self.infoLabel:SetText("Your pain is only describeable as being off the scale. You're most likely screaming right now.");
	self.infoLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color_help"));
	self.infoLabel:SizeToContents();
	
	//self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	//self.spawnIcon:SetColor(customData.spawnIconColor);
	
	/*if (customData.cooldown) then
		self.spawnIcon:SetCooldown(
			customData.cooldown.expireTime,
			customData.cooldown.textureID
		);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (customData.Callback) then
			customData.Callback();
		end;
	end;
	
	self.spawnIcon:SetModel(customData.model, customData.skin);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetSize(48, 48);
	self.spawnIcon:SetPos(4, 4);*/
end;

function PANEL:Paint(width, height)
	//CUSTOM_BUSINESS_ITEM_BG:Draw(0, 0, width, height, 8, Color(255, 255, 255, 255));

	local painText = "";
	local pain = Clockwork.Client:GetSharedVar("pain") or 0;

	if (pain >= 50) then
		painText = "Your pain is only describeable as being off the scale. You're most likely screaming right now.";
	else
		painText = "You describe your pain as a "..math.Round(pain/5).."/10.";
	end;

	//print(painText)

	self.infoLabel:SetText(painText);
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self.infoLabel:SetPos(self.infoLabel.x, self:GetTall() - self.infoLabel:GetTall() - 6);
end;
	
vgui.Register("cwPain", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 56);
	
	local customData = self:GetParent().injuryData or {};
	local injuryTable = Clockwork.injury:FindByID(customData.injuryTable.type);
	local toolTip = nil;

	//print(customData, injuryTable)
	
	if (customData.information) then
		if (type(customData.information) == "number") then
			if (customData.information != 0) then
				customData.information = Clockwork.kernel:FormatCash(customData.information);
			else
				customData.information = L("Priceless");
			end;
		end;
	end;
	
	if (customData.description) then
		toolTip = Clockwork.config:Parse(L(customData.description));
	end;
	
	local nameFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 25);
	local infoFont = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(56, 6);
	self.nameLabel:SetFont(nameFont);
	self.nameLabel:SetText(injuryTable.name);
	self.nameLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color"));
	self.nameLabel:SizeToContents();
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(56, 6);
	self.infoLabel:SetFont(infoFont);
	self.infoLabel:SetText(injuryTable.description);
	self.infoLabel:SetTextColor(Clockwork.option:GetColor("basic_form_color_help"));
	self.infoLabel:SizeToContents();
	
	//self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	//self.spawnIcon:SetColor(customData.spawnIconColor);
	
	/*if (customData.cooldown) then
		self.spawnIcon:SetCooldown(
			customData.cooldown.expireTime,
			customData.cooldown.textureID
		);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (customData.Callback) then
			customData.Callback();
		end;
	end;
	
	self.spawnIcon:SetModel(customData.model, customData.skin);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetSize(48, 48);
	self.spawnIcon:SetPos(4, 4);*/
end;

function PANEL:Paint(width, height)
	CUSTOM_BUSINESS_ITEM_BG:Draw(0, 0, width, height, 8, Color(255, 255, 255, 255));
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self.infoLabel:SetPos(self.infoLabel.x, self:GetTall() - self.infoLabel:GetTall() - 6);
end;
	
vgui.Register("cwInjury", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local FACTION = Clockwork.faction:FindByID(Clockwork.Client:GetFaction());
	local CLASS = Clockwork.class:FindByID(Clockwork.Client:Team());
	local costScale = CLASS.costScale or FACTION.costScale or 1;
	local itemData = self:GetParent().itemData;
	
	self:SetSize(56, 56);
	self.itemTable = itemData.itemTable;
	
	Clockwork.plugin:Call("PlayerAdjustBusinessItemTable", self.itemTable);
	
	if (!self.itemTable.originalCost) then
		self.itemTable.originalCost = self.itemTable("cost");
	end;

	if (costScale >= 0) then
		self.itemTable.cost = self.itemTable.originalCost * costScale;
	end;

	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	
	if (Clockwork.OrderCooldown and CurTime() < Clockwork.OrderCooldown) then
		self.spawnIcon:SetCooldown(Clockwork.OrderCooldown);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		Clockwork.kernel:RunCommand("OrderShipment", self.itemTable("uniqueID"));
	end;
	
	self.spawnIcon:SetModel(model, skin);
	self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetSize(56, 56);
end;

-- Called each frame.
function PANEL:Think()
	if (!self.nextUpdateMarkup) then
		self.nextUpdateMarkup = 0;
	end;
	
	if (CurTime() < self.nextUpdateMarkup) then
		return;
	end;

	self.spawnIcon:SetMarkupToolTip(Clockwork.item:GetMarkupToolTip(self.itemTable, true));
	self.spawnIcon:SetColor(self.itemTable("color"));
	
	self.nextUpdateMarkup = CurTime() + 1;
end;
	
vgui.Register("cwInjuryss", PANEL, "DPanel");
