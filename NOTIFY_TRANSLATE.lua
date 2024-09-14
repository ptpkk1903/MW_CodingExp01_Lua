local text = {["tha"] = "#Rเงินไม่เพียงพอ!!",["tw"] = "#R錢不夠！",["en"] = "#R not enough money!!",["ita"] = "#R non abbastanza soldi!!",["tur"] = "#R yeterli para yok!!",["ger"] = "#R nicht genug Geld!!",["cn"] = "#R钱不够！！",["jpn"] = "#R お金が足りない!!",["ptb"] = "#R não há dinheiro suficiente!!",["esn"] = "#R ¡¡No hay suficiente dinero!!",["ind"] = "#R uang tidak cukup!!",["vie"] = "#R không đủ tiền!!",["msa"] = "#R tak cukup duit!!",["rus"] = "#R недостаточно денег!!",["fra"] = "#R pas assez d'argent !!",["kor"] = "#R 돈이 부족해요!!",["ara"] = "#ص لا يكفي المال!!",}

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

Player:notifyGameInfo2Self(CurEventParam.TriggerByPlayer, text[getLangCode(CurEventParam.TriggerByPlayer)])