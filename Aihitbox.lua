--[[
    Script Name: Roblox Hitbox Expander Pro UI
    Description: 具有自定义数值输入、透明度调节及最小化功能的 Hitbox 扩大工具
    Usage: 复制到支持 Lua 的注入器中运行
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ⚙️ 默认参数配置
local Config = {
    RootHitboxEnabled = false,
    RootSize = Vector3.new(6, 6, 6),
    HeadHitboxEnabled = false,
    HeadSize = Vector3.new(4, 4, 4),
    Transparency = 0.6,
    TeamCheck = false,
}

-- 防止重复运行导致 UI 重叠
if CoreGui:FindFirstChild("HitboxUI") then
    CoreGui.HitboxUI:Destroy()
end

-- 🎨 创建 UI 主界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 290)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- 允许鼠标拖动面板
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Expander [Pro UI]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 🗕 最小化/还原按钮
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -32, 0, 4)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = MainFrame
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 4)

-- 存储所有需要随最小化隐藏的内部控件
local contentElements = {}

local function addContent(element)
    table.insert(contentElements, element)
    element.Parent = MainFrame
end

-- 1. 身体 Hitbox 开关按钮
local RootButton = Instance.new("TextButton")
RootButton.Size = UDim2.new(0.9, 0, 0, 32)
RootButton.Position = UDim2.new(0.05, 0, 0, 40)
RootButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RootButton.Text = "身体判定 (RootPart): [ 关闭 ]"
RootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RootButton.TextSize = 13
RootButton.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", RootButton).CornerRadius = UDim.new(0, 6)
addContent(RootButton)

-- 身体数值输入框 (TextBox)
local RootBox = Instance.new("TextBox")
RootBox.Size = UDim2.new(0.9, 0, 0, 28)
RootBox.Position = UDim2.new(0.05, 0, 0, 76)
RootBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RootBox.Text = "6, 6, 6"
RootBox.PlaceholderText = "身体尺寸, 例: 6,6,6"
RootBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RootBox.TextSize = 12
RootBox.Font = Enum.Font.SourceSans
Instance.new("UICorner", RootBox).CornerRadius = UDim.new(0, 6)
addContent(RootBox)

-- 2. 头部 Hitbox 开关按钮
local HeadButton = Instance.new("TextButton")
HeadButton.Size = UDim2.new(0.9, 0, 0, 32)
HeadButton.Position = UDim2.new(0.05, 0, 0, 115)
HeadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HeadButton.Text = "头部判定 (Head): [ 关闭 ]"
HeadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadButton.TextSize = 13
HeadButton.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", HeadButton).CornerRadius = UDim.new(0, 6)
addContent(HeadButton)

-- 头部数值输入框 (TextBox)
local HeadBox = Instance.new("TextBox")
HeadBox.Size = UDim2.new(0.9, 0, 0, 28)
HeadBox.Position = UDim2.new(0.05, 0, 0, 151)
HeadBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HeadBox.Text = "4, 4, 4"
HeadBox.PlaceholderText = "头部尺寸, 例: 4,4,4"
HeadBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadBox.TextSize = 12
HeadBox.Font = Enum.Font.SourceSans
Instance.new("UICorner", HeadBox).CornerRadius = UDim.new(0, 6)
addContent(HeadBox)

-- 3. 透明度调整输入框
local TransBox = Instance.new("TextBox")
TransBox.Size = UDim2.new(0.9, 0, 0, 28)
TransBox.Position = UDim2.new(0.05, 0, 0, 190)
TransBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TransBox.Text = "0.6"
TransBox.PlaceholderText = "透明度 (0 - 1)"
TransBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TransBox.TextSize = 12
TransBox.Font = Enum.Font.SourceSans
Instance.new("UICorner", TransBox).CornerRadius = UDim.new(0, 6)
addContent(TransBox)

-- 底部说明标签
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "提示: 输入数值后按回车生效"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.SourceSansItalic
addContent(StatusLabel)

-- 🗕 最小化/还原交互逻辑
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeButton.Text = "+"
        MainFrame.Size = UDim2.new(0, 260, 0, 35)
        for _, elem in ipairs(contentElements) do
            elem.Visible = false
        end
    else
        MinimizeButton.Text = "-"
        MainFrame.Size = UDim2.new(0, 260, 0, 290)
        for _, elem in ipairs(contentElements) do
            elem.Visible = true
        end
    end
end)

-- 🔘 按钮与输入交互逻辑
RootButton.MouseButton1Click:Connect(function()
    Config.RootHitboxEnabled = not Config.RootHitboxEnabled
    if Config.RootHitboxEnabled then
        RootButton.Text = "身体判定 (RootPart): [ 开启 ]"
        RootButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    else
        RootButton.Text = "身体判定 (RootPart): [ 关闭 ]"
        RootButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

HeadButton.MouseButton1Click:Connect(function()
    Config.HeadHitboxEnabled = not Config.HeadHitboxEnabled
    if Config.HeadHitboxEnabled then
        HeadButton.Text = "头部判定 (Head): [ 开启 ]"
        HeadButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    else
        HeadButton.Text = "头部判定 (Head): [ 关闭 ]"
        HeadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- 解析输入的 Vector3 辅助函数
local function parseVector3(text, defaultVector)
    local success, result = pcall(function()
        local numbers = {}
        for num in string.gmatch(text, "([^,%s]+)") do
            table.insert(numbers, tonumber(num))
        end
        if #numbers >= 3 then
            return Vector3.new(numbers[1], numbers[2], numbers[3])
        elseif #numbers == 1 then
            return Vector3.new(numbers[1], numbers[1], numbers[1])
        end
        return defaultVector
    end)
    if success and result then
        return result
    end
    return defaultVector
end

RootBox.FocusLost:Connect(function()
    Config.RootSize = parseVector3(RootBox.Text, Vector3.new(6, 6, 6))
end)

HeadBox.FocusLost:Connect(function()
    Config.HeadSize = parseVector3(HeadBox.Text, Vector3.new(4, 4, 4))
end)

TransBox.FocusLost:Connect(function()
    local val = tonumber(TransBox.Text)
    if val then
        Config.Transparency = math.clamp(val, 0, 1)
    end
end)

-- 🔄 核心运行循环：实时刷新所有玩家的身体和头部大小
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                -- 身体判定 (HumanoidRootPart)
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    if Config.RootHitboxEnabled then
                        rootPart.Size = Config.RootSize
                        rootPart.Transparency = Config.Transparency
                        rootPart.CanCollide = false
                        rootPart.Material = Enum.Material.Neon
                    else
                        rootPart.Size = Vector3.new(2, 2, 1)
                        rootPart.Transparency = 1
                    end
                end

                -- 头部判定 (Head)
                local head = character:FindFirstChild("Head")
                if head then
                    if Config.HeadHitboxEnabled then
                        head.Size = Config.HeadSize
                        head.Transparency = Config.Transparency
                        head.CanCollide = false
                        head.Material = Enum.Material.Neon
                    else
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                    end
                end
            end
        end
    end
end)