local player_shop ={}
-------------------------------
local STORE_NAME = "Gun_shop"
local ui_data = {}
ui_data["interface"] = [[7347976277455562624]]
ui_data["main_shop"] = [[7347976277455562624_16]]
ui_data["background"] = [[7347976277455562624_114]]
ui_data["close"] = [[7347976277455562624_125]]
ui_data["btn_purchase"] = [[7347976277455562624_156]]
ui_data["image_purchase"] = [[7347976277455562624_158]]
local colored = {0xdcdcdc,0x8f9190}
local sound_click = 10971
local sound_open = 10946

local text = {}
text[1] = "#Gซื้อสำเร็จ"
text[2] = "#Rเงินไม่เพียงพอ"

local default_data = [[7347976277455562624_126]]
local Shop_Menu = {}
Shop_Menu[tostring([[7347976277455562624_126]])] = {
    Menu_Name = "Machine Gun",
    product = {
	    {Img=[[7347976277455562624_17]],ImageMoney=[[7347976277455562624_41]],show_price=[[7347976277455562624_24]],Btn="[[7347976277455562624_159]]",ItemsID={15003},price=10,MoneyId=4121,count={20},showatk=[[7347976277455562624_35]],atk=0},
        {Img=[[7347976277455562624_20]],ImageMoney=[[7347976277455562624_42]],show_price=[[7347976277455562624_26]],Btn="[[7347976277455562624_160]]",ItemsID={4105},price=300,MoneyId=4121,count={20},showatk=[[7347976277455562624_36]],atk=25},
	    {Img=[[7347976277455562624_21]],ImageMoney=[[7347976277455562624_43]],show_price=[[7347976277455562624_25]],Btn="[[7347976277455562624_161]]",ItemsID={4111},price=500,MoneyId=4121,count={1},showatk=[[7347976277455562624_38]],atk=15},
	    {Img=[[7347976277455562624_22]],ImageMoney=[[7347976277455562624_44]],show_price=[[7347976277455562624_27]],Btn="[[7347976277455562624_162]]",ItemsID={4107},price=400,MoneyId=4121,count={1},showatk=[[7347976277455562624_40]],atk=6},
	    {Img=[[7347976277455562624_23]],ImageMoney=[[7347976277455562624_45]],show_price=[[7347976277455562624_28]],Btn="[[7347976277455562624_163]]",ItemsID={4110},price=800,MoneyId=4121,count={1},showatk=[[7347976277455562624_37]],atk=3},
    }
}

Shop_Menu[tostring([[7347976277455562624_128]])] = {
    Menu_Name = "Pistol Gun",
    product = {
	    {Img=[[7347976277455562624_17]],ImageMoney=[[7347976277455562624_41]],show_price=[[7347976277455562624_24]],Btn="[[7347976277455562624_159]]",ItemsID={4154},price=150,MoneyId=4121,count={1},showatk=[[7347976277455562624_35]],atk=25},
	{Img=[[7347976277455562624_20]],ImageMoney=[[7347976277455562624_42]],show_price=[[7347976277455562624_26]],Btn="[[7347976277455562624_160]]",ItemsID={4106},price=250,MoneyId=4121,count={1},showatk=[[7347976277455562624_36]],atk=30},
	{Img=[[7347976277455562624_21]],ImageMoney=[[7347976277455562624_43]],show_price=[[7347976277455562624_25]],Btn="[[7347976277455562624_161]]",ItemsID={4155},price=300,MoneyId=4121,count={1},showatk=[[7347976277455562624_38]],atk=30},
	{Img=[[7347976277455562624_22]],ImageMoney=[[7347976277455562624_44]],show_price=[[7347976277455562624_27]],Btn="[[7347976277455562624_162]]",ItemsID={4153},price=350,MoneyId=4121,count={1},showatk=[[7347976277455562624_40]],atk=45},
	{Img=[[7347976277455562624_23]],ImageMoney=[[7347976277455562624_45]],show_price=[[7347976277455562624_28]],Btn="[[7347976277455562624_163]]",ItemsID={4108},price=400,MoneyId=4121,count={1},showatk=[[7347976277455562624_37]],atk=70},
    }
}

Shop_Menu[tostring([[7347976277455562624_130]])] = {
    Menu_Name = "Premium Gun",
    product = {
	    {Img=[[7347976277455562624_17]],ImageMoney=[[7347976277455562624_41]],show_price=[[7347976277455562624_24]],Btn="[[7347976277455562624_159]]",ItemsID={4104},price=3,MoneyId=4130,count={1},showatk=[[7347976277455562624_35]],atk=80},
	    {Img=[[7347976277455562624_20]],ImageMoney=[[7347976277455562624_42]],show_price=[[7347976277455562624_26]],Btn="[[7347976277455562624_160]]",ItemsID={4103},price=3,MoneyId=4130,count={1},showatk=[[7347976277455562624_36]],atk=100},
	    {Img=[[7347976277455562624_21]],ImageMoney=[[7347976277455562624_43]],show_price=[[7347976277455562624_25]],Btn="[[7347976277455562624_161]]",ItemsID={4160},price=5,MoneyId=4130,count={1},showatk=[[7347976277455562624_38]],atk=15},
	    {Img=[[7347976277455562624_22]],ImageMoney=[[7347976277455562624_44]],show_price=[[7347976277455562624_27]],Btn="[[7347976277455562624_162]]",ItemsID={4113},price=5,MoneyId=4130,count={1},showatk=[[7347976277455562624_40]],atk=150},
	    {Img=[[7347976277455562624_23]],ImageMoney=[[7347976277455562624_45]],show_price=[[7347976277455562624_28]],Btn="[[7347976277455562624_163]]",ItemsID={4159},price=15,MoneyId=4130,count={1},showatk=[[7347976277455562624_37]],atk=200},
    }
}

	

---------------------------------------------------------------------------------------------
local function getBtnData(uid,btn_id)
    local menu = player_shop[tostring(uid)][2]
    for i,v in pairs(Shop_Menu[tostring(menu)]["product"]) do
        if(tostring("[["..btn_id.."]]") == v["Btn"]) then
            return {true, Shop_Menu[tostring(menu)]["product"][i]}
        end
    end
    return {nil}
end

local function refresh_product(uid)
    local menu = player_shop[tostring(uid)][2]
    for i,v in pairs(Shop_Menu[tostring(menu)]["product"]) do
        local code, icon = Customui:getItemIcon(v["ItemsID"][1])
        local code = Customui:setTexture(uid, ui_data["interface"], v["Img"], icon) -- Product img
        local code, icon2 = Customui:getItemIcon(v["MoneyId"])
        local code = Customui:setTexture(uid, ui_data["interface"], v["ImageMoney"], icon2) -- Money img
        local code = Customui:setText(uid, ui_data["interface"], v["show_price"], tostring(v["price"]))
        local code = Customui:setText(uid, ui_data["interface"], v["showatk"], "ATK "..tostring(v["atk"]+20))
    end
end

local function getFirstMenu()
    return default_data
end

local function getitemnum(uid,itemid)
    local itemnum = 0
    local result,num1,arr1=Backpack:getItemNumByBackpackBar(uid,1,itemid)
    local result,num2,arr2=Backpack:getItemNumByBackpackBar(uid,2,itemid)
    return num1 + num2
end

local function open_UI(uid)
    Customui:PlayElementAnim(uid, ui_data["interface"],ui_data["background"], 10001, 0.4, 2)
    Customui:PlayElementAnim(uid, ui_data["interface"],ui_data["main_shop"], 10001, 0.4, 2)
    Customui:hideElement(uid, ui_data["interface"], ui_data["btn_purchase"])
    Customui:hideElement(uid, ui_data["interface"], ui_data["image_purchase"])
    player_shop[tostring(uid)] = {STORE_NAME, getFirstMenu(), 0, ""}
    refresh_product(uid)
    Player:playMusic(uid,sound_open,70,1,false)
end

local function close_UI(uid)
    Customui:PlayElementAnim(uid, ui_data["interface"],ui_data["background"], 20001, 0.4, 2)
    Customui:PlayElementAnim(uid, ui_data["interface"],ui_data["main_shop"], 20001, 0.4, 2)
    player_shop[tostring(uid)] = {STORE_NAME, getFirstMenu(), 0, ""}
    refresh_product(uid)
    Player:playMusic(uid,sound_open,70,1,false)
    for i,v in pairs(Shop_Menu) do
        local code = Customui:setColor(uid, ui_data["interface"], i, colored[2])
    end
    local code = Customui:setColor(uid, ui_data["interface"], getFirstMenu(), colored[1])
end
---------------------------------------------------------------------------------------------
local function add_player(add)
    local uid = add.eventobjid
    player_shop[tostring(uid)] = {STORE_NAME, getFirstMenu(), 0, ""}
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], add_player)

local function ClickToClose(ctc)
    local uid = ctc.eventobjid
    local data_buy = getBtnData(uid,ctc.uielement)
    if(ctc.uielement == ui_data["close"]) then
        close_UI(uid)
    elseif(data_buy[1] ~= nil) then
        player_shop[tostring(uid)][4] = data_buy
        local code, icon3 = Customui:getItemIcon(data_buy[2]["ItemsID"][1])
        local code = Customui:setTexture(uid, ui_data["interface"], ui_data["image_purchase"], icon3) -- Money img
        Customui:showElement(uid, ui_data["interface"], ui_data["btn_purchase"])
        Customui:showElement(uid, ui_data["interface"], ui_data["image_purchase"])
        Player:playMusic(uid,sound_click,70,1,false)
    elseif(ctc.uielement == ui_data["btn_purchase"]) then --- Purchase Purchase Purchase Purchase Purchase Purchase Purchase Purchase
        local data_buy = player_shop[tostring(uid)][4]
        local money_enouhgt = getitemnum(uid,data_buy[2]["MoneyId"])
        if(money_enouhgt >= data_buy[2]["price"]) then
            Player:removeBackpackItem(uid,data_buy[2]["MoneyId"],data_buy[2]["price"])
            for i,v in pairs(data_buy[2]["ItemsID"]) do
                Player:gainItems(uid,v,data_buy[2]["count"][i],1)
            end
            Player:notifyGameInfo2Self(uid,text[1])
            Player:playMusic(uid,10947,70,1,false)
            Customui:hideElement(uid, ui_data["interface"], ui_data["btn_purchase"])
            Customui:hideElement(uid, ui_data["interface"], ui_data["image_purchase"])
        elseif(money_enouhgt < data_buy[2]["price"]) then
            Player:notifyGameInfo2Self(uid,text[2])
            Player:playMusic(uid,10949,70,1,false)
        end
    elseif(Shop_Menu[(tostring(ctc.uielement))] ~= nil) then
        player_shop[tostring(uid)][2] = tostring(ctc.uielement)
        for i,v in pairs(Shop_Menu) do
            local code = Customui:setColor(uid, ui_data["interface"], i, colored[2])
        end
        local code = Customui:setColor(uid, ui_data["interface"], tostring(ctc.uielement), colored[1])
        refresh_product(uid)
        Player:playMusic(uid,sound_click,70,1,false)
    end
end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], ClickToClose)

------------------------------------------More Function---------------------------------------------
local function ctype_monster(uid,id_check)
    local result,actorid=Creature:getActorID(uid)
    if actorid == id_check then
        return true
    else
        return false
    end
end
------------------------------------------Open Close-----------------------------------------
local function open_ibterface(add)
    local uid = add.eventobjid
    local pid = add.toobjid
    if(ctype_monster(pid,2) == true) then
        open_UI(uid)
    end
end
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], open_ibterface)










