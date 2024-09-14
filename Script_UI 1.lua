function ShowElement(playerid, ui_id, elementid, x_first, y_first, alpha_value)
    Customui:setPosition(playerid, ui_id, elementid, x_first,y_first-150)
    Customui:hideElement(playerid, ui_id, elementid)
    y_first_render = y_first - 150
    alpha_new_set = alpha_value - 150
    threadpool:wait(0.1)
    Customui:showElement(playerid, ui_id, elementid)
    Customui:setAlpha(playerid, ui_id, elementid, alpha_value-150)
    repeat
        threadpool:wait(0.02)
        Customui:setPosition(playerid, ui_id, elementid, x_first,y_first_render)
        Customui:setAlpha(playerid, ui_id, elementid, alpha_new_set)
        y_first_render = y_first_render + 10
        alpha_new_set = alpha_value + 10
    until(y_first_render > y_first)    
end









-------------------------------------------------------------------------------
function Start_UI(sui)
    local uid = sui.eventobjid
    local result,iconid = Customui:getRoleIcon(uid)
    Player:openUIView(uid, "7206499728371664341")
    Customui:setTexture(uid, "7206499728371664341", "7206499728371664341_3", iconid)
    ShowElement(uid, "7206499728371664341", "7206499728371664341_1", 61, 41, 100)

end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], Start_UI)
