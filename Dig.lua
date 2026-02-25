-- Dig Training
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
humanoid.Health = 0
local newCharacter = player.CharacterAdded:Wait()
local waitTime = 1
task.wait(waitTime) 
local playerGui = player:WaitForChild("PlayerGui")
local autoFightButton
local knit = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit")
local autoServiceRE = knit:WaitForChild("Services"):WaitForChild("AutoService"):WaitForChild("RE")

local function updateButton()
    pcall(function()
        autoFightButton = playerGui:WaitForChild("HomeGui"):WaitForChild("RightFrame"):WaitForChild("AutoFightButton")
    end)
end

updateButton()

task.spawn(function()
    while getgenv().AutoTrain do
        local args = {
	    "Anvil_1_1"
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TrainService"):WaitForChild("RE"):WaitForChild("RunTrain"):FireServer(unpack(args))
        end)
        task.wait(0.1)
    end
end)

local function jimsDigButton()
    local mouse = {"MouseButton1Click", "Activated", "MouseButton1Down"}
    for _, click in ipairs(mouse) do
        local auto = autoFightButton[click]
        if auto then
            for _, connection in pairs(getconnections(auto)) do
                connection:Fire()
            end
        end
    end
end

task.spawn(function()
    pcall(function() autoServiceRE.AutoFightStop:FireServer() end)
    task.wait(0.1)
    while getgenv().AutoDig do
        if autoFightButton and autoFightButton.Parent then
            jimsDigButton()
            task.wait(1)
            if not getgenv().AutoDig then break end
            pcall(function() autoServiceRE.AutoFightStop:FireServer() end)
            task.wait(0.1)
            jimsDigButton()
            task.wait(0.1)
        else
            updateButton()
            task.wait(1)
        end
    end
end)

task.spawn(function()
    local claimRemote = knit:WaitForChild("Services"):WaitForChild("OnlineRewardService"):WaitForChild("RE"):WaitForChild("ClaimOnlineReward")
    while getgenv().AutoClaim do
        for i = 1, 12 do
            pcall(function()
                claimRemote:FireServer(i)
            end)
            task.wait(1)
        end
        task.wait(60)
    end
end)

if getgenv().AntiAFK then
    task.spawn(function()
        local player = game.Players.LocalPlayer
        local success = false
        pcall(function()
            local getconn = getconnections or get_signal_cons
            if getconn then
                for _, connection in pairs(getconn(player.Idled)) do
                    if connection["Disable"] then
                        connection:Disable()
                    elseif connection["Disconnect"] then
                        connection:Disconnect()
                    end
                end
                success = true
            end
        end)

        if not success then
            local VirtualUser = game:GetService("VirtualUser")            
            player.Idled:Connect(function()
                if getgenv().AntiAFK then 
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end)
end
