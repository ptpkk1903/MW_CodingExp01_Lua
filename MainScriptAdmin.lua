-- **จำกัดแอดมินแค่คนเดียว** --
password = 1952 --กำหนดรหัสผ่านแอดมินได้เลย

-- /lg {รหัสผ่าน} = ล้อกอินเพื่อใช้งานคำสั่งอื่นๆ
-- /give {ไอดีไอเทม} {จำนวนที่จะเสก} = เสกไอเทมเข้าตัวเอง   (แนะแนำ)
-- /tf {ลำดับตั้งต้น} = กำหนดลำดับตั้งต้นในการเรียกดูข้อมูลไอเทมทีละ 30  กด E ต่อไป กด Q กลับ (แนะแนำ)
-- /setfind {ลำดับตั้งต้น} = กำหนดลำดับตั้งต้นในการค้นหา ID ของไอเทม
-- /find {ชื่อไอเทมที่ชัดเจน} = เริ่มค้นหาข้อมูลตามชื่อไอเทม
-- /stopfind = หยุดการค้นหา
-- /getid = รับค่าไอดีของไอเทมในมือ (แนะแนำ)

----------------------Special Functions-----------------------
function Split(s, delimiter)
    result_spl = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result_spl, match)
    end
    return result_spl
end

function inTable(tablef, vcheck)
    Checked_table = "False"
    Found_Status = "False"
    for key, value in pairs(tablef) do
        if(vcheck == value and Found_Status == "False") then
            Checked_table = "True"
            Found_Status = "True"
        elseif(vcheck ~= value and Found_Status == "True") then    
            --Empty
        elseif(vcheck ~= value and Found_Status == "False") then
            Checked_table = "False"
            Found_Status = "False"
            --Chat:sendSystemMsg("#RNot Found #B"..vcheck.." #Y"..value,Admin)
        end    
    end    
    return Checked_table
end    

function shortnum(number)
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

function clearTable(tableclear)
    for key, value in pairs(tableclear) do
        tableclear[key] = nil
    end    
end   

function tabclone(tabtarget,tabfrom)
    for key, value in pairs(tabfrom) do
        tabtarget[key] = tabfrom[key]
    end
end

function checknumber(x)
    if tonumber(x) ~= nil then
        return true
    end
    return false
end
------------------------Global Variables----------------------------
Admin = 0  -- UID Admin
Search_Status = {0,1} -- {Status_Can_Find, Count_to_find}
Tf_count = 1 -- Count_to_tf
cmd_tr = {"/give","/tf","/setfind","/find","/stopfind","/getid"}

----------New---------
trigger_tf_run = 0
tf_back = {}
tf_now = {}
tf_next = {}
now_show = 1
dalay_tf_click = 0
------------------------Login Admin----------------------------
function Login(lg)
    local pass_simulate = Split(lg.content," ")
    if(pass_simulate[1] == "/lg") then
        if(Admin == 0 and lg.content == "/lg "..password) then
            Admin = lg.eventobjid
            Chat:sendSystemMsg("#GYou Login Successful: #B"..Admin,lg.eventobjid)
            Player:playMusic(lg.eventobjid,10948,100,1,false)
        elseif(Admin == lg.eventobjid and lg.content == "/lg "..password) then
            Chat:sendSystemMsg("#GYou are admin on this server.",lg.eventobjid)
        elseif(Admin == lg.eventobjid and pass_simulate[1] == "/lg" and pass_simulate[2] ~= password) then    
            Chat:sendSystemMsg("#GYou are admin on this server.",lg.eventobjid)
        else    
            Chat:sendSystemMsg("#RYou Login Error: #B"..lg.eventobjid,lg.eventobjid)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=],Login)
---------------------Command Script-----------------------------
function Command_Script(cm)
    local cmobjid = cm.eventobjid
    local cmct = cm.content
    local cmct_split = Split(cmct," ")
    
    if(string.sub(cmct,1,1) == "/") then
        if(cmobjid == Admin and inTable(cmd_tr, cmct_split[1]) == "True" and cmct_split[1] ~= "/lg") then
            if(cmct_split[1] == "/give") then
                --local result, AddITEMS=Backpack:addItem(cmobjid,cmct_split[2],cmct_split[3])
                Player:gainItems(cmobjid,cmct_split[2],cmct_split[3],1)
                local result, itemname_give = Item:getItemName(cmct_split[2])
                Player:playMusic(cmobjid,10947,100,1,false)
                Chat:sendSystemMsg("#GAdd Item:  #B"..itemname_give.."  #GCount:  #B"..cmct_split[3].."  #GSuccesful",cmobjid)
            elseif(cmct_split[1] == "/getid") then
                local result, id_getitem=Player:getCurToolID(unidg)
                Player:playMusic(cmobjid,10946,100,1,false)
                Chat:sendSystemMsg("#GThe ID of this item is: #B"..id_getitem,cmobjid)
            elseif(cmct_split[1] == "/setfind") then    
                Search_Status[2] = cmct_split[2]
                Chat:sendSystemMsg("#GSet value of starting find successful: #B"..Search_Status[2],cmobjid)
            elseif(cmct_split[1] == "/stopfind" and Search_Status[1] == 1) then    
                Search_Status[1] = 0
                Search_Status[2] = 1
                Chat:sendSystemMsg("#RStop Searching",cmobjid)
            elseif(cmct_split[1] == "/find" and Search_Status[1] == 0) then    
                Founded = "False"
                Search_Status[1] = 1
                repeat
                    threadpool:wait(0.05)
                    Run_round_five = 1
                    repeat
                        local result, itemname_find = Item:getItemName(Search_Status[2])
                        if(string.find(itemname_find, cmct_split[2]) ~= cmct_split[2] and Search_Status[1] == 1) then
                            Chat:sendSystemMsg("#GThe ID of #B"..Search_Status[2].." ".."["..itemname_find.."]".." #Gis #B"..cmct_split[2],cmobjid)
                            local result, AddITEMS_FIND=Backpack:addItem(cmobjid,Search_Status[2],1)
                            Player:playMusic(cmobjid,10947,100,1,false)
                            Search_Status[1] = 0
                            Search_Status[2] = 1
                            Founded = "True"
                        elseif(string.find(itemname_find, cmct_split[2]) == nil and Search_Status[1] == 1) then
                            Run_round_five = Run_round_five + 1
                            Search_Status[2] = Search_Status[2] + 1
                            Chat:sendSystemMsg("Searching! ["..shortnum(Search_Status[2]).."]#B "..cmct_split[2],cmobjid)
                        end    
                    until(Run_round_five == 45 or Founded == "True" or Search_Status[1] == 0)    
                until(Founded == "True" or Search_Status[1] == 0)
            elseif(cmct_split[1] == "/tf" and cmct_split[2] ~= nil and cmct_split[2] ~= "" and checknumber(cmct_split[2]) == true) then    
                Chat:sendSystemMsg("#b#YPlease wait.....",cmobjid)
                Backpack:removeGridItem(cmobjid,29,99)
                Backpack:setGridItem(cmobjid,29,14001,1,nil)
                Player:setActionAttrState(cmobjid,1,false)
                clearTable(tf_back)
                clearTable(tf_now)
                clearTable(tf_next)
                WorldContainer:clearContainer(0,255,0)
                threadpool:wait(0.05)
                WorldContainer:removeStorageBox(0,255,0)
                threadpool:wait(0.05)
                Block:placeBlock(801,0,255,0,0)
                --local result = Player:openBoxByPos(cmobjid, 0, 255, 0)
                now_show = cmct_split[2] - 1
                if(table.getn(tf_back) == 0 and table.getn(tf_now) == 0 and table.getn(tf_next) == 0) then
                    repeat
                        threadpool:wait(0.0001)
                        local loop_again = 1
                        repeat
                            --threadpool:wait(0.03)
                            local result, item_name = Item:getItemName(now_show)
                            if(item_name ~= nil and now_show ~= 101 and item_name ~= "")then
                                table.insert(tf_next,now_show)
                                now_show = now_show + 1
                                loop_again = loop_again + 1
                                --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                            elseif(item_name == nil and item_name ~= "ดิน" and now_show ~= 101) then
                                now_show = now_show + 1
                                loop_again = loop_again + 1
                                --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                            elseif(item_name ~= nil and now_show ~= 101 and item_name == "ดิน" and item_name ~= "") then
                                now_show = now_show + 1
                                loop_again = loop_again + 1
                                --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                            elseif(item_name ~= nil and now_show == 101 and item_name == "ดิน" and item_name ~= "") then
                                table.insert(tf_next,now_show)
                                now_show = now_show + 1
                                loop_again = loop_again + 1
                                --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                            else
                                now_show = now_show + 1
                                loop_again = loop_again + 1
                                --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                            end    
                        until(table.getn(tf_next) == 30 or loop_again == 30)    
                    until(table.getn(tf_next) == 30)
                    local result = Player:openBoxByPos(cmobjid, 0, 255, 0)
                    --Chat:sendSystemMsg(table.getn(tf_next),cmobjid)
                    trigger_tf_run = 1
                    threadpool:wait(1)
                    Player:setActionAttrState(cmobjid,1,true)
                end    
            end
        elseif(cmobjid == Admin and inTable(cmd_tr, cmct_split[1]) == "False" and cmct_split[1] ~= "/lg") then
            Chat:sendSystemMsg("#RThis command could not be found.",cmobjid)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=],Command_Script)
-------------------------------Button And Special Script---------------------------------

function tf_button(tfb)
    if(tfb.eventobjid == Admin and tfb.vkey == "E" and trigger_tf_run == 1 and dalay_tf_click == 0) then
        Backpack:removeGridItem(tfb.eventobjid,29,99)
        WorldContainer:clearContainer(0,255,0)
        Player:playMusic(tfb.eventobjid,10947,100,1,false)
        dalay_tf_click = 1
        tabclone(tf_back,tf_now)
        tabclone(tf_now,tf_next)
        --table.sort(tf_back)
        --table.sort(tf_now)
        --table.sort(tf_next)
        --Chat:sendSystemMsg("Yeah",tfb.eventobjid)
        for key, value in pairs(tf_now) do
            threadpool:wait(0.01)
            local result,relNumT=WorldContainer:addStorageItem(0,255,0,value,1)
            --Chat:sendSystemMsg("Yeah",tfb.eventobjid)
        end 
        if(tf_next[30] ~= nil or tf_next[30] ~= "") then
            now_show = tf_next[30] + 1
        end
        clearTable(tf_next)
        repeat
            threadpool:wait(0.0001)
            local loop_again = 1
            repeat
                --threadpool:wait(0.03)
                local result, item_name = Item:getItemName(now_show)
                if(item_name ~= nil and now_show ~= 101 and item_name ~= "")then
                    table.insert(tf_next,now_show)
                    now_show = now_show + 1
                    loop_again = loop_again + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                elseif(item_name == nil and item_name ~= "ดิน" and now_show ~= 101) then
                    now_show = now_show + 1
                    loop_again = loop_again + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                elseif(item_name ~= nil and now_show ~= 101 and item_name == "ดิน" and item_name ~= "") then
                    now_show = now_show + 1
                    loop_again = loop_again + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                elseif(item_name ~= nil and now_show == 101 and item_name == "ดิน" and item_name ~= "") then
                    table.insert(tf_next,now_show)
                    now_show = now_show + 1
                    loop_again = loop_again + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                else
                    now_show = now_show + 1
                    loop_again = loop_again + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                end    
            until(table.getn(tf_next) == 30 or loop_again == 30)    
        until(table.getn(tf_next) == 30)
        dalay_tf_click = 0
        Backpack:setGridItem(tfb.eventobjid,29,14001,1,nil)
        --Player:notifyGameInfo2Self(tfb.eventobjid,"Reset-Cooldown")
    elseif(tfb.eventobjid == Admin and tfb.vkey == "Q" and trigger_tf_run == 1 and dalay_tf_click == 0) then
        Backpack:removeGridItem(tfb.eventobjid,29,99)
        WorldContainer:clearContainer(0,255,0)
        Player:playMusic(tfb.eventobjid,10947,100,1,false)
        dalay_tf_click = 1
        tabclone(tf_next,tf_now)
        tabclone(tf_now,tf_back)
        table.sort(tf_back)
        table.sort(tf_now)
        table.sort(tf_next)
        for key, value in pairs(tf_now) do
            threadpool:wait(0.01)
            local result,relNumO=WorldContainer:addStorageItem(0,255,0,value,1)
            --Chat:sendSystemMsg("Yeah",tfb.eventobjid)
        end
        if(tf_back[1] ~= nil or tf_back[1] ~= "") then
            now_show = tf_back[1] - 1
        end    
        clearTable(tf_back) 
        repeat
            threadpool:wait(0.0001)
            local loop_againT = 1
            repeat
                --threadpool:wait(0.03)
                local result, item_nameT = Item:getItemName(now_show)
                if(item_nameT ~= nil and now_show ~= 101 and item_nameT ~= "")then
                    table.insert(tf_back,now_show)
                    now_show = now_show - 1
                    loop_againT = loop_againT + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                    table.sort(tf_back)
                elseif(item_nameT == nil and item_nameT ~= "ดิน" and now_show ~= 101) then
                    now_show = now_show - 1
                    loop_againT = loop_againT + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                elseif(item_nameT ~= nil and now_show ~= 101 and item_nameT == "ดิน" and item_name ~= "") then
                    now_show = now_show - 1
                    loop_againT = loop_againT + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                elseif(item_nameT ~= nil and now_show == 101 and item_nameT == "ดิน" and item_namTe ~= "") then
                    now_show = now_show - 1
                    loop_againT = loop_againT + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                else
                    now_show = now_show - 1
                    loop_againT = loop_againT + 1
                    --Chat:sendSystemMsg("#RTEST"..now_show,cmobjid)
                end    
            until(table.getn(tf_back) == 30 or loop_againT == 30)    
        until(table.getn(tf_back) == 30)
        dalay_tf_click = 0
        Backpack:setGridItem(tfb.eventobjid,29,14001,1,nil)
        --Player:notifyGameInfo2Self(tfb.eventobjid,"Reset-Cooldown")
    end
end
ScriptSupportEvent:registerEvent([=[Player.InputKeyDown]=],tf_button)
------------------------------Stopped TF-------------------------------------
function close_tf(ctf)
    if(ctf.eventobjid == Admin and trigger_tf_run == 1) then
        Backpack:removeGridItem(ctf.eventobjid,29,99)
        trigger_tf_run = 0
        now_show = 1
        WorldContainer:clearContainer(0,255,0)
        threadpool:wait(0.05)
        WorldContainer:removeStorageBox(0,255,0)
        Chat:sendSystemMsg("#R[TF] Close",ctf.eventobjid)
    end    
end
ScriptSupportEvent:registerEvent([=[Player.MoveOneBlockSize]=],close_tf)
-------------------------------------------------------------------------------