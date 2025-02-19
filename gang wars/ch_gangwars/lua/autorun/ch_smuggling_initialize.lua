-- INITIALIZE SCRIPT
if SERVER then	
	for k, v in ipairs( file.Find( "ch_gangwars/shared/*.lua", "LUA" ) ) do
		include( "ch_gangwars/shared/".. v )
		AddCSLuaFile( "ch_gangwars/shared/".. v )
	end

	for k, v in ipairs( file.Find( "ch_gangwars/server/*.lua", "LUA" ) ) do
		include( "ch_gangwars/server/".. v )
	end

	for k, v in ipairs( file.Find( "ch_gangwars/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_gangwars/client/".. v )
	end
end

if CLIENT then
	for k, v in ipairs( file.Find( "ch_gangwars/shared/*.lua", "LUA" ) ) do
		include( "ch_gangwars/shared/".. v )
	end
	
	for k, v in ipairs( file.Find( "ch_gangwars/client/*.lua", "LUA" ) ) do
		include( "ch_gangwars/client/".. v )
	end
end