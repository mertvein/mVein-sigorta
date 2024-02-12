local QBCore = exports['qb-core']:GetCoreObject()

local money = 0

local aracbenim = false

CreateThread(function()
    Config.Vehicles = QBCore.Shared.Vehicles

    for k, v in pairs(Config.Vehicles) do
        v.price = (v.price * 10) / 100
    end
end)

RegisterNetEvent('mVein-sigorta:menuopen')
AddEventHandler('mVein-sigorta:menuopen', function()
    local elements = {}
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))
    aracbenim = false
    QBCore.Functions.TriggerCallback("mVein-sigorta:araclar", function(data)
        for i = 1, #data do
            local CurrentVehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
            if data[i].plate == CurrentVehPlate then  
                local sigortali = tonumber(data[i].sigorta) 
                aracbenim = true 
                if sigortali == 0 or not data[i].sigorta then
                    for k, car in pairs(Config.Vehicles) do 
                        if GetHashKey(model) == GetHashKey(car.model) then
                            money = math.floor(car.price)
                            tables = {
                                {
                                    icon = "fas fa-file",
                                    isMenuHeader = true,
                                    header = "Sigorta Sistemi",
                                    txt = car.model:upper()..' model aracının sigortasını yenileme vaktin geldi.',
                                }
                            }
                            if aracbenim then
                                table.insert(tables, 
                                {
                                    header = "Sigorta Durumu: Sigortasız",
                                    txt = money.."$ karşılığında "..car.model:upper().." aracının sigortasını yenile.",
                                    params = {
                                        event = "sigorta:yenile",
                                        args = {
                                            money = money,
                                        },
                                    }
                                }
                            )
                            end
                            exports["qb-menu"]:openMenu(tables)
                        end
                    end
                else
                    tabless = {
                        {
                            icon = "fas fa-documents",
                            isMenuHeader = true,
                            header = "Sigorta Durumu: Sigortalı",
                            txt = "Araç sigortanı yenilemene daha var."
                        }
                    }
                    exports["qb-menu"]:openMenu(tabless)
                end
            end
        end
    end)
end)

RegisterNetEvent('sigorta:yenile', function(money)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    TriggerServerEvent("mVein-sigorta:buysigorta", money, plate)
end)

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local kordinat = {
    {x = -23.46, y = -1094.24, z = 27.14},
}

CreateThread(function()
    while true do
        time = 2500
        for k,v in pairs(kordinat) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if IsPedInAnyVehicle(PlayerPedId(), true) then
                if dist <= 7 then
                    time = 1
                    DrawText3Ds(v.x, v.y, v.z -0.2, "[~b~E~w~] - Araç Sigortası")
                    if IsControlJustPressed(0, Keys['E']) then
                        time = 1
                        TriggerEvent('mVein-sigorta:menuopen')
                    end
                end
            end
        end
        Wait(time)
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 300
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end