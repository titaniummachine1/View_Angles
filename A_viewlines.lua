--[[draws projectile trajectories]]

local function OnCreateMove(pCmd)
    --
end


local myfont = draw.CreateFont("Verdana", 16, 800) -- Create a font for doDraw

local function doDraw()
    local pLocal = entities.GetLocalPlayer()
    if not pLocal or engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end

    draw.SetFont(myfont)
    draw.Color(255, 255, 255, 255)
    local w, h = draw.GetScreenSize()
    local screenPos = { w / 2 - 15, h / 2 + 35}

    local players = entities.FindByClass("CTFPlayer")  -- Create a table of all players in the game
    for i, vPlayer in pairs(players) do
        if not vPlayer:IsAlive() or vPlayer:IsDormant() or pLocal:GetIndex() == vPlayer:GetIndex() then goto continue end

           local source = vPlayer:GetAbsOrigin() + vPlayer:GetPropVector("localdata", "m_vecViewOffset[0]")
            local viewAngles = vPlayer:GetPropVector("tfnonlocaldata", "m_angEyeAngles[0]")
            local forwardVector = viewAngles:Forward()
            local destination = source + forwardVector * 1000

            local trace = engine.TraceLine(source, destination, MASK_SHOT_HULL)

                local startPos = source
                local endPos = trace.endpos
                local startScreenPos = client.WorldToScreen(startPos)
                local endScreenPos = client.WorldToScreen(endPos)

                if startScreenPos ~= nil and endScreenPos ~= nil then
                    draw.Line(startScreenPos[1], startScreenPos[2], endScreenPos[1], endScreenPos[2])
                end
        
        ::continue::
    end
end


callbacks.Register("Draw", doDraw)


--[[ Remove the vPlayernu when unloaded ]]--
local function OnUnload()                                -- Called when the script is unloaded
    client.Command('play "ui/buttonclickrelease"', true) -- Play the "buttonclickrelease" sound
end


--[[ Unregister previous callbacks ]]--
callbacks.Unregister("CreateMove", "MCT_CreateMove")            -- Unregister the "CreateMove" callback
callbacks.Unregister("Unload", "MCT_Unload")                    -- Unregister the "Unload" callback
callbacks.Unregister("Draw", "MCT_Draw")                        -- Unregister the "Draw" callback

--[[ Register callbacks ]]--
callbacks.Register("CreateMove", "MCT_CreateMove", OnCreateMove)             -- Register the "CreateMove" callback
callbacks.Register("Unload", "MCT_Unload", OnUnload)                         -- Register the "Unload" callback
callbacks.Register("Draw", "MCT_Draw", doDraw)                               -- Register the "Draw" callback
--[[ Play sound when loaded ]]--
client.Command('play "ui/buttonclick"', true) -- Play the "buttonclick" sound when the script is loaded