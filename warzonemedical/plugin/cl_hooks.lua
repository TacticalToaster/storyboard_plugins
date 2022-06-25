local PLUGIN = PLUGIN;

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

function PLUGIN:PostDrawTranslucentRenderables()
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
		if (v:GetRenderMode() != RENDERMODE_NORMAL) then
			v:SetRenderMode(RENDERMODE_NORMAL);
		end;
	end;
end;

function PLUGIN:Think()

	for i, v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
		local ragdoll = v;

		//print(ragdoll, "GJLAJL")

		if (!ragdoll.ragdollJitter) then
			ragdoll.ragdollJitter = CurTime();
		end;

		if (IsValid(ragdoll) and CurTime() >= ragdoll.ragdollJitter) then
			//print(ragdoll.ragdollJitter, "JITTERS")
			local boneJitters = math.random(2, 10);
			local nextJitter = math.Rand(.02, .5);

			ragdoll.ragdollJitter = CurTime() + nextJitter;

			for i=1, boneJitters do
				local bonePhysID = ragdoll:TranslateBoneToPhysBone(math.random(1, ragdoll:GetBoneCount()));

				if (bonePhysID != -1) then
					local physObj = ragdoll:GetPhysicsObjectNum(bonePhysID);

					local jitAmountX = math.Clamp(math.random(-20, 20) * physObj:GetMass(), -280, 280);
					local jitAmountY = math.Clamp(math.random(-20, 20) * physObj:GetMass(), -280, 280);
					local jitAmountZ = math.Clamp(math.random(-30, 30) * physObj:GetMass(), -400, 400);

					//physObj:AddVelocity( Vector(jitAmount, jitAmount, jitAmount) );
					physObj:AddAngleVelocity( Vector(jitAmountX, jitAmountY, jitAmountZ) );
				end;
			end;
		end;
	end;

end;

-- Called when the local player's motion blurs should be adjusted.
function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs)
	if ( Clockwork.Client:HasInitialized() ) then
		local blood = Clockwork.Client:GetSharedVar("blood");
		local data = math.max(blood);
		
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
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, 1.3, interval);
		self.colorModify.color = math.Approach(self.colorModify.color, 1.5, interval);
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