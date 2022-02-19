-- Config
local Config = {
	x = 0.165,
	y = 0.95,
    scale = 0.40,

    WhisperDistance = 2.0,
    NormalDistance = 10.0,
    ShoutingDistance = 30.0,
    
    Keybind = 20
}

local Config2 = {
	x2 = 0.157,
	y2 = 0.97,
    scale = 0.40,
}

local InputWhisper = false
local InputNormal = true
local InputShouting = false
local isTalking = false
local CurrentDistance = Config.NormalDistance

function InputText(text, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(Config.x, Config.y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, Config.Keybind) then
            if InputWhisper == true then
                MumbleSetAudioInputDistance(Config.NormalDistance)
                -- MumbleSetAudioOutputDistance(Config.NormalDistance)
                CurrentDistance = Config.NormalDistance
                InputWhisper = false
                InputNormal = true
                InputShouting = false
            elseif InputNormal == true then
                MumbleSetAudioInputDistance(Config.ShoutingDistance)
                -- MumbleSetAudioOutputDistance(Config.ShoutingDistance)
                CurrentDistance = Config.ShoutingDistance
                InputWhisper = false
                InputNormal = false
                InputShouting = true
            elseif InputShouting == true then
                MumbleSetAudioInputDistance(Config.WhisperDistance)
                -- MumbleSetAudioOutputDistance(Config.WhisperDistance)
                CurrentDistance = Config.WhisperDistance
                InputWhisper = true
                InputNormal = false
                InputShouting = false
            end
        end
        if IsControlPressed(1, Config.Keybind) then
            local pedCoords = GetEntityCoords(PlayerPedId())
            --DrawMarker(1, pedCoords.x, pedCoords.y, pedCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, CurrentDistance * 2.0, CurrentDistance * 2.0, 1.0, 40, 140, 255, 150, false, false, 2, false, nil, nil, false)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

        if isTalking == false then
            if NetworkIsPlayerTalking(PlayerId()) then
                isTalking = true
            end
        else
            if NetworkIsPlayerTalking(PlayerId()) == false then
                isTalking = false
            end
        end
	end
end)
-- icon hud
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if InputWhisper == true and isTalking == false then
            InputText("🔈", Config.scale)
        elseif InputNormal == true and isTalking == false then
            InputText("🔉", Config.scale)
        elseif InputShouting == true and isTalking == false then
            InputText("🔊", Config.scale)
        elseif InputWhisper == true and isTalking == true then
            InputText("🔈", Config.scale)
        elseif InputNormal == true and isTalking == true then
            InputText("🔉", Config.scale)
        elseif InputShouting == true and isTalking == true then
            InputText("🔊", Config.scale)
        end
    end
end)
-- W/N/S hud
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetTextScale(0.0, 0.3)
        SetTextFont(6)
        SetTextProportional(1)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        if InputWhisper == true and isTalking == false then
            SetTextEntry("STRING")
            AddTextComponentString("W")
            DrawText(Config2.x2, Config2.y2)
        elseif InputNormal == true and isTalking == false then
            SetTextEntry("STRING")
            AddTextComponentString("N")
            DrawText(Config2.x2, Config2.y2)
        elseif InputShouting == true and isTalking == false then
            SetTextEntry("STRING")
            AddTextComponentString("S")
            DrawText(Config2.x2, Config2.y2)
       elseif InputWhisper == true and isTalking == true then
            SetTextEntry("STRING")
            AddTextComponentString("~b~W")
            DrawText(Config2.x2, Config2.y2)
        elseif InputNormal == true and isTalking == true then
            SetTextEntry("STRING")
            AddTextComponentString("~b~N")
            DrawText(Config2.x2, Config2.y2)
        elseif InputShouting == true and isTalking == true then
            SetTextEntry("STRING")
            AddTextComponentString("~b~S")
            DrawText(Config2.x2, Config2.y2)
        end
    end
end)
