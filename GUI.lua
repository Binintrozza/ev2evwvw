local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Binintrozza/ev2evwvw/main/main.lua"))()



function Script()
    local Window = Library.CreateLib("huythanh", "Serpent")



    local Main = Window:NewTab("Main")
    local MainSection = Main:NewSection("Main")
    MainSection:NewButton("infi money (BEta)", "JUST WAIT :)", function()
    end)
    MainSection:NewToggle("REDEEM GIFT ONLINE", "GIFT", function(toggleState)
        MainToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while MainToggleEnabled do -- lặp lại nếu toggle được bật
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Spin["[C-S]TrySpin"]
            Event:InvokeServer()
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)


    -- Map
    local Map = Window:NewTab("TELEPORT")
    local MapSection = Map:NewSection("TELEPORT")
    MapSection:NewButton("MAP 4", "GO TO MAP 4", function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-282.5,163,2379)
    end)
    MapSection:NewButton("MAP 3", "GO TO MAP 3", function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-203.5,163,1694)
    end)
    MapSection:NewButton("MAP 2", "GO TO MAP 2", function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-210.5,164,985)
    end)
    MapSection:NewButton("MAP 1", "GO TO MAP 1", function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-139.5,163,-4)
    end)
    -- eggs
    local Eggs = Window:NewTab("Eggs")
    local EggsSection = Eggs:NewSection("Select")
    local eggToggleEnabled = false -- biến để lưu trạng thái của toggle
    EggsSection:NewLabel("STarter egg")

    EggsSection:NewToggle("Starter egg( 1k5 coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin1500"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Starter egg( 12K coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin12000"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Starter egg( 90k coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin90000"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewLabel("Pro egg")
    EggsSection:NewToggle("Pro egg( 450K coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin450000"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Pro egg( 3M coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin3M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Pro egg( 10M coin )", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin10M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewLabel("Event egg")
    EggsSection:NewToggle("12M Eggs ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin12M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewLabel("Map 2 egg")
    EggsSection:NewToggle("Map 2 eggs  ( 15M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin15M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Map 2 eggs  ( 35M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin35M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewLabel("Map 3 egg")
    EggsSection:NewToggle("Map 3 eggs  ( 50M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin50M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Map 3 eggs  ( 100M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin100M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewLabel("Map 4 egg")
    EggsSection:NewToggle("Map 4 eggs  ( 200M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin200M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    EggsSection:NewToggle("Map 3 eggs  ( 400M ) ", "Eggs", function(toggleState)
        eggToggleEnabled = toggleState -- cập nhật trạng thái toggle
    
        while eggToggleEnabled do -- lặp lại nếu toggle được bật
            local A_1 = "Coin400M"
            local Event = game:GetService("ReplicatedStorage").Remote.Function.Luck["[C-S]DoLuck"]
            Event:InvokeServer(A_1)
    
            wait(1) -- chờ 1 giây trước khi lặp lại
        end
    end)
    
    
    -- Credits
    local Credits = Window:NewTab("Credits")
    local CreditsSection = Credits:NewSection("Credits")


    CreditsSection:NewLabel("Created by huythanh")
    


end

if game.PlaceId == 11561748530 then
    Script()
end
