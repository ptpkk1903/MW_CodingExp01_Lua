local Interface = [[7358355985049347968]]
local UI_Load = [[7358355985049347968_1]]
local UI_Btn = [[7358355985049347968_4]]
local UI_text_load = [[7358355985049347968_3]]
local UI_text_load_Btn = [[7358355985049347968_5]]

------------- GET UID FROM --> local uid = CurEventParam.CloudValue.eventobjid ------------- 
--------------------------------------------------------------------------------
local Text_Load = {["tha"] = "คุณจำเป็นต้องโหลดข้อมูล!",["tw"] = "您需要載入資料！",["en"] = "You need to load data!",["ita"] = "Devi caricare i dati!",["tur"] = "Veri yüklemeniz gerekiyor!",["ger"] = "Sie müssen Daten laden!",["cn"] = "您需要加载数据！",["jpn"] = "データをロードする必要があります!",["ptb"] = "Você precisa carregar dados!",["esn"] = "¡Necesitas cargar datos!",["ind"] = "Anda perlu memuat data!",["vie"] = "Bạn cần tải dữ liệu!",["msa"] = "Anda perlu memuatkan data!",["rus"] = "Вам необходимо загрузить данные!",["fra"] = "Vous devez charger des données !",["kor"] = "데이터를 로드해야 합니다!",["ara"] = "تحتاج إلى تحميل البيانات!",}
local Text_btn = {["tha"] = "โหลด",["tw"] = "載入",["en"] = "Load",["ita"] = "Carico",["tur"] = "Yük",["ger"] = "Belastung",["cn"] = "加载",["jpn"] = "負荷",["ptb"] = "Carregar",["esn"] = "Carga",["ind"] = "Memuat",["vie"] = "Trọng tải",["msa"] = "Muatkan",["rus"] = "Нагрузка",["fra"] = "Charger",["kor"] = "짐",["ara"] = "حمولة",}
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
--------------------------------------------------------------------------------
local PPA_Dalay = {}
local function delay_check(uid) if(PPA_Dalay[tostring(uid)] == "End" or PPA_Dalay[tostring(uid)] == nil) then local pass = "PASS" elseif(PPA_Dalay[tostring(uid)] == "Start") then local error_ = "TEST" * 1 print(error_) end end
local function THREAD_On(uid) delay_check(uid) if(PPA_Dalay[tostring(uid)] == nil or PPA_Dalay[tostring(uid)] == "End") then PPA_Dalay[tostring(uid)] = "Start" end end
local function THREAD_Off(uid) threadpool:wait(2) if(PPA_Dalay[tostring(uid)] == "Start") then PPA_Dalay[tostring(uid)] = "End" end end
local function PlayerOnline(ppa)
    local uid = ppa.eventobjid
    if(ppa.uielement == UI_Btn) then
        THREAD_On(uid)
        Customui:hideElement(uid, Interface, UI_Btn)
        local data = {eventobjid = uid}
        local ok, json = pcall(JSON.encode, JSON, data)
        Game:dispatchEvent("Player.Online",{customdata = json})
        threadpool:wait(1)
        THREAD_Off(uid)
    end
end
ScriptSupportEvent:registerEvent([=[UI.Button.TouchBegin]=], PlayerOnline)

local function Online(ppa)
    local uid = ppa.eventobjid
    Actor:setActionAttrState(uid,1,false)
    Customui:setText(uid, Interface, UI_text_load, Text_Load[getLangCode(uid)])
    Customui:setText(uid, Interface, UI_text_load_Btn, Text_btn[getLangCode(uid)])
    threadpool:wait(0.4)
    Player:openUIView(uid,Interface)
    Customui:showElement(uid, Interface, UI_Load)
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], Online)

local function Player_Loaded(ppa)
    local uid = CurEventParam.CloudValue.eventobjid
    print(uid)
    threadpool:wait(1.8)
    Customui:hideElement(uid, Interface, UI_Load)
    Actor:setActionAttrState(uid,1,true)
end
ScriptSupportEvent:registerEvent([=[Player.Online]=], Player_Loaded)

