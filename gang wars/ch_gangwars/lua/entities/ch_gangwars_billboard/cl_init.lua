include( "shared.lua" )

local total_territories = #CH_GangWars.Config.Territories

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_GangWars.Config.DistanceTo3D2D then
		return
	end
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	-- Territories count
	local crips_territories = 0
	local bloods_territories = 0
	local mafia_territories = 0
	
	for k, ent in ipairs( ents.FindByClass( "ch_gangwars_capture" ) ) do
		if ent:GetGang() == "Crips" then
			crips_territories = crips_territories + 1
		elseif ent:GetGang() == "Bloods" then
			bloods_territories = bloods_territories + 1
		elseif ent:GetGang() == "Mafia" then
			mafia_territories = mafia_territories + 1
		end	
	end
	cam.Start3D2D( pos, ang, 0.15 )		
		-- Draw frame
		surface.SetDrawColor( CH_GangWars.Colors.GrayFront )
		surface.DrawRect( -740, -475, 1480, 650 )
		
		-- Draw top
		surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
		surface.DrawRect( -740, -475, 1480, 100 )
		
		-- Draw outline
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( -740, -475, 1480, 650, 2 )

		surface.DrawRect( -740, -375, 1480, 2 )
		
		-- Draw the top title
		draw.SimpleTextOutlined( "GANG BILLBOARD", "CH_GangWars_Font_3D2D_100", 0, -425, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		-- Crips area
		surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
		surface.DrawRect( -700, -350, 450, 500 )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( -700, -350, 450, 500, 2 )
		
		draw.SimpleTextOutlined( "Crips", "CH_GangWars_Font_3D2D_75", -480, -310, CH_GangWars.Config.GangColors[ "Crips" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		draw.SimpleTextOutlined( "Territories: ".. crips_territories .." / ".. total_territories, "CH_GangWars_Font_3D2D_40", -480, -260, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_GangWars.Config.GangLogos[ "Crips" ] )
		surface.DrawTexturedRect( -650, -225, 350, 350 )
		
		-- Bloods area
		surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
		surface.DrawRect( -220, -350, 450, 500 )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( -220, -350, 450, 500, 2 )
		
		draw.SimpleTextOutlined( "Bloods", "CH_GangWars_Font_3D2D_75", 5, -310, CH_GangWars.Config.GangColors[ "Bloods" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		draw.SimpleTextOutlined( "Territories: ".. bloods_territories .." / ".. total_territories, "CH_GangWars_Font_3D2D_40", 5, -260, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_GangWars.Config.GangLogos[ "Bloods" ] )
		surface.DrawTexturedRect( -170, -225, 350, 350 )
		
		-- Mafia area
		surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
		surface.DrawRect( 260, -350, 450, 500 )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 260, -350, 450, 500, 2 )
		
		draw.SimpleTextOutlined( "Mafia", "CH_GangWars_Font_3D2D_75", 480, -310, CH_GangWars.Config.GangColors[ "Mafia" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		
		draw.SimpleTextOutlined( "Territories: ".. mafia_territories .." / ".. total_territories, "CH_GangWars_Font_3D2D_40", 480, -260, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )

		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_GangWars.Config.GangLogos[ "Mafia" ] )
		surface.DrawTexturedRect( 310, -225, 350, 350 )
	cam.End3D2D()
end