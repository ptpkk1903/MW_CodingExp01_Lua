local admin = {1014793465,1002203008} -- uid
local player_entered = {} -- ["uid_player"] = เวลา // defalt เป็น 0
local player_closed = {} -- uid // เลย
local game_time = 0
local shop_bought = {} -- ["item_id_in_shop"] = 1 // 1 คือจำนวนที่ซื้อ
local start_room = os.date("%d/%m/%Y %H:%M")
local buycount = 0

-------------------------------------------------------------------------
local function inTable(tablef, vcheck) -- Checked Items in Table
    Checked_table = false
    Found_Status = false
    for key, value in pairs(tablef) do
        if(vcheck == value and Found_Status == false) then
            Checked_table = true
            Found_Status = true
        elseif(vcheck ~= value and Found_Status == true) then
        elseif(vcheck ~= value and Found_Status == false) then
            Checked_table = false
            Found_Status = false
        end    
    end    
    return Checked_table
end    

local function timetostring(seconds)
  local minutes = math.floor(seconds / 60)
  local remainingSeconds = seconds % 60
  return string.format("%dm%ds", math.floor(minutes), math.floor(remainingSeconds))
end

local function alive(uid)
    local result,x,y,z=Actor:getPosition(uid)
    if(result == 0) then
        return true
    else
        return false
    end
end

local function range(start, ende)
    local result = {}
    local i = start
    while i < (ende+1) do
        table.insert(result, i)
        i=i+1
    end
    return result
end

local function tablecount(tablee)
    local i = 0
    for id,v in pairs(tablee) do
        i=i+1
    end
    return i
end

local function average()
    local average_time = 0
    local count = 0
    for i,v in pairs(player_entered) do
        average_time = average_time+tonumber(v)
        count=count+1
    end
    local result = average_time/count
    return timetostring(result)
end
--------------------------------------------------------------------------------
local function stat_play(sts)
    local uid = sts.eventobjid
    if(sts.content == "/stat play") then
        if(inTable(admin, uid) == true) then
            for i,v in ipairs(range(1, 9)) do
                Chat:sendSystemMsg(" ")
            end
            Chat:sendSystemMsg("#Y---------------- Play Stat ----------------", uid)
            Chat:sendSystemMsg("#GRoom Start at: #B"..start_room, uid)
            Chat:sendSystemMsg("#GGameTime: #B"..timetostring(game_time), uid)
            local result,num=World:getPlayerTotal(-1)
            Chat:sendSystemMsg("#GPlayer InGame: #B"..num, uid)
            Chat:sendSystemMsg("#GPlayer EnterGame: #B"..tablecount(player_entered), uid)
            Chat:sendSystemMsg("#GPlayer LeaveGame: #B"..#player_closed, uid)
            Chat:sendSystemMsg("#GTime Average per player: #B"..average(), uid)
        else
            Chat:sendSystemMsg("#RYou not admin", uid)
        end
    elseif(sts.content == "/stat shop") then
        if(inTable(admin, uid) == true) then
            for i,v in ipairs(range(1, 9)) do
                Chat:sendSystemMsg(" ")
            end
            Chat:sendSystemMsg("#Y---------------- Shop Stat ----------------", uid)
            Chat:sendSystemMsg("#GBought Count: #B"..buycount, uid)
            Chat:sendSystemMsg("#Y{", uid)
            for i,v in pairs(shop_bought) do
                local result,name=Item:getItemName(tonumber(i))
                Chat:sendSystemMsg("#G      "..name..": ".."#B"..v, uid)
            end
            Chat:sendSystemMsg("#Y}", uid)
        else
            Chat:sendSystemMsg("#RYou not admin", uid)
        end
    elseif(sts.content == "/endgame") then
        if(inTable(admin, uid) == true) then
            Game:doGameEnd(nil)
        else
            Chat:sendSystemMsg("#RYou not admin", uid)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=], stat_play)








--------------------------------------------------------------------------------

local function player_enteredgame(plent)
    local uid = plent.eventobjid
    if(player_entered[tostring(uid)] == nil) then
        player_entered[tostring(uid)] = 0
    end
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], player_enteredgame)

local function player_outgame(plot)
    local uid = plot.eventobjid
    if(inTable(player_closed, uid) == false) then
        table.insert(player_closed, uid)
    end
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], player_outgame)

local timeup_rate = true
local function timeup()
    if(timeup_rate == true) then
        timeup_rate = false
        threadpool:wait(1)
        for i,v in pairs(player_entered) do
            if(alive(tonumber(i)) == true) then
                player_entered[i] = tonumber(player_entered[i])+1
            end
        end
        game_time = game_time+1
        timeup_rate = true
    end
end
ScriptSupportEvent:registerEvent([=[Game.RunTime]=], timeup)

local function pbuy(pb)
    local item = pb.itemid
    local uid = pb.eventobjid
    if(shop_bought[tostring(item)] ~= nil) then
        shop_bought[tostring(item)] = tonumber(shop_bought[tostring(item)])+1
        buycount=buycount+1
    else
        shop_bought[tostring(item)] = 1
        buycount=buycount+1
    end
end
ScriptSupportEvent:registerEvent([=[Developer.BuyItem]=], pbuy)

































