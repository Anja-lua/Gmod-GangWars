CH_GangWars = CH_GangWars or {}
CH_GangWars.Config = CH_GangWars.Config or {}
CH_GangWars.Upgrades = CH_GangWars.Upgrades or {}
CH_GangWars.Colors = CH_GangWars.Colors or {}
CH_GangWars.Materials = CH_GangWars.Materials or {}

-- USE CONSOLE COMMAND ch_gangwars_save TO SAVE BILLBOARDS ON MAP

--[[
	General
--]]
CH_GangWars.Config.DistanceTo3D2D = 500000 -- Distance before drawing 3d2d

CH_GangWars.Config.Font = "Roboto" -- The font to use with the addon

CH_GangWars.Config.WarfareModeToggleDelay = 2 -- Seconds delay to toggle warfare mode on and off

--[[
	UI Design options
--]]
CH_GangWars.Config.GangColors = {
	["None"] = Color( 200, 200, 200, 50 ),
	["Crips"] = Color( 52, 0, 197, 100 ),
	["Bloods"] = Color( 208, 15, 0, 100 ),
	["Mafia"] = Color( 40, 40, 40, 100 ),
}

CH_GangWars.Config.GangLogos = {
	["Crips"] = Material( "materials/craphead_scripts/ch_gangwars/crips.png", "noclamp smooth" ),
	["Bloods"] = Material( "materials/craphead_scripts/ch_gangwars/bloods.png", "noclamp smooth" ),
	["Mafia"] = Material( "materials/craphead_scripts/ch_gangwars/mafia.png", "noclamp smooth" ),
}

CH_GangWars.Config.CommunityLogo = Material( "materials/craphead_scripts/ch_gangwars/logo.png", "noclamp smooth" )
CH_GangWars.Config.CommunityLogoColor = Color( 255, 255, 255, 50 )

CH_GangWars.Materials.CloseIcon = Material( "materials/craphead_scripts/ch_gangwars/close.png", "noclamp smooth" )
CH_GangWars.Materials.StripesBG = Material( "materials/craphead_scripts/ch_gangwars/bg_stripes.png", "noclamp smooth" )

CH_GangWars.Colors.GrayBG = Color( 30, 30, 30, 255 )
CH_GangWars.Colors.GrayFront = Color( 22, 22, 22, 255 )
CH_GangWars.Colors.GrayAlpha = Color( 22, 22, 22, 225 )

CH_GangWars.Colors.Green = Color( 52, 178, 52, 255 )
CH_GangWars.Colors.Red = Color( 201, 29, 29, 255 )
CH_GangWars.Colors.WhiteAlpha2 = Color( 255, 255, 255, 100 )
CH_GangWars.Colors.GMSBlue = Color( 52, 152, 219, 255 )

--[[
	Gang warfare options
--]]
CH_GangWars.Config.OptionalWarfareButton = IN_WALK -- It will be E + whatever this config is (in this case ALT)

--[[
	Teams config
	
	Define what DarkRP teams are considered in the different groups.
--]]
CH_GangWars.Config.CripsLeaders = {
	["Crips Leader"] = true,
}

CH_GangWars.Config.CripsMembers = {
	["Crips Member"] = true,
	["Crips Gangbanger"] = true,
}

CH_GangWars.Config.BloodsLeaders = {
	["Bloods Leader"] = true,
}

CH_GangWars.Config.BloodsMembers = {
	["Bloods Member"] = true,
	["Bloods Gangbanger"] = true,
}

CH_GangWars.Config.MafiaLeaders = {
	["Mafia Leader"] = true,
}

CH_GangWars.Config.MafiaMembers = {
	["Mafia Member"] = true,
	["Mafia Gangbanger"] = true,
}

CH_GangWars.Config.PoliceTeams = {
	["Police Officer"] = true,
	["Police Chief"] = true,
	["Corrupt Civil Protection Leader"] = true,
	["Corrupt Civil Protection Juggernaut"] = true,
	["Corrupt Civil Protection Member"] = true,
}

--[[
	Areas
	
	Here you can configure the territories by a position and size.
	It will create a sphere from the position you set and spread it out for the size you set.
	You can also define who controls it by default (if any).
	
	To get the position simply put "getpos" in console and copy the vector (setpos) and put the commas like in the examples.
--]]
CH_GangWars.Config.Territories = {
	[1] = {
		Name = "First",
		Pos = Vector( 55.227470, -1100.699341, -139.968750 ),
		Size = 200,
		Control = "Bloods",
	},
	[2] = {
		Name = "Second",
		Pos = Vector( 2615.626953, -907.514343, -139.968750 ),
		Size = 200,
	},
	[3] = {
		Name = "Third",
		Pos = Vector( 67.994423, -3092.135986, -139.968750 ),
		Size = 200,
		Control = "Mafia",
	},
	[4] = {
		Name = "Fourth",
		Pos = Vector( 973.051025, -1319.832153, -131.968750 ),
		Size = 500,
		Control = "Crips",
	},
}

--[[
	Capture territory
--]]
CH_GangWars.Config.CapturePointModel = "models/maxofs2d/hover_rings.mdl" -- The model of the capture point.

CH_GangWars.Config.CaptureTime = 30 -- How long it takes for 1 to capture a point when started

--[[
	Upgrades
--]]
CH_GangWars.Config.GangUpgradesChatCommand = "!gangupgrades"

CH_GangWars.Upgrades["upgrade_kevlar"] = {
	Name = "Kevlar",
	Icon = Material( "materials/craphead_scripts/ch_gangwars/kevlar.png", "noclamp smooth" ),
	Description = "Equip your police officers with extra bulletproof kevlar.",
	Levels = {
		[1] = {
			Price = 1500,
			Description = "Equips the government teams with 50 extra kevlar.",
			Amount = 50,
		},
		[2] = {
			Price = 3500,
			Description = "Equips the government teams with 60 extra kevlar.",
			Amount = 60,
		},
		[3] = {
			Price = 7500,
			Description = "Equips the government teams with 70 extra kevlar.",
			Amount = 70,
		},
		[4] = {
			Price = 1350,
			Description = "Equips the government teams with 80 extra kevlar.",
			Amount = 80,
		},
		[5] = {
			Price = 20000,
			Description = "Equips the government teams with 90 extra kevlar.",
			Amount = 90,
		},
	},
}

CH_GangWars.Upgrades["upgrade_paycheck"] = {
	Name = "Paycheck Bonus",
	Icon = Material( "materials/craphead_scripts/ch_gangwars/paycheck.png", "noclamp smooth" ),
	Description = "Increases your government teams paycheck.",
	Levels = {
		[1] = {
			Price = 2500,
			Description = "10% extra money on paychecks.",
			Amount = 10,
		},
		[2] = {
			Price = 5000,
			Description = "20% extra money on paychecks.",
			Amount = 20,
		},
		[3] = {
			Price = 15000,
			Description = "30% extra money on paychecks.",
			Amount = 30,
		},
	},
}

CH_GangWars.Upgrades["upgrade_walkrun"] = {
	Name = "Fitness Subscription",
	Icon = Material( "materials/craphead_scripts/ch_gangwars/run.png", "noclamp smooth" ),
	Description = "Increase officials walk and run speeds.",
	Levels = {
		[1] = {
			Price = 1200,
			Description = "Gives all government teams 10% extra walk and run speed.",
			Amount = 10,
		},
		[2] = {
			Price = 2000,
			Description = "Gives all government teams 15% extra walk and run speed.",
			Amount = 15,
		},
		[3] = {
			Price = 4250,
			Description = "Gives all government teams 20% extra walk and run speed.",
			Amount = 20,
		},
		[4] = {
			Price = 7500,
			Description = "Gives all government teams 25% extra walk and run speed.",
			Amount = 25,
		},
		[5] = {
			Price = 1250,
			Description = "Gives all government teams 30% extra walk and run speed.",
			Amount = 30,
		},
	},
}