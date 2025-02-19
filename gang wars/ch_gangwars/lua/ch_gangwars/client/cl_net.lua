--[[
	Receive capture timer from point
--]]
net.Receive( "CH_GangWars_Net_CaptureArea", function()
	local point = net.ReadEntity()

	point.CaptureTime = CurTime() + CH_GangWars.Config.CaptureTime
end )