local Mail = "MAIL" -- CLOUD table
local Player_StringGroup_Read = "Mail_read" -- PVAR_GROUP_STRING
local MaiL_Data = "Data1"
local ADMIN = {1002203008, 1014793465, 1066059221}
-------------------------------------------------------------------------------------------
local player_data = {} --player_data["uid"] = {mail_data=get data mail, mail_read = get reade mail, page=1, active_page=""}
local Mail_Presents = {} -- ["mail_id"] = {topic="", button="", msg="", gift={}, days=0}
local last_player = 99999999
local Sender_only_admin = {topic="", button="", msg="", gift={}, days=0}
-------------------------------------------------------------------------------------------
local Get_data_success = true
local Player_login = true
--------------------------------------- UI --------------------------------------------------
local uidata = {}
local colored = {0xFFFFFF, 0x82FF5A}
uidata["interface"] = [[7347976277455562624]]
uidata["btn_open"] = [[7347976277455562624_290]]
uidata["mail_page"] = [[7347976277455562624_256]]
uidata["bg"] = [[7347976277455562624_114]]
uidata["topic"] = [[7347976277455562624_279]]
uidata["expired"] = [[7347976277455562624_280]]
uidata["message"] = [[7347976277455562624_281]]
uidata["read_btn"] = [[7347976277455562624_276]]
uidata["close_btn"] = [[7347976277455562624_275]]
uidata["next_page"] = [[7347976277455562624_273]]
uidata["back_page"] = [[7347976277455562624_274]]
uidata["light_noti"] = [[7347976277455562624_291]]

uidata["gift1"] = {[[7347976277455562624_282]], [[7347976277455562624_283]]}
uidata["gift2"] = {[[7347976277455562624_284]], [[7347976277455562624_285]]}
uidata["gift3"] = {[[7347976277455562624_286]], [[7347976277455562624_287]]}
uidata["giftanother"] = {[[7347976277455562624_288]],[[7347976277455562624_289]]}

local text_msg = {}
text_msg["Epired"] = "หมดอายุ: "

local page_btn = {}
page_btn["7347976277455562624_258"] = {rank=1, text=[[7347976277455562624_259]], notification=[[7347976277455562624_260]]}
page_btn["7347976277455562624_261"] = {rank=2, text=[[7347976277455562624_262]], notification=[[7347976277455562624_263]]}
page_btn["7347976277455562624_264"] = {rank=3, text=[[7347976277455562624_265]], notification=[[7347976277455562624_266]]}
page_btn["7347976277455562624_267"] = {rank=4, text=[[7347976277455562624_268]], notification=[[7347976277455562624_269]]}
page_btn["7347976277455562624_270"] = {rank=5, text=[[7347976277455562624_271]], notification=[[7347976277455562624_272]]}

local expired_text = {["tha"] = "หมดอายุ:",["tw"] = "到期：",["en"] = "expire:",["ita"] = "scadenza:",["tur"] = "sona erme tarihi:",["ger"] = "erlöschen:",["cn"] = "到期：",["jpn"] = "期限切れ：",["ptb"] = "expirar:",["esn"] = "expirar:",["ind"] = "berakhir:",["vie"] = "hết hạn:",["msa"] = "tamat tempoh:",["rus"] = "истекает:",["fra"] = "expirer:",["kor"] = "내쉬다:",["ara"] = "تنقضي:",}
----------------------------------------------------------------------------------------------
Mail_Presents["10000001"] = {
	topic = {["tha"] = "ยินดีต้อนรับผู้เล่นใหม่",["tw"] = "歡迎新玩家",["en"] = "Welcome new players",["ita"] = "Benvenuto ai nuovi giocatori",["tur"] = "Yeni oyunculara hoş geldiniz",["ger"] = "Willkommen neue Spieler",["cn"] = "欢迎新玩家",["jpn"] = "新しいプレイヤーを歓迎します",["ptb"] = "Bem vindos novos jogadores",["esn"] = "Bienvenidos nuevos jugadores",["ind"] = "Selamat datang pemain baru",["vie"] = "Chào mừng người chơi mới",["msa"] = "Selamat datang pemain baru",["rus"] = "Приветствуем новых игроков",["fra"] = "Bienvenue aux nouveaux joueurs",["kor"] = "새로운 플레이어를 환영합니다",["ara"] = "نرحب باللاعبين الجدد",},
	button = {["tha"] = "ต้อนรับ",["tw"] = "歡迎",["en"] = "welcome",["ita"] = "Benvenuto",["tur"] = "Hoş geldin",["ger"] = "Willkommen",["cn"] = "欢迎",["jpn"] = "いらっしゃいませ",["ptb"] = "Bem-vindo",["esn"] = "bienvenido",["ind"] = "selamat datang",["vie"] = "Chào mừng",["msa"] = "selamat datang",["rus"] = "добро пожаловать",["fra"] = "accueillir",["kor"] = "환영",["ara"] = "مرحباً",},
	msg = {["tha"] = "ยินดีต้อนรับผู้เล่นใหม่ทุกท่าน เราหวังว่าคุณจะสนุกกับเกมของเรา",["tw"] = "歡迎所有新玩家。我們希望您喜歡我們的遊戲。",["en"] = "Welcome all new players. We hope you enjoy our game.",["ita"] = "Benvenuti a tutti i nuovi giocatori. Ci auguriamo che il nostro gioco ti piaccia.",["tur"] = "Tüm yeni oyunculara hoş geldiniz. Oyunumuzu beğeneceğinizi umuyoruz.",["ger"] = "Willkommen alle neuen Spieler. Wir hoffen, dass Ihnen unser Spiel gefällt.",["cn"] = "欢迎所有新玩家。我们希望您喜欢我们的游戏。",["jpn"] = "新規プレイヤーの皆様を歓迎します。私たちのゲームをお楽しみいただければ幸いです。",["ptb"] = "Dê as boas-vindas a todos os novos jogadores. Esperamos que você goste do nosso jogo.",["esn"] = "Bienvenidos todos los nuevos jugadores. Esperamos que disfrutes de nuestro juego.",["ind"] = "Selamat datang semua pemain baru. Kami harap Anda menikmati permainan kami.",["vie"] = "Chào mừng tất cả người chơi mới. Chúng tôi hy vọng bạn thích trò chơi của chúng tôi.",["msa"] = "Selamat datang semua pemain baharu. Kami harap anda menikmati permainan kami.",["rus"] = "Приветствуем всех новых игроков. Мы надеемся, что вам понравится наша игра.",["fra"] = "Bienvenue à tous les nouveaux joueurs. Nous espérons que vous apprécierez notre jeu.",["kor"] = "새로운 플레이어 여러분을 환영합니다. 우리 게임을 즐기시기 바랍니다.",["ara"] = "نرحب بجميع اللاعبين الجدد. نأمل أن تستمتع لعبتنا.",},
	gift = {{4155,1},{15003,64},{4121,400},{4163,3},{4186,1},},
	days = "1712163600"
}

-------------------------------------------------------------------------------------------
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
    while i < ende+1 do
        result[tostring(i)] = i
        i=i+1
    end
    return result
end

local function inTable(tablef, vcheck)
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

local function timestampToString(timestamp)
    local formattedDate = os.date("%d%b%Y %H:%M:%S", timestamp)
    local months = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    }
    local monthNumber = tonumber(os.date("%m", timestamp))
    local monthName = months[monthNumber]
    formattedDate = formattedDate:gsub("%a%a%a", monthName)
    return formattedDate
end

local function checkFormat(input)
    local pattern = "^%d+,%d+$"
    if string.match(input, pattern) then
        return true
    else
        return false
    end
end

local function gettimefuture(days)
    local current_date = os.date("*t")
    current_date.hour = 23
    current_date.min = 59
    current_date.sec = 59
    local current_time = os.time()
    local future_time = os.time(current_date) + (days * 86400)
    if(days == 0) then
        return os.time()
    else
        return future_time
    end
    
end

local function blank_chat()
    for i,v in pairs(range(1,20)) do
        Chat:sendSystemMsg(" ")
    end
end

local function tablecount(tablee)
    local i = 0
    for id,v in pairs(tablee) do
        i=i+1
    end
    return i
end

local function getValueInTable(table_data, num_per_set, set_number)
    local start_index = (set_number - 1) * num_per_set + 1
    local end_index = start_index + num_per_set - 1
    local result = {}

    for i = start_index, end_index do
        result[#result + 1] = table_data[i]
    end

    return result
end

local function getKeybyRank()
    for i,v in pairs(page_btn) do
        if(v["rank"] == 1) then
            return i
        end
    end
end

local function ColorRefresh()
    for i,v in pairs(page_btn) do
        Customui:setColor(uid, uidata["interface"], i, colored[1])
    end
    Customui:hideElement(uid, uidata["interface"], uidata["gift1"][1])
    Customui:hideElement(uid, uidata["interface"], uidata["gift2"][1])
    Customui:hideElement(uid, uidata["interface"], uidata["gift3"][1])
    Customui:hideElement(uid, uidata["interface"], uidata["giftanother"][1])
end
-------------------------------------------------------------------------------------------
local function get_readed(uid) -- Get Data Read
    local code, datas = Valuegroup:getAllGroupItem(18, Player_StringGroup_Read, uid)
    local result = {}
    for i,v in ipairs(datas) do
        table.insert(result,v)
    end
    return result
end

local function Update_readed(uid) -- Update Data Read
    local code, val = Valuegroup:clearGroupByName(18, Player_StringGroup_Read, uid)
    for i,v in ipairs(player_data[tostring(uid)]["mail_read"]) do
        local code = Valuegroup:insertInGroupByName(18, Player_StringGroup_Read, v, uid)
    end
end

local function Del_Readed_player(uid)
    local result = {}
    for i,v in pairs(player_data[tostring(uid)]["mail_read"]) do
        if(inTable(player_data[tostring(uid)]["keyinTable"], v) == true) then
            table.insert(result, v)
        end
    end
    player_data[tostring(uid)]["mail_read"] = result
    Update_readed(uid)
end

local function Light_Notification(uid)
    if(tablecount(player_data[tostring(uid)]["mail_read"]) >= tablecount(player_data[tostring(uid)]["keyinTable"])) then
        Customui:hideElement(uid, uidata["interface"], uidata["light_noti"])
    elseif(tablecount(player_data[tostring(uid)]["mail_read"]) < tablecount(player_data[tostring(uid)]["keyinTable"])) then
        Customui:showElement(uid, uidata["interface"], uidata["light_noti"])
    end
end

local function getLangCode(playerID) -- Get lang Code
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

--------------------------------------------------------------------------------------------------

local function player_enter(pe)
    local uid = pe.eventobjid
    while Get_data_success == false do
        threadpool:wait(1)
    end
    Get_data_success = false
    last_player = uid
    local puck_data = {}
    for i,v in pairs(Mail_Presents) do
        if(tonumber(v["days"]) > os.time()) then
            table.insert(puck_data, i)
        end
    end
    table.sort(puck_data, function(a, b) return tonumber(a) < tonumber(b) end)
    player_data[tostring(uid)] = {mail_data=Mail_Presents, mail_read=get_readed(uid), keyinTable=puck_data, page=1, active_page={}}
    Del_Readed_player(uid)
    Light_Notification(uid)
    Get_data_success = true
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], player_enter)

local function active_expired(timed)
    if(tonumber(timed) > os.time()) then
        return "#G(Active)"
    else
        return "#R(Expired)"
    end
end

local function Send_Letter(sll)
    local uid = sll.eventobjid
    local msg = Split(sll.content," ")
    if(msg[1] == "/getmail" and inTable(ADMIN, uid) == true) then
        Chat:sendSystemMsg("#BAll mails: #G"..tablecount(Mail_Presents), uid)
        for i,v in pairs(Mail_Presents) do
            Chat:sendSystemMsg("#G"..tostring(i).." #Y"..tostring(v["button"]).." #B"..timestampToString(tonumber(v["days"])).." "..active_expired(v["days"]), uid)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=], Send_Letter)


---------------------------------------------------------------------------------------------------

local function refresh_menu(uid, page_manu)
    player_data[tostring(uid)]["page"] = page_manu
    local letter_puck = getValueInTable(player_data[tostring(uid)]["keyinTable"], 5, player_data[tostring(uid)]["page"])
    local readed_puck = player_data[tostring(uid)]["mail_read"]
    for i,v in pairs(page_btn) do
        if(inTable(readed_puck, letter_puck[v["rank"]]) == false and letter_puck[v["rank"]] ~= nil) then   -- dont read
            local getdata_mail = player_data[tostring(uid)]["mail_data"][letter_puck[v["rank"]]]
            Customui:setText(uid, uidata["interface"], v["text"], getdata_mail["button"][getLangCode(uid)])
            Customui:showElement(uid, uidata["interface"], v["notification"])
            Customui:setText(uid, uidata["interface"], uidata["topic"], "")
            Customui:setText(uid, uidata["interface"], uidata["expired"], "")
            Customui:setText(uid, uidata["interface"], uidata["message"], "")
            Customui:hideElement(uid, uidata["interface"], uidata["read_btn"])
        else
            if(letter_puck[v["rank"]] ~= nil) then
                local getdata_mail = player_data[tostring(uid)]["mail_data"][letter_puck[v["rank"]]]
                Customui:setText(uid, uidata["interface"], v["text"], getdata_mail["button"][getLangCode(uid)])
                Customui:hideElement(uid, uidata["interface"], v["notification"])
                Customui:setText(uid, uidata["interface"], uidata["topic"], "")
                Customui:setText(uid, uidata["interface"], uidata["expired"], "")
                Customui:setText(uid, uidata["interface"], uidata["message"], "")
                Customui:hideElement(uid, uidata["interface"], uidata["read_btn"])
            else
                Customui:setText(uid, uidata["interface"], v["text"], "")
                Customui:hideElement(uid, uidata["interface"], v["notification"])
                Customui:setText(uid, uidata["interface"], uidata["topic"], "")
                Customui:setText(uid, uidata["interface"], uidata["expired"], "")
                Customui:setText(uid, uidata["interface"], uidata["message"], "")
                Customui:hideElement(uid, uidata["interface"], uidata["read_btn"])
            end
        end
        ColorRefresh()
    end
end

local function ShowBox(uid, gift)
    local ui_puck = {}
    ui_puck[1] = uidata["gift1"]
    ui_puck[2] = uidata["gift2"]
    ui_puck[3] = uidata["gift3"]
    ui_puck[4] = uidata["giftanother"]
    for i,v in pairs(gift) do
        if(i < 4 and i ~= 0) then
            local code, icon = Customui:getItemIcon(tonumber(v[1]))
            Customui:showElement(uid, uidata["interface"], ui_puck[i][1])
            Customui:setTexture(uid, uidata["interface"], ui_puck[i][2], icon)
        elseif(i >= 4) then
            Customui:showElement(uid, uidata["interface"], ui_puck[4][1])
        end
    end
end

local function giveitems(uid)
    local mail_id , btn = player_data[tostring(uid)]["active_page"][1], player_data[tostring(uid)]["active_page"][2]
    local get_items = player_data[tostring(uid)]["mail_data"][mail_id]["gift"]
    if(#get_items > 0) then
        for i,v in pairs(get_items) do
            Player:gainItems(uid,tonumber(v[1]),tonumber(v[2]),1)
        end
    end
    table.insert(player_data[tostring(uid)]["mail_read"], mail_id)
    Update_readed(uid)
    Customui:hideElement(uid, uidata["interface"], uidata["read_btn"])
    Customui:hideElement(uid, uidata["interface"], page_btn[tostring(btn)]["notification"])
    if(#get_items > 0) then
        Player:playMusic(uid,10947,70,1,false)
        --Player:notifyGameInfo2Self(uid,text_msg["Readed"])
    end
end

local function btn_function(gst)
    local uid = gst.eventobjid
    if(gst.uielement == uidata["btn_open"]) then
        refresh_menu(uid, 1)
        --Del_Readed_player(uid)
        Light_Notification(uid)
        Customui:PlayElementAnim(uid, uidata["interface"], uidata["mail_page"], 10001, 0.8, 2)
        
    elseif(gst.uielement == uidata["close_btn"]) then -- close
        Customui:PlayElementAnim(uid, uidata["interface"], uidata["mail_page"], 20003, 0.8, 2)
        
    elseif(gst.uielement == uidata["next_page"]) then
        refresh_menu(uid, player_data[tostring(uid)]["page"]+1)
    elseif(gst.uielement == uidata["back_page"] and player_data[tostring(uid)]["page"] > 1) then
        refresh_menu(uid, player_data[tostring(uid)]["page"]-1)
    elseif(page_btn[tostring(gst.uielement)] ~= nil) then
        local rank = page_btn[tostring(gst.uielement)]["rank"]
        local letter_puck = getValueInTable(player_data[tostring(uid)]["keyinTable"], 5, player_data[tostring(uid)]["page"])
        local readed_puck = player_data[tostring(uid)]["mail_read"]
        ColorRefresh()
        Customui:setColor(uid, uidata["interface"], gst.uielement, colored[2])
        local datas = player_data[tostring(uid)]["mail_data"][letter_puck[rank]]
        Customui:setText(uid, uidata["interface"], uidata["topic"], datas["topic"][getLangCode(uid)])
        Customui:setText(uid, uidata["interface"], uidata["expired"], expired_text[getLangCode(uid)]..timestampToString(tonumber(datas["days"])))
        Customui:setText(uid, uidata["interface"], uidata["message"], datas["msg"][getLangCode(uid)])
        ShowBox(uid, datas["gift"])
        if(inTable(readed_puck, letter_puck[rank]) == false and letter_puck[rank] ~= nil) then -- None read
            Customui:showElement(uid, uidata["interface"], uidata["read_btn"]) 
            player_data[tostring(uid)]["active_page"] = {letter_puck[rank],tostring(gst.uielement)}
        elseif(letter_puck[rank] ~= nil) then -- Readed
            Customui:hideElement(uid, uidata["interface"], uidata["read_btn"])
            player_data[tostring(uid)]["active_page"] = {letter_puck[rank],tostring(gst.uielement)}
        end
    elseif(gst.uielement == uidata["read_btn"]) then
        giveitems(uid)
        Light_Notification(uid)
        Customui:PlayElementAnim(uid, uidata["interface"], uidata["mail_page"], 20003, 0.8, 2)
        Customui:PlayElementAnim(uid, uidata["interface"], uidata["bg"], 20001, 0.8, 2)
    end
end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], btn_function)
