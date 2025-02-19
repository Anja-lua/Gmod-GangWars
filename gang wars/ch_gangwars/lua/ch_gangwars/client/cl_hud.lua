--[[
	Draw the spheres
--]]
hook.Add( "PostDrawTranslucentRenderables", "CH_GangWars_DrawControlSphere", function()
	-- Set the draw material to solid white
	render.SetColorMaterial()

	-- The position to render the sphere at, in this case, the looking position of the local player
	for k, ent in ipairs( ents.FindByClass( "ch_gangwars_capture" ) ) do
		local radius = CH_GangWars.Config.Territories[ ent:GetKey() ].Size
		local wideSteps = 15
		local tallSteps = 15

		-- Draw the sphere!
		local color = CH_GangWars.Config.GangColors[ ent:GetGang() ]
		render.DrawSphere( ent:GetPos(), radius, wideSteps, tallSteps, color )
	end
end )

--[[
	Draw HUD while inside areas
--]]
function CH_GangWars.DrawTerritoryHUD()
	local ply = LocalPlayer()
	local cur_time = CurTime()

	local ply_point = ply:GetNWEntity( "CH_GangWars_CapturePoint" )

	-- Capture point entity info
	if IsValid( ply_point ) then		
		surface.SetDrawColor( CH_GangWars.Colors.GrayAlpha )
		surface.DrawRect( CH_GangWars.ScrW * 0.425, CH_GangWars.ScrH * 0.025, CH_GangWars.ScrW * 0.15, CH_GangWars.ScrH * 0.065 )
		
		if ( ply_point:GetIsBeingCaptured() and ply_point:GetStatus() != "Contested" ) and ( ply_point.CaptureTime or 0 ) > cur_time then
			local size_of_bar = CH_GangWars.ScrW * 0.15
			local bar_lenght = ( size_of_bar / CH_GangWars.Config.CaptureTime ) * ( ( ply_point.CaptureTime - cur_time ) / 1 )

			surface.SetDrawColor( CH_GangWars.Config.GangColors[ ply_point:GetGang() ] )
			surface.DrawRect( CH_GangWars.ScrW * 0.425, CH_GangWars.ScrH * 0.025, bar_lenght, CH_GangWars.ScrH * 0.065 )
			
			draw.SimpleTextOutlined( string.ToMinutesSeconds( math.Round( ply_point.CaptureTime - cur_time ) ), "CH_GangWars_Font_Size14", CH_GangWars.ScrW / 2, CH_GangWars.ScrH * 0.055, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		else
			draw.SimpleTextOutlined( ply_point:GetStatus(), "CH_GangWars_Font_Size12", CH_GangWars.ScrW / 2, CH_GangWars.ScrH * 0.0425, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
			
			draw.SimpleTextOutlined( ply_point:GetGang(), "CH_GangWars_Font_Size10", CH_GangWars.ScrW / 2, CH_GangWars.ScrH * 0.075, CH_GangWars.Config.GangColors[ ply_point:GetGang() ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		end
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( CH_GangWars.ScrW * 0.425, CH_GangWars.ScrH * 0.025, CH_GangWars.ScrW * 0.15, CH_GangWars.ScrH * 0.065, 1 )
	end

end
hook.Add( "HUDPaint", "CH_GangWars.DrawTerritoryHUD", CH_GangWars.DrawTerritoryHUD )

--[[
	Draw warfare overhead hud
--]]
function CH_GangWars.DrawWarfare3D2D( target )
	local ply = LocalPlayer()
	local OurPos = ply:GetPos() + Vector( 0, 0, 65 )
	
	if ply == target then return end
    if not IsValid( ply ) or not ply:Alive() or not IsValid( target ) or not target:Alive() then return end
    if target:GetColor().a == "0" then return end
    if ply:GetPos():DistToSqr( target:GetPos() ) > CH_GangWars.Config.DistanceTo3D2D then return end
	if not target:CH_GangWars_GetWarfareMode() then return end
	
	local pos = target:GetPos() + Vector( 0, 0, target:OBBMaxs().z * 1.15 ) 
    local ang = Angle( 0, ply:EyeAngles().y - 90, 90 )

	-- y pos
	local y_pos = 0
	if target:Crouching() then
		y_pos = -600
	end
	
	local flash = math.abs( math.sin( CurTime() * 1.2 ) )
	local red_flash = Color( 200, 200 * flash, 50, 255 )
	cam.Start3D2D( pos, ang, 0.02 )
		draw.SimpleTextOutlined( "Warfare Mode", "CH_GangWars_Font_3D2D_150", 0, y_pos, red_flash, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		draw.SimpleTextOutlined( target:CH_GangWars_GetGang(), "CH_GangWars_Font_3D2D_100", 0, y_pos + 120, CH_GangWars.Config.GangColors[ target:CH_GangWars_GetGang() ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
    cam.End3D2D()
end
hook.Add( "PostPlayerDraw", "CH_GangWars.DrawWarfare3D2D", CH_GangWars.DrawWarfare3D2D )