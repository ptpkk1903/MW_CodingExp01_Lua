function Split(msg, delimiter) -- Split Text to Table
    result_spl = {}
    for match in (msg .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result_spl, match)
    end
    return result_spl
end
---------------------------------------------------------------------------------------------------------------
function inTable(tablef, vcheck) -- Checked Items in Table
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
---------------------------------------------------------------------------------------------------------------
function shortnum(number) --10000,1000,100000,1000000 to 10k 1k 100k 1m
    local to_text = ""
    if(number > 1000) then
        convert = math.floor(number / 1000)
        to_text = (convert.."k")
    elseif(number > 1000000) then
        convert = math.floor(number / 1000000)
        to_text = (convert.."m")
    else
        to_text = (number)
    end    
    return to_text
end    
---------------------------------------------------------------------------------------------------------------
function clearTable(tableclear) -- Clear Table
    for key, value in pairs(tableclear) do
        tableclear[key] = nil
    end    
end   
---------------------------------------------------------------------------------------------------------------
function tabclone(tabtarget,tabfrom) -- Copy Table
    clearTable(tabtarget)
    for key, value in pairs(tabfrom) do
        tabtarget[key] = tabfrom[key]
    end
end
---------------------------------------------------------------------------------------------------------------
function checknumber(x) -- Checked number only
    if tonumber(x) ~= nil then
        return true
    end
    return false
end
---------------------------------------------------------------------------------------------------------------
local function getpostion(objid)  ---- get x,y,z postion
    local pos = {}
    local result,xp,yp,zp=Actor:getPosition(objid)
    if(result == 1001) then
        return {x=0,y=0,z=0}
    else
        return {x=math.floor(xp),y=math.floor(yp),z=math.floor(zp)}
    end
end
---------------------------------------------------------------------------------------------------------------
function chat(objid,msg)  ----Send msg to player
    Chat:sendSystemMsg(msg,objid)
end
---------------------------------------------------------------------------------------------------------------
function gototarget(bnum,afnum) ---- number +- to number
    if(bnum < afnum) then
		return bnum+1
    elseif(bnum > afnum) then
		return bnum-1
    elseif(bnum == afnum) then
		return bnum
    end
end
---------------------------------------------------------------------------------------------------------------
function in_range(targetnumber, var_number_check) ---- Checked number in range of number
    local satnumber, lasnumber = var_number_check
    if(satnumber <= lasnumber) then
        if(targetnumber >= satnumber and targetnumber <= lasnumber) then
            return true
        else
            return false
        end
    elseif(satnumber >= lasnumber) then
        if(targetnumber <= satnumber and targetnumber >= lasnumber) then
            return true
        else
            return false
        end
    end
end
---------------------------------------------------------------------------------------------------------------
function ctype_monster(uid,id_check)
    local result,actorid=Creature:getActorID(uid)
    if actorid == id_check then
        return true
    else
        return false
    end
end
---------------------------------------------------------------------------------------------------------------
local function getpos_area_new(center, width, height)
    local x, y, z = center[1], center[2], center[3]
    local corner1 = {x+width, y-height, z-width}
    local corner2 = {x-width, y+height, z+width}
    return corner1, corner2
end

---------------------------------------------------------------------------------------------------------------
local function table_equal(tbl1, tbl2)
  if #tbl1 ~= #tbl2 then
    return false
  end

  for i, v in ipairs(tbl1) do
    if v ~= tbl2[i] then
      return false
    end
  end

  return true
end

local function find_pos(value, tbl)
  for i, v in ipairs(tbl) do
    if table_equal(value, v) then
      return true
    end
  end
  return false
end

function generatePointsInCircle(center, radius) -- get pos around center getposaround({x,y,z}, 10)
    local points = {}
    for angle = 0, 360, 1 do
        local radian = math.rad(angle)
        local x = math.floor(center[1] + radius * math.cos(radian) + 0.5)
        local z = math.floor(center[3] + radius * math.sin(radian) + 0.5)
	if(find_pos({x, center[2], z}, points) == false) then
            table.insert(points, {x, center[2], z})
	end
    end
    return points
end
---------------------------------------------------------------------------------------------------------------
function calculatePoints(centerX, centerY, radius, numPoints)
    local points = {}

    for i = 1, numPoints do
        local angle = (i - 1) * (2 * math.pi) / numPoints
        local x = centerX + radius * math.cos(angle)
        local y = centerY + radius * math.sin(angle)

        table.insert(points, {math.floor(x),math.floor(y)})
    end

    return points
end

function cpos_in_area(targetpos, startpos, endpos)
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

function getDistance(point1, point2)
    local sum = 0
    for i = 1, 3 do
        sum = sum + math.abs(point2[i] - point1[i])
    end
    return sum
end

local function objgo(goal, uid, speed)
  local pos = {}
  local result,xp,yp,zp=Actor:getPosition(objid)
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

local function faceto(uid,pos)
    local x, y, z = pos[1], pos[2], pos[3]
    Creature:setAIActive(uid,false)
    Actor:tryMoveToPos(uid,x,y,z,0)
    Creature:setAIActive(uid,true)
end

-----------------------------------------------------------
function line_actortoactor(obj1,obj2,sizeline,colorline,idline,dir) -- line_actortoactor(obj1,obj2,0.5,0xFFFFFF,1,{x=0,y=0,z=0})
	local objid=obj1
	local size=sizeline
	local color=colorline
	local id=idline
	local info=Graphics:makeGraphicsLineToActor(objid, size, color, id)
	local objid2=obj2
	local dir={x=0,y=0,z=0}
	local offset=0
	local code, id = Graphics:createGraphicsLineByActorToActor(objid2, info, dir, offset)
	return id
end

function delete(obj2,typeid)
	local objid=obj2
	local itype=1
	local graphType=typeid
	return Graphics:removeGraphicsByObjID(objid, itype, graphType)
end

function searchInString(str, keyword)
    local start, _ = string.find(str, keyword)
    if start then
        return true
    else
        return false
    end
end


local function timetostring(seconds)
  local minutes = math.floor(seconds / 60)
  local remainingSeconds = seconds % 60
  return string.format("%dm%ds", minutes, remainingSeconds)
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
    while i < ende+1 do
        result[tostring(i)] = i
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

local function getitemnum(uid,itemid)
    local itemnum = 0
    local result,num1,arr1=Backpack:getItemNumByBackpackBar(uid,1,itemid)
    local result,num2,arr2=Backpack:getItemNumByBackpackBar(uid,2,itemid)
    return num1 + num2
end

local function get_midnight_timestamp()
    local current_date = os.date("*t")  -- รับวันที่ปัจจุบัน
    current_date.hour = 0  -- กำหนดชั่วโมงให้เป็น 0
    current_date.min = 0   -- กำหนดนาทีให้เป็น 0
    current_date.sec = 0   -- กำหนดวินาทีให้เป็น 0
    return os.time(current_date)  -- แปลงวันที่กลับเป็น timestamp
end

local function getposTopos(uid, endPos)
    local step = 20
    local result,x1,y1,z1=Actor:getPosition(uid)
    local startPos = {tonumber(x1), tonumber(y1), tonumber(z1)}
    local result = {}
    local diff = {
        x = endPos[1] - startPos[1],
        y = endPos[2] - startPos[2],
        z = endPos[3] - startPos[3]
    }
    local distance = math.sqrt(diff.x^2 + diff.y^2 + diff.z^2)
    local numSteps = math.floor((distance / step) + 0.5)
    local stepSize = 1 / numSteps

    for i = 0, numSteps do
        local x = startPos[1] + diff.x * (i * stepSize)
        local y = startPos[2] + diff.y * (i * stepSize)
        local z = startPos[3] + diff.z * (i * stepSize)
        table.insert(result, {tonumber(x), tonumber(y), tonumber(z)})
    end
    local result4,mode=Actor:getActionAttrState(uid,1)
    Actor:setActionAttrState(uid,1,false)
    for i,v in pairs(result) do
        threadpool:wait(0.3)
        Actor:setPosition(uid,v[1],v[2],v[3])
    end
    Actor:setActionAttrState(uid,1,mode)
    return result
end

local function cloudteleport(uid,x,y,z)
    local default = {5,9,-39} ---- ***Default Setting***  --จำเป็นต้องตั้งค่าตำแหน่งเกิดเริ่มต้น
    local result,mode=Actor:getActionAttrState(uid,1)
    Actor:setActionAttrState(uid,1,false)
    Player:setRevivePoint(uid,x,y,z)
    Actor:killSelf(uid)
    local pos = {x=99999,y=99999,z=99999}
    local i = 0
    repeat
        local result,xp,yp,zp=Actor:getPosition(uid)
        pos = {x=math.floor(xp) or 99999,y=math.floor(yp) or 99999,z=math.floor(zp) or 99999}
        threadpool:wait(1)
        i=i+1
        Actor:setActionAttrState(uid,1,false)
        if((pos.x-x) >= -1 and (pos.x-x) <= 2) then pos["x"] = true else pos["x"] = false end
        if((pos.y-y) >= -1 and (pos.y-y) <= 2) then pos["y"] = true else pos["y"] = false end
        if((pos.z-z) >= -1 and (pos.z-z) <= 2) then pos["z"] = true else pos["z"] = false end
    until((pos.x == true and pos.y == true and pos.z == true) or i > 100)
    Actor:setActionAttrState(uid,1,true)
    Player:setRevivePoint(uid,default[1],default[2],default[3])
end

local function GetdataStringData(string_data, key) --- "[HGH]value1[FGF]value2[JHK]value3[JHG]value3"
    local start_pos = string.find(string_data, "%["..key.."%]")
    if start_pos then
        local end_pos = string.find(string_data, "%[", start_pos + 1)
        if end_pos then
            local value = string.sub(string_data, start_pos + string.len("["..key.."]"), end_pos - 1)
            return value
        else
            local value = string.sub(string_data, start_pos + string.len("["..key.."]"))
            return value
        end
    else
        return nil
    end
end

function SetTableTenNumber(tbl)
    for i, num in ipairs(tbl) do
        local num_str = tostring(num)
        if string.len(num_str) < 10 then
            tbl[i] = tonumber("1" .. string.format("%09d", num))
        else
            tbl[i] = tonumber(num_str)
        end
    end
    return tbl
end


local function Send_Event(customevent)
    local data = {id = "",ops = ""}
    local ok, json = pcall(JSON.encode, JSON, data)
    Game:dispatchEvent(customevent,{customdata = json})
end

local function getLangCode(playerID)
    local lang = "en"
    local conf_langCodeToString = {"cn","en","tw", "tha","esn","ptb","fra","jpn","ara","kor","vie","rus","tur","ita","ger","ind", "msa"}
    if playerID ~= nil then
        playerID = tonumber(playerID)
        local ret, langCode, area = Player:GetLanguageAndRegion(playerID)
        if ret == 0 and nil ~= langCode then
            local resultLang = tonumber(langCode)
            if resultLang and resultLang >= 0 then
                langCode = resultLang < #conf_langCodeToString and conf_langCodeToString[resultLang + 1] or "en"
            else
                langCode = langCode or "en"
            end
            lang = langCode
        end
    end
    return lang
end

local function replace(find, replace, str)
    return (string.gsub(str, find, replace))
end

local function getValueData(data, key)
    for k, v in string.gmatch(data, "([^:]+)=([^:]+)") do
        if k == key then return v end
    end
    return nil
end

local function editValueData(data, key, value)
    local found = false
    local new_data = {}
    for k, v in string.gmatch(data, "([^:]+)=([^:]+)") do
        if k == key then
            table.insert(new_data, k .. "=" .. value)
            found = true
        else
            table.insert(new_data, k .. "=" .. v)
        end
    end
    if not found then table.insert(new_data, key .. "=" .. value) end
    return table.concat(new_data, ":")
end

local function getAllValueData(data)
    local result = {}
    for k, v in string.gmatch(data, "([^:]+)=([^:]+)") do
        result[k] = v
    end
    return result
end