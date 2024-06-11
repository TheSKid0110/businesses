include("shared.lua")
include("business_register_config.lua")

function ENT:Draw()
    self:DrawModel()
end

net.Receive("cash_register_open", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    frame:Center()
    frame:SetTitle("Cash Register")
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, 24, Color(133, 131, 131))
    end
    
    local itemslist = vgui.Create("DScrollPanel", frame)
    itemslist:Dock(FILL)
    for item, ichoose in pairs(BUSINESS_REGISTER["Guns"]) do
        local itemPanel = vgui.Create("DPanel", itemslist)
        itemPanel:Dock(TOP)
        itemPanel:SetTall(50)
        itemPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        end
    
        local itemLabel = vgui.Create("DLabel", itemPanel)
        itemLabel:Dock(FILL)
        itemLabel:SetText(item .. " - " .. ichoose.price)
        itemLabel:SetContentAlignment(5)
    
        local purchaseButton = vgui.Create("DButton", itemPanel)
        purchaseButton:Dock(RIGHT)
        purchaseButton:SetText("Purchase")
        purchaseButton.DoClick = function()
            net.Start("cash_register_purchase")
            net.WriteString(item)
            net.SendToServer()
        end
    end
end)
