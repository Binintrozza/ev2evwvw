local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Binintrozza/ev2evwvw/main/main.lua"))()

function Script()
    local Window = Library.CreateLib("💎[🍀X6!] Rebirth Champions X💎 YUTO HUB", "Serpent")

    local Main = Window:NewTab("💎MAIN💎")
    local MainSection = Main:NewSection("Main")

    local MainToggleEnabled = false
    MainSection:NewToggle("Auto click", "help you farm click", function(toggleState)
        MainToggleEnabled = toggleState
        while MainToggleEnabled do -- loop while the toggle is enabled
            local Event = game:GetService("ReplicatedStorage").Events.Click3
            Event:FireServer()
            wait(0.01) -- wait for a short time before repeating
        end
    end)
    MainSection:NewButton("spin daily","will spin the wheel daily",function ()
         local Event = game:GetService("ReplicatedStorage").Functions.Spin
         Event:InvokeServer()        
    end)
        local function AntiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

AntiAFK()



    -- local player
    local Local = Window:NewTab("🟢LOCAL PLAYER🟢")
    local LocalSection =  Local:NewSection("LOCAL PLAYER ")
    LocalSection:NewSlider("Walkspeed", "Changes how fast you walk.", 250, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end)

    LocalSection:NewSlider("JumpPower", "Changes how fast you jump.", 250, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = s -- fixed typo, it should be JumpPower
    end)
    LocalSection:NewKeybind("PRESS F FOR TOGGLE", "KeybindInfo", Enum.KeyCode.F, function()
        Library:ToggleUI()
    end)

    -- Auto eggs
    local Eggs = Window:NewTab("🥚AUTO HATCH🥚")
    local eggToggleEnabled = false

local EggsSection = Eggs:NewSection(" 🚀 SPAWN MAP SELECT EGG 🚀")

        local u = "Forest" -- mặc định là rừng
    local eggDropdown = EggsSection:NewDropdown("EGG SELECT", "DropdownInf", {"Forest", "Basic", "Mythic","Atlantis","Desert","Winter","Volcano","Magma","Moon","Cyber","Magic","Heaven","Nuclear","Void","Spooky","Cave","Steampunk","Hell"}, function(currentOption)
        u = currentOption
        print(currentOption)
    end)
    
    local eggAutoSelectToggle = EggsSection:NewToggle("🚀 Auto Egg SPAWN Select 🚀", "auto Hatch egg select", function(toggleState)
        eggToggleEnabled = toggleState
        while eggToggleEnabled do
            local A_1 = u
            local A_2 = "Triple"
            local Event = game:GetService("ReplicatedStorage").Functions.Unbox
            Event:InvokeServer(A_1, A_2)
            wait(0.1) -- sửa lỗi chính tả, nó phải là 0.1 thay vì 0,1
        end
    end)

    local EggsSection = Eggs:NewSection("🚀 SPACE MAP SELECT EGG 🚀")

    local o = "Space" 
    local eggDropdown = EggsSection:NewDropdown("EGG SELECT", "DropdownInf", {"Space", "Mars", "Alien","Galaxy Forest","Spacelab","Fantasy","Neon","Shadow","Dectruction","Sun","Saturn","Hacker","Black Hole"}, function(currentOption)
        o = currentOption
        print(currentOption)
    end)
    
    local eggAutoSelectToggle = EggsSection:NewToggle("🚀 Auto Egg SPACE Select 🚀", "auto Hatch egg select", function(toggleState)
        eggToggleEnabled = toggleState
        while eggToggleEnabled do
            local A_1 = o
            local A_2 = "Triple"
            local Event = game:GetService("ReplicatedStorage").Functions.Unbox
            Event:InvokeServer(A_1, A_2)
            wait(0.1) -- sửa lỗi chính tả, nó phải là 0.1 thay vì 0,1
        end
    end)
    local EggsSection = Eggs:NewSection("🌊 OCEAN MAP SELECT EGG 🌊")

    local po = "Axolotl" 
    local eggDropdown = EggsSection:NewDropdown("EGG SELECT", "DropdownInf", {"Axolotl", "Underwater Lab", "Pixel","Sea Cave","Acient","Pirate","Exotic Island","Fishing Village","Ocean","Motlen","Saturn","Hacker","Black Hole"}, function(currentOption)
        po = currentOption
        print(currentOption)
    end)
    
    local eggAutoSelectToggle = EggsSection:NewToggle("🌊 Auto Egg OCEAN Select 🌊 ", "auto Hatch egg select", function(toggleState)
        eggToggleEnabled = toggleState
        while eggToggleEnabled do
            local A_1 = po
            local A_2 = "Triple"
            local Event = game:GetService("ReplicatedStorage").Functions.Unbox
            Event:InvokeServer(A_1, A_2)
            wait(0.1) -- sửa lỗi chính tả, nó phải là 0.1 thay vì 0,1
        end
    end)
    local EggsSection = Eggs:NewSection("🌴 Jungle MAP SELECT EGG 🌴")

    local lo = "Fantasy Spawn" 
    local eggDropdown = EggsSection:NewDropdown("EGG SELECT", "DropdownInf", {"Fantasy Spawn", "Fantasy Jungle","Cake","Party","100M","Anniversary"}, function(currentOption)
        lo = currentOption
        print(currentOption)
    end)
    
    local eggAutoSelectToggle = EggsSection:NewToggle("🌴 Auto Egg Jungle Select 🌴 ", "auto Hatch egg select", function(toggleState)
        eggToggleEnabled = toggleState
        while eggToggleEnabled do
            local A_1 = lo
            local A_2 = "Triple"
            local Event = game:GetService("ReplicatedStorage").Functions.Unbox
            Event:InvokeServer(A_1, A_2)
            wait(0.1) -- sửa lỗi chính tả, nó phải là 0.1 thay vì 0,1
        end
    end)


-- auto rebirth 
    local Rebirth = Window:NewTab("🔃AUTO REBIRTH🔃")
    local RebirthSection = Rebirth:NewSection("🔃AUTO REBIRTH🔃")
    RebirthSection:NewDropdown("Rebirth select", "Select Which for rebirth", {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94}, function(currentOption)
        i = currentOption
        print(currentOption)
    end)
    RebirthSection:NewToggle("Auto rebirth ", "That will auto rebirth", function(toggleState) -- added comma after "Auto hatch egg"
        eggToggleEnabled = toggleState
        while eggToggleEnabled do
            local A_1 = i
         local Event = game:GetService("ReplicatedStorage").Events.Rebirth
         Event:FireServer(A_1)
            wait(0.1) -- fixed typo, it should be 0.1 instead of 0,1
        end
    end)
    
--cupcake
    local Cupcake = Window:NewTab("CUPCAKE COLLECT")
    local CupcakeSection = Cupcake:NewSection(" 🧲Cupcake magnet🧲")
    local CupcakeToggleEnabled = false

    CupcakeSection:NewToggle("Cupcake Collect", "That's so OP :)", function(toggleState)
        CupcakeToggleEnabled = toggleState
        while CupcakeToggleEnabled do 
            local cupcakes = game:GetService("Workspace").Scripts.CollectCupcakes.Storage:GetChildren()
            for i, v in pairs(cupcakes) do 
                firetouchinterest(game.Players.LocalPlayer.Character.Head, v.Part, 0)
            end
            wait(5)
        end
    end)
-- shop
local Shop = Window:NewTab("SHOP BOOST🏪")
local ShopSection = Shop:NewSection("Select BOOST🏪")
local il = "x2Gems"
ShopSection:NewDropdown("Boost select", "SELECT BOOST TO BUY", {"x2Gems","x2Luck","x2PetXP","x2HatchSpeed","x2Rebirths"}, function(currentOption)
il = currentOption
print(currentOption)
end)
ShopSection:NewButton("Buy x1 BOOST🏪 you select", "That will buy 1 thing", function ()
local A_1 = il
local A_2 = 1
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2)
end)
ShopSection:NewButton("Buy x10 BOOST🏪 you select", "That will buy 10 things", function ()
local A_1 = il
local A_2 = 10
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2)
end)
ShopSection:NewButton("Buy x100 BOOST🏪 you select", "That will buy 100 things", function ()
local A_1 = il
local A_2 = 100
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2)
end)

local ShopSection2 = Shop:NewSection("Select BOOST AQUA Map🌊")
local ik = "x3Gems"
ShopSection2:NewDropdown("Boost AQua select", "DropdownInf", {"x3Clicks","x3Gems","x3PetLevel","x3Rebirths"}, function(currentOption)
ik = currentOption
print(currentOption)
end)
ShopSection2:NewButton("Buy x1 BOOST AQUA Map🌊 you select", "That will buy 1 thing", function ()
local A_1 = ik
local A_2 = 1
local A_3 = "aqua"
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2, A_3)
end)
ShopSection2:NewButton("Buy x10 BOOST AQUA Map🌊 you select", "That will buy 10 things", function ()
local A_1 = ik
local A_2 = 10
local A_3 = "aqua"
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2, A_3)
end)
ShopSection2:NewButton("Buy x100 BOOST AQUA Map🌊 you select", "That will buy 100 things", function ()
local A_1 = ik
local A_2 = 100
local A_3 = "aqua"
local Event = game:GetService("ReplicatedStorage").Events.Potion
Event:FireServer(A_1, A_2, A_3)
end)



-- Credits
      local Credits = Window:NewTab("Credits")
      local CreditsSection = Credits:NewSection("Credits")
     CreditsSection:NewLabel("Created by 'huythanh'")

end

-- Call Script function
if game.PlaceId == 8540346411 then
Script()
end
