local PLUGIN = PLUGIN;

local maskMat = Material( "OIIJIOT/gasmaskdmxmd" ) -- Calling Material() every frame is quite expensive
local dustMat = Material("particle/particle_smokegrenade1")
local shatter = Material("decals/glass/shot1")
local X_BOUNDS = 50
local Y_BOUNDS = 50

local MouseX, MouseY = 0, 0
local NewMouseX, NewMouseY = 0, 0
local OldMouseX, OldMouseY = 0, 0
local ResetTime = 0

function PLUGIN:HUDPaint()
	if (GetConVarNumber("cwThirdPerson") == 1) then return end;

	local info = {speed = 1, yaw = 0.5, roll = 0.1};

	Clockwork.plugin:Call("PlayerAdjustHeadbobInfo", info);

	//print(Clockwork.LastStrafeRoll, Clockwork.HeadbobInfo.roll, Clockwork.HeadbobInfo.speed, Clockwork.WalkTimer, math.cos(Clockwork.HeadbobAngle), math.cos(Clockwork.WalkTimer) * Clockwork.VelSmooth * 0.000002 * Clockwork.VelSmooth)
	if !self.bobOffsetx then self.bobOffsetx = 0 end;
	if !self.bobOffsety then self.bobOffsety = 0 end;
	self.bobOffsetx = math.Approach(self.bobOffsetx, info.speed * math.sin(CurTime() * info.speed) * 25, FrameTime()*30*info.speed);
	self.bobOffsety = math.Approach(self.bobOffsety, info.speed/2 * math.cos(CurTime() * (info.speed/2)) * 15, FrameTime()*30*info.speed);

	local weapon = Clockwork.Client:GetActiveWeapon();
	//print(weapon, weapon.HUDPaint)
	if weapon.HUDPaint then
		weapon:HUDPaint();
	end

	local overlayItems = {}

	if (Clockwork.player:IsWearingClothes() && Clockwork.player:GetClothesItem().maskOverlay) then table.insert(overlayItems, Clockwork.player:GetClothesItem()) end;

	for i, v in pairs(Clockwork.player:GetAccessoryData()) do
		local itemTable = Clockwork.inventory:FindItemByID(Clockwork.inventory:GetClient(), v, i);

		if itemTable and itemTable:HasPlayerEquipped(Clockwork.Client, false) and itemTable.maskOverlay then
			table.insert(overlayItems, itemTable);
		elseif itemTable and itemTable:HasPlayerEquipped(Clockwork.Client, false) and itemTable.nvgMaskOverlay and Clockwork.Client:GetSharedVar("nvdActive") then
			table.insert(overlayItems, itemTable);
		end;
	end;

	for i, v in pairs(overlayItems) do
		//print(Clockwork.player:IsWearingClothes(), Clockwork.player:GetClothesItem().maskOverlay)
		//if (Clockwork.player:IsWearingClothes() && Clockwork.player:GetClothesItem().maskOverlay) then
			//surface.SetDrawColor( 100, 100, 50, 50 );
			//surface.SetMaterial( dustMat );
			//surface.DrawTexturedRect( -(ScrW()*.5)/2, -(ScrH()*.5)/2, ScrW()*1.5, ScrH()*1.5 );
			//MouseX, MouseY = 0, 0
			--print(gui:MousePos())
			MouseX = math.Clamp(MouseX+NewMouseX/10, -X_BOUNDS, X_BOUNDS);
			MouseY = math.Clamp(MouseY+NewMouseY/10, -Y_BOUNDS, Y_BOUNDS);
			surface.SetDrawColor( 255, 255, 255, 255 );
			if (v.canTakeDamage) then
				for i2, v2 in pairs(v:GetData("Damage")) do
					//print(v2.x, v2.y, "ALJFLJLAKJ")
					//print(v.material)
					surface.SetTexture( surface.GetTextureID(v2.material) ); -- If you use Material, cache it!
					surface.DrawTexturedRect( math.Clamp(MouseX + self.bobOffsetx, -X_BOUNDS, X_BOUNDS) + ((v2.x * ScrW()) - ((v2.size/2) * ScrH())), math.Clamp(MouseY - self.bobOffsety, -Y_BOUNDS, Y_BOUNDS) + ((v2.y * ScrH()) - ((v2.size/2) * ScrH())), v2.size * ScrH(), v2.size * ScrH() );
				end;
			end;

			if (v.smudge) then
				local cwClient = Clockwork.Client;
				local lightColor = render.GetLightColor(cwClient:EyePos());
				local posColor = render.GetLightColor(cwClient:GetPos());
				local colorX, colorY, colorZ = math.max(lightColor.x, posColor.x), math.max(lightColor.y, posColor.y), math.max(lightColor.z, posColor.z);

				//local activationIntensity = .2;

				local averageIntensity = (colorX + colorY + colorZ)/3; //(colorX + colorY + colorZ + ambientColor.x + ambientColor.y + ambientColor.z)/6;

				surface.SetMaterial(v.smudge);
				surface.SetDrawColor(255, 255, 255, 255 * averageIntensity);
				surface.DrawTexturedRect( math.Clamp(MouseX + self.bobOffsetx, -X_BOUNDS, X_BOUNDS)-((96/1920)*ScrW()), math.Clamp(MouseY -	 self.bobOffsety, -Y_BOUNDS, Y_BOUNDS)-((54/1080)*ScrH()), ((2112/1920)*ScrW()), ((1188/1080)*ScrH()) );
				surface.SetDrawColor( 255, 255, 255, 255 );
			end;

			surface.SetMaterial( v.maskOverlay or v.nvgMaskOverlay ); -- If you use Material, cache it!
			surface.DrawTexturedRect( math.Clamp(MouseX + self.bobOffsetx, -X_BOUNDS, X_BOUNDS)-((96/1920)*ScrW()), math.Clamp(MouseY -	 self.bobOffsety, -Y_BOUNDS, Y_BOUNDS)-((54/1080)*ScrH()), ((2112/1920)*ScrW()), ((1188/1080)*ScrH()) ); // (2112, 1188 [96, 54]) (2220, 1250 [150, 85]) surface.DrawTexturedRect( math.Clamp(MouseX, -X_BOUNDS, X_BOUNDS), math.Clamp(MouseY, -Y_BOUNDS, Y_BOUNDS), ScrW(), ScrH() )
			//print(Clockwork.player:GetClothesItem().canTakeDamage, "canTakeDamage")
			//PrintTable(Clockwork.player:GetClothesItem():GetData("Damage"))
		//end;
	end;
end;

hook.Add( "InputMouseApply", "GetMousePos", function( cmd, x, y )
	NewMouseX = x
	NewMouseY = y
	if x != 0 and y != 0 then
		ResetTime = CurTime() + .05
		//print(x, y, ResetTime)
	end
end )

function PLUGIN:Think()
	if ResetTime <= CurTime() and OldMouseX == MouseX then
		MouseX = Lerp(.01, MouseX, 0)
		MouseY = Lerp(.01, MouseY, 0)
	end

	OldMouseX = MouseX
end;