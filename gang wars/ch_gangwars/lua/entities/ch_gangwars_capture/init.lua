AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( CH_GangWars.Config.CapturePointModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	--self:DropToFloor()
	
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
	
	-- Set variables
	self:SetIsBeingCaptured( false )
	self:SetIsBeingCapturedBy( nil )
	
	self:SetStatus( "Uncontrolled" )
	self:SetGang( "None" )

	-- Contest table
	self.Contestants = {}
end

function ENT:Use( ply )
	local ply_gang = ply:CH_GangWars_GetGang()
	
	if ply_gang == "None" then
		DarkRP.notify( ply, 1, 5, "You are not in a gang and cannot fight for territory!" )
		return
	end
	
	-- If already captured, disallow
	if self:GetStatus() == "Territory Controlled" and self:GetGang() == ply_gang then
		DarkRP.notify( ply, 1, 5, "Your gang already controls this territory!" )
		return
	end
	
	-- If we're not just one gang in capture point then disallow
	for contester, k in pairs( self.Contestants ) do
		if contester:CH_GangWars_GetGang() != ply_gang then
			DarkRP.notify( ply, 1, 5, "You can't fight for this territory while multiple gangs are inside the zone!" )
			return
		end
	end
	
	-- If somebody capturing, disallow.
	if self:GetIsBeingCaptured() then
		DarkRP.notify( ply, 1, 5, "Someone else is already fighting for this territory!" )
		return
	end
	
	-- All good, start!
	self:StartCapture( ply )
end

function ENT:StartCapture( ply )
	-- They're stealing, set old variables
	if self:GetStatus() == "Territory Controlled" then
		self.OldCaptureGang = self:GetGang()
	end
	
	-- Start capture
	self:SetIsBeingCaptured( true )
	self:SetIsBeingCapturedBy( ply )
	
	ply.CH_GangWars_Capturing = self

	self:SetStatus( "Being Captured" )
	
	-- set gang
	local gang = ply:CH_GangWars_GetGang()
	self:SetGang( gang )
	
	-- broadcast net timer for this point entity
	net.Start( "CH_GangWars_Net_CaptureArea" )
		net.WriteEntity( self )
	net.Broadcast()
	
	-- Start capture timer.
	timer.Create( "CH_GangWars_Capture_".. self:EntIndex(), CH_GangWars.Config.CaptureTime, 1, function()
		self:WasCaptured()
	end )
end

function ENT:AbortCapture( status )
	-- Destroy timer
	timer.Destroy( "CH_GangWars_Capture_".. self:EntIndex() )
	
	-- Reset vars
	local capturer = self:GetIsBeingCapturedBy()
	self:SetStatus( status )
	
	if status == "Uncontrolled" then
		self:SetIsBeingCaptured( false )
		self:SetIsBeingCapturedBy( nil )
		
		if not self.OldCaptureGang then
			self:SetGang( "None" )
		else
			self:SetGang( self.OldCaptureGang )
			self:WasCaptured()
		end
		
		if IsValid( capturer ) then
			capturer.CH_GangWars_Capturing = nil
		end
	end
end

function ENT:Think()
	local cur_time = CurTime()
	
	local distance = CH_GangWars.Config.Territories[ self:GetKey() ].Size
	
	-- Scan nearby players
	for k, ply in ipairs( player.GetAll() ) do
		if ply:CH_GangWars_GetGang() == "None" then
			continue
		end
		
		if ply:GetPos():Distance( self:GetPos() ) < distance then
			if self.Contestants[ ply ] then
				if not ply:Alive() then
					self:PlayerLeftZone( ply )
				end
				
				continue
			end
			
			if ply:Alive() then
				self:PlayerEnteredZone( ply )
			end
		elseif ply:GetPos():Distance( self:GetPos() ) >= distance and self.Contestants[ ply ] then
			self:PlayerLeftZone( ply )
		end
	end
	
	self:NextThink( cur_time + 0.2 )
    return true
end

function ENT:PlayerEnteredZone( ply )
	self.Contestants[ ply ] = true

	-- Show HUD for player.
	ply:SetNWEntity( "CH_GangWars_CapturePoint", self )
	
	local capturer = self:GetIsBeingCapturedBy()
	
	-- Check if we should contest now
	if self:GetIsBeingCaptured() and IsValid( capturer ) and capturer:CH_GangWars_GetGang() != ply:CH_GangWars_GetGang() then
		-- CONTEST
		self:AbortCapture( "Contested" )
	elseif self:GetStatus() == "Territory Controlled" and self:GetGang() != ply:CH_GangWars_GetGang() then
		-- CONTEST AND SAVE OLD STATUS
		self.OldCaptureGang = self:GetGang()
		
		self:AbortCapture( "Contested" )
	end
end

function ENT:PlayerLeftZone( ply )
	self.Contestants[ ply ] = nil

	-- Stop drawing HUD for player
	ply:SetNWEntity( "CH_GangWars_CapturePoint", "" )
	
	-- If somebody leaves and the points gang is not equal to whoever is in here, we uncapture
	local contestants = table.Count( self.Contestants )
	if contestants == 1 and self:GetStatus() == "Contested" then
		self:AbortCapture( "Uncontrolled" )
	elseif contestants > 1 or contestants < 1 then
		local crips_found = false
		local bloods_found = false
		local mafia_found = false
		
		for contester, k in pairs( self.Contestants ) do
			if contester:CH_GangWars_GetGang() == "Crips" then
				crips_found = true
			end
			
			if contester:CH_GangWars_GetGang() == "Bloods" then
				bloods_found = true
			end
			
			if contester:CH_GangWars_GetGang() == "Mafia" then
				mafia_found = true
			end
		end
		
		-- Check who we found and apply
		if ( crips_found and bloods_found ) or ( crips_found and mafia_found ) or ( bloods_found and mafia_found ) then
			self:AbortCapture( "Contested" )
		elseif self:GetStatus() != "Territory Controlled" then
			self:AbortCapture( "Uncontrolled" )
		end
	elseif self:GetIsBeingCapturedBy() == ply then
		local crips_found = false
		local bloods_found = false
		local mafia_found = false
		local ply_found = nil
		
		for contester, k in pairs( self.Contestants ) do
			if contester:CH_GangWars_GetGang() == "Crips" then
				crips_found = true
				ply_found = contester
			end
			
			if contester:CH_GangWars_GetGang() == "Bloods" then
				bloods_found = true
				ply_found = contester
			end
			
			if contester:CH_GangWars_GetGang() == "Mafia" then
				mafia_found = true
				ply_found = contester
			end
		end
		
		-- Check who we found and apply
		if self:GetGang() == "Crips" and not crips_found then
			self:AbortCapture( "Uncontrolled" )
		elseif self:GetGang() == "Bloods" and not bloods_found then
			self:AbortCapture( "Uncontrolled" )
		elseif self:GetGang() == "Mafia" and not mafia_found then
			self:AbortCapture( "Uncontrolled" )
		else
			self:SetIsBeingCapturedBy( ply_found )
		end
	end
end

function ENT:WasCaptured()
	-- update the vars
	self:SetStatus( "Territory Controlled" )
	
	-- Reset the being variables
	self:SetIsBeingCaptured( false )
	self:SetIsBeingCapturedBy( nil )
	
	-- Change color
	self:SetColor( CH_GangWars.Config.GangColors[ self:GetGang() ] )
end

function ENT:OnRemove()
	-- Destroy timer
	timer.Destroy( "CH_GangWars_Capture_".. self:EntIndex() )
end

function ENT:OnTakeDamage( dmg )
	return false
end