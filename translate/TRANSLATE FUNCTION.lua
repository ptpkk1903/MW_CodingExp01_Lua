local function GetTranslateString(uid, key_text)
    local Text_Group_Variable = "AllTranslate"
    local lang_set = {"tha","tw","en","ita","tur","ger","cn","jpn","ptb","esn","ind","vie","msa","rus","fra","kor","ara"}
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
    local function getstring(string_txt, langcode, key)  -- Get value from string
        local pattern = "%[([^%]]+)%]%[([^%]]+)%](.+)"
        local lang, k, value = string.match(string_txt, pattern)
        if lang == langcode and k == key then
            return value
        else
            return nil
        end
    end
    local function getIndexOfLang(langcode)
        for i,v in ipairs(lang_set) do
            if(langcode == v) then
                return i
            end
        end
        return 3
    end
    local function GetTranslateTxtString(key_string, langcode, indexoflang)
        local result,value=Valuegroup:getAllGroupItem(18, Text_Group_Variable, 0)
        if(#value > 0) then
            local text_num = #value / #lang_set
            local start = (text_num * (indexoflang-1))+1
            local i = start
            while i <= (start+(text_num-1)) do
                local txt = getstring(value[i], langcode, key_string)
                if(txt ~= nil) then
                    return txt
                end
                i=i+1
            end
            return nil
        end
    end
        
    local LangCode = getLangCode(uid)
    local GetIndexLang = getIndexOfLang(LangCode)
    local Translate_txt = GetTranslateTxtString(key_text, LangCode, GetIndexLang) or "None"
    return Translate_txt
end




------------------------
local function GetTranslateString(uid, key_text)
    local Text_Group_Variable = "AllText"
    local lang_set = {"tha","tw","en","ita","tur","ger","cn","jpn","ptb","esn","ind","vie","msa","rus","fra","kor","ara"}
    local conf_langCodeToString = {"cn","en","tw", "tha","esn","ptb","fra","jpn","ara","kor","vie","rus","tur","ita","ger","ind", "msa"}
    local function getLangCode(playerID) local lang = "en" if playerID ~= nil then playerID = tonumber(playerID) local ret, langCode, area = Player:GetLanguageAndRegion(playerID) if ret == 0 and nil ~= langCode then local resultLang = tonumber(langCode) if resultLang and resultLang >= 0 then langCode = resultLang < #conf_langCodeToString and conf_langCodeToString[resultLang + 1] or "en" else langCode = langCode or "en" end lang = langCode end end return lang end
    local function getstring(string_txt, langcode, key) local pattern = "%[([^%]]+)%]%[([^%]]+)%](.+)" local lang, k, value = string.match(string_txt, pattern) if lang == langcode and k == key then return value else return nil end end
    local function getIndexOfLang(langcode) for i,v in ipairs(lang_set) do if(langcode == v) then return i end end return 3 end
    local function GetTranslateTxtString(key_string, langcode, indexoflang) local result,value=Valuegroup:getAllGroupItem(18, Text_Group_Variable, 0) if(#value > 0) then local text_num = #value / #lang_set local start = (text_num * (indexoflang-1))+1 local i = start while i <= (start+(text_num-1)) do local txt = getstring(value[i], langcode, key_string) if(txt ~= nil) then return txt end i=i+1 end return nil end end
    local LangCode = getLangCode(uid) local GetIndexLang = getIndexOfLang(LangCode) local Translate_txt = GetTranslateTxtString(key_text, LangCode, GetIndexLang) or "None" return Translate_txt 
end
-------------------------
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