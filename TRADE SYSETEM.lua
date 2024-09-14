local Player_Data = {} -- {true,uid_reciver,{uid,itemid,itemnum,feeGiver}}   true,{send},{reciever}  // true คือรับได้และให้ได้
local Money_Pvar = "Bank_Money2"
local Exchange_Point = "gift_point"

local msg_lang = {}
msg_lang["cancel"] = {["tha"] = "ปฏิเสธ",["tw"] = "拒絕",["en"] = "refuse",["ita"] = "rifiutare",["tur"] = "reddetmek",["ger"] = "verweigern",["cn"] = "拒绝",["jpn"] = "拒否する",["ptb"] = "recusar",["esn"] = "rechazar",["ind"] = "menolak",["vie"] = "từ chối ",["msa"] = "menolak",["rus"] = "мусор",["fra"] = "refuser",["kor"] = "거절하다",["ara"] = "رفض",}
msg_lang["recieve"] = {["tha"] = "รับ",["tw"] = "收到",["en"] = "receive",["ita"] = "ricevere",["tur"] = "almak",["ger"] = "erhalten",["cn"] = "收到",["jpn"] = "受け取る",["ptb"] = "receber",["esn"] = "recibir",["ind"] = "menerima",["vie"] = "nhận được",["msa"] = "menerima",["rus"] = "получать",["fra"] = "recevoir",["kor"] = "받다",["ara"] = "يستلم",}
msg_lang["itemshand"] = {["tha"] = "ให้ของในมือ",["tw"] = "給手上的東西",["en"] = "give things in hand",["ita"] = "dare le cose in mano",["tur"] = "eline bir şeyler ver",["ger"] = "Dinge in die Hand geben",["cn"] = "给手上的东西",["jpn"] = "手に物を与える",["ptb"] = "dar as coisas em mãos",["esn"] = "dar las cosas en la mano",["ind"] = "memberikan sesuatu di tangan",["vie"] = "đưa đồ trong tay",["msa"] = "memberikan sesuatu di tangan",["rus"] = "отдать вещи в руки",["fra"] = "donner les choses en main",["kor"] = "물건을 손에 쥐다",["ara"] = "إعطاء الأشياء في متناول اليد",}
msg_lang["re_success"] = {["tha"] = "รับสำเร็จ",["tw"] = "成功收到",["en"] = "Successfully received",["ita"] = "Ricevuto con successo",["tur"] = "Başarıyla alındı",["ger"] = "Erfolgreich empfangen",["cn"] = "成功收到",["jpn"] = "正常に受信しました",["ptb"] = "Recebido com sucesso",["esn"] = "Recibido con éxito",["ind"] = "Berhasil diterima",["vie"] = "Đã nhận thành công",["msa"] = "Berjaya diterima",["rus"] = "Успешно получено",["fra"] = "Reçu avec succès",["kor"] = "성공적으로 수신됨",["ara"] = "تم الاستلام بنجاح",}
msg_lang["refunded"] = {["tha"] = "ผู้เล่นไม่รับของ (คืนเงินแล้ว 90%)",["tw"] = "玩家沒有收到物品（90% 退款）",["en"] = "Player did not receive the item (90% refunded)",["ita"] = "Il giocatore non ha ricevuto l'oggetto (rimborsato al 90%)",["tur"] = "Oyuncu öğeyi alamadı (%90'ı iade edildi)",["ger"] = "Der Spieler hat den Artikel nicht erhalten (90 % Rückerstattung)",["cn"] = "玩家没有收到物品（90% 退款）",["jpn"] = "プレイヤーがアイテムを受け取らなかった (90% 返金)",["ptb"] = "O jogador não recebeu o item (90% reembolsado)",["esn"] = "El jugador no recibió el artículo (90 % reembolsado)",["ind"] = "Pemain tidak menerima item (90% dikembalikan)",["vie"] = "Người chơi không nhận được vật phẩm (hoàn tiền 90%)",["msa"] = "Pemain tidak menerima item (90% dikembalikan)",["rus"] = "Игрок не получил предмет (возврат 90%)",["fra"] = "Le joueur n'a pas reçu l'article (remboursé à 90 %)",["kor"] = "플레이어가 아이템을 받지 못했습니다(90% 환불).",["ara"] = "لم يستلم اللاعب العنصر (تم استرداد 90% منه)",}
msg_lang["not_pre"] = {["tha"] = "ผู้รับไม่พร้อมรับในตอนนี้",["tw"] = "收件人此時尚未準備好接收它。",["en"] = "The recipient is not ready to receive it at this time.",["ita"] = "Il destinatario non è pronto a riceverlo in questo momento.",["tur"] = "Alıcı şu anda bunu almaya hazır değil.",["ger"] = "Der Empfänger ist derzeit nicht empfangsbereit.",["cn"] = "收件人此时尚未准备好接收它。",["jpn"] = "受信者は現時点では受信する準備ができていません。",["ptb"] = "O destinatário não está pronto para recebê-lo neste momento.",["esn"] = "El destinatario no está listo para recibirlo en este momento.",["ind"] = "Penerima belum siap menerimanya saat ini.",["vie"] = "Người nhận chưa sẵn sàng nhận nó vào lúc này.",["msa"] = "Penerima tidak bersedia untuk menerimanya pada masa ini.",["rus"] = "Получатель в настоящее время не готов его получить.",["fra"] = "Le destinataire n'est pas prêt à le recevoir pour le moment.",["kor"] = "수신자가 현재 이를 수신할 준비가 되어 있지 않습니다.",["ara"] = "المستلم ليس جاهزًا لاستلامه في هذا الوقت.",}
msg_lang["not_enough_reciever"] = {["tha"] = "ผู้รับมีเงินจ่ายค่าธรรมเนียมไม่พอ",["tw"] = "收款人沒有足夠的錢來支付費用。",["en"] = "The recipient does not have enough money to pay the fee.",["ita"] = "Il destinatario non ha abbastanza soldi per pagare la tassa.",["tur"] = "Alıcının ücreti ödemek için yeterli parası yok.",["ger"] = "Der Empfänger verfügt nicht über genügend Geld, um die Gebühr zu bezahlen.",["cn"] = "收款人没有足够的钱来支付费用。",["jpn"] = "受信者には料金を支払うのに十分な資金がありません。",["ptb"] = "O destinatário não tem dinheiro suficiente para pagar a taxa.",["esn"] = "El destinatario no tiene suficiente dinero para pagar la tarifa.",["ind"] = "Penerima tidak mempunyai cukup uang untuk membayar biaya.",["vie"] = "Người nhận không có đủ tiền để trả phí.",["msa"] = "Penerima tidak mempunyai wang yang cukup untuk membayar yuran.",["rus"] = "У получателя недостаточно денег для оплаты комиссии.",["fra"] = "Le destinataire n'a pas assez d'argent pour payer les frais.",["kor"] = "수취인은 수수료를 지불할 충분한 돈이 없습니다.",["ara"] = "ليس لدى المتلقي ما يكفي من المال لدفع الرسوم.",}
msg_lang["not_enough_giver"] = {["tha"] = "เงินหรือแต้มแลกเปลี่ยนไม่เพียงพอ",["tw"] = "沒有足夠的錢或兌換點",["en"] = "Not enough money or exchange points",["ita"] = "Non abbastanza soldi o punti di scambio",["tur"] = "Yeterli para veya değişim noktası yok",["ger"] = "Nicht genügend Geld oder Tauschpunkte",["cn"] = "没有足够的钱或兑换点",["jpn"] = "お金や交換ポイントが足りない",["ptb"] = "Não há dinheiro ou pontos de troca suficientes",["esn"] = "No hay suficiente dinero ni puntos de cambio.",["ind"] = "Tidak cukup uang atau poin penukaran",["vie"] = "Không đủ tiền hoặc đổi điểm",["msa"] = "Tidak cukup wang atau pertukaran mata",["rus"] = "Недостаточно денег или обменных пунктов",["fra"] = "Pas assez d'argent ni de points d'échange",["kor"] = "돈이나 환전 포인트가 부족해요",["ara"] = "لا يوجد ما يكفي من المال أو نقاط الصرف",}
msg_lang["fee_text"] = {["tha"] = "ค่าธรรมเนียม",["tw"] = "費用",["en"] = "fee",["ita"] = "tassa",["tur"] = "ücret",["ger"] = "Gebühr",["cn"] = "费用",["jpn"] = "手数料",["ptb"] = "taxa",["esn"] = "tarifa",["ind"] = "biaya",["vie"] = "phí",["msa"] = "Bayaran",["rus"] = "платеж",["fra"] = "frais",["kor"] = "요금",["ara"] = "مصاريف",}
msg_lang["give_success"] = {["tha"] = "มอบให้สำเร็จ",["tw"] = "成功給予",["en"] = "Successfully given",["ita"] = "Donato con successo",["tur"] = "Başarıyla verildi",["ger"] = "Erfolgreich vergeben",["cn"] = "成功给予",["jpn"] = "無事与えられました",["ptb"] = "Dado com sucesso",["esn"] = "dado con éxito",["ind"] = "Berhasil diberikan",["vie"] = "Đã trao thành công",["msa"] = "Berjaya diberi",["rus"] = "Успешно дано",["fra"] = "Donné avec succès",["kor"] = "성공적으로 제공됨",["ara"] = "تم تقديمه بنجاح",}
msg_lang["error_level"] = {["tha"] = "ทรัพย์สินของพวกคุณต่างกันเกินไป",["tw"] = "你們的資產相差太大了。",["en"] = "Your assets are too different.",["ita"] = "Le tue risorse sono troppo diverse.",["tur"] = "Varlıklarınız çok farklı.",["ger"] = "Ihr Vermögen ist zu unterschiedlich.",["cn"] = "你们的资产相差太大了。",["jpn"] = "資産が違いすぎます。",["ptb"] = "Seus ativos são muito diferentes.",["esn"] = "Tus activos son demasiado diferentes.",["ind"] = "Aset Anda terlalu berbeda.",["vie"] = "Tài sản của bạn quá khác biệt.",["msa"] = "Aset anda terlalu berbeza.",["rus"] = "Ваши активы слишком разные.",["fra"] = "Vos atouts sont trop différents.",["kor"] = "귀하의 자산이 너무 다릅니다.",["ara"] = "أصولك مختلفة جدًا.",}

local ui_data = {}
ui_data["interface"] = [[7347976277455562624]]
ui_data["ui_send"] = [[7347976277455562624_776]]
ui_data["exit_btn"] = [[7347976277455562624_779]]
ui_data["photo_reciver"] = [[7347976277455562624_778]]
ui_data["name_reciever"] = [[7347976277455562624_780]]
ui_data["give_btn"] = [[7347976277455562624_781]]
ui_data["fee_giver"] = [[7347976277455562624_806]]
--------------------------------------------------------------------------------
ui_data["ui_reciever"] = [[7347976277455562624_777]]
ui_data["photo_giver"] = [[7347976277455562624_783]]
ui_data["name_giver"] = [[7347976277455562624_784]]
ui_data["photo_items"] = [[7347976277455562624_788]]
ui_data["nums_items"] = [[7347976277455562624_789]]
ui_data["submit_btn"] = [[7347976277455562624_792]]
ui_data["cancel_btn"] = [[7347976277455562624_790]]
ui_data["fee_reciever"] = [[7347976277455562624_794]]
------------------------------Translate UI--------------------------------------
ui_data["itemshand_text"] = [[7347976277455562624_785]]
ui_data["fee_text"] = [[7347976277455562624_796]]
ui_data["cancel_text"] = [[7347976277455562624_791]]
ui_data["submit_text"] = [[7347976277455562624_793]]
--------------------------------------------------------------------------------
local PPA_Dalay = {}
local function delay_check(uid) if(PPA_Dalay[tostring(uid)] == "End" or PPA_Dalay[tostring(uid)] == nil) then local pass = "PASS" elseif(PPA_Dalay[tostring(uid)] == "Start") then local error_ = "TEST" * 1 print(error_) end end
local function THREAD_On(uid) delay_check(uid) if(PPA_Dalay[tostring(uid)] == nil or PPA_Dalay[tostring(uid)] == "End") then PPA_Dalay[tostring(uid)] = "Start" end end
local function THREAD_Off(uid) threadpool:wait(0.25) if(PPA_Dalay[tostring(uid)] == "Start") then PPA_Dalay[tostring(uid)] = "End" end end


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

local function alive(uid)
    local result,x,y,z=Actor:getPosition(uid)
    if(result == 0) then
        return true
    else
        return false
    end
end

local function findEqualDifference(a, b)
    return math.floor(math.max(a,b)/math.min(a,b))
end

local function getFee(uid, gi_re, itemid, itemnum, pvar_bank, limitFee) -- gi_re / 1 giver , 2 reciever
    local Fee_PremiumOne,Fee_PremiumMax,Fee_Premium = 20000,1500,{10,1}
    local Fee_NormalOne,Fee_NormalMax,Fee_Normal = 1000,200,{5,0.5}
    local RecieverFee = 30  --%
    local function getSubinString(mainString, subString)
        local count = 0
        local start = 1
        while true do
            local found = string.find(mainString, subString, start, true)
            if not found then
                break
            end
            count = count + 1
            start = found + 1
        end
            return count
    end
    local function getBaseNumber(n)
        local base = 1
        while n >= 10 do
            n = math.floor(n / 10)
            base = base * 10
        end
        return base
    end
    local code, balance = VarLib2:getPlayerVarByName(uid, 3, pvar_bank) --- BALANCE_BANKK
    local code, desc = Item:getItemDesc(itemid) 
    local numstar = getSubinString(desc, "★")
    local code, _max = Item:GetAttr(itemid, 2)
    local Fee = 999999999999
    if(numstar >= 1) then
        if(_max == 1) then
            Fee = Fee_PremiumOne + ((tonumber(balance)*Fee_Premium[1])/100)
        elseif(_max > 1) then
            Fee = (itemnum*Fee_PremiumMax*numstar) + ((tonumber(balance)*Fee_Premium[2])/100)
        end
    elseif(numstar == 0) then
        if(_max == 1) then
            Fee = Fee_NormalOne + ((tonumber(balance)*Fee_Normal[1])/100)
        elseif(_max > 1) then
            Fee = (itemnum*Fee_NormalMax) + ((tonumber(balance)*Fee_Normal[2])/100)
        end
    end
    Chat:sendSystemMsg(tostring(math.floor(Fee)), 1002203008)
    if(gi_re == 1) then
        return math.floor(math.min(tonumber(Fee),limitFee))
    elseif(gi_re == 2) then
        return math.floor(math.min(tonumber(Fee)/2.5,limitFee))
    else
        return math.floor(math.min(tonumber(Fee),limitFee))
    end
end
--------------------------------------------------------------------------------
local function Online(ppa)
    local uid = ppa.eventobjid
    Player_Data[tostring(uid)] = {true,0,{0,0,0,0}} -- {true,uid_reciver,{uid,itemid,itemnum,fee}}
    Customui:setText(uid, ui_data["interface"], ui_data["itemshand_text"], msg_lang["itemshand"][getLangCode(uid)])
    Customui:setText(uid, ui_data["interface"], ui_data["fee_text"], msg_lang["fee_text"][getLangCode(uid)])
    Customui:setText(uid, ui_data["interface"], ui_data["cancel_text"], msg_lang["cancel"][getLangCode(uid)])
    Customui:setText(uid, ui_data["interface"], ui_data["submit_text"], msg_lang["recieve"][getLangCode(uid)])
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], Online)

local function Offline(ppa)
    local uid = ppa.eventobjid
    Player_Data[tostring(uid)] = nil 
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], Offline)

local function clickplayer(ppa)   -- Click player
    local uid = ppa.eventobjid
    local pia = ppa.toobjid
    local resultp=Actor:isPlayer(pia)
    local result,id=Player:getCurToolID(uid)
    local result,scutIdx=Player:getCurShotcut(uid)
    print(scutIdx)
    id = id or 0
    if(resultp == 0 and id ~= 0 and Player_Data[tostring(uid)][1] == true and Player_Data[tostring(pia)][1] == true) then
        Customui:showElement(uid, ui_data["interface"], ui_data["ui_send"])
        Customui:setText(uid, ui_data["interface"], ui_data["itemshand_text"], msg_lang["itemshand"][getLangCode(uid)])
        Customui:setText(uid, ui_data["interface"], ui_data["fee_text"], msg_lang["fee_text"][getLangCode(uid)])
        Customui:setText(uid, ui_data["interface"], ui_data["cancel_text"], msg_lang["cancel"][getLangCode(uid)])
        Customui:setText(uid, ui_data["interface"], ui_data["submit_text"], msg_lang["recieve"][getLangCode(uid)])
        Player_Data[tostring(uid)][1] = false
        Player_Data[tostring(uid)][2] = pia
        local result,name=Player:getNickname(pia)
        local code, icon = Customui:getRoleIcon(pia)
        Customui:setText(uid, ui_data["interface"], ui_data["name_reciever"], name)
        Customui:setTexture(uid, ui_data["interface"], ui_data["photo_reciver"], icon)
        local result,itemid,num=Backpack:getGridItemID(uid,1000+scutIdx)
        local fee = getFee(uid, 1, itemid, num, Money_Pvar, 1000000)
        Customui:setText(uid, ui_data["interface"], ui_data["fee_giver"], "-"..tostring(fee))
    end
end
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], clickplayer)

local function close_swap(ppa)   -- CLOSE
    local uid = ppa.eventobjid
    if(Player_Data[tostring(uid)][1] == false) then
        Player_Data[tostring(uid)][1] = true
        Player_Data[tostring(uid)][2] = 0
        Customui:hideElement(uid, ui_data["interface"], ui_data["ui_send"])
    end
end
ScriptSupportEvent:registerEvent([=[Player.SelectShortcut]=], close_swap)
ScriptSupportEvent:registerEvent([=[Player.ShortcutChange]=], close_swap)

local function btn_click(ppa) -- OPEN 
    local uid = ppa.eventobjid
    local result,scutIdx=Player:getCurShotcut(uid)
    local result,itemid,num=Backpack:getGridItemID(uid,1000+scutIdx)
    THREAD_On(uid)
    if(ppa.uielement == ui_data["exit_btn"]) then  -- close
        Player_Data[tostring(uid)][1] = true
        Player_Data[tostring(uid)][2] = 0
        Customui:hideElement(uid, ui_data["interface"], ui_data["ui_send"])
    elseif(ppa.uielement == ui_data["give_btn"]) then
        if(Player_Data[tostring(Player_Data[tostring(uid)][2])][1] == true) then
            local pid = Player_Data[tostring(uid)][2]
            local code, balanceGiver = VarLib2:getPlayerVarByName(uid, 3, Money_Pvar)
            local code, balanceReciever = VarLib2:getPlayerVarByName(pid, 3, Money_Pvar)
            if(findEqualDifference(balanceGiver, balanceReciever) <= 100) then
                local code, gift_point = VarLib2:getPlayerVarByName(uid, 3, Exchange_Point)
                local fee = getFee(uid, 1, itemid, num, Money_Pvar, 1000000)
                if(gift_point >= 1 and balanceGiver >= fee) then
                    Customui:hideElement(uid, ui_data["interface"], ui_data["ui_send"])
                    Backpack:removeGridItem(uid,1000+scutIdx)
                    VarLib2:setPlayerVarByName(uid, 3, Money_Pvar, balanceGiver - fee)
                    VarLib2:setPlayerVarByName(uid, 3, Exchange_Point, gift_point - 1)
                    Player:notifyGameInfo2Self(uid, "#G"..".-.-.-.-.")
                    threadpool:wait(3)
                    if(alive(uid) == true and alive(uid) == true) then
                        Player_Data[tostring(uid)][1] = true
                        Player_Data[tostring(uid)][2] = 0
                        Player_Data[tostring(pid)][1] = "Reciever"
                        Player_Data[tostring(pid)][2] = 0
                        Player_Data[tostring(pid)][3] = {uid,itemid,num,fee}
                        local code, iconplayer = Customui:getRoleIcon(uid)
                        local code, iconitem = Customui:getItemIcon(itemid)
                        local result,name=Player:getNickname(uid)
                        Customui:setTexture(pid, ui_data["interface"], ui_data["photo_giver"], iconplayer)
                        Customui:setTexture(pid, ui_data["interface"], ui_data["photo_items"], iconitem)
                        Customui:setText(pid, ui_data["interface"], ui_data["name_giver"], name)
                        Customui:setText(pid, ui_data["interface"], ui_data["nums_items"], "x"..tostring(num))
                        local fee_rec = getFee(pid, 2, itemid, num, Money_Pvar, 1000000)
                        Customui:setText(pid, ui_data["interface"], ui_data["fee_reciever"], tostring(fee_rec))
                        Customui:PlayElementAnim(pid, ui_data["interface"], ui_data["ui_reciever"], 10001, 0.8, 2)
                    end
                else
                    Player:notifyGameInfo2Self(uid, "#R"..msg_lang["not_enough_giver"][getLangCode(uid)])
                end
            else
                Player:notifyGameInfo2Self(uid, "#R"..msg_lang["error_level"][getLangCode(uid)])
            end
        elseif(Player_Data[tostring(Player_Data[tostring(uid)][2])][1] == false or Player_Data[tostring(Player_Data[tostring(uid)][2])][1] == "Reciever") then
            Player:notifyGameInfo2Self(uid, "#R"..msg_lang["not_pre"][getLangCode(uid)])
        end
    elseif(ppa.uielement == ui_data["cancel_btn"] and Player_Data[tostring(uid)][1] == "Reciever") then
        Customui:hideElement(uid, ui_data["interface"], ui_data["ui_reciever"])
        local pid = Player_Data[tostring(uid)][3][1]
        Player_Data[tostring(uid)][1] = true
        Player_Data[tostring(uid)][2] = 0
        local code, balanceGiver = VarLib2:getPlayerVarByName(pid, 3, Money_Pvar)
        VarLib2:setPlayerVarByName(pid, 3, Money_Pvar, balanceGiver+((Player_Data[tostring(uid)][3][4]*90)/100))
        Player:notifyGameInfo2Self(pid, "#B"..msg_lang["refunded"][getLangCode(pid)])
        Player:gainItems(pid,Player_Data[tostring(uid)][3][2],Player_Data[tostring(uid)][3][3],1)
    elseif(ppa.uielement == ui_data["submit_btn"] and Player_Data[tostring(uid)][1] == "Reciever") then
        local pid = Player_Data[tostring(uid)][3][1]
        Customui:hideElement(uid, ui_data["interface"], ui_data["ui_reciever"])
        local fee_rec = getFee(uid, 2, Player_Data[tostring(uid)][3][2],  Player_Data[tostring(uid)][3][3], Money_Pvar, 1000000)
        Player:gainItems(uid,Player_Data[tostring(uid)][3][2],Player_Data[tostring(uid)][3][3],1)
        local code, balanceReciever = VarLib2:getPlayerVarByName(uid, 3, Money_Pvar)
        VarLib2:setPlayerVarByName(uid, 3, Money_Pvar, balanceReciever-fee_rec)
        Player_Data[tostring(uid)][1] = true
        Player_Data[tostring(uid)][2] = 0
        Player:notifyGameInfo2Self(pid, "#G"..msg_lang["give_success"][getLangCode(pid)])
        Player:notifyGameInfo2Self(uid, "#G"..msg_lang["re_success"][getLangCode(uid)])
    end
    THREAD_Off(uid)
end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], btn_click)























