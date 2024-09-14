local P_VarGroupString = "Inventory001" -- None Default
local Start_Items = {{4124,1},{4165,3},{4132,5},{4121,1000}}
local Exist_Items = {4169,4170,4171,4172,4173,4174,4175,4176,4177} -- Items Not Cloud
local SIFOP = {} -- Special_Items_For_Only_Player
local Load_ITEM = 9999
local BAR_ID = {
    ["1000"] = 1, ["1001"] = 2, ["1002"] = 3, ["1003"] = 4, ["1004"] = 5, ["1005"] = 6, ["1006"] = 7, ["1007"] = 8,
    ["0"] = 9, ["1"] = 10, ["2"] = 11, ["3"] = 12, ["4"] = 13, ["5"] = 14, ["6"] = 15, ["7"] = 16, ["8"] = 17, ["9"] = 18,
    ["10"] = 19, ["11"] = 20, ["12"] = 21, ["13"] = 22, ["14"] = 23, ["15"] = 24, ["16"] = 25, ["17"] = 26, ["18"] = 27, ["19"] = 28,
    ["20"] = 29, ["21"] = 30, ["22"] = 31, ["23"] = 32, ["24"] = 33, ["25"] = 34, ["26"] = 35, ["27"] = 36, ["28"] = 37, ["29"] = 38,
    ["8000"] = 39, ["8001"] = 40, ["8002"] = 41, ["8003"] = 42, ["8004"] = 43
}

local BAR_ID_ITX = {
    [1] = "1000", [2] = "1001", [3] = "1002", [4] = "1003", [5] = "1004", [6] = "1005", [7] = "1006", [8] = "1007",
    [9] = "0", [10] = "1", [11] = "2", [12] = "3", [13] = "4", [14] = "5", [15] = "6", [16] = "7", [17] = "8", [18] = "9",
    [19] = "10", [20] = "11", [21] = "12", [22] = "13", [23] = "14", [24] = "15", [25] = "16", [26] = "17", [27] = "18", [28] = "19",
    [29] = "20", [30] = "21", [31] = "22", [32] = "23", [33] = "24", [34] = "25", [35] = "26", [36] = "27", [37] = "28", [38] = "29",
    [39] = "8000", [40] = "8001", [41] = "8002", [42] = "8003", [43] = "8004"
}

--SIFOP["1117082357"] = {{4191,1},{4192,1},{4159,1},{4130,5},{4228,1},{4230,1}}
--SIFOP["1273179897"] = {{4122,1},{4123,1},{4159,1},{4130,5},{4228,1},{4230,1}}
--SIFOP["1109822807"] = {{4189,1},{4190,1},{4159,1},{4130,10},{4228,1},{4230,1}}
--SIFOP["1002203008"] = {{4191,1},{4192,1},{4159,1},{4130,5},{4228,1},{4230,1}}
-------------------------------------------------------------------------------
local function Split(msg, delimiter) -- Split Text to Table
    result_spl = {}
    for match in (msg .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result_spl, match)
    end
    return result_spl
end

local function range(start, ende)
    local result = {}
    local i = start
    local ix = 1
    while i < ende+1 do
        result[ix] = i
        i=i+1
        ix=ix+1
    end
    return result
end

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
    
--[[local function getLangCode(playerID) -- Get lang Code
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
end]]--

--local function getItemsData()

local function alive(uid)
    local result,x,y,z=Actor:getPosition(uid)
    if(result == 0) then
        return true
    else
        return false
    end
end
-------------------------------------------------------------------------------
local Player_Run = {}

--local text_sorry = {["tha"] = "เนื่องจากปัญหาที่เกิดขึ้น เราขอมอบของแทนคุณเหล่านี้ให้กับท่าน กลุ่มผู้เล่นระดับ Top ",["tw"] = "由於出現的問題我們願意代表您贈送這些禮物給您。頂尖選手組",["en"] = "Due to the problems that occurred We would like to offer you these gifts on behalf of you. Top player group",["ita"] = "A causa dei problemi che si sono verificati Vorremmo offrirti questi doni a nome tuo. Gruppo di giocatori di punta",["tur"] = "Yaşanan sorunlar nedeniyle Bu hediyeleri sizin adınıza size sunmak istiyoruz. En iyi oyuncu grubu",["ger"] = "Aufgrund der aufgetretenen Probleme Diese Geschenke möchten wir Ihnen in Ihrem Namen anbieten. Top-Spielergruppe",["cn"] = "由于出现的问题我们愿意代表您向您赠送这些礼物。顶尖选手组",["jpn"] = "発生した問題により私たちはあなたに代わってこれらの贈り物を提供したいと思います。トッププレイヤーグループ",["ptb"] = "Devido aos problemas ocorridos Gostaríamos de lhe oferecer esses presentes em seu nome. Grupo de melhores jogadores",["esn"] = "Debido a los problemas ocurridos Nos gustaría ofrecerle estos obsequios en su nombre. Grupo de mejores jugadores",["ind"] = "Karena permasalahan yang terjadi Kami ingin menawarkan hadiah ini atas nama Anda. Grup pemain top",["vie"] = "Do những vấn đề xảy ra Chúng tôi xin thay mặt bạn tặng bạn những món quà này. Nhóm người chơi hàng đầu",["msa"] = "Disebabkan masalah yang berlaku Kami ingin menawarkan hadiah ini bagi pihak anda. Kumpulan pemain teratas",["rus"] = "В связи с возникшими проблемами Мы хотели бы предложить вам эти подарки от вашего имени. Группа лучших игроков",["fra"] = "En raison des problèmes survenus Nous aimerions vous offrir ces cadeaux en votre nom. Groupe de meilleurs joueurs",["kor"] = "발생한 문제로 인해 우리는 당신을 대신하여 이러한 선물을 제공하고 싶습니다. 최고 플레이어 그룹",["ara"] = "بسبب المشاكل التي حدثت ونود أن نقدم لك هذه الهدايا نيابة عنك. أفضل مجموعة من اللاعبين",}
--local function Special_Items(uid) 
--    if(SIFOP[tostring(uid)] ~= nil) then -- Special Run
--        for i,v in ipairs(SIFOP[tostring(uid)]) do
--             Player:gainItems(uid,v[1],v[2],1)
----        end
--        Customui:setText(uid, [[7347976277455562624]], [[7347976277455562624_583]], text_sorry[getLangCode(uid)])
--        Customui:showElement(uid, [[7347976277455562624]], [[7347976277455562624_578]])
--    end
--    Refresh_Inventory(uid)
--    Player_Run[tostring(uid)] = "Start"
--    print(uid..": Start Inventory")
--end

local function Save_Cloud_Datas(uid,itx)
    local code = Valuegroup:setValueNoByName(18, P_VarGroupString, 1, "Old", uid)
    local result1,itemid,num=Backpack:getGridItemID(uid,itx)
    local result2,durcur,durmax=Backpack:getGridDurability(uid,itx)
    local itemid = itemid or 0
    local num = num or 0
    local durcur = durcur or -1
    if(inTable(Exist_Items, itemid) == false) then
        local text_data = tostring(itx.."^"..itemid.."^"..num.."^"..durcur)
        Valuegroup:setValueNoByName(18, P_VarGroupString, BAR_ID[tostring(itx)]+1, text_data, uid)
        --Chat:sendSystemMsg(tostring(itemid.."^"..num), 1002203008)
    end
end

local function GetInventoryAndSetItems(uid)
    Backpack:clearAllPack(uid)
    local code, inventory = Valuegroup:getAllGroupItem(18, P_VarGroupString, uid)
    if(#inventory == 0 and inventory[1] ~= "Old") then
        local code = Valuegroup:clearGroupByName(18, P_VarGroupString, uid)
        Player_Run[tostring(uid)] = "Start"
        local code = Valuegroup:setValueNoByName(18, P_VarGroupString, 1, "Old", uid)
        for i,v in ipairs(range(1, 43)) do
            local code = Valuegroup:setValueNoByName(18, P_VarGroupString, tonumber(v)+1, tostring(BAR_ID_ITX[v]).."^".."0".."^".."0".."^".."-1", uid)
        end
        for i,v in ipairs(Start_Items) do
            Player:gainItems(uid,v[1],v[2],1)
        end
        --Special_Items(uid)
    elseif(inventory[1] == "Old") then
        local code = Valuegroup:clearGroupByName(18, P_VarGroupString, uid)
        local code = Valuegroup:setValueNoByName(18, P_VarGroupString, 1, "Old", uid)
        for i,v in ipairs(range(1, 43)) do
            local code = Valuegroup:setValueNoByName(18, P_VarGroupString, tonumber(v)+1, tostring(BAR_ID_ITX[v]).."^".."0".."^".."0".."^".."-1", uid)
        end
        Player_Run[tostring(uid)] = "Start"
        for i,v in ipairs(inventory) do
            if(v ~= "Old") then
                local Datas = Split(v, "^")   --- Items --> barid,itemid,itemnum,dubility
                local barid,itemid,itemnum,dubility = tonumber(Datas[1]),tonumber(Datas[2]),tonumber(Datas[3]),tonumber(Datas[4])
                if(dubility <= 0) then
                    Backpack:setGridItem(uid,barid,itemid,itemnum,nil)
                elseif(dubility > 0) then
                    Backpack:setGridItem(uid,barid,itemid,itemnum,dubility)
                end
            end
        end
        for i,v in ipairs(range(8000, 8004)) do
            Save_Cloud_Datas(uid,v)
        end
        print(uid..": Load Inventory".." Items: "..#inventory)
    end
end
-------------------------------------------------------------------------------
local function Run_Player(ppa)
    local uid = ppa.eventobjid
    if(Player_Run[tostring(uid)] == nil and ppa.itemid == Load_ITEM) then
        Player_Run[tostring(uid)] = "Loading"
        local result2=Player:checkActionAttrState(uid,2048)
        Player:setActionAttrState(uid,2048,false)
        threadpool:wait(4)
        Player:removeBackpackItem(uid,Load_ITEM,99)
        Player_Run[tostring(uid)] = "Pre_Start"
        GetInventoryAndSetItems(uid)
        threadpool:wait(2)
        if result2==0 then
	        Player:setActionAttrState(uid,2048,true)
        else
        	Player:setActionAttrState(uid,2048,false)
        end 
    elseif(Player_Run[tostring(uid)] == "Start" and ppa.itemid == Load_ITEM) then
        Player:removeBackpackItem(uid,Load_ITEM,99)
    end
end
ScriptSupportEvent:registerEvent([=[Player.AddItem]=], Run_Player)

local function Give_run_Player(ppa)
    Backpack:clearAllPack(ppa.eventobjid)
    for i,v in pairs(range(1, 38)) do
        Player:gainItems(ppa.eventobjid,Load_ITEM,1,1)
    end
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], Give_run_Player)

local function Despawn(ppa)
    if(ppa.itemid == Load_ITEM) then
        Player:gainItems(ppa.eventobjid,Load_ITEM,1,1)
        World:despawnItemByObjid(ppa.toobjid)
    end
end
ScriptSupportEvent:registerEvent([=[Player.DiscardItem]=], Despawn)

local function Out_Player(ppa)
    local uid = ppa.eventobjid
    Player_Run[tostring(uid)] = nil
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], Out_Player)

local function Inventory_Changed(ppa)
    local uid = ppa.eventobjid
    if(Player_Run[tostring(uid)] == "Start") then
        threadpool:wait(0.0001)
        Save_Cloud_Datas(uid,ppa.itemix)
    end
end
ScriptSupportEvent:registerEvent([=[Player.BackPackChange]=], Inventory_Changed)
ScriptSupportEvent:registerEvent([=[Player.EquipChange]=], Inventory_Changed)
ScriptSupportEvent:registerEvent([=[Player.ShortcutChange]=], Inventory_Changed)

local function Armor_Changed(ppa)
    local uid = ppa.eventobjid
    if(Player_Run[tostring(uid)] == "Start") then
        threadpool:wait(0.0001)
        for i,v in ipairs(range(8000, 8004)) do
            Save_Cloud_Datas(uid,v)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.BeHurt]=], Armor_Changed)

local table_of_drops = {} -- [dropsid] = {uid,}

local function Fixed_Bug(fb)
    local itemdrop = fb.toobjid
    if(itemdrop >= 999999999) then
        threadpool:wait(1)
        if(alive(fb.eventobjid) == false) then
            World:despawnItemByObjid(itemdrop)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.DiscardItem]=], Fixed_Bug)












