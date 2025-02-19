--[[
	Toggle mode on and off
--]]
hook.Add( "KeyPress", "CH_GangWars_ToggleWarfareMode", function( ply, key )
	local cur_time = CurTime()
	if ( ply.CH_GangWars_WarfareModeDelay or 0 ) > cur_time then
		return
	end
	
	if not ply:Alive() then
		return
	end
	
	-- Make sure we're in gang
	if ply:CH_GangWars_GetGang() == "None" then
		return
	end
	
	-- If not pressing alt then stop
	if not ply:KeyDown( CH_GangWars.Config.OptionalWarfareButton ) then
		return
	end
	
	-- Opt in or out of warfare mode
	if key == IN_USE then
		local warfare = ply:CH_GangWars_GetWarfareMode()
		
		if warfare then
			ply:SetNWBool( "CH_GangWars_WarfareMode", false )
			
			DarkRP.notify( ply, 3, 5, "You are no longer in warfare mode!" )
		else
			ply:SetNWBool( "CH_GangWars_WarfareMode", true )
			
			DarkRP.notify( ply, 3, 5, "You are now in warfare mode!" )
		end
		
		ply.CH_GangWars_WarfareModeDelay = cur_time + CH_GangWars.Config.WarfareModeToggleDelay
	end
end )

--[[
	Control the damage
--]]
hook.Add( "PlayerShouldTakeDamage", "CH_GangWars_WarfareDamage", function( ply, attacker )
	if ( ply != attacker ) and ply:IsPlayer() and attacker:IsPlayer() then
		if ( ply:CH_GangWars_GetWarfareMode() and not attacker:CH_GangWars_GetWarfareMode() ) or ( attacker:CH_GangWars_GetWarfareMode() and not ply:CH_GangWars_GetWarfareMode() ) then
			return false
		end
	end
end )