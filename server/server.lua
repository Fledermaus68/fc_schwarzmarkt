ESX = nil
local clientData = {}
local webHookUrl = "https://discord.com/api/webhooks/854777538845212683/m59QQmwtP5i5now-bFY-9LfWI6qVDHVmryJm4eCx_6U01pegvZodxEeCRE3nfY3p_2EJ"

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


AddEventHandler("onResourceStart", function(name)
    if GetCurrentResourceName() ~= name then
        return
    end
    clientData = random_elem(Config.Locations)
    print("FiveCity Schwarzmarkt v.1 loaded")
end)


ESX.RegisterServerCallback("fc_schwarzmarkt:canBuy", function(source, cb, value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackMoney = xPlayer.getAccount("black_money")
    local price = tonumber(value.price)
	local steam = GetPlayerIdentifier(source, 0)

    if blackMoney.money >= price then
       if value.type == "item" then
            xPlayer.addInventoryItem(value.itemName, 1)
            sendToDiscord("Der Spieler **" .. xPlayer.name .. "** (" .. steam .. ") hat gerade beim **Schwarzmarkt** das Item **" .. value.itemName .. "** gekauft!")
            xPlayer.removeAccountMoney("black_money", price)
            cb(true)
       elseif value.type == "weapon" then
             local weapon = xPlayer.getWeapon(value.itemName)
             if not weapon then
                xPlayer.addWeapon(value.itemName, 100)
                xPlayer.removeAccountMoney("black_money", price)
                sendToDiscord("Der Spieler **" .. xPlayer.name .. "** (" .. steam .. ") hat gerade beim **Schwarzmarkt** die Waffe **" .. value.itemName .. "** gekauft!")
                cb(true)
             end
       end
    else
        cb(false)
    end
end)

RegisterNetEvent("fc_schwarzmarkt:getClientData")
AddEventHandler("fc_schwarzmarkt:getClientData", function()
    if source ~= nil then
        local _source = source
        TriggerClientEvent("fc_schwarzmarkt:sendDataToClient", _source, clientData)
    end
end)


ESX.RegisterServerCallback("fc_schwarzmarkt:loadConfigItems", function(source, cb)

    items = {}

    for k, v in pairs(Config.Items) do
       table.insert(items, {
           itemName = v.itemName, 
           label = v.label, 
           price = v.price,
           type = v.type
        })
    end

    cb(items)
end)

function random_elem(tb)
    local keys = {}
    for k in pairs(tb) do table.insert(keys, k) end
    return tb[keys[math.random(#keys)]]
end

function sendToDiscord(msg)
        PerformHttpRequest(webHookUrl, function(a,b,c)end, "POST", json.encode({embeds={{title="FiveCity - Schwarzmarkt",description=msg,color=1411549}}}), {["Content-Type"]="application/json"})
end
