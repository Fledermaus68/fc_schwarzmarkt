local open = false
local clientData = {}
local inMarker = false

ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  TriggerServerEvent("fc_schwarzmarkt:getClientData")
  toggleUI(false)
  Citizen.Wait(1000)
  ESX.TriggerServerCallback('fc_schwarzmarkt:loadConfigItems', function(items)
      for k, v in pairs(items) do
          AddItem(v.itemName, v.label, v.price, v.type)
      end
  end)
end)

RegisterNetEvent("fc_schwarzmarkt:sendDataToClient")
AddEventHandler("fc_schwarzmarkt:sendDataToClient", function(data)
  clientData = data
end)


Citizen.CreateThread(function()

    while clientData.location == nil or clientData.heading == nil do
        Wait(1.0)
    end
    
    RequestModel(Config.pedModel)

    while not HasModelLoaded(Config.pedModel) do
        Wait(1.0)
    end

    RequestAnimDict("mini@strip_club@idles@bouncer@base")
    while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
    end

    local ped = CreatePed(4, 0xB3B3F5E6, clientData.location, 10, false, false)
        SetEntityHeading(ped, clientData.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)

end)

Citizen.CreateThread(function()

    while clientData.location == nil do
        Wait(1.0)
    end

    while true do
        Citizen.Wait(1.0)

        local playerLocation = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(playerLocation, clientData.location, true)

        if distance < 2.0 then
            inMarker = true
            ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um den ~b~Schwarzmarkt~w~ zu öffnen!")
        else
            inMarker = false
        end

        if IsControlJustPressed(1, 51) and inMarker then
            inMarker = false
            if open then
                toggleUI(false)
            else
                toggleUI(true)
            end            
        end
    end
end)

function toggleUI(enable)
    SetNuiFocus(enable, enable)
    open = enable


    if enable then
        SendNUIMessage({
            action = "open"
        })
    else
        SendNUIMessage({
            action = "close"
        })
    end
end

RegisterNUICallback("close", function(data, cb)
    toggleUI(false)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("buy", function(data, cb)
    ESX.TriggerServerCallback("fc_schwarzmarkt:canBuy", function(canBuy)
        if canBuy then
            ESX.ShowNotification("Dein ~g~Kauf~w~ wurde getätigt.")
        else
            ESX.ShowNotification("Du hast nicht genügend ~r~Schwarzgeld ~w~dabei!")
        end
    end, data)
end)

function AddItem(itemName, label, price, type)
    SendNUIMessage({
        action = "add",
        itemName = itemName,
        label = label,
        price = price,
        type = type
    })
end

