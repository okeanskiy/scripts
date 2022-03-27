
-- Static configurable values
local CURRENCY_NAME = "Money"
local DEFAULT_AMOUNT = 100
local LEADERSTATS_ENABLED = true

-- game services
local Players = game:GetService("Players")

-- module
local PlayerMoney = {}

-- { Player player : number money }
PlayerMoney.Values = {}

local function updateLeaderstats(player)
    player.leaderstats[CURRENCY_NAME].Value = PlayerMoney.Values[player]
end

-- Get player's current money
-- (Player player) -> number money
function PlayerMoney.Get(player)
    return PlayerMoney.Values[player]
end

-- Add (or subtract with negative number) money to a player
-- (Player player, number amount) -> void
function PlayerMoney.Increment(player, amount)
    if PlayerMoney.Values[player] == nil then return end
    PlayerMoney.Values[player] += amount
    if LEADERSTATS_ENABLED then
        updateLeaderstats(player)
    end
end

-- Set player's money to a specific value
-- (Player player, number setTo) -> void
function PlayerMoney.Set(player, setTo)
    if PlayerMoney.Values[player] == nil then return end
    PlayerMoney.Values[player] = setTo
    if LEADERSTATS_ENABLED then
        updateLeaderstats(player)
    end
end

local function addLeaderstats(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end
    local money = leaderstats:FindFirstChild(CURRENCY_NAME)
    if not money then
        money = Instance.new("NumberValue")
        money.Name = CURRENCY_NAME
        money.Parent = leaderstats
    end
end

local function onPlayerAdded(player)
    -- replace 'DEFAULT_VALUE' with a datastore implementation to load saved money
    PlayerMoney.Values[player] = DEFAULT_VALUE
    
    -- player may have left during datastore get
    -- if not player:IsDescendantOf(Players) then return end
    
    if LEADERSTATS_ENABLED then
        addLeaderstats(player)
        updateLeaderstats(player)
    end
end

local function onPlayerRemoving(player)
    -- datasave here
    PlayerMoney.Values[player] = nil
end

local function init()
    Players.PlayerAdded:Connect(onPlayerAdded)
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
    Players.PlayerRemoving:Connect(onPlayerRemoving)
end

init()
        
return PlayerMoney
