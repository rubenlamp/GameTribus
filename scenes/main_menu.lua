EXIT_TO =  nil

function Main()
    local self = Escena()
    local screen_ima = nil  
    
    local newbutton = nil
    local creditos = nil
    local salir = nil
    
    local background = nil
    local STATE = 0
    local limpiar_fondo = false
    
    local scroll_ima = nil
    self.size = 8
    self.dummy = 0
    
    local tale_text = ''
    local current_char = 0
    
    local tale_box = nil
    
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
    
    function ensuciaFondo()
        STATE = 3
        limpiar_fondo = false
    end

    function loadNewGame()
        local sim_scene =  love.filesystem.load("scenes/juego.lua")()
        SCENA_MANAGER.replace(sim_scene,{FILENAME})
        MSC_MAIN_MENU:stop()
        TRIBUS = {}
        TRIBUS[0]=0
        TRIBUS[1]=0
        TRIBUS[2]=0
    end
    
    function self.load(settings)
        background = love.graphics.newImage("/rcs/img/aldea_cuadrado_normal.png")
        
        scroll_ima = love.graphics.newImage("/rcs/img/Scroll.png")
        
        newbutton = Boton('',1920/2,1080*0.3,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/new_game.png"),
                love.graphics.newImage("/rcs/gui/new_game_hover.png"))
            
        creditos = Boton('',1920/2,1080*0.5,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/creditos.png"),
                love.graphics.newImage("/rcs/gui/creditos_hover.png"))
            
        salir = Boton('',1920/2,1080*0.7,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/quit.png"),
                love.graphics.newImage("/rcs/gui/quit_hover.png"))
            
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        --flux.to(self,0.5,{dummy=1}):ease("linear"):oncomplete(addChar)
        tale_box =  BoxTextDLP(DIAL[LANG].gui_once_was_a_king,1920/2-400,
                1080*0.3,800)
        tale_box.setAling('center')
        tale_box.start()
        MSC_MAIN_MENU:play()
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

        if STATE == 1 then
            love.graphics.setFont(FONT_BIG)
            love.graphics.setColor(1,1,1,1-self.size/8)
            love.graphics.printf(DIAL[LANG].game_name,0,1080*0.1,1920,'center')
            love.graphics.setColor(0,0,0,1-self.size/8)
            love.graphics.printf(DIAL[LANG].game_name,0,1080*0.1-3,1920,'center')
            love.graphics.setFont(FONT)
        
            love.graphics.setColor(1,1,1)
            newbutton.setPointerPos(globalX, globalY)
            newbutton.draw()
            
            creditos.setPointerPos(globalX, globalY)
            creditos.draw()
            
            salir.setPointerPos(globalX, globalY)
            salir.draw()
        end
        
        if STATE == 0 then
            love.graphics.setColor(1,1,1,self.size/8)
            love.graphics.draw(scroll_ima,
                1920/2-(scroll_ima:getWidth()/2)*2.6,
                1080/2-(scroll_ima:getHeight()/2)*2.30,0,2.6,2.3)
        end
        
        if STATE == 2 or STATE == 3 then
            love.graphics.setColor(1,1,1,self.size/8)
            love.graphics.draw(scroll_ima,
                1920/2-(scroll_ima:getWidth()/2)*2.6,
                1080/2-(scroll_ima:getHeight()/2)*2.5,0,2.6,2.5)
            
            love.graphics.setColor(0.2,0.2,0,self.size/16)
            love.graphics.setFont(FONT_SCROLL)
            love.graphics.printf(DIAL[LANG].gui_team_name,3,1080*0.1+3,1920,'center')
            love.graphics.setFont(FONT_SCROLL_SMALL)
            love.graphics.printf(DIAL[LANG].gui_creditos_full,2,1080*0.18+2,1920,'center')
            love.graphics.setFont(FONT_SCROLL)
            
            love.graphics.setColor(0,0,0,self.size/8)
            
            love.graphics.printf(DIAL[LANG].gui_team_name,0,1080*0.1,1920,'center')
            love.graphics.setFont(FONT_SCROLL_SMALL)
            love.graphics.printf(DIAL[LANG].gui_creditos_full,0,1080*0.18,1920,'center')
            love.graphics.setFont(FONT)
        end
        
        if STATE == 0 then
            love.graphics.setColor(0.2,0.2,0,self.size/16)
            
            love.graphics.push()
            love.graphics.translate(3,3)
            tale_box.draw()
            love.graphics.pop()
            
            love.graphics.setColor(0,0,0,self.size/8)
            tale_box.draw()
        end
        
        love.graphics.pop()
    end
    
    function self.update(dt)
        if (STATE == 0 or STATE == 1)  and self.size > 0 and limpiar_fondo  then
            GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        end
        if STATE == 0 then
            tale_box.update(dt)
            if tale_box.isEnded() then
                flux.to(self,3,{dummy= 0}):oncomplete(limpiaFondo)
            end
        end
    end
    
    function self.mousepressed(x, y, button)
        if STATE == 1 then
            if newbutton.isPointerInside() then
                loadNewGame()
            end
            if creditos.isPointerInside() then
                STATE = 2
                flux.to(self,2,{size=8}):oncomplete(ensuciaFondo)
            end
            if salir.isPointerInside() then
                love.event.quit()
            end
        end
        if (STATE == 0 or STATE == 3) and not limpiar_fondo then
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
