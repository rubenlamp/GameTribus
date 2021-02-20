
function Boton(text,x,y,w,h,bg_ima,bg_ima_hover)
    local self = {}
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
    self.text = text
    local iw = w or 0
    local ih = h or 0
    if bg_ima then
        iw = bg_ima:getWidth()
        ih = bg_ima:getHeight()
    end
    self.w = math.max(love.graphics.getFont():getWidth( text )+40,iw)
    self.h = math.max(love.graphics.getFont():getHeight( text )+20,ih)
    self.mw = math.floor(self.w/2)
    self.mh = math.floor(self.h/2)

    self.rgba_text = {0.9,0.9,0.9,1}
    self.rgba = {0.1,0.1,0.1,0.8}

    self.rgba_hover = {0.15,0.15,0.15,0.9}
    self.rgba_text_hover = nil


    local px = 0
    local py = 0

    function self.setPointerPos(x,y)
        px = x
        py = y
    end
    
    function self.setAlpha(normal, hover)
        self.rgba_hover[4] = hover
        self.rgba[4] = normal
    end

    function self.isPointerInside()
        if px < self.pos.x+(self.w-self.mw) and py < self.pos.y+(self.h-self.mh) then
            if px > self.pos.x-self.mw and py > self.pos.y-self.mh then
               return true
            end
        end
        return false
    end

    function self.draw()
        local rgb_a_bg = {
            self.rgba[1],
            self.rgba[2],
            self.rgba[3],
            self.rgba[4]
            }
        local rgb_a_text = {
            self.rgba_text[1],
            self.rgba_text[2],
            self.rgba_text[3]
            }
        local mdx = 0
        local mdy = 0
        if self.isPointerInside() then
            if not self.rgba_text_hover then
                rgb_a_text[1] = math.min(self.rgba_text[1]+0.5)
                rgb_a_text[2] = math.min(self.rgba_text[2]+0.5)
                rgb_a_text[3] = math.min(self.rgba_text[3]+0.5)
            else
                rgb_a_text[1] = self.rgba_text_hover[1]
                rgb_a_text[2] = self.rgba_text_hover[2]
                rgb_a_text[3] = self.rgba_text_hover[3]
                rgb_a_text[4] = self.rgba_text_hover[4]
            end
            if self.rgba_hover then
                rgb_a_bg[1] = self.rgba_hover[1]
                rgb_a_bg[2] = self.rgba_hover[2]
                rgb_a_bg[3] = self.rgba_hover[3]
                rgb_a_bg[4] = self.rgba_hover[4]
            end
        end

        love.graphics.setFont(love.graphics.getFont())

        if not bg_ima then
            love.graphics.setColor(rgb_a_bg[1],rgb_a_bg[2],rgb_a_bg[3],rgb_a_bg[4])
            love.graphics.rectangle('fill',self.pos.x-self.mw,self.pos.y-self.mh,self.w,self.h,15,15,8)
        else
            local inside = self.isPointerInside()
            if not bg_ima_hover then
                love.graphics.setColor(0.5,0.5,0.5,rgb_a_bg[4])
                if inside then
                    love.graphics.setColor(1,1,1,rgb_a_bg[4])
                end
                love.graphics.draw(bg_ima,self.pos.x-self.mw,self.pos.y-self.mh)
            else
                if inside then
                    love.graphics.setColor(1,1,1,rgb_a_bg[4])
                    love.graphics.draw(bg_ima_hover,self.pos.x-self.mw,self.pos.y-self.mh)
                else
                    love.graphics.setColor(0.7,0.7,0.7,rgb_a_bg[4])
                    love.graphics.draw(bg_ima,self.pos.x-self.mw,self.pos.y-self.mh)
                end
            end
        end

        if self.isPointerInside() then
            love.graphics.setColor(0,0,0,1)
            love.graphics.printf(self.text,self.pos.x-self.mw+1,self.pos.y-self.mh+10+4+2,self.w,'center')
        end

        love.graphics.setColor(rgb_a_text[1],rgb_a_text[2],rgb_a_text[3],rgb_a_text[4])
        love.graphics.printf(self.text,self.pos.x-self.mw,self.pos.y-self.mh+10+mdy,self.w,'center')

    end

    return self
end