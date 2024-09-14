local player_data = {}
local items = {}
------ Items Normal ------
items["4187"] = {name="4187", itemid=4187, num=2, color=0x43C3FF, percent=20}
items["4183"] = {name="4183", itemid=4183, num=2, color=0x43C3FF, percent=20}
items["4182"] = {name="4182", itemid=4182, num=2, color=0x43C3FF, percent=20}
items["4121"] = {name="4121", itemid=4121, num=1000, color=0x43C3FF, percent=30}
------ Items Rare ------
items["4110"] = {name="4110", itemid=4110, num=1, color=0xFCB435, percent=10}
items["4108"] = {name="4108", itemid=4108, num=1, color=0xFCB435, percent=10}
items["4158"] = {name="4158", itemid=4158, num=1, color=0xFCB435, percent=10}

items["4222"] = {name="4222", itemid=4222, num=1, color=0xFC5F35, percent=8}
items["4223"] = {name="4223", itemid=4223, num=1, color=0xFC5F35, percent=8}

------ Super Super Rare ------
items["4220"] = {name="4220", itemid=4220, num=1, color=0xF81A1A, percent=5}

local ui_data = {}
ui_data["interface"] = [[7347976277455562624]]
ui_data["Random_UI"] = [[7347976277455562624_535]]
ui_data["items_1_color"] = [[7347976277455562624_557]]
ui_data["items_2_color"] = [[7347976277455562624_560]]
ui_data["items_3_color"] = [[7347976277455562624_561]]
ui_data["items_4_color"] = [[7347976277455562624_559]]
ui_data["items_5_color"] = [[7347976277455562624_558]]
ui_data["items_1"] = [[7347976277455562624_568]]
ui_data["items_2"] = [[7347976277455562624_565]]
ui_data["items_3"] = [[7347976277455562624_564]]
ui_data["items_4"] = [[7347976277455562624_566]]
ui_data["items_5"] = [[7347976277455562624_567]]
ui_data["VingVing"] = [[7347976277455562624_569]]
----------------------------------------------------------------------------------------------
local item_randoms_cheange = {}
local function percent_has()
    if(#item_randoms_cheange == 0) then
    for i,v in pairs(items) do
        ic = 1
        while ic <= v["percent"] do
            table.insert(item_randoms_cheange, tonumber(i))
            ic = ic+1
        end
    end
    end
end
percent_has()

local function getitemnum(uid,itemid)
    local itemnum = 0
    local result,num1,arr1=Backpack:getItemNumByBackpackBar(uid,1,itemid)
    local result,num2,arr2=Backpack:getItemNumByBackpackBar(uid,2,itemid)
    return num1 + num2
end

local function randitems()
    return item_randoms_cheange[math.random(1,#item_randoms_cheange)]
end

local function refresh_image_items(uid)
    local uid = uid
    local i = 1
    while i <= 5 do
        local code, icon = Customui:getItemIcon(tonumber(player_data[tostring(uid)]["table1"][i]))
        Customui:setTexture(uid, ui_data["interface"], ui_data["items_"..tostring(i)], icon)
        Customui:setColor(uid, ui_data["interface"], ui_data["items_"..tostring(i).."_color"], items[tostring(player_data[tostring(uid)]["table1"][i])]["color"])
        i = i + 1
    end
end

local function RunUI(uid)
    local uid = uid
    player_data[tostring(uid)] = {timere=0,table1={}}
    player_data[tostring(uid)]["table1"] = {randitems(),randitems(),randitems(),randitems(),randitems()}
    refresh_image_items(uid)
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], RunUI)

-------------- Random ----------------
local function setitemsplayer(uid)
    player_data[tostring(uid)]["table1"][5] = player_data[tostring(uid)]["table1"][4]
    player_data[tostring(uid)]["table1"][4] = player_data[tostring(uid)]["table1"][3]
    player_data[tostring(uid)]["table1"][3] = player_data[tostring(uid)]["table1"][2]
    player_data[tostring(uid)]["table1"][2] = player_data[tostring(uid)]["table1"][1]
    player_data[tostring(uid)]["table1"][1] = randitems()
end
local function Random(uid)
    local uid = uid
    if(player_data[tostring(uid)]["timere"] == 0) then
        player_data[tostring(uid)]["timere"] = 1
        Customui:showElement(uid, ui_data["interface"], ui_data["Random_UI"])
        Customui:showElement(uid, ui_data["interface"], ui_data["Random_UI"])
        Player:playMusic(uid,10945,70,1,false)
        local round = 1
        repeat
        player_data[tostring(uid)]["i"] = 1
        local times = 80
        local ts = 0.05
        repeat
            threadpool:wait(ts*(20/100))
            setitemsplayer(uid)
            refresh_image_items(uid)
            Player:playMusic(uid,10952,50,1,false)
            player_data[tostring(uid)]["i"] = player_data[tostring(uid)]["i"] + 1
            ts = ts+(ts*(5/100))
            times = times-1
        until(times == 0)
        player_data[tostring(uid)]["i"] = 0
        Player:playMusic(uid,10947,50,1,false)
        local result,successNum=Backpack:addItem(uid,player_data[tostring(uid)]["table1"][3],items[tostring(player_data[tostring(uid)]["table1"][3])]["num"])
        Customui:showElement(uid, ui_data["interface"], ui_data["VingVing"])
        threadpool:wait(0.2)
        Customui:hideElement(uid, ui_data["interface"], ui_data["VingVing"])
        threadpool:wait(0.2)
        Customui:showElement(uid, ui_data["interface"], ui_data["VingVing"])
        threadpool:wait(0.2)
        Customui:hideElement(uid, ui_data["interface"], ui_data["VingVing"])
        threadpool:wait(0.2)
        Customui:showElement(uid, ui_data["interface"], ui_data["VingVing"])
        threadpool:wait(0.2)
        Customui:hideElement(uid, ui_data["interface"], ui_data["VingVing"])
        player_data[tostring(uid)]["timere"] = 0
        round = round-1
        until(round == 0)
        threadpool:wait(0.8)
        Customui:hideElement(uid, ui_data["interface"], ui_data["Random_UI"])
        Customui:hideElement(uid, ui_data["interface"], ui_data["Random_UI"])
    end
end

local function Run_Random(uid)
    RunUI(uid)
    Random(uid)
end
Run_Random(CurEventParam.TriggerByPlayer)
