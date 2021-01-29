EXIT_TO =  nil

function Main()
    local self = Escena()
    local screen_ima = nil  
    
    local newbutton = nil
    
    function loadCentralHub()
        --local sim_scene =  love.filesystem.load("scenes/central_hub.lua")()
        --SCENA_MANAGER.push(sim_scene,{FILENAME})
    end
    
    function loadNewGame()
        local sim_scene =  love.filesystem.load("scenes/juego.lua")()
        SCENA_MANAGER.replace(sim_scene,{FILENAME})
    end

    function self.load(settings)
        
       
        --love.graphics.setFont(MACHINA_FONT)
        
        
        newbutton = Boton("No hay juego aquí :'(",1920/2,1080*0.3,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        --[[
        creditbutton = Boton('Creditos',1920/2,1080*0.5,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        
            
        exitbutton = Boton('Salir',1920/2,1080*0.7,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        --]]
    end
    
    function self.draw()
       
        love.graphics.clear(0.6,0.6,0.6)
        love.graphics.setColor(1,1,1)
        
        local zoom = 1
        love.graphics.push()
        --love.graphics.scale(2,2)
        love.graphics.setColor(1,1,1)
        
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)

        love.graphics.setColor(1,1,1)
        
        newbutton.setPointerPos(globalX, globalY)
        newbutton.draw()
        love.graphics.pop()
    end
    
    function self.update(dt)

    end
    
    function self.mousepressed(x, y, button)
        if newbutton.isPointerInside() then
            loadNewGame()
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
