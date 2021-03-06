EXIT_TO =  nil

function Main()
    local self = Escena()
    local screen_ima = nil

    local game_title = nil
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
    
    -- esto controla el nivel del alpha de el pergamino, y los botones
    local alphas = {}
    alphas.a = 0
    alphas.b = 0
    alphas.c = 0
    
    local vid_scale_pos = {}
    vid_scale_pos.x = 0.5
    vid_scale_pos.y = 0.38
    vid_scale_pos.sx = 1
    vid_scale_pos.sy = 1
    
    local easing = nil
    local is_text_end = false
    
  	local credits_move_vid = false
	local credits_show_thanks = false
    local moving_vid_easing = nil

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
            ayo.new(alphas,0.5,{c=1}).setEasing('inBack')
            if tale_box then
                tale_box.callOutro()
                tale_box = nil
            end
            
            if moving_vid_easing then
                moving_vid_easing.cancel()
            end
            -- fijar valores iniciales de la posición del video :p
            vid_scale_pos.x = 0.5
            vid_scale_pos.y = 0.38
            vid_scale_pos.sx = 1
            vid_scale_pos.sy = 1
            
            credits_move_vid = false
            credits_show_thanks = false
            limpiar_fondo = true
        end
    end

    function ensuciaFondo()
        limpiar_fondo = false
        -- en este punto tale_box es un objeto de tipo DialogBox
        tale_box.start()
        tale_box.show_scroll = false
        VIDEO_CREDITS:play()
    end

    function loadNewGame()
        -- limpiar los resultados de los minijuegos.
        -- reinica el juego
        TRIBUS = {}
        TRIBUS[0]=0
        TRIBUS[1]=0
        TRIBUS[2]=0
        
        local sim_scene =  love.filesystem.load("scenes/intro.lua")()
        SCENA_MANAGER.replace(sim_scene,{FILENAME})
        MSC_MAIN_MENU:stop()
        
    end

    function self.load(settings)
        background = love.graphics.newImage("/rcs/img/main_title_bg.png")

        scroll_ima = love.graphics.newImage("/rcs/img/Scroll.png")

        game_title = love.graphics.newImage("/rcs/img/before_losing_logo.png")

        newbutton = Boton('',1920/2,1080*0.65,
                love.graphics.getWidth(),love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/new_game.png"),
                love.graphics.newImage("/rcs/gui/new_game_hover.png"))

        creditos = Boton('',1920/2,1080*0.775,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/creditos.png"),
                love.graphics.newImage("/rcs/gui/creditos_hover.png"))

        salir = Boton('',1920/2,1080*0.9,
                love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                love.graphics.newImage("/rcs/gui/quit.png"),
                love.graphics.newImage("/rcs/gui/quit_hover.png"))

        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        --flux.to(self,0.5,{dummy=1}):ease("linear"):oncomplete(addChar)
        tale_box =  BoxTextDLP(DIAL[LANG].gui_once_was_a_king,1920/2-400,
                1080*0.3,800)
        tale_box.setAling('center')
        tale_box.setMode('normal','static')
        
        easing = ayo.new(alphas,1,{a=1}).setEasing('inQuint').chain(1.5,{b=1}).onEnd(tale_box.start) 
        MSC_MAIN_MENU:play()
    end

    function self.draw()

        love.graphics.clear(0,0,0)
        love.graphics.setColor(1,1,1)

        local zoom = 1
        love.graphics.push()

        if STATE == 0 then
            --love.graphics.setShader(GAUSIAN_BLURS)
        end
        love.graphics.setColor(1,1,1,alphas.a)
        love.graphics.draw(background,0,0,0,(1920/background:getWidth()),(1080/background:getHeight())  )

        --love.graphics.setShader()

        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
        
        newbutton.setAlpha(alphas.c,alphas.c)
        newbutton.draw()
        
        creditos.setAlpha(alphas.c,alphas.c)
        creditos.draw()
        
        salir.setAlpha(alphas.c,alphas.c)
        salir.draw()
        
        love.graphics.setColor(1,1,1,alphas.c)
        love.graphics.draw(game_title, (1920/2)-595 )
        
        if STATE == 1 then
            newbutton.setPointerPos(globalX, globalY)
            creditos.setPointerPos(globalX, globalY)
            salir.setPointerPos(globalX, globalY)
        end

        love.graphics.setColor(1,1,1,alphas.b)
        love.graphics.draw(scroll_ima,
            1920*0.5 - (scroll_ima:getWidth()/2)*1.2,
            1080*0.5 - (scroll_ima:getHeight()/2),0,1.2,1)

        if STATE == 2  then
            love.graphics.setColor(0,0,0,alphas.b)
            love.graphics.setFont(FONT_SCROLL)
            love.graphics.printf(DIAL[LANG].gui_team_name,0,1080*0.2,1920,'center')
            love.graphics.setFont(FONT)
            love.graphics.setColor(1,1,1,alphas.b)
            love.graphics.draw(VIDEO_CREDITS,
                1920 * vid_scale_pos.x - (VIDEO_CREDITS:getWidth()/2)* vid_scale_pos.sx,
                1080 * vid_scale_pos.y - (VIDEO_CREDITS:getHeight()/2)* vid_scale_pos.sy,
                0,
                vid_scale_pos.sx,vid_scale_pos.sy)
        end
        
        if tale_box then
            tale_box.draw()
        end
        
        love.graphics.pop()
    end

    function self.update(dt)
        if (STATE == 0 or STATE == 1)  and self.size > 0 and limpiar_fondo  then
            -- GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        end
        
        if tale_box then
            tale_box.update(dt)
        end
        
        if STATE == 2 then
            if VIDEO_CREDITS:tell() >= 39 and not credits_move_vid then
                --
                moving_vid_easing = ayo.new(vid_scale_pos,2,{x=0.5, y=0.5, sx = 1.5, sy = 1.5})
                credits_move_vid = true
            end
            if VIDEO_CREDITS:tell() >= 52 and not credits_show_thanks and tale_box then
                -- thanks for playing!!!
                tale_box = DialogBox(nil,DIAL[LANG].gui_thanks,1000,0.5,0.67)
                tale_box.start()
                tale_box.show_scroll = false
                credits_show_thanks = true
            end
        end
        
        if STATE == 0 or STATE == 2 then
            if not is_text_end and tale_box.isEnded() then
               is_text_end = true
               --flux.to(self,3,{dummy= 0}):oncomplete(limpiaFondo)
                print('The table is ended...')
                easing = ayo.new(alphas,1.25,{b=0, c=1}).delay(1.2).setEasing('outBack').onStart(tale_box.callOutro).onEnd(limpiaFondo)
            end
        end
    end
    
    function quitGame()
        print('Exit game...')
        love.event.quit()
    end

    function self.mousepressed(x, y, button)
        if STATE == 1 then
            if newbutton.isPointerInside() then
                ayo.new(alphas,0.2,{c=0}).setEasing('outBack').chain(0.3,{a=0}).onEnd(loadNewGame)
            end
            if creditos.isPointerInside() then
                STATE = 2
                tale_box =  DialogBox(nil,DIAL[LANG].gui_creditos_full,1000,0.5,0.49)
                tale_box.show_scroll = false
                easing.cancel()
                limpiaFondo()
                VIDEO_CREDITS:rewind()
                easing = ayo.new(alphas,0.5,{c=0}).setEasing('outBack').chain(0.5,{b=1}).setEasing('inSine') 
                flux.to(self,1,{size=8}):oncomplete(ensuciaFondo)
            end
            if salir.isPointerInside() then
                STATE = 0
                ayo.new(alphas,0.2,{c=0}).chain(0.3,{b=0,a=0}).onEnd(quitGame)
            end
        end
        if STATE == 0  or STATE == 2 and not limpiar_fondo then
            if tale_box then
                tale_box.callOutro()
            end
            if STATE == 0 then
                easing.cancel()
            end
            ayo.new(alphas,0.5,{b=0}).onEnd(limpiaFondo)
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
