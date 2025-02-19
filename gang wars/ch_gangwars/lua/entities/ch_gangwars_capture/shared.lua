ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Capture Point"
ENT.Author = "Crap-Head"
ENT.Category = "Gang Wars by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsBeingCaptured" )
	self:NetworkVar( "Bool", 1, "IsCaptured" )
	
	self:NetworkVar( "Entity", 0, "IsBeingCapturedBy" )
	
	self:NetworkVar( "String", 0, "Status" )
	self:NetworkVar( "String", 1, "Gang" )
	
	self:NetworkVar( "Int", 0, "Key" )
end