
function Boton(text,x,y,w,h)
    local self = {}
    self.pos = {}
    self.pos.x = x
    self.pos.y = y
    self.text = text
    local iw = w or 0
    local ih = h or 0
    self.w = math.max(love.graphics.getFont():getWidth( text )+40,iw)
    self.h = math.max(love.graphics.getFont():getHeight( text )+20,ih)
    self.mw = math.floor(self.w/2)
    self.mh = math.floor(self.h/2)
    self.rgba_text = {0.25,0.25,0.25}
    self.rgba = {0.8,0.6,0.7,1}
    
    local px = 0
    local py = 0
    
    function self.setPointerPos(x,y)
        px = x
        py = y
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
        self.rgba[4] = 0.8
        local rgb_a_text = {
            self.rgba_text[1],
            self.rgba_text[2],
            self.rgba_text[3]
            }
        local mdx = 0
        local mdy = 0
        if self.isPointerInside() then
            self.rgba[4] = 0.9
            rgb_a_text[1] = math.min(self.rgba_text[1]+0.5)
            rgb_a_text[2] = math.min(self.rgba_text[2]+0.5)
            rgb_a_text[3] = math.min(self.rgba_text[3]+0.5)
            mdx=-2
            mdy=-2
            love.graphics.setColor(0,0,0,0.75)
            love.graphics.rectangle('line',self.pos.x-self.mw-1,self.pos.y-self.mh-1,self.w+1,self.h+1,15,15,8)
        end
        love.graphics.setFont(love.graphics.getFont())
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf(self.text,self.pos.x-self.mw+2,self.pos.y-self.mh+10+4+4,self.w,'center')
        
        love.graphics.setColor(self.rgba[1],self.rgba[2],self.rgba[3],self.rgba[4])
        love.graphics.rectangle('fill',self.pos.x-self.mw,self.pos.y-self.mh,self.w,self.h,15,15,8)
        love.graphics.setColor(rgb_a_text[1],rgb_a_text[2],rgb_a_text[3],rgb_a_text[4])
        love.graphics.printf(self.text,self.pos.x-self.mw,self.pos.y-self.mh+10+mdy,self.w,'center')

    end
    
    return self
end


function BotonIma(ima,x,y,w,h,offset)
    local self = Boton('',x,y,w,h)
    self.ima = ima
    self.pos.z = 1
    self.pos.w = 1
    local int_x = x
    local int_y = y
    local int_z = 1
    local int_w = 1
    local offset = offset or 0
    local max_w = 1
    local max_z = 1
    if ima then
        self.ima_sx = w/ima:getWidth()
        self.ima_sy = h/ima:getHeight()
        --sé que esto se puede simplificar, pero me da flojera
        self.pos.z = ((ima:getWidth()*0.5)/(w/ima:getWidth()))/ima:getWidth()
        self.pos.w = ((ima:getHeight()*0.5)/(h/ima:getHeight()))/ima:getHeight()
        int_w = self.pos.w
        int_z = self.pos.z 
        max_w = self.pos.w*4
        max_z = self.pos.z*4
    end
    
    local moving = false
    local state = 1
    
    function self.setText()
    
    end
    
    function self.setPointerPos(x,y)
        px = x
        py = y
    end
    
    function self.moveEnd()
        moving = false
        --print(self.w*self.pos.z)
    end
    
    function self.isMoveEnd()
        return not moving
    end
    
    function self.startMove()
        if not moving and state == 1 then
            moving = true
            state = 2
            flux.to(self.pos,1,{x=(1920*1.25)+offset,y=(1080/2),z=max_z,w=max_w}):oncomplete(self.moveEnd)
        end
    end
    
    function self.isPointerInside()
        if px < self.pos.x+(self.w-self.mw)*self.pos.z and py < self.pos.y+(self.h-self.mh)*self.pos.w then
            if px > self.pos.x-self.mw*self.pos.z and py > self.pos.y-self.mh*self.pos.w then
               return true
            end
        end
        return false 
    end
    
    function self.goBack()
        if not moving and state == 2 then
            moving = true
            state = 1
            flux.to(self.pos,1,{x=int_x,y=int_y,z=int_z,w=int_w}):oncomplete(self.moveEnd)
        end
    end
    
    function self.draw()
        local c = 0.75
        if self.isPointerInside() or state == 2 then
            c = 1
        end
        if self.ima then
            love.graphics.setColor(c,c,c,1)
            love.graphics.draw(self.ima,self.pos.x-self.mw*self.pos.z,self.pos.y-self.mw*self.pos.w,0,self.ima_sx*self.pos.z,self.ima_sy*self.pos.w)
        end
    end
    
    return self
end