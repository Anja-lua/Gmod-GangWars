--[[
	Initialize all upgrades into a table.
--]]
function CH_GangWars.SetupUpgradeLevels()
	CH_GangWars.UpgradeLevels = {
		["Crips"] = {},
		["Bloods"] = {},
		["Mafia"] = {},
	}
	
	for gang, tbl in pairs( CH_GangWars.UpgradeLevels ) do
		for k, upgrade in pairs( CH_GangWars.Upgrades ) do
			CH_GangWars.UpgradeLevels[ gang ][ k ] = 0
		end
	end
end
hook.Add( "InitPostEntity", "CH_GangWars.SetupUpgradeLevels", CH_GangWars.SetupUpgradeLevels )

net.Receive( "CH_GangWars_Net_BuyUpgrade", function( len, ply )
	local cur_time = CurTime()
	if ( ply.CH_GangWars_NetDelay or 0 ) > cur_time then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_GangWars_NetDelay = cur_time + 0.5
	
	-- Check if player is a gang leader
	if not ply:CH_GangWars_IsGangLeader() then
		DarkRP.notify( ply, 1, 5, "Only the gang leader can purchase upgrades!" )
		return
	end
	
	-- Read net and buy function
	local upgrade = net.ReadString()
	local gang = ply:CH_GangWars_GetGang()
	
	CH_GangWars.BuyUpgrade( ply, upgrade, gang )
end )

function CH_GangWars.BuyUpgrade( ply, upgrade, gang )
	-- Check that upgrade exist
	if not CH_GangWars.Upgrades[ upgrade ] then
		print( "ERROR: Upgrade does not exist!" )
		return
	end
	
	local to_buy = CH_GangWars.Upgrades[ upgrade ]
	local cur_level = CH_GangWars.UpgradeLevels[ gang ][ upgrade ]
	local next_level = to_buy.Levels[ cur_level + 1 ]
	
	-- Check that we are not maxed on this upgrade
	if ( cur_level + 1 ) > #to_buy.Levels then
		DarkRP.notify( ply, 1, 5, "This upgrade is maxed out!" )
		return
	end
	
	-- Check that we can afford the next level
	if not ply:canAfford( next_level.Price ) then
		DarkRP.notify( ply, 1, 5, "You cannot afford this!" )
		return
	end
	
	-- BUY
	
	-- Take money from player
	ply:addMoney( -next_level.Price )
	
	-- Update table
	CH_GangWars.UpgradeLevels[ gang ][ upgrade ] = cur_level + 1
	
	-- Network and notify gang members
	for k, member in player.Iterator() do
		if member:CH_GangWars_GetGang() == gang then
			CH_GangWars.NetworkUpgrades( member, gang )
		
			DarkRP.notify( member, 1, 5, "Your gang has upgraded ".. to_buy.Name .." to level ".. CH_GangWars.UpgradeLevels[ gang ][ upgrade ] )
		end
	end
end

--[[
	Network the upgrade levels to the mayor
--]]
function CH_GangWars.NetworkUpgrades( ply, gang )
	-- Get the length of the table so we know how many uints and floats we need to receive on the other end
	local table_length = table.Count( CH_GangWars.UpgradeLevels[ gang ] )
	
	-- Network it to the client as efficient as possible
	net.Start( "CH_GangWars_Net_NetworkUpgradeLevels" )
		net.WriteString( gang )
		net.WriteUInt( table_length, 6 )
	
		for name, level in pairs( CH_GangWars.UpgradeLevels[ gang ] ) do
			net.WriteString( name )
			net.WriteUInt( level, 6 )
		end
	net.Send( ply )
end

--[[
	Function to reset upgrades
	Should be ran when there's a new leader for that gang
--]]
function CH_GangWars.OnJobChange( ply, before, after )
	-- Check if we're in gang after changing team
	timer.Simple( 0.1, function()
		local gang = ply:CH_GangWars_GetGang()
		if gang != "None" then
			-- Reset if new gang leader or simply network
			if ply:CH_GangWars_IsGangLeader() then
				CH_GangWars.ResetGangUpgrades( gang )
			else
				CH_GangWars.NetworkUpgrades( ply, gang )
			end
		end
	end )
end
hook.Add( "OnPlayerChangedTeam", "CH_GangWars.OnJobChange", CH_GangWars.OnJobChange )

function CH_GangWars.ResetGangUpgrades( gang )
	CH_GangWars.UpgradeLevels[ gang ] = {}

	for k, upgrade in pairs( CH_GangWars.Upgrades ) do
		CH_GangWars.UpgradeLevels[ gang ][ k ] = 0
	end
	
	-- Network and notify gang members
	for k, member in player.Iterator() do
		if member:CH_GangWars_GetGang() == gang then
			CH_GangWars.NetworkUpgrades( member, gang )
		
			DarkRP.notify( member, 1, 5, "Your gang upgrades have been reset!" )
		end
	end
end

--[[
	Upgrade hooks
--]]
hook.Add( "PlayerSpawn", "CH_GangWars_UpgradeModifiers", function( ply )
	timer.Simple( 1, function()
		if not IsValid( ply ) then
			return
		end
		
		-- Make sure we're gang related xx)
		local gang = ply:CH_GangWars_GetGang()
		if gang == "None" then
			return
		end
		
		-- Walk/Run modify
		local level = CH_GangWars.UpgradeLevels[ gang ][ "upgrade_walkrun" ]
		
		if level and level > 0 then
			local amount = CH_GangWars.Upgrades["upgrade_walkrun"].Levels[ level ].Amount

			local current_walk = ply:GetWalkSpeed()
			local walk_add = ( current_walk / 100 ) * amount
			ply:SetWalkSpeed( current_walk + walk_add )
			
			local current_run = ply:GetRunSpeed()
			local run_add = ( current_run / 100 ) * amount
			ply:SetRunSpeed( current_walk + walk_add )
		end
		
		-- Armor
		local level = CH_GangWars.UpgradeLevels[ gang ][ "upgrade_kevlar" ]
		if level and level > 0 then
			local amount = CH_GangWars.Upgrades["upgrade_kevlar"].Levels[ level ].Amount
			ply:SetArmor( ply:Armor() + amount )
		end
	end )
end )

hook.Add( "playerGetSalary", "CH_GangWars_ModifyPaycheck", function( ply, salary )
	-- Make sure we're gang related xx)
	local gang = ply:CH_GangWars_GetGang()
	if gang == "None" then
		return
	end
	
	local level = CH_GangWars.UpgradeLevels[ gang ][ "upgrade_paycheck" ]
	if level and level > 0 then
		local amount = CH_GangWars.Upgrades["upgrade_paycheck"].Levels[ level ].Amount
		
		local bonus_to_add = math.Round( ( salary / 100 ) * amount )
		ply:addMoney( bonus_to_add )
		
		DarkRP.notify( ply, 4, 5, "You have received a gang paycheck bonus of ".. DarkRP.formatMoney( bonus_to_add ) )
	end
end )

--[[
	Open upgrades menu via chat command
--]]
function CH_GangWars.PlayerSay( ply, text )
	if string.lower( text ) == CH_GangWars.Config.GangUpgradesChatCommand and ply:CH_GangWars_GetGang() != "None" then
		net.Start( "CH_GangWars_Net_OpenUpgradesMenu" )
		net.Send( ply )
		
		return ""
	end
end
hook.Add( "PlayerSay", "CH_GangWars.PlayerSay", CH_GangWars.PlayerSay )