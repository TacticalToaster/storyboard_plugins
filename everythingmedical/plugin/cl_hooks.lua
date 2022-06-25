local PLUGIN = PLUGIN;

local function RenderWounds(ent) //shamelessly taken from litegibs, thanks litegibs!!!
	if PLUGIN.amputationData[ent] then ent.AmpWounds = PLUGIN.amputationData[ent].wounds end;

	if not ent.AmpWounds then
		ent:DrawModel()

		return
	end

	if halo.RenderedEntity() == ent then
		ent:DrawModel()

		return
	end

	if #ent.AmpWounds == 0 then
		ent:DrawModel()

		return
	end

	--start off by clearing stencil
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	--first we write the entity to the stencil buffer with value 1
	--writing to the depth buffer but not color allows us to clip the wound with the model
	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.CullMode(MATERIAL_CULLMODE_CCW)
	render.OverrideColorWriteEnable(true, false)
	ent:DrawModel()
	render.OverrideColorWriteEnable(false, false)
	--now we write the wound model, which increments the see-through areas to stencil value 2
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_INCR)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetBlend(0)
	render.OverrideDepthEnable(true, false)

	for _, v in ipairs(ent.AmpWounds) do
		if IsValid(v.model) and v.bone and v.pos and v.ang then
			local mat = ent:GetBoneMatrix(v.bone)

			if mat then
				local bpos, bang
				bpos = mat:GetTranslation()
				bang = mat:GetAngles()
				local pos, ang = LocalToWorld(v.pos, v.ang, bpos, bang)
				v.model:SetupBones()
				v.model:SetRenderOrigin(pos)
				v.model:SetRenderAngles(ang)
				v.model:DrawModel()
			end
		end
	end

	render.OverrideDepthEnable(false, false)
	render.SetBlend(1)
	--now we clear the depth of the wound area
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	render.OverrideColorWriteEnable(true, false)
	render.ClearBuffersObeyStencil(0, 0, 0, 0, true)
	render.OverrideColorWriteEnable(false, false)
	--now we write, in order, the fleshy interior of the model, and the wound model
	render.OverrideDepthEnable(false, false)
	render.ModelMaterialOverride()
	render.SetStencilReferenceValue(2)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	ent:DrawModel()
	render.ClearStencil()
	render.SetStencilEnable(false)
end

-- Called when the menu's items should be adjusted.
function PLUGIN:MenuItemsAdd(menuItems)
	menuItems:Add("Medical", "cwMedical", "Check your character's medical condition.");
end;

-- Called when the bars are needed.
function PLUGIN:GetBars(bars)
	local blood = Clockwork.Client:GetSharedVar("blood");
	local respiration = Clockwork.Client:GetSharedVar("respiration");

	if (!self.blood) then
		self.blood = blood;
	else
		self.blood = math.Approach(self.blood, blood, 1);
	end;

	if (!self.respiration) then
		self.respiration = respiration;
	else
		self.respiration = math.Approach(self.respiration, respiration, 1);
	end;

	if (self.blood < 80) then
		bars:Add("BLOOD", Color(255, 0, 0, 255), "Blood", self.blood, 100, self.blood <= 50);
	end;

	if (self.respiration < 80) then
		bars:Add("RESPIRATION", Color(224, 236, 255, 255), "Respiration", self.respiration, 100, self.respiration <= 60);
	end;
end;

local vhuge = Vector(math.huge, math.huge, math.huge);

local function SetBoneScales(player, ent)
	if (!PLUGIN.amputationData[ent] or !PLUGIN.amputationData[player]) then return end;

	local ampData = PLUGIN.amputationData[ent] or PLUGIN.amputationData[player];
	local bones = {};
	local renderBones = {};
	local setupbones = false;

	if (player != ent and !PLUGIN.amputationData[ent]) then
		PLUGIN.amputationData[ent] = PLUGIN.amputationData[player]; // GOTO, character detection rather than blanket player detection, updating character amputations on name change, ect.
	end;

	//print(#ampData, #ampData <= 0)

	//if (#ampData <= 0) then return end;

	for i,v in pairs(ampData) do
		//PrintTable(v);
		local norenderTable = PLUGIN.GetAllChildBones(ent, ent:LookupBone(v.norender), bones) or {};
		//PrintTable(norenderTable);
		//table.Merge(bones, norenderTable);

		for i2,v2 in pairs(self.amputationTable[i] or {}) do
			local newBone = ent:LookupBone(v2);
			if (newBone) then table.insert(renderBones, newBone);
			PLUGIN.GetAllChildBones(ent, newBone, renderBones);
		end;

		local renderBone = ent:LookupBone(v.render);

		if (renderBone) then table.insert(renderBones, renderBone) end;//ent:ManipulateBoneScale(renderBone, Vector(0,0,0)) end;

	end;

	for i,v in pairs(renderBones) do
		ent:ManipulateBoneScale(v, Vector(0,0,0));
	end;

	for i,v in pairs(bones) do
		setupbones = true;
		ent:ManipulateBoneScale(v, vhuge);
	end;

	//if setupbones then ent:SetupBones() end;
end;

function PLUGIN:PostDrawTranslucentRenderables()
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
		//if (IsValid(v:GetNetworkedEntity("Player"))) then
		//	SetBoneScales(v:GetNetworkedEntity("Player"), v);
		//end;
		//if (!v.RenderOverride) then v.RenderOverride = RenderWounds end;
		if (v:GetRenderMode() != RENDERMODE_NORMAL) then
			v:SetRenderMode(RENDERMODE_NORMAL);
		end;
	end;
end;

function PLUGIN:PreDrawOpaqueRenderables(bDepth, bSky, b3DSky)
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
		if (IsValid(v) and (v:GetNetworkedEntity("Player") or self.amputationData[v])) then
			SetBoneScales(v:GetNetworkedEntity("Player"), v);
		end;
	end;
end;

function PLUGIN:PrePlayerDraw(player)
	//if (!player.RenderOverride) then player.RenderOverride = RenderWounds end;

	SetBoneScales(player, player)

	/*if (!self.amputationData[player]) then return end;

	local ampData = self.amputationData[player];
	local bones = {};

	for i,v in pairs(ampData) do
		local norenderTable = self.GetAllChildBones(player, player:LookupBone(v.norender)) or {};
		table.Merge(bones, norenderTable);

		/*for i2,v2 in pairs(self.amputationTable[i] or {}) do
			local boneTable = self.GetAllChildBones(player, player:LookupBone(v2), bones) or {};
			table.Merge(bones, boneTable);
		end;//

		local renderBone = player:LookupBone(v.render);

		if (renderBone) then player:ManipulateBoneScale(renderBone, Vector()) end;

	end;

	for i,v in pairs(bones) do
		player:ManipulateBoneScale(v, vhuge);
	end;*/
end;

-- Called when the local player's motion blurs should be adjusted.
function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs)
	if ( Clockwork.Client:HasInitialized() ) then
		local blood = Clockwork.Client:GetSharedVar("blood");
		local data = math.max(blood);
		local ragdoll = Clockwork.Client:GetRagdollEntity();
		local s2ksystem = Clockwork.config:Get("death_s2k"):Get();
		local s2kOn = Clockwork.kernel:GetSharedVar("s2kOn");

		if (IsValid(ragdoll) and s2ksystem and s2kOn) then return; end;

		if (data <= 60) then
			motionBlurs.blurTable["blood"] = 1 - Lerp(math.abs(blood-60) / 30, .1, .9);//( (0.25 / 10) * ( 10 - (100 - data) ) );
		end;
	end;
end;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (Clockwork.Client:Alive()) then
		if (action == "wearingGloves") then
			return {text = "Putting on gloves...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingBurnGel") then
			return {text = "Applying gel...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingTourniquetSelf") then
			return {text = "Wrapping tourniquet on yourself...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingTourniquetPatient") then
			return {text = "Wrapping tourniquet on patient...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingBandageSelf") then
			return {text = "Wrapping bandage and applying pressure on yourself...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingBandagePatient") then
			return {text = "Wrapping bandage and applying pressure on patient...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingPressureSelf") then
			return {text = "Applying pressure on yourself...", percentage = percentage, flash = percentage < 10};
		elseif (action == "applyingPressurePatient") then
			return {text = "Applying pressure on patient...", percentage = percentage, flash = percentage < 10};
		elseif (action == "decompressionKit") then
			return {text = "Preparing decompression kit...", percentage = percentage, flash = percentage < 10};
		end;
	end;
end;

local SCREEN_DAMAGE_OVERLAY = Clockwork.kernel:GetMaterial("clockwork/screendamage.png");

function PLUGIN:DrawPlayerScreenDamage(damageFraction)
	local sizeMultiplier = TimedSin(.2 + damageFraction, 1.1, 1.2, 0);
	local scrW, scrH = ScrW() * sizeMultiplier, ScrH() * sizeMultiplier;

	surface.SetDrawColor(255, 255, 255, math.Clamp(255 * damageFraction, 0, 255));
	surface.SetMaterial(SCREEN_DAMAGE_OVERLAY);
	surface.DrawTexturedRect(-(scrW - ScrW())/2, -(scrH - ScrH())/2, scrW, scrH);

	local ragdoll = Clockwork.Client:GetRagdollEntity();
	local s2ksystem = Clockwork.config:Get("death_s2k"):Get();
	local s2kOn = Clockwork.kernel:GetSharedVar("s2kOn");

	if (IsValid(ragdoll) and s2ksystem and s2kOn) then return false; end;

	return true;
end;

local SCREEN_PAIN_OVERLAY = Clockwork.kernel:GetMaterial("clockwork/gradient_pain_square3.png");

function PLUGIN:HUDPaint()
	local pain = Clockwork.Client:GetSharedVar("pain");
	local intendedPainSize = Lerp( math.Clamp(pain, 0, 60)/60, 2, 1 );

	if (!self.painAlpha) then
		self.painAlpha = 0;
	end;

	if (pain > 0) then
		self.painAlpha = math.Approach(self.painAlpha, 255, 30*FrameTime());
	else
		self.painAlpha = math.Approach(self.painAlpha, 0, -30*FrameTime());
	end;

	if (!self.painSize) then
		self.painSize = intendedPainSize;
	end;

	self.painSize = math.Approach(self.painSize, intendedPainSize, (1/10)*FrameTime());

	local ragdoll = Clockwork.Client:GetRagdollEntity();
	local s2ksystem = Clockwork.config:Get("death_s2k"):Get();
	local s2kOn = Clockwork.kernel:GetSharedVar("s2kOn");

	if (IsValid(ragdoll) and s2ksystem and s2kOn) then return; end;

	local scrW, scrH = ScrW() * self.painSize, ScrH() * self.painSize;

	surface.SetDrawColor(255, 255, 255, math.Clamp(self.painAlpha, 0, 255));
	surface.SetMaterial(SCREEN_PAIN_OVERLAY);
	surface.DrawTexturedRect(-(scrW - ScrW())/2, -(scrH - ScrH())/2, scrW, scrH);

end;

function PLUGIN:RenderScreenspaceEffects()
	if self.suppression > 0 then
		DrawToyTown(5, ScrH()*(self.suppression/4));
		DrawSharpen(self.suppression, .75*(self.suppression/2));
	end;

	self.suppression = math.Approach(self.suppression, 0, FrameTime());
end;

-- Called when the local player's colorify should be adjusted.
function PLUGIN:PlayerAdjustColorModify(colorModify)
	local combatBoost = Clockwork.Client:GetSharedVar("combatBoost");
	local combatBoostCooldown = Clockwork.Client:GetSharedVar("combatBoostCooldown");
	local frameTime = FrameTime();
	local interval = FrameTime() / 5;
	local curTime = CurTime();

	if (!self.colorModify) then
		self.colorModify = {
			brightness = colorModify["$pp_colour_brightness"],
			contrast = colorModify["$pp_colour_contrast"],
			color = colorModify["$pp_colour_colour"]
		};
	end;

	//print(combatBoost, combatBoostCooldown, combatBoost > curTime and combatBoostCooldown < curTime)

	if (combatBoost > curTime and combatBoostCooldown < curTime) then
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, -.1, interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, 1.15, interval);
		self.colorModify.color = math.Approach(self.colorModify.color, 1.25, interval);
	else
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, colorModify["$pp_colour_brightness"], interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, colorModify["$pp_colour_contrast"], interval);
		self.colorModify.color = math.Approach(self.colorModify.color, colorModify["$pp_colour_colour"], interval);
	end;

	colorModify["$pp_colour_brightness"] = self.colorModify.brightness;
	colorModify["$pp_colour_contrast"] = self.colorModify.contrast;
	colorModify["$pp_colour_colour"] = self.colorModify.color;
end;

-- Called when the F1 Text is needed.
/*
function PLUGIN:GetPlayerInfoText(playerInfoText)
	local injuries = Clockwork.Client:GetSharedVar("injuries");
	PrintTable(injuries);

	local text = "[Injuries]\n";

	if ((istable(injuries) and table.IsEmpty(injuries)) or !istable(injuries)) then
		text = "[Injuries]\nYou seem to have no noticable injuries."
	end;

	for i,v in pairs(injuries) do
		local injuryTable = Clockwork.injury:FindByID(v.type);

		text = text..injuryTable.name..": "..injuryTable.description.."\n";
	end;

	playerInfoText:Add("Injuries", text);
end;*/
