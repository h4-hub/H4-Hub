-- H4-Hub 🗡 | Unified MM2 Script Hub
-- Vortex-based GUI with all top public features combined

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Load Vortex Base
loadstring(game:HttpGet("https://raw.githubusercontent.com/Vertex-MM2/Vertex/refs/heads/main/MM2.lua"))()

-- ESP (from Overdrive/SpaceHub)
loadstring(game:HttpGet("https://raw.githubusercontent.com/furqwk/dip/refs/heads/main/most.lua"))()

-- Auto Farm (best TP logic)
loadstring(game:HttpGet("https://raw.githubusercontent.com/ployprimetime/MM2/refs/heads/main/script.lua"))()

-- Auto End Round (fling murderer or sheriff)
loadstring(game:HttpGet("https://raw.githubusercontent.com/hoodratleahh/Summer-UPD/refs/heads/main/Initializer.lua"))()

-- Auto Reset after round
loadstring(game:HttpGet("https://raw.githubusercontent.com/moonlast/MM2/refs/heads/main/Overdrive%20Lite"))()

-- Anti-Fling System (from Overdrive full)
loadstring(game:HttpGet("https://raw.githubusercontent.com/maksi-alt/mm2/refs/heads/main/NeziksHub"))()

-- Performance Mode (cleans FPS/visuals)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Azura83/Murder-Mystery-2/refs/heads/main/Script.lua"))()

-- Gun Grab / Silent Aura Logic
loadstring(game:HttpGet("https://raw.githubusercontent.com/mm2scripthub/TravHub/refs/heads/main/MurderMystery2"))()

-- ESP Role Reveal (Sheriff/Murderer)
loadstring(game:HttpGet("https://raw.githubusercontent.com/amberryplayz/Roblox/refs/heads/main/Script"))()

-- Additional GUI options
loadstring(game:HttpGet("https://raw.githubusercontent.com/crt4r/MM2-Scripts/refs/heads/main/ScriptHUB-OP"))()

-- Optional alternate ESP/TP/Aura handler
loadstring(game:HttpGet("https://pastefy.app/ecOhoHqX/raw"))()
