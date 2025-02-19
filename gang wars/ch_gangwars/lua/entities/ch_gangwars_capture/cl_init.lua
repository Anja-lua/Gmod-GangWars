include( "shared.lua" )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	local ply = LocalPlayer()
	local pos = self:GetPos()
	
	local distance = CH_GangWars.Config.Territories[ self:GetKey() ].Size
	if ply:GetPos():Distance( pos ) >= distance then
		return
	end

    local ang = self:GetAngles()
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 180 )

	local maxs = self:OBBMaxs()
	maxs.y = 0
	maxs.x = 0

	cam.Start3D2D( pos + maxs, Angle( 0, ply:EyeAngles().y - 90, 90 ), 0.04 )	
		draw.SimpleTextOutlined( self:GetStatus(), "CH_GangWars_Font_3D2D_250", 0, -350, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
		draw.SimpleTextOutlined( self:GetGang(), "CH_GangWars_Font_3D2D_150", 0, -180, CH_GangWars.Config.GangColors[ self:GetGang() ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
	cam.End3D2D()
end