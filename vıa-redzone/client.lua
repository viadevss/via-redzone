
local redZones = { --REDZONE BÖLGELERİ BURAYA EKLENECEKTİR SINIRSIZ EKLENEBİLİR --VIA DEVELOPMENT
    {
        -- x = 2719.26,    -- x koordinatı 
        -- y = 1527.8,    -- y koordinatı
        -- z = 24.5,    -- z kordinatı
        -- radius = 170.0,   -- BÜYÜKLÜK
        -- visibleDistance = 750.0, -- REDZONENIN GÖRÜNME UZAKLIGI
        -- color = {r = 255, g = 0, b = 0, a = 128} -- RENK AYARI
    },
}

local isInRedZone = {}

for i = 1, #redZones do
    isInRedZone[i] = false
end


-- OYUNCUNUN REDZONEYE GİRDİĞİNDE BİLDİRİM GELMESİ -VIA DEVELOPMENT
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i, redZone in ipairs(redZones) do
            local distance = #(vector3(redZone.x, redZone.y, redZone.z) - playerCoords)

            if distance < redZone.radius then
                if not isInRedZone[i] then
                    isInRedZone[i] = true
                    TriggerEvent('QBCore:Notify', 'Red Zone\'a girdiniz!', 'error')
                end
            else
                if isInRedZone[i] then
                    isInRedZone[i] = false
                    TriggerEvent('QBCore:Notify', 'Red Zone\'dan çıktınız!', 'success')
                end
            end
            if distance < redZone.visibleDistance then
                DrawMarker(28, redZone.x, redZone.y, redZone.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, redZone.radius, redZone.radius, redZone.radius, redZone.color.r, redZone.color.g, redZone.color.b, redZone.color.a, false, false, 2, false, nil, nil, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, redZone in ipairs(redZones) do
        local blip = AddBlipForRadius(redZone.x, redZone.y, redZone.z, redZone.radius)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 128)
    end
end)
