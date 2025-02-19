CH_GangWars.UpgradeLevels = CH_GangWars.UpgradeLevels or {
	["Crips"] = {},
	["Bloods"] = {},
	["Mafia"] = {},
}

net.Receive( "CH_GangWars_Net_NetworkUpgradeLevels", function( len, ply )
	local gang = net.ReadString()
	local amount_of_entries = net.ReadUInt( 6 )
	
	for i = 1, amount_of_entries do
		local name = net.ReadString()
		local level = net.ReadUInt( 6 )
		
		CH_GangWars.UpgradeLevels[ gang ][ name ] = level
	end
end )

--[[
	Menu
--]]
net.Receive( "CH_GangWars_Net_OpenUpgradesMenu", function()
	CH_GangWars.OpenUpgradesMenu()
end )

function CH_GangWars.OpenUpgradesMenu()
	local ply = LocalPlayer()
	local gang = ply:CH_GangWars_GetGang()
	local total_items = table.Count( CH_GangWars.Upgrades )
	local ply_money = ply:getDarkRPVar( "money" )
	
	local GUI_NotifySettingsFrame = vgui.Create( "DFrame" )
	GUI_NotifySettingsFrame:SetTitle( "" )
	GUI_NotifySettingsFrame:SetSize( CH_GangWars.ScrW * 0.6, CH_GangWars.ScrH * 0.6875 )
	GUI_NotifySettingsFrame:Center()
	GUI_NotifySettingsFrame.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_GangWars.Colors.GrayFront )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
		surface.DrawRect( 0, 0, w, h * 0.059 )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, w, h * 0.059, 1 )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, w, h, 1 )
		
		-- Draw the top title.
		draw.SimpleText( "Gang Upgrades (".. gang ..")", "CH_GangWars_Font_Size10", w / 2, h * 0.028, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Draw Icon
		surface.SetDrawColor( CH_GangWars.Config.CommunityLogoColor )
		surface.SetMaterial( CH_GangWars.Config.CommunityLogo )
		surface.DrawTexturedRect( CH_GangWars.ScrW * 0.004, CH_GangWars.ScrH * 0.005, CH_GangWars.ScrW * 0.02, CH_GangWars.ScrW * 0.019 )
	end
	GUI_NotifySettingsFrame:MakePopup()
	GUI_NotifySettingsFrame:SetDraggable( false )
	GUI_NotifySettingsFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_NotifySettingsFrame )
	GUI_CloseMenu:SetPos( CH_GangWars.ScrW * 0.582, CH_GangWars.ScrH * 0.01 )
	GUI_CloseMenu:SetSize( CH_GangWars.ScrW * 0.0125, CH_GangWars.ScrW * 0.0125 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( self:IsHovered() and CH_GangWars.Colors.Red or color_white )
		surface.SetMaterial( CH_GangWars.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_NotifySettingsFrame:Remove()
	end

	-- The list of upgrades	
	local GUI_UpgradesList = vgui.Create( "DPanelList", GUI_NotifySettingsFrame )
	GUI_UpgradesList:SetSize( CH_GangWars.ScrW * 0.5925, CH_GangWars.ScrH * 0.63 )
	GUI_UpgradesList:SetPos( CH_GangWars.ScrW * 0.005, CH_GangWars.ScrH * 0.0475 )
	GUI_UpgradesList:EnableVerticalScrollbar( true )
	GUI_UpgradesList:EnableHorizontal( true )
	GUI_UpgradesList:SetSpacing( 9 )
	GUI_UpgradesList.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_transparent )
	end
	if ( GUI_UpgradesList.VBar ) then
		GUI_UpgradesList.VBar.Paint = function( self, w, h ) -- BG
			surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_UpgradesList.VBar.btnUp.Paint = function( self, w, h )
			surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_UpgradesList.VBar.btnGrip.Paint = function( self, w, h )
			surface.SetDrawColor( CH_GangWars.Colors.GMSBlue )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_UpgradesList.VBar.btnDown.Paint = function( self, w, h )
			surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
	end
	
	for name, upgrade in pairs( CH_GangWars.Upgrades ) do
		local cur_level = CH_GangWars.UpgradeLevels[ gang ][ name ]
		local max_level = #upgrade.Levels
		local next_level = upgrade.Levels[ math.Clamp( cur_level + 1, 0, max_level ) ]

		local GUI_UpgradePanel = vgui.Create( "DPanelList" )
		GUI_UpgradePanel:SetSize( CH_GangWars.ScrW * 0.59, CH_GangWars.ScrH * 0.1351 )
		GUI_UpgradePanel.Paint = function( self, w, h )
			-- Background
			surface.SetDrawColor( CH_GangWars.Colors.GrayBG )
			if total_items <= 4 then
				surface.DrawRect( 0, 0, w, h )
			else
				surface.DrawRect( 0, 0, w * 0.986, h )
			end
			
			-- Name and description
			surface.SetFont( "CH_GangWars_Font_Size14" )
			local upgrade_name = upgrade.Name
			local x, y = surface.GetTextSize( upgrade_name )
			draw.SimpleText( upgrade_name, "CH_GangWars_Font_Size14", w * 0.16, h * 0.185, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( upgrade.Description, "CH_GangWars_Font_Size8", w * 0.16 + ( x + CH_GangWars.ScrW * 0.005 ), h * 0.22, CH_GangWars.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			-- Upgrade icon
			surface.SetDrawColor( 230, 230, 230 )
			surface.SetMaterial( upgrade.Icon )
			surface.DrawTexturedRect( w * 0.013, h * 0.1, CH_GangWars.ScrW * 0.065, CH_GangWars.ScrH * 0.11 )

			-- Next level text
			surface.SetFont( "CH_GangWars_Font_Size8" )
			local next_level_txt = "Next level: "
			local x, y = surface.GetTextSize( next_level_txt )
			draw.SimpleText( next_level_txt, "CH_GangWars_Font_Size8", w * 0.16, h * 0.44, CH_GangWars.Colors.GMSBlue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if cur_level < max_level then
				draw.SimpleText( next_level.Description, "CH_GangWars_Font_Size8", w * 0.16 + ( x + CH_GangWars.ScrW * 0.001 ), h * 0.44, CH_GangWars.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "This upgrade is maxed out!", "CH_GangWars_Font_Size8", w * 0.16 + ( x + CH_GangWars.ScrW * 0.001 ), h * 0.44, CH_GangWars.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			-- Price
			if cur_level < max_level then
				draw.SimpleText( DarkRP.formatMoney( next_level.Price ), "CH_GangWars_Font_Size12", w * 0.972, h * 0.185, ply_money > next_level.Price and CH_GangWars.Colors.Green or CH_GangWars.Colors.Red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			-- Upgrade progress bar
			local lenght_per_value = 0.625 / max_level
			local bar_lenght = lenght_per_value * cur_level
	
			draw.RoundedBox( 3, w * 0.16, h * 0.63, w * bar_lenght, h * 0.3, cur_level == max_level and CH_GangWars.Colors.Green or CH_GangWars.Colors.GMSBlue )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_GangWars.Materials.StripesBG )
			surface.DrawTexturedRect( w * 0.16, h * 0.63, w * 0.625, h * 0.3 )
			
			if cur_level == max_level then
				draw.SimpleText( "Maximum Level", "CH_GangWars_Font_Size10", w * 0.43, h * 0.76, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Level ".. cur_level .." / ".. max_level, "CH_GangWars_Font_Size10", w * 0.43, h * 0.76, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		
		local GUI_PurchaseUpgradeBtn = vgui.Create( "DButton", GUI_UpgradePanel )
		GUI_PurchaseUpgradeBtn:SetSize( CH_GangWars.ScrW * 0.1, CH_GangWars.ScrH * 0.04 )
		GUI_PurchaseUpgradeBtn:SetPos( CH_GangWars.ScrW * 0.4725, CH_GangWars.ScrH * 0.085 )
		GUI_PurchaseUpgradeBtn:SetText( "" )
		GUI_PurchaseUpgradeBtn.Paint = function( self, w, h )
			if self:IsHovered() then
				surface.SetDrawColor( CH_GangWars.Colors.GrayFront )
				surface.DrawRect( 0, 0, w, h )
				
				if cur_level == max_level then
					surface.SetDrawColor( CH_GangWars.Colors.GMSBlue )
				else
					surface.SetDrawColor( ply_money > next_level.Price and CH_GangWars.Colors.Green or CH_GangWars.Colors.Red )
				end
				surface.DrawRect( 0, 0, w, 1 )
				surface.DrawRect( 0, h-1, w, 1 )
				surface.DrawRect( w-1, 0, 1, h )
				surface.DrawRect( 0, 0, 1, h )
			else
				surface.SetDrawColor( CH_GangWars.Colors.GrayFront )
				surface.DrawRect( 0, 0, w, h )
				
				if cur_level == max_level then
					surface.SetDrawColor( CH_GangWars.Colors.GMSBlue )
				else
					surface.SetDrawColor( ply_money > next_level.Price and CH_GangWars.Colors.Green or CH_GangWars.Colors.Red )
				end
				surface.DrawRect( 0, 0, 1, 10 )
				surface.DrawRect( 0, 0, 10, 1 )
				surface.DrawRect( 0, h-10, 1, 10 )
				surface.DrawRect( 0, h-1, 10, 1 )
				surface.DrawRect( w-1, 0, 1, 10 )
				surface.DrawRect( w-10, 0, 10, 1 )
				surface.DrawRect( w-1, h-10, 1, 10 )
				surface.DrawRect( w-10, h-1, 10, 1 )
			end
			
			if cur_level == max_level then
				draw.SimpleText( "Maxed Out", "CH_GangWars_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( ply_money > next_level.Price and "Purchase Upgrade" or "Cannot Afford", "CH_GangWars_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		GUI_PurchaseUpgradeBtn.DoClick = function()
			if ply_money < next_level.Price then
				surface.PlaySound( "common/wpn_denyselect.wav" )
				return
			end
			
			net.Start( "CH_GangWars_Net_BuyUpgrade" )
				net.WriteString( name )
			net.SendToServer()
			
			GUI_NotifySettingsFrame:Remove()
		end
		
		GUI_UpgradesList:AddItem( GUI_UpgradePanel )
	end
end