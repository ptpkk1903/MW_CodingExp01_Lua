local datas = {
	["logindays"]="7347976277455562624_301",
	["read_btn"]="7347976277455562624_277",
	["back_base_text"]="7347976277455562624_104,7347976277455562624_464",
	["confirm_btn"]="7347976277455562624_111",
	["amount"]="7347976277455562624_230",
	["deposit"]="7347976277455562624_235",
	["withdraw"]="7347976277455562624_236",
	["random_btn"]="7347976277455562624_408,7347976277455562624_455",
	["safe"]="7347976277455562624_251",
	["understand"]="7347976277455562624_250,7347976277455562624_638,7347976277455562624_644",
	["safe_msg"]="7347976277455562624_252",
	["cloud"]="7347976277455562624_253",
	["die_drop_text"]="7347976277455562624_354",
	["exception_drop"]="7347976277455562624_355",
	["Steal"]="7347976277455562624_356",
	["buy"]="7347976277455562624_157,7347976277455562624_150,7347976277455562624_143",
	["gun_store"]="7347976277455562624_124",
	["armor_store"]="7347976277455562624_115",
	["melee_store"]="7347976277455562624_118",
	["normal"]="7347976277455562624_122,7347976277455562624_117",
	["macgun"]="7347976277455562624_127",
	["pisgun"]="7347976277455562624_129",
	["spegun"]="7347976277455562624_131",
	["backbase_howto"] = "7347976277455562624_631",
	["drop_howto"] = "7347976277455562624_642",
	["noti_item_save"] = "7347976277455562624_653",
}

local interface = [[7347976277455562624]]

--------------------------------------------------------------------------------
local function Split(msg, delimiter) -- Split Text to Table
    result_spl = {}
    for match in (msg .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result_spl, match)
    end
    return result_spl
end

local function GetTranslateString(uid, key_text)
    local Text_Group_Variable = "AllTranslate"
    local lang_set = {"tha","tw","en","ita","tur","ger","cn","jpn","ptb","esn","ind","vie","msa","rus","fra","kor","ara"}
    local conf_langCodeToString = {"cn","en","tw", "tha","esn","ptb","fra","jpn","ara","kor","vie","rus","tur","ita","ger","ind", "msa"}
    local function getLangCode(playerID) local lang = "en" if playerID ~= nil then playerID = tonumber(playerID) local ret, langCode, area = Player:GetLanguageAndRegion(playerID) if ret == 0 and nil ~= langCode then local resultLang = tonumber(langCode) if resultLang and resultLang >= 0 then langCode = resultLang < #conf_langCodeToString and conf_langCodeToString[resultLang + 1] or "en" else langCode = langCode or "en" end lang = langCode end end return lang end
    local function getstring(string_txt, langcode, key) local pattern = "%[([^%]]+)%]%[([^%]]+)%](.+)" local lang, k, value = string.match(string_txt, pattern) if lang == langcode and k == key then return value else return nil end end
    local function getIndexOfLang(langcode) for i,v in ipairs(lang_set) do if(langcode == v) then return i end end return 3 end
    local function GetTranslateTxtString(key_string, langcode, indexoflang) local result,value=Valuegroup:getAllGroupItem(18, Text_Group_Variable, 0) if(#value > 0) then local text_num = #value / #lang_set local start = (text_num * (indexoflang-1))+1 local i = start while i <= (start+(text_num-1)) do local txt = getstring(value[i], langcode, key_string) if(txt ~= nil) then return txt end i=i+1 end return nil end end
    local LangCode = getLangCode(uid) local GetIndexLang = getIndexOfLang(LangCode) local Translate_txt = GetTranslateTxtString(key_text, LangCode, GetIndexLang) or "None" return Translate_txt 
end
--------------------------------------------------------------------------------
local function Run_Script(rs)
    local uid = rs.eventobjid
    for i,v in pairs(datas) do
        local uidata = Split(v, ",")
        for a, dt in pairs(uidata) do
            if(dt ~= nil and dt ~= "" and dt ~= " ") then
                Customui:setText(uid, interface, dt, GetTranslateString(uid, i))
            end
        end
    end
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], Run_Script)














