local map = string.lower( game.GetMap() )

--[[
	Spawn all entities
--]]
function CH_GangWars.SpawnEntities()
	-- Directories
	if not file.IsDir( "craphead_scripts", "DATA" ) then
		file.CreateDir( "craphead_scripts", "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_gangwars/", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_gangwars/", "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_gangwars/".. map, "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_gangwars/".. map, "DATA" )
	end
	
	-- Spawn territories
	for k, v in ipairs( CH_GangWars.Config.Territories ) do
		local ent = ents.Create( "ch_gangwars_capture" )
		ent:SetPos( v.Pos )
		ent:SetAngles( Angle( 0, 0, 0 ) )
		ent:SetKey( k )
		ent:Spawn()
		
		timer.Simple( 0.1, function()
			if v.Control then
				ent:SetStatus( "Territory Controlled" )
				ent:SetGang( v.Control )
				
				-- Change color
				ent:SetColor( CH_GangWars.Config.GangColors[ ent:GetGang() ] )
			end
		end )
	end
	
	-- Spawn billboards
	local pos_file = file.Read( "craphead_scripts/ch_gangwars/".. map .."/billboards.json", "DATA" )
	
	if not pos_file then
		return
	end
	
	local file_table = util.JSONToTable( pos_file )

	for k, v in ipairs( file_table ) do
		local ent = ents.Create( v.EntityClass )
		ent:SetPos( v.EntityVector )
		ent:SetAngles( v.EntityAngles )
		ent:Spawn()
	end
end
hook.Add( "InitPostEntity", "CH_GangWars.SpawnEntities", CH_GangWars.SpawnEntities )
hook.Add( "PostCleanupMap", "CH_GangWars.SpawnEntities", CH_GangWars.SpawnEntities )

--[[
	Billboards
--]]
local function CH_GangWars_SaveBillboards( ply, cmd, args )
	if not ply:IsSuperAdmin() then
		return
	end
	
	-- Save entities
	local pos_file = {}
	
	for ent, value in pairs( CH_GangWars.Billboards ) do
		local ent_info = {
			EntityClass = ent:GetClass(),
			EntityVector = ent:GetPos(),
			EntityAngles = ent:GetAngles(),
		}
		
		table.insert( pos_file, ent_info )
	end
	
	file.Write( "craphead_scripts/ch_gangwars/".. map .."/billboards.json", util.TableToJSON( pos_file ), "DATA" )

	-- Notify the player
	DarkRP.notify( ply, 1, 5, "All billboards have been saved to the map." )
end
concommand.Add( "ch_gangwars_save", CH_GangWars_SaveBillboards )