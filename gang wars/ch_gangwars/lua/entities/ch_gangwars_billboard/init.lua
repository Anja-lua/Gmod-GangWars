AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then
		return
	end
	
	local SpawnPos = tr.HitPos + tr.HitNormal
	
	local ent = ents.Create( "ch_gangwars_billboard" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( ply:GetAngles() + Angle( 0, 90, 0 ) )
	ent:Spawn()
	
	return ent
end

CH_GangWars.Billboards = CH_GangWars.Billboards or {}

function ENT:Initialize()
	self:SetModel( "models/props_phx/construct/metal_plate1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )

	self:SetColor( Color( 0, 0, 0, 1 ) ) 
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
	
	-- Add entity to table
	CH_GangWars.Billboards[ self ] = true
end

function ENT:OnRemove()
	-- Remove entity from table
	CH_GangWars.Billboards[ self ] = nil
end