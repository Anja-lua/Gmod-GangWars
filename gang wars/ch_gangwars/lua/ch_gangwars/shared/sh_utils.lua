local PMETA = FindMetaTable( "Player" )

--[[
	Various meta team funcs
--]]
function PMETA:CH_GangWars_IsCripsLeader()
	return CH_GangWars.Config.CripsLeaders[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsCripsMember()
	return CH_GangWars.Config.CripsMembers[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsBloodsLeader()
	return CH_GangWars.Config.BloodsLeaders[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsBloodsMember()
	return CH_GangWars.Config.BloodsMembers[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsMafiaLeader()
	return CH_GangWars.Config.MafiaLeaders[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsMafiaMember()
	return CH_GangWars.Config.MafiaMembers[ team.GetName( self:Team() ) ]
end

function PMETA:CH_GangWars_IsPoliceOfficer()
	return CH_GangWars.Config.PoliceTeams[ team.GetName( self:Team() ) ]
end

--[[
	Get players gang
--]]
function PMETA:CH_GangWars_GetGang()
	if self:CH_GangWars_IsCripsLeader() or self:CH_GangWars_IsCripsMember() then
		return "Crips"
	elseif self:CH_GangWars_IsBloodsLeader() or self:CH_GangWars_IsBloodsMember() then
		return "Bloods"
	elseif self:CH_GangWars_IsMafiaLeader() or self:CH_GangWars_IsMafiaMember() then
		return "Mafia"
	end
	
	-- In case they're netural
	return "None"
end

--[[
	Check if gang leader
--]]
function PMETA:CH_GangWars_IsGangLeader()
	return ( self:CH_GangWars_IsCripsLeader() or self:CH_GangWars_IsBloodsLeader() or self:CH_GangWars_IsMafiaLeader() ) or false
end

--[[
	Get amount of active cops
--]]
function CH_GangWars.GetTotalPoliceOfficers()
	local count = 0
	
	for k, ply in player.Iterator() do
		if ply:CH_GangWars_IsPoliceOfficer() then
			count = count + 1
		end
	end
	
	return count
end

--[[
	Get in warfare mode
--]]
function PMETA:CH_GangWars_GetWarfareMode()
	return self:GetNWBool( "CH_GangWars_WarfareMode" )
end