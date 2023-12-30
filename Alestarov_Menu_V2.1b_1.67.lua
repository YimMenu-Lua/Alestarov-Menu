-- Game version: 3095
-- Online version: 1.68
--
--
--Please also make sure to download the file published by the official GitHub user Alestarov or on youtube channel Alestarov_. Any other method may be a malicious script.
--Github: https://github.com/Alestarov/YimMenu-lua-script-Alestarov_Menu
--YouTube: https://www.youtube.com/@Alestarov_
--
--When editing the Script, please indicate the authors
--
--
--
--
----------------------------------------------------------
Almenu = gui.get_tab("Al_Menu v3 1.68")

gui.show_message("Alestarov_Menu_V3b_1.68","is Successfully launched!")

	Almenu:add_text("         Alestarov_Menu_V3_1.68 ")
------------------------------------

function run_script(name) --start script thread
    script.run_in_fiber(function (runscript)
        SCRIPT.REQUEST_SCRIPT(name)  
        repeat runscript:yield() until SCRIPT.HAS_SCRIPT_LOADED(name)
        SYSTEM.START_NEW_SCRIPT(name, 5000)
        SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(name)
    end)
end


function tpfac()
    local Pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(590))
    if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(590)) then
        PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), Pos.x, Pos.y, Pos.z+4)
    end

end

function DELETE_OBJECT_BY_HASH(hash)
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        if ENTITY.GET_ENTITY_MODEL(ent) == hash then
            PED.SET_PED_COORDS_KEEP_VEHICLE(ent, 0, 0, 0)
        end
    end
end
------------------------------------



AlmenuT = Almenu:add_tab("Teleport")

AlmenuT:add_button("to Marker (particles)", function()
    script.run_in_fiber(function (tp2wp)
        command.call("waypointtp",{}) --调用Yimmenu自身传送到导航点命令
        STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_rcbarry2") --小丑出现烟雾
        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_rcbarry2") do
            STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_rcbarry2")
            tp2wp:yield()               
        end
        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")
        GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE("scr_clown_appears", PLAYER.PLAYER_PED_ID(), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0x8b93, 1.0, false, false, false, 0, 0, 0, 0)
    end)
end)


AlmenuT:add_button("to Bunker", function()
    local PlayerPos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0.0, 0.52, 0.0)
    local intr = INTERIOR.GET_INTERIOR_AT_COORDS(PlayerPos.x, PlayerPos.y, PlayerPos.z)

    if intr == 269313 then 
        gui.show_message("no need to send","You are already in the facility")
    else
        tpfac()
    end
end)

AlmenuT:add_sameline()

AlmenuT:add_button("to Bunker Plan Screen", function()
    local PlayerPos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0.0, 0.52, 0.0)
    local intr = INTERIOR.GET_INTERIOR_AT_COORDS(PlayerPos.x, PlayerPos.y, PlayerPos.z)
    if intr == 269313 then 
        if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(428)) then
            PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 350.69284, 4872.308, -60.794243)
        end
    else
        gui.show_message("make sure you are in the facility","Please enter the facility before teleporting to the planning screen")
        tpfac()
    end
end)
-------------------------------------


local NightclubPropertyInfo = {
    [1]  = {name = "La Mesa Nightclub",           coords = {x = 757.009,   y =  -1332.32,  z = 27.1802 }},
    [2]  = {name = "Mission Row Nightclub",       coords = {x = 345.7519,  y =  -978.8848, z = 29.2681 }},
    [3]  = {name = "Strawberry Nightclub",        coords = {x = -120.906,  y =  -1260.49,  z = 29.2088 }},
    [4]  = {name = "West Vinewood Nightclub",     coords = {x = 5.53709,   y =  221.35,    z = 107.6566}},
    [5]  = {name = "Cypress Flats Nightclub",     coords = {x = 871.47,    y =  -2099.57,  z = 30.3768 }},
    [6]  = {name = "LSIA Nightclub",              coords = {x = -676.625,  y =  -2458.15,  z = 13.8444 }},
    [7]  = {name = "Elysian Island Nightclub",    coords = {x = 195.534,   y =  -3168.88,  z = 5.7903  }},
    [8]  = {name = "Downtown Vinewood Nightclub", coords = {x = 373.05,    y =  252.13,    z = 102.9097}},
    [9]  = {name = "Del Perro Nightclub",         coords = {x = -1283.38,  y =  -649.916,  z = 26.5198 }},
    [10] = {name = "Vespucci Canals Nightclub",   coords = {x = -1174.85,  y =  -1152.3,   z = 5.56128 }},
}

-- Business / Other Online Work Stuff [[update]]
local function GetOnlineWorkOffset()
    -- GLOBAL_PLAYER_STAT
        local playerid = globals.get_int(1574918) --疑似与MPPLY_LAST_MP_CHAR相等
    return (1853988 + 1 + (playerid * 867) + 267)
end
local function GetNightClubHubOffset()
    return (GetOnlineWorkOffset() + 310)
end
local function GetNightClubOffset()
    return (GetOnlineWorkOffset() + 354) -- CLUB_OWNER_X
end

local function GetWarehouseOffset()
    return (GetOnlineWorkOffset() + 116) + 1
end

local function GetMCBusinessOffset()
    return (GetOnlineWorkOffset() + 193) + 1
end
local function GetNightClubPropertyID()
    return globals.get_int(GetNightClubOffset())
end

local function IsPlayerInNightclub()
    return (GetPlayerPropertyID() > 101) and (GetPlayerPropertyID() < 112)
end

function tpnc() --传送到夜总会
    local property = GetNightClubPropertyID()
    if property ~= 0  then
        local coords = NightclubPropertyInfo[property].coords
        PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
    end
end

AlmenuT:add_button("to Nightclub (Work only in invitation session)", function()
    tpnc()
end)

AlmenuT:add_sameline()

AlmenuT:add_button("to Nightclub safe (TP to NC first)", function()
    PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), -1615.6832, -3015.7546, -75.204994)
end)
-----------


---------------

AlmenuF = Almenu:add_tab("CMM")

AlmenuF:add_text("(Computers Management Menu)")
---------------

AlmenuM = Almenu:add_tab("Money")

---------------

AlmenuH = Almenu:add_tab("Heist Editor")

---------------
CayoH = AlmenuH:add_tab("Cayo Perico Heist")

CayoH:add_button("Setup Panther", function()
    PlayerIndex = globals.get_int(1574918)
	if PlayerIndex == 0 then
		mpx = "MP0_"
	else
		mpx = "MP1_"
	end
		STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_BS_GEN"), 131071, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_BS_ENTR"), 63, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_BS_ABIL"), 63, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_WEAPONS"), 5, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_WEP_DISRP"), 3, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_ARM_DISRP"), 3, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_HEL_DISRP"), 3, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_TARGET"), 5, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_TROJAN"), 2, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_APPROACH"), -1, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_CASH_I"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_CASH_C"), 0, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_WEED_I"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_WEED_C"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_COKE_I"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_COKE_C"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_CASH_I"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_GOLD_I"), 0, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_GOLD_C"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_PAINT"), -1, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4_PROGRESS"), 126823, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_CASH_I_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_CASH_C_SCOPED"), 0, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_WEED_I_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_WEED_C_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_COKE_I_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_COKE_C_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_GOLD_I_SCOPED"), 0, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_GOLD_C_SCOPED"), 0, true)
		STATS.STAT_SET_INT(joaat(mpx .. "H4LOOT_PAINT_SCOPED"), -1, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4_MISSIONS"), 65535, true)
                STATS.STAT_SET_INT(joaat(mpx .. "H4_PLAYTHROUGH_STATUS"), 32, true)
                
                --
                
end)

CayoH:add_sameline()

CayoH:add_button("Setup Hard", function()
    PlayerIndex = globals.get_int(1574918)
    if PlayerIndex == 0 then
        mpx = "MP0_"
    else
        mpx = "MP1_"
    end
        STATS.STAT_SET_INT(joaat(mpx .. "H4_PROGRESS"), 131055, true)
                
                --
                
end)

CayoH:add_sameline()

CayoH:add_button("Setup Normal", function()
    PlayerIndex = globals.get_int(1574918)
    if PlayerIndex == 0 then
        mpx = "MP0_"
    else
        mpx = "MP1_"
    end
        STATS.STAT_SET_INT(joaat(mpx .. "H4_PROGRESS"), 126823, true)
                
                --
                
end)

--



CayoH:add_button("Reset", function()
    PlayerIndex = globals.get_int(1574918)
    if PlayerIndex == 0 then
        mpx = "MP0_"
    else
        mpx = "MP1_"
    end
         STATS.STAT_SET_INT(joaat(mpx .. "H4_MISSIONS"), 0, true)
         STATS.STAT_SET_INT(joaat(mpx .. "H4_PROGRESS"), 0, true)
         STATS.STAT_SET_INT(joaat(mpx .. "H4_PLAYTHROUGH_STATUS"), 0, true)
         STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_APPROACH"), 0, true)
         STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_BS_ENTR"), 0, true)
         STATS.STAT_SET_INT(joaat(mpx .. "H4CNF_BS_GEN"), 0, true)       
end)
--

CayoH:add_separator()

CayoH:add_button("remove all cameras", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        for __, cam in pairs(CamList) do
            if ENTITY.GET_ENTITY_MODEL(ent) == cam then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent,true,true) --不执行这个下面会删除失败 @nord123#9579
                ENTITY.DELETE_ENTITY(ent)               
            end
        end
    end
end)
CamList = {   --从heist control抄的
    joaat("prop_cctv_cam_01a"),
    joaat("prop_cctv_cam_01b"),
    joaat("prop_cctv_cam_02a"),
    joaat("prop_cctv_cam_03a"),
    joaat("prop_cctv_cam_04a"),
    joaat("prop_cctv_cam_04c"),
    joaat("prop_cctv_cam_05a"),
    joaat("prop_cctv_cam_06a"),
    joaat("prop_cctv_cam_07a"),
    joaat("prop_cs_cctv"),
    joaat("p_cctv_s"),
    joaat("hei_prop_bank_cctv_01"),
    joaat("hei_prop_bank_cctv_02"),
    joaat("ch_prop_ch_cctv_cam_02a"),
    joaat("xm_prop_x17_server_farm_cctv_01"),
}

CayoH:add_sameline()

CayoH:add_button("Removed Perico hoplites", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if ENTITY.GET_ENTITY_MODEL(ent) == 193469166 then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent,true,true)
            ENTITY.DELETE_ENTITY(ent)
        end
    end
end)

--

CayoH:add_separator()

CayoH:add_button("TP at the entrance", function()
            PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 5048.157, -5821.616, -12.726)
        end)

CayoH:add_sameline()

CayoH:add_button("TP in storage", function()
            PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 5007.505, -5755.067, 15.484)
        end)

CayoH:add_sameline()

CayoH:add_button("TP on the way out", function()
            PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 4990.359, -5717.899, 19.880)
        end)

CayoH:add_sameline()

CayoH:add_button("TP on the sea", function()
            PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 4200.177, -5625.261, -2.69)
        end)
--







---------------
FleecaH = AlmenuH:add_tab("Fleeca Heist")

FleecaH:add_button("Skip Prep", function()
	PlayerIndex = globals.get_int(1574907)
	if PlayerIndex == 0 then
		mpx = "MP0_"
	else
		mpx = "MP1_"
	end
		STATS.STAT_SET_INT(joaat(mpx .. "HEIST_PLANNING_STAGE"), -1, true)
end)

FleecaH:add_sameline()

FleecaH:add_button("Reset Prep", function()
	PlayerIndex = globals.get_int(1574907)
	if PlayerIndex == 0 then
		mpx = "MP0_"
	else
		mpx = "MP1_"
	end
		STATS.STAT_SET_INT(joaat(mpx .. "HEIST_PLANNING_STAGE"), 0, true)
end)
---------------


---------------






----------------------------------------------------------------


AlmenuF:add_text("Works properly in session by invitations. in an open session does not work well")


AlmenuF:add_button("Show master control computer", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("apparcadebusinesshub")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("apparcadebusinesshub")
        else
                gui.show_message("Don't forget to register as CEO/Leader")
                run_script("apparcadebusinesshub")
        end
    end
end)






AlmenuF:add_button("Show Nightclub computer", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("appbusinesshub")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("appbusinesshub")
        else
                gui.show_message("Don't forget to register as CEO/Leader")
                run_script("appbusinesshub")
        end
    end
end)

AlmenuF:add_button("Show office computer", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("appfixersecurity")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            globals.set_int(1895156+playerIndex*609+10+429+1,0)
            gui.show_message("prompt","Converted to CEO")
            run_script("appfixersecurity")
            else
            gui.show_message("Don't forget to register as CEO/Leader","It may also be a script detection error, known problem, no feedback required")
            run_script("appfixersecurity")
        end
    end
end)

AlmenuF:add_button("show bunker computer", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("appbunkerbusiness")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("appbunkerbusiness")
            else
                gui.show_message("Don't forget to register as CEO/Leader","It may also be a script detection error, known problem, no feedback required")
                run_script("appbunkerbusiness")
            end
    end
end)

AlmenuF:add_button("show hangar computer", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("appsmuggler")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("appsmuggler")
            else
                gui.show_message("Don't forget to register as CEO/Leader","It may also be a script detection error, known problem, no feedback required")
                run_script("appsmuggler")
            end
    end
end)

AlmenuF:add_button("Show the Terrorist Dashboard", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("apphackertruck")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("apphackertruck")
        else
            gui.show_message("Don't forget to register as CEO/Leader","It may also be a script detection error, known problem, no feedback required")
            run_script("apphackertruck")
        end
    end
end)

AlmenuF:add_button("Show Avengers panel", function()
    local playerIndex = globals.get_int(1574918)
    if globals.get_int(1895156+playerIndex*609+10+429+1) == 0 then
        run_script("appAvengerOperations")
    else
        if globals.get_int(1895156+playerIndex*609+10+429+1) == 1 then
            run_script("appAvengerOperations")
        else
            gui.show_message("Don't forget to register as CEO/Leader","It may also be a script detection error, known problem, no feedback required")
            run_script("appAvengerOperations")
        end
    end
end)









AlmenuM:add_text("Here are the best and safest ways to cheat money in GTA 5 online.")
AlmenuM:add_text("BUT DO NOT GET A LOT OF MONEY, AND USE THE ''STAT EDITOR'' SECTION FOR ACCOUNT SAFETY!!!")
AlmenuM:add_text("Make money in moderation!")
ult = AlmenuM:add_tab("CEO")

Howtou = ult:add_tab("How to use CEO")

Howtou:add_text("How the buy Mission:") 
Howtou:add_text("1)Click ''Enable YimCeo''")
Howtou:add_text("2) Click ''Show computer'' and select ''CEO''")
Howtou:add_text("3) select ur warhouse and start the 1 Crate Mission for 2k$")
Howtou:add_text("4) wait 1 second -> now your warehouse is full.")
Howtou:add_text("5)Clear statistics by selecting ''STAT EDITOR''")

Howtou:add_separator()

Howtou:add_text("How to get money")
Howtou:add_text("1)Click ''Enable YimCeo''")
Howtou:add_text("2)Select the required amount of funds (from 10k to 6m)")
Howtou:add_text("3)Click ''Show computer'' and select ''CEO'', click ''Sell Cargo'' and wait")
Howtou:add_text("4)Clear statistics by selecting ''STAT EDITOR''")





cratevalue = 0
ult:add_imgui(function()
    cratevalue, used = ImGui.DragInt("Crate Value", cratevalue, 10000, 0, 6000000)
    if used then
        globals.set_int(262145+15991, cratevalue)
    end
end)
checkbox = ult:add_checkbox("Enable YimCeo")
ult:add_button("Show computer", function() SCRIPT.REQUEST_SCRIPT("apparcadebusinesshub") SYSTEM.START_NEW_SCRIPT("apparcadebusinesshub", 8344) end)
script.register_looped("yimceoloop", function (script)
    cratevalue = globals.get_int(262145+15991)
    globals.set_int(262145+15756, 0)
    globals.set_int(262145+15757, 0)
    script:yield()

    if checkbox:is_enabled() == true then
        if locals.get_int("gb_contraband_sell", 2) == 1 then
            locals.set_int("gb_contraband_sell", 543+595, 1)
            locals.set_int("gb_contraband_sell", 543+55, 0)
            locals.set_int("gb_contraband_sell", 543+584, 0) 
            locals.set_int("gb_contraband_sell", 543+7, 7)
            script:sleep(500)
            locals.set_int("gb_contraband_sell", 543+1, 99999)  
        end
        if locals.get_int("appsecuroserv", 2) == 1 then
            script:sleep(500)
            locals.set_int("appsecuroserv", 740, 1)
            script:sleep(200)
            locals.set_int("appsecuroserv", 739, 1)
            script:sleep(200)
            locals.set_int("appsecuroserv", 558, 3012)
            script:sleep(1000)
        end
        if locals.get_int("gb_contraband_buy", 2) == 1 then
            locals.set_int("gb_contraband_buy", 601+5, 1)
            locals.set_int("gb_contraband_buy", 601+1, 111)
            locals.set_int("gb_contraband_buy", 601+191, 6)
            locals.set_int("gb_contraband_buy", 601+192, 4)
            gui.show_message("Ur Warehouse is now full!")
        end
        if locals.get_int("gb_contraband_sell", 2) ~= 1 then  
            script:sleep(500)
            if locals.get_int("am_mp_warehouse", 2) == 1 then
                SCRIPT.REQUEST_SCRIPT("appsecuroserv")
                SYSTEM.START_NEW_SCRIPT("appsecuroserv", 8344)
                SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED("appsecuroserv")
            end
        end
    end
    script:sleep(500)
end)

--


Casino = AlmenuM:add_tab("Casino")


Casino:add_text("Chips can be bought")

Casino:add_button("Chips set to 1000000000", function()
    script.run_in_fiber(function (script)
        STATS.STAT_SET_INT(joaat("MPPLY_CASINO_CHIPS_PUR_GD"), -1000000000, true)
    end)
end)

Casino:add_button("Chips reset to 0", function()
    script.run_in_fiber(function (script)
        STATS.STAT_SET_INT(joaat("MPPLY_CASINO_CHIPS_PUR_GD"), 0, true)
    end)
end)






AlmenuS = Almenu:add_tab("Stat Editor")

AlmenuS:add_text("Use ''Reset 1'' player or ''Reset 2 player'' and change session and exit the game to apply changes")

AlmenuS:add_separator()

AlmenuS:add_button("Reset 1 player", function()
    gui.show_message("Player 1 Stats Reset","Change session to apply changes")
    script.run_in_fiber(function (script)
        STATS.STAT_SET_INT(joaat("MPPLY_TOTAL_EVC"), 0, true)
        STATS.STAT_SET_INT(joaat("MPPLY_TOTAL_SVC"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_BETTING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_JOBS"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_SHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_SHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_JOBSHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_SELLING_VEH"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_WEAPON_ARMOR"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_VEH_MAINTENANCE"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_STYLE_ENT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_PROPERTY_UTIL"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_JOB_ACTIVITY"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_BETTING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_VEHICLE_EXPORT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_SPENT_VEHICLE_EXPORT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_MONEY_EARN_CLUB_DANCING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_CHIPS_WON_GD"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_CHIPS_WONTIM"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_GMBLNG_GD"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_BAN_TIME"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_CHIPS_PURTIM"), 0, true)
        STATS.STAT_SET_INT(joaat("MP0_CASINO_CHIPS_PUR_GD"), 0, true)
	end)
end)







AlmenuS:add_button("Reset 2 player", function()
    gui.show_message("Player 2 Stats Reset","Change session to apply changes")
    script.run_in_fiber(function (script)
        STATS.STAT_SET_INT(joaat("MPPLY_TOTAL_EVC"), 0, true)
        STATS.STAT_SET_INT(joaat("MPPLY_TOTAL_SVC"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_BETTING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_JOBS"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_SHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_SHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_JOBSHARED"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_SELLING_VEH"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_WEAPON_ARMOR"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_VEH_MAINTENANCE"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_STYLE_ENT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_PROPERTY_UTIL"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_JOB_ACTIVITY"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_BETTING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_VEHICLE_EXPORT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_SPENT_VEHICLE_EXPORT"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_MONEY_EARN_CLUB_DANCING"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_CHIPS_WON_GD"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_CHIPS_WONTIM"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_GMBLNG_GD"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_BAN_TIME"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_CHIPS_PURTIM"), 0, true)
        STATS.STAT_SET_INT(joaat("MP1_CASINO_CHIPS_PUR_GD"), 0, true)
	end)
end)

AlmenuCredits = Almenu:add_tab("Credits")

Yimura = AlmenuCredits:add_tab("Yimura")
Yimura:add_text("Yim Menu Cheat creator")
Yimura:add_text("Cheat on GitHub:")
Yimura:add_text("https://github.com/YimMenu/YimMenu")

Alestarov = AlmenuCredits:add_tab("Alestarov")
Alestarov:add_text("compiled a script")
Alestarov:add_text("Profile on GitHub:")
Alestarov:add_text("https://github.com/Alestarov")

schlda = AlmenuCredits:add_tab("sch-lda")
schlda:add_text("allowed to use the code from his script ''SCH-LUA-YIMMENU.lua''")
schlda:add_text("The code from the script ''SCH-LUA-YIMMENU.lua'' was implemented")
schlda:add_text("Script on GitHub:")
schlda:add_text("https://github.com/sch-lda/SCH-LUA-YIMMENU")

xiaoxiao921 = AlmenuCredits:add_tab("xiaoxiao921")
xiaoxiao921:add_text("Helped with writing code")
xiaoxiao921:add_text("Profile on GitHub:")
xiaoxiao921:add_text("https://github.com/xiaoxiao921")

SLON = AlmenuCredits:add_tab("SLON")
SLON:add_text("The code from the script ''YimCeo v0.5 by Slon.lua'' was implemented")
SLON:add_text("Script on unknowncheats.me:")
SLON:add_text("https://www.unknowncheats.me/forum/grand-theft-auto-v/591335-yimceo-ceo-crates-method-yimmenu.html")
