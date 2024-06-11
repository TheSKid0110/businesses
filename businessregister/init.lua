AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("business_register_config.lua")
util.AddNetworkString("cash_register_open")
util.AddNetworkString("cash_register_purchase")

function ENT:Initialize()
    self:SetModel("models/props_c17/cashregister01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end


function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    activator:ChatPrint("You used the cash register!")
    net.Start("cash_register_open")
    net.Send(activator)
end

net.Receive("cash_register_purchase", function(len, ply)
    local item = net.ReadString()
    if BUSINESS_REGISTER["Guns"][item] then
        if ply:canAfford(BUSINESS_REGISTER["Guns"][item].price) then
            ply:addMoney(-BUSINESS_REGISTER["Guns"][item].price)
            ply:Give(BUSINESS_REGISTER["Guns"][item].model)
            ply:ChatPrint("You have purchased a " .. item .. " for " .. BUSINESS_REGISTER["Guns"][item].price .. "!")
        else
            ply:ChatPrint("You cannot afford this item!")
        end
    end
end)