EXIT_TO =  nil

function Main()
    local self = Escena()
    local screen_ima = nil  
    
    local newbutton = nil
    local background = nil
    local STATE = 0
    local limpiar_fondo = false
    self.size = 8
    
    function loadCentralHub()
        --local sim_scene =  love.filesystem.load("scenes/central_hub.lua")()
        --SCENA_MANAGER.push(sim_scene,{FILENAME})
    end
    
    function changeState()
        STATE = 1
    end
    
    function limpiaFondo()
        if not limpiar_fondo then
            flux.to(self,0.5,{size=0}):ease("quadout"):oncomplete(changeState)
            limpiar_fondo = true
        end
    end

    function loadNewGame()
        local sim_scene =  love.filesystem.load("scenes/juego.lua")()
        SCENA_MANAGER.push(sim_scene,{FILENAME})
    end

    function self.load(settings)
        background = love.graphics.newImage("/rcs/img/aldea_cuadrado_normal.png")
        
        newbutton = Boton(DIAL[LANG].gui_new_game,1920/2,1080*0.3,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        --[[
        creditbutton = Boton('Creditos',1920/2,1080*0.5,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        
            
        exitbutton = Boton('Salir',1920/2,1080*0.7,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        --]]
    end
    
    function self.draw()
       
        love.graphics.clear(0.5,0.3,0.2)
        love.graphics.setColor(1,1,1)
        
        local zoom = 1
        love.graphics.push()
        
        love.graphics.setColor(0,0.4,0.1)
        love.graphics.rectangle('fill',0,1080*0.7,1920,1080*0.3)
        
        if STATE == 0 then
            love.graphics.setShader(GAUSIAN_BLURS)
        end
        love.graphics.setColor(1,1,1)
        love.graphics.draw(background,0,0,0,(1920/background:getWidth()),(1080/background:getHeight())  )
        
        love.graphics.setShader()
        
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)

        
        love.graphics.setFont(FONT_BIG)
        love.graphics.setColor(1,1,1,1-self.size/8)
        love.graphics.printf(DIAL[LANG].game_name,0,1080*0.1,1920,'center')
        love.graphics.setColor(0,0,0,1-self.size/8)
        love.graphics.printf(DIAL[LANG].game_name,0,1080*0.1-3,1920,'center')
        love.graphics.setFont(FONT)
        
        
        if STATE == 1 then
            love.graphics.setColor(1,1,1)
            newbutton.setPointerPos(globalX, globalY)
            newbutton.draw()
        end
        
        if STATE == 0 then
            love.graphics.setFont(FONT_BIG)
            love.graphics.setColor(0,0,0,self.size/8)
            love.graphics.printf(DIAL[LANG].gui_once_was_a_king,0,1080*0.3+4,1920,'center')
            love.graphics.printf(DIAL[LANG].gui_once_was_a_king,4,1080*0.3,1920,'center')
            love.graphics.printf(DIAL[LANG].gui_once_was_a_king,0,1080*0.3-4,1920,'center')
            love.graphics.printf(DIAL[LANG].gui_once_was_a_king,-4,1080*0.3,1920,'center')
            love.graphics.setColor(0.7,0.7,0,self.size/8)
            love.graphics.printf(DIAL[LANG].gui_once_was_a_king,0,1080*0.3,1920,'center')
            love.graphics.setFont(FONT)
        end
        
        love.graphics.pop()
    end
    
    function self.update(dt)
        if STATE == 0  and self.size > 0 and limpiar_fondo  then
            GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        end
    end
    
    function self.mousepressed(x, y, button)
        if STATE == 1 then
            if newbutton.isPointerInside() then
                loadNewGame()
            end
        end
        if STATE == 0 then
            limpiaFondo()
        end
        --[[
        
        if creditbutton.isPointerInside() then
            loadCreditos()
        end
        if exitbutton.isPointerInside() then
            love.event.quit()
        end
        --]]
    end
    
    function self.keyreleased( key, scancode )

    end
    
    function self.keypressed(key,scancode)
        --mi_menu.keypressed(scancode)
    end
    
    function self.mousemoved(x, y, dx, dy, istouch)

    end

    function self.mousereleased(x, y, buttom)
        
    end

    
    return self
end

return Main()
