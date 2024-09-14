local data = {} -- data["id_missile"] = {damage=100, range=100}
local mode = {}
------ Mode NOT EDIT ------
mode[1] = {playeratk=true, owneratk=true, monsteratk=true} -- All damage + owner damage
mode[2] = {playeratk=false, owneratk=false, monsteratk=true} -- Creature damage only
mode[3] = {playeratk=true, owneratk=false, monsteratk=false} -- Player damage but owner not damage
mode[4] = {playeratk=true, owneratk=true, monsteratk=false} -- Player damage + owner damage
mode[5] = {playeratk=true, owneratk=false, monsteratk=true} -- Creature&Player damage but owner not damage
------ AMMO EDIT ------
-- data["Ammo_ID"] = {damage=XXX, range=X, sound=XXXXXX, effect={Effect_ID,Size}, mode=mode[X]}
data["9999"] = {damage=999, range=3, sound=10660, effect={1334,4}, mode=mode[1]}



--------------------------------------------------------------------
local function getpos_area_new(center, width, height)
    local x, y, z = center[1], center[2], center[3]
    local corner1 = {x+width, y-height, z-width}
    local corner2 = {x-width, y+height, z+width}
    return corner1, corner2
end
--------------------------------------------------------------------
local player_shoot = {} -- [uid_ammo_create] = uid_player
local function setuid(at)
    local itemid = at.itemid
    if data[tostring(itemid)] ~= nil then
        local id = at.toobjid or 0
        if(id == at.toobjid) then
            player_shoot[tostring(at.toobjid)] = at.eventobjid
        elseif(id == 0) then
            player_shoot[tostring(at.toobjid)] = 1000
        end
        
    end
end
ScriptSupportEvent:registerEvent([=[Missile.Create]=], setuid)

local function missile_bomb(at)
    local itemid = at.itemid
    if data[tostring(itemid)] ~= nil then
        --Chat:sendSystemMsg(tostring(at.eventobjid), 10022003008)
        local pos1, pos2 = getpos_area_new({math.floor(at.x), math.floor(at.y), math.floor(at.z)}, data[tostring(itemid)].range, data[tostring(itemid)].range)
        local result,areaid=Area:createAreaRectByRange({x=pos1[1],y=pos1[2],z=pos1[3]},{x=pos2[1],y=pos2[2],z=pos2[3]})
        local objinarea = {}
        local result,playerlist=Area:getAreaPlayers(areaid)
        local result,creaturelist=Area:getAreaCreatures(areaid)
        for i,v in pairs(creaturelist) do table.insert(objinarea, tonumber(v)) end
        for i,v in pairs(playerlist) do table.insert(objinarea, tonumber(v)) end
        local uin = player_shoot[tostring(at.eventobjid)]    --Player:getHostUin()
        local result, bool=Actor:getActionAttrState(uin,32)
        World:playSoundEffectOnPos({x=math.floor(at.x),y=math.floor(at.y),z=math.floor(at.z)},data[tostring(itemid)].sound,60,1,false)
        World:playParticalEffect(math.floor(at.x), math.floor(at.y), math.floor(at.z),data[tostring(itemid)].effect[1],data[tostring(itemid)].effect[2])
        if #objinarea>0 and bool==true then
	        for i,a in ipairs(objinarea) do
	            local result3,objtype=Actor:getObjType(a)
	            if(data[tostring(itemid)]["mode"]["monsteratk"] == true and objtype == 2) then
	                Actor:playerHurt(uin, a, data[tostring(itemid)].damage, 0)
	            end
	            if(objtype == 1) then
	                if(data[tostring(itemid)]["mode"]["owneratk"] == true and a == uin) then
	                    Actor:playerHurt(uin, a, data[tostring(itemid)].damage, 0)
	                elseif(a ~= uin and data[tostring(itemid)]["mode"]["playeratk"] == true) then
	                    Actor:playerHurt(uin, a, data[tostring(itemid)].damage, 0)
	                end
	            end
	        end
        end
        player_shoot[tostring(at.eventobjid)] = nil
        Area:destroyArea(areaid)
    end
end
ScriptSupportEvent:registerEvent([=[Actor.Projectile.Hit]=], missile_bomb)










