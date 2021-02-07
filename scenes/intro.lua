EXIT_TO =  nil
function Main()
    local self = Escena()
    
    local background = nil
    local STATE = 0
    local limpiar_fondo = false

    local scroll_ima = nil
    self.size = 8
    self.dummy = 0

    local tale_text = ''
    local current_char = 0

    local tale_box = nil
    local current_text = 1
    local ocupado_texto = false
    
    function changeState()
        STATE = 1
        tale_box.start()
    end
    
    function increaseNumber()
        tale_box.pos.y = 1080*0.7
        current_text = current_text+1
        if current_text > #DIAL[LANG].tale_intro then
            local sim_scene =  love.filesystem.load("scenes/juego.lua")()
            SCENA_MANAGER.replace(sim_scene,{FILENAME})
            MSC_MAIN_MENU:stop()
        end
    end
    
    function goNextText()
        if current_text <= #DIAL[LANG].tale_intro then
            ocupado_texto = false
            tale_box.resetText(DIAL[LANG].tale_intro[current_text])
            tale_box.pos.y = 1080*0.7
            tale_box.start()
        end
    end

    function limpiaFondo()
        if not limpiar_fondo then
            flux.to(self,2,{size=0}):ease("quadout"):oncomplete(changeState)
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
        
    end

    function self.load(settings)
        
        background = {
            love.graphics.newImage("/rcs/img/mapa.png"),
            love.graphics.newImage("/rcs/scenes/rey_buscando.png")
        }
        
        scroll_ima = love.graphics.newImage("/rcs/img/Scroll.png")
        
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        --flux.to(self,0.5,{dummy=1}):ease("linear"):oncomplete(addChar)
        tale_box =  BoxTextDLP(DIAL[LANG].tale_intro[current_text],1920/2-400,
                1080*0.3,800)
        tale_box.setAling('center')
        
        MSC_MAIN_MENU:play()
        
        limpiaFondo()
    end

    function self.draw()

        love.graphics.clear(0.5,0.3,0.2)
        love.graphics.setColor(1,1,1)

        local zoom = 1
        love.graphics.push()
        
        love.graphics.setShader(GAUSIAN_BLURS)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(background[current_text],0,0,0,
            (1920/background[current_text]:getWidth()),(1080/background[current_text]:getHeight())  )
        love.graphics.setShader()
        
            local scroll_scale_x = (1200/scroll_ima:getWidth())
            local scroll_scale_y = ((tale_box.line_height*8)/scroll_ima:getHeight())
            local scroll_x = (1920/2)-600
            local scroll_y = tale_box.pos.y-75
            love.graphics.setColor(1,1,1,1-self.size/8)        
            love.graphics.draw(scroll_ima,scroll_x,scroll_y,0,
                scroll_scale_x,scroll_scale_y)
            
            if self.size == 0 then
                love.graphics.setColor(0,0,0)
                tale_box.draw()
            end

        
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
        love.graphics.pop()
    end

    function self.update(dt)
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        
        tale_box.update(dt)
        if tale_box.isEnded() and not ocupado_texto then
            flux.to(self,1,{size= 8}):ease('quintout'):delay(2):oncomplete(increaseNumber):after(self,1,{size=0}):ease('quintin'):oncomplete(goNextText)
            ocupado_texto = true
        end
    end

    function self.mousepressed(x, y, button)
        if not tale_box.isEnded() then
            tale_box.showAll()
        end
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
