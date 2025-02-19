--[[
	Kill counter
--]]
local function CH_GangWars_CountShouldNotify( count )
    return count % 5 == 0 and count >= 5 and count <= 30
end

function CH_GangWars.KillCounter( victim, inflictor, attacker )
	-- Check if player
	if not victim:IsPlayer() or not attacker:IsPlayer() then
		return
	end
	
	-- Make sure they're both in a gang
	if attacker:CH_GangWars_GetGang() == "None" or victim:CH_GangWars_GetGang() == "None" then
		return
	end
	
	-- Reset victims count
	victim.CH_GangWars_KillCount = 0
	
	-- Accumilate kill count if not killing own gang
	if attacker:CH_GangWars_GetGang() != victim:CH_GangWars_GetGang() then
		-- One up
		attacker.CH_GangWars_KillCount = ( attacker.CH_GangWars_KillCount or 0 ) + 1
		
		-- Check for notify broadcast
		if CH_GangWars_CountShouldNotify( attacker.CH_GangWars_KillCount ) then
			for k, v in player.Iterator() do
				v:ChatPrint( "[GANG WARS] ".. attacker:Nick() .." has reached a gang kill count of ".. attacker.CH_GangWars_KillCount .." kills!" )
			end
		end
	end
end
hook.Add( "PlayerDeath", "CH_GangWars.KillCounter", CH_GangWars.KillCounter )