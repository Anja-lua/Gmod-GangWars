CH_GangWars.ScrW = ScrW()
CH_GangWars.ScrH = ScrH()

--[[
	Create scaled fonts
--]]
local function CH_GangWars_CreateFonts()
	surface.CreateFont( "CH_GangWars_Font_Size8", {
		font = CH_GangWars.Config.Font, 
		size = ScreenScale( 8 ), 
		weight = 500
	} )

	surface.CreateFont( "CH_GangWars_Font_Size10", {
		font = CH_GangWars.Config.Font, 
		size = ScreenScale( 10 ), 
		weight = 500
	} )
	
	surface.CreateFont( "CH_GangWars_Font_Size12", {
		font = CH_GangWars.Config.Font, 
		size = ScreenScale( 12 ), 
		weight = 500
	} )
	
	surface.CreateFont( "CH_GangWars_Font_Size14", {
		font = CH_GangWars.Config.Font, 
		size = ScreenScale( 14 ), 
		weight = 500
	} )
end

CH_GangWars_CreateFonts()

surface.CreateFont( "CH_GangWars_Font_3D2D_250", {
	font = CH_GangWars.Config.Font, 
	size = 250, 
	weight = 500
} )

surface.CreateFont( "CH_GangWars_Font_3D2D_150", {
	font = CH_GangWars.Config.Font, 
	size = 150, 
	weight = 500
} )

surface.CreateFont( "CH_GangWars_Font_3D2D_100", {
	font = CH_GangWars.Config.Font, 
	size = 100, 
	weight = 500
} )

surface.CreateFont( "CH_GangWars_Font_3D2D_75", {
	font = CH_GangWars.Config.Font, 
	size = 75, 
	weight = 500
} )

surface.CreateFont( "CH_GangWars_Font_3D2D_40", {
	font = CH_GangWars.Config.Font, 
	size = 40, 
	weight = 500
} )

--[[
	Update when screen sizes changes
--]]
local function CH_GangWars_OnScreenSizeChanged()
	CH_GangWars.ScrW = ScrW()
	CH_GangWars.ScrH = ScrH()
	
	-- Recreate fonts
    CH_GangWars_CreateFonts()
end
hook.Add( "OnScreenSizeChanged", "CH_GangWars_OnScreenSizeChanged", CH_GangWars_OnScreenSizeChanged )