local boss_monsterid = 3
local range_trigger_block = 24


-------------------------------------------------------------------------------
local boss_id = 3586787849
-------------------------------Normal------------------------------------------
local function objgo(goal, uid, speed)
  local pos = {}
  local result,xp,yp,zp=Actor:getPosition(uid)
  if(result == 1001) then
      xp = goal[1]+5
      yp = goal[2]+5
      zp = goal[3]+5
  else
      xp = math.floor(xp)
      yp = math.floor(yp)
      zp = math.floor(zp)
  end
  local tolerance = 0.8
  Actor:setActionAttrState(uid,1,false)
  Actor:setActionAttrState(uid,64,false)
  Creature:setAIActive(uid,false)
  Actor:playAct(uid,15)
  local currentPosition = {x = xp, y = yp, z = zp}
  local goalPosition = {x = goal[1], y = goal[2], z = goal[3]}
  local get_status = {}
  get_status[1] = false
  get_status[2] = 0
  while math.abs(currentPosition.x - goalPosition.x) > tolerance or
        math.abs(currentPosition.y - goalPosition.y) > tolerance or
        math.abs(currentPosition.z - goalPosition.z) > tolerance do
    threadpool:wait(0.005)
    if get_status[1] == false and get_status[2] == 0 then
        result,data_get = Actor:getActionAttrState(uid,1)
        get_status[1] = data_get
        get_status[2] = result
        local direction = {
            x = goalPosition.x - currentPosition.x,
            y = goalPosition.y - currentPosition.y,
            z = goalPosition.z - currentPosition.z
        }
        local distance = math.sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z)

        local stepX = direction.x / distance * speed
        local stepY = direction.y / distance * speed
        local stepZ = direction.z / distance * speed

        currentPosition.x = currentPosition.x + stepX
        currentPosition.y = currentPosition.y + stepY
        currentPosition.z = currentPosition.z + stepZ
        Actor:setPosition(uid,currentPosition.x,currentPosition.y,currentPosition.z)
    else
        break
    end
 end
  Actor:setActionAttrState(uid,1,true)
  Creature:setAIActive(uid,true)
  Actor:setActionAttrState(uid,64,true)
  -- เมื่อถึงเป้าหมาย
end

local function getDistance(point1, point2)
    local sum = 0
    for i = 1, 3 do
        sum = sum + math.abs(point2[i] - point1[i])
    end
    return sum
end

local function cpos_in_area(targetpos, startpos, endpos)
    -- เช็คทุกมิติ (x, y, z)
    for i = 1, 3 do
        local min_val = math.min(startpos[i], endpos[i])
        local max_val = math.max(startpos[i], endpos[i])
        if targetpos[i] < min_val or targetpos[i] > max_val then
            return false
        end
    end
    return true
end

local function getpostion(objid)  ---- get x,y,z postion
    local pos = {}
    local result,xp,yp,zp=Actor:getPosition(objid)
    if(result == 1001) then
        return {0,0,0}
    else
        return {math.floor(xp),math.floor(yp),math.floor(zp)}
    end
end

local function ctype_monster(uid,id_check)
    local result,actorid=Creature:getActorID(uid)
    if actorid == id_check then
        return true
    else
        return false
    end
end

local function faceto(uid,pos)
    local x, y, z = pos[1], pos[2], pos[3]
    Creature:setAIActive(uid,false)
    Actor:tryMoveToPos(uid,x,y,z,0)
    Creature:setAIActive(uid,true)
end

local function getpos_area_new(center, width, height)
    local x, y, z = center[1], center[2], center[3]
    local corner1 = {x+width, y-height, z-width}
    local corner2 = {x-width, y+height, z+width}
    return corner1, corner2
end
----------------------------------Skill--------------------------------------
local function skill1(uid,pos,playerlist)
    local mons = {3407}
    local pos_p = {}
    World:playSoundEffectOnPos({x=pos[1],y=pos[2],z=pos[3]},10539,100,1,false)
    World:playParticalEffect(pos[1],pos[2],pos[3],1609,5)
    threadpool:wait(1)
    World:playParticalEffect(pos[1],pos[2],pos[3],1609,5)
    threadpool:wait(1)
    for i,v in ipairs(playerlist) do
        local position = getpostion(v)
        World:playParticalEffect(position[1],position[2],position[3],1505,1)
        World:playSoundEffectOnPos({x=position[1],y=position[2],z=position[3]},10811,50,1,false)
        pos_p[tostring(v)] = {position[1],position[2],position[3]}
        faceto(uid,position)
    end
    local i = 2
    while i > 0 do
        threadpool:wait(1)
        for i,v in ipairs(playerlist) do
            World:playParticalEffect(pos_p[tostring(v)][1],pos_p[tostring(v)][2],pos_p[tostring(v)][3],1505,1)
            World:playSoundEffectOnPos({x=pos_p[tostring(v)][1],y=pos_p[tostring(v)][2],z=pos_p[tostring(v)][3]},10811,50,1,false)
            faceto(uid,pos_p[tostring(v)])
        end
        i=i-1
    end
    threadpool:wait(1)
    Actor:playAct(uid,16)
    for i,v in ipairs(playerlist) do
        local result,objids=World:spawnCreature(pos_p[tostring(v)][1],pos_p[tostring(v)][2]+1,pos_p[tostring(v)][3],mons[math.random(1,#mons)],1)
        faceto(uid,pos_p[tostring(v)])
    end
end


----------------------------------System--------------------------------------
local function set_boss_spawn(ssp)
    if ctype_monster(ssp.eventobjid,boss_monsterid) == true then
        boss_id = ssp.eventobjid
    end
end
ScriptSupportEvent:registerEvent([=[Actor.Create]=], set_boss_spawn)

local function run_skill(pll) ------------- skill setting ------------
    local rate = math.random(1,100)
    local position = getpostion(boss_id)
    if(rate <= 10) then 
        skill1(boss_id,position,pll)
    elseif(rate <= 100) then
        skill1(boss_id,position,pll)
    end
end
-----------------------------------------------------------------------------
local checktime = true
local function startskill(rc)
    if checktime == true and boss_id ~= 3586787849 then
        checktime = false
        local pos_boss = getpostion(boss_id)
        local np1, np2 = getpos_area_new(pos_boss, range_trigger_block, range_trigger_block)
        local result,areaid=Area:createAreaRectByRange({x=np1[1],y=np1[2],z=np1[3]},{x=np2[1],y=np2[2],z=np2[3]})
        local result,playerlist=Area:getAreaPlayers(areaid)
        if #playerlist > 0 then
            Actor:setActionAttrState(boss_id,1,false)
            Creature:setAIActive(boss_id,false)
            run_skill(playerlist)
        end
        Area:destroyArea(areaid)
        threadpool:wait(5)
        Actor:setActionAttrState(boss_id,1,true)
        Creature:setAIActive(boss_id,true)
        checktime = true
    end
end
ScriptSupportEvent:registerEvent([=[Game.RunTime]=], startskill)


























