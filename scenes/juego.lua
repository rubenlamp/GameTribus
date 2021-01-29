EXIT_TO =  nil

function Main()
    local self = Escena()
    
    local aldea_list = {}
    local state = 1
    local working_id = -1
    local offset_x = 0
    local back_ground = nil
    self.cam_x = 0
    local cam_y = 0
    
    function self.load(settings)
        
        local i = 0
        aldea_list[0] = BotonIma(love.graphics.newImage("/rcs/img/aldea_icon_template.png"),250,200,500,500)
        aldea_list[1] = BotonIma(love.graphics.newImage("/rcs/img/aldea_icon_template_2.png"),500,700,500,500)
        aldea_list[2] = BotonIma(love.graphics.newImage("/rcs/img/aldea_icon_template_3.png"),1920/2,600,500,500)
        
        back_ground = love.graphics.newImage("/rcs/img/top_view.jpg")
        
    end
    
    function self.draw()
       
        love.graphics.clear(0.6,0.6,0.6)
        love.graphics.setColor(1,1,1)
        
        local zoom = 1

        love.graphics.push()
        
        love.graphics.translate(self.cam_x,0)
        
        love.graphics.draw(back_ground,0,0,0,(1920/back_ground:getWidth()),(1080/back_ground:getHeight())  )
        love.graphics.setColor(1,0,1)
        love.graphics.print('Escoge una aldea para hacer algo...')
        if state == 2 then
            love.graphics.setColor(0,0,0)
            love.graphics.print('¿Qué quieres hacer?',1920*1.5,400)
            love.graphics.setColor(1,1,1)
        end
        --love.graphics.scale(2,2)

        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
        
        
        local i = 0
        while aldea_list[i] do
            if i ~= working_id then
                aldea_list[i].setPointerPos(globalX, globalY)
                aldea_list[i].draw()
            end
            i=i+1
        end
        -- working id goes here
        if aldea_list[working_id] then
            aldea_list[working_id].setPointerPos(globalX, globalY)
            aldea_list[working_id].draw()
        end
        
        
        love.graphics.pop()
    end
    
    function self.update(dt)
    if working_id >= 0  then
            if state == 1 then
                if aldea_list[working_id].isMoveEnd() then
                    state = 2
                end
            end
            if state == 3 then
                if aldea_list[working_id].isMoveEnd() then
                    working_id = -1
                    state = 1
                end
            end
        end
    end
    
    function self.mousepressed(x, y, button)
        if button == 1 then
            if state == 1 then
                local i = 0
                while aldea_list[i] do
                    if aldea_list[i].isPointerInside() then
                        working_id = i
                        aldea_list[i].startMove()
                        flux.to(self,1,{cam_x = -1920})
                        --state = 2
                        break
                    end
                    i=i+1
                end
            end
            if state == 2 then
                aldea_list[working_id].goBack()
                flux.to(self,1,{cam_x = 0})
                state = 3
            end
        end
    end
    
    function self.keyreleased( key, scancode )

    end
    
    function self.keypressed(key,scancode)
        --mi_menu.keypressed(scancode)
        --SCENA_MANAGER.pop()
    end
    
    function self.mousemoved(x, y, dx, dy, istouch)

    end

    function self.mousereleased(x, y, buttom)
        
    end

    
    return self
end

return Main()
