local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("mVein-sigorta:araclar", function(source, cb)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    MySQL.query("SELECT * FROM player_vehicles WHERE citizenid = ?", { xPlayer.PlayerData.citizenid
    }, function (data)
        cb(data)
    end) 
end)

RegisterNetEvent('mVein-sigorta:buysigorta')
AddEventHandler('mVein-sigorta:buysigorta', function(money, plate)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayerBank = xPlayer.PlayerData.money.bank
    moneys = QBCore.Shared.Round(json.encode(money.money))
    if xPlayerBank >= moneys then
        xPlayer.Functions.RemoveMoney('bank', moneys)
        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Başarıyla Sigorta Satın Aldın.", "success")
        exports.oxmysql:execute("SELECT * FROM player_vehicles WHERE plate = @plate", {
            ['@plate'] = plate
        }, function(result)
            if result[1] then
            exports["oxmysql"]:execute("UPDATE player_vehicles SET sigorta=@s WHERE plate=@p",{
                ['@p'] = plate,
                ['@s'] = os.time()
            })
            end
        end)
    else
        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Bankanda Yeterince Paran Yok!", "error")
    end
end)

CreateThread(function()
    while true do Wait(5 * 60 * 1000) --Her 10 dakikada bir
        exports["oxmysql"]:execute("SELECT * FROM player_vehicles",{},function(result)
            if result then
                for k,v in ipairs(result) do -- Haftalık süre biçimi, aylik süre biçimi
                    local sure = 1296000*2
                    if os.time() - tonumber(v.sigorta) >= tonumber(sure) then
                        exports["oxmysql"]:execute("UPDATE player_vehicles SET sigorta=@s WHERE plate=@p",{
                            ['@p'] = plate,
                            ['@s'] = 0
                        })
                    end
                end
            end
        end)
    end 
end)