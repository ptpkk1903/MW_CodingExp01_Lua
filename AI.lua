------------------------------------------------❌❌❌❌   Template Function
local function tablecount(tablee)
    local i = 0
    for id,v in pairs(tablee) do
        i=i+1
    end
    return i
end

local function getpostion(objid)  ---- get x,y,z postion
    local pos = {}
    local result,xp,yp,zp=Actor:getPosition(objid)
    if(result == 1001) then
        return {x=99999,y=99999,z=99999}
    else
        return {math.floor(xp), math.floor(yp), math.floor(zp)}
    end
end

local function findNeareastPos(original_pos, pos_target_table, infinite_range)
    local nearest_key = nil
    local nearest_distance = math.huge
    local Result = {}
    for key, pos in pairs(pos_target_table) do
        local distance = math.sqrt((original_pos[1] - pos[1])^2 + (original_pos[2] - pos[2])^2 + (original_pos[3] - pos[3])^2)
        if distance < nearest_distance then
            if(distance <= infinite_range) then
                Result[key] = pos
            end
        end
    end
    --if nearest_distance <= infinite_range then
    --    return tonumber(nearest_key), pos_target_table[nearest_key]
    --else
        --return false
    --end
    return Result , tablecount(Result)
end

------------------------------------------------❌❌❌❌    Function Support
local function findNeareastPlayer(oid, range) -- Find Neareast Player //       return (uid, {x,y,z})      OR      false
    local oid_pos = getpostion(oid)
    local Players_Pos = {}
    local result,num,array=World:getAllPlayers(-1)
    for i,v in pairs(array) do
        Players_Pos[tostring(v)] = getpostion(v)
    end
    return findNeareastPos(oid_pos, Players_Pos, range)
end



------------------------------------------------❌❌❌❌    Start Function
local function RunFunction(RF)
    local uid = RF.eventobjid
    local pos = getpostion(uid)
    Creature:setAttr(uid,16,1)
end
ScriptSupportEvent:registerEvent([=[Actor.Create]=], RunFunction)

local function RefreshFunction(RF)
    local uid = RF.eventobjid
    if(RF.actorattr == 16)then
        local result,value=Creature:getAttr(RF.eventobjid,16)
        if(value == 1) then
            Creature:setAttr(RF.eventobjid,16,0)
        elseif(value == 0) then
            Creature:setAttr(RF.eventobjid,16,1)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Actor.ChangeAttr]=], RefreshFunction)
------------------------------------------------✅✅✅✅    AI System
local function MainRun(oid)
    local uid = oid.eventobjid
    if(oid.actorattr == 16)then
        --------------
        local player_list, num = findNeareastPlayer(uid, 5)
        Chat:sendSystemMsg(tostring(num))
    end
end
ScriptSupportEvent:registerEvent([=[Actor.ChangeAttr]=], MainRun)
