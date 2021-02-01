EXIT_TO =  nil

function Main()
    local self = Escena()

    local aldea_list = {}
    local kings_list = {}
    local state = 1
    local working_id = -1
    local offset_x = 0
    local back_ground = nil

    self.blur_size = 0
    self.cam_x = 0

    local boton_atacar = nil
    local boton_diplom = nil
    local boton_go_back = nil
    local boton_go_back_end = nil

    local tip_text = nil

    local tale_box = nil
    local scroll_ima = nil
    
    local rey_img = nil

    function self.load(settings)
        -- gui_boton_opcion.png
        aldea_list[0] = BotonAldea(love.graphics.newImage("/rcs/img/aldea_circulo_normal.png"),1530,820,500,500)
        aldea_list[1] = BotonAldea(love.graphics.newImage("/rcs/img/aldea_cuadrado_normal.png"),480,315,100,100)
        aldea_list[2] = BotonAldea(love.graphics.newImage("/rcs/img/aldea_triangulo_normal.png"),370,730,500,500)

        kings_list[0] = love.graphics.newImage("/rcs/img/rey_circulo.png")
        kings_list[1] = love.graphics.newImage("/rcs/img/rey_cuadrado.png")
        kings_list[2] = love.graphics.newImage("/rcs/img/rey_triangulo.png")

        back_ground = love.graphics.newImage("/rcs/img/aldea_mapa.png")
        
        rey_img = love.graphics.newImage("/rcs/img/rey_jugador.png")
        
        local boton_bg = nil -- love.graphics.newImage("/rcs/img/gui_boton_opcion.png")
        --[[
        DIAL[LANG].gui_opt_atk
        DIAL[LANG].gui_opt_dial
        DIAL[LANG].gui_opt_ret
        ]]
        boton_atacar =  Boton('', 1920*1.75,1080*0.3,0,0,
            love.graphics.newImage("/rcs/gui/attack.png"),love.graphics.newImage("/rcs/gui/hover_attack.png"))
        boton_diplom =  Boton('', 1920*1.75,1080*0.5,0,0,
            love.graphics.newImage("/rcs/gui/diplomacy.png"),love.graphics.newImage("/rcs/gui/hover_diplomacy.png"))

        local back_img = love.graphics.newImage("/rcs/gui/back.png")
        local back_img_hover = love.graphics.newImage("/rcs/gui/hover_back.png")
        boton_go_back = Boton('', 1920*1.75,1080*0.7,0,0,
            back_img,back_img_hover)

        boton_go_back_end = Boton('', 1920*0.5,1080*0.8,0,0,
            back_img,back_img_hover)

        MSC_MAP_MENU:play()

        if TRIBUS[0] > 0 and TRIBUS[1] > 0 and TRIBUS[2] > 0 then
            MSC_MAP_MENU:stop()
            local won_1 = 0
            local won_2 = 0
            local won_3 = 0
            if (TRIBUS[0] == 1 or TRIBUS[0] == 3) then won_1 = 1 end
            if (TRIBUS[1] == 1 or TRIBUS[1] == 3) then won_2 = 1 end
            if (TRIBUS[2] == 1 or TRIBUS[2] == 3) then won_3 = 1 end
            local ganadas = won_1+won_2+won_3
            local tell = ''
            if ganadas >= 2 then
                state = 4 -- victoria
                MSC_EXITO:play()
                tell = DIAL[LANG].gui_victoria_final
            else
                state = 5 -- derrota
                MSC_DERROTA:play()
                tell = DIAL[LANG].gui_derrota_final
            end

            tale_box =  BoxTextDLP(tell,1920/2-400,
                1080*0.3,800)

            scroll_ima = love.graphics.newImage("/rcs/img/Scroll.png")

            tale_box.setAling('center')
            tale_box.start()
        end
    end

    function self.goToDiplomMini()
        local sim_scene =  love.filesystem.load("scenes/min_diplo.lua")()
        SCENA_MANAGER.replace(sim_scene,{working_id})
        MSC_MAP_MENU:stop()
        if working_id == 0 then
            MSC_TRB_PACIFICA:stop()
        end
        if working_id == 1 then
            MSC_TRB_MERCANTE:stop()
        end
        if working_id == 2 then
            MSC_TRB_GUERRERA:stop()
        end
    end

    function self.goToAtaqueMini()
        local sim_scene =  love.filesystem.load("scenes/min_atack.lua")()
        SCENA_MANAGER.replace(sim_scene,{working_id})
        MSC_MAP_MENU:stop()
        if working_id == 0 then
            MSC_TRB_PACIFICA:stop()
        end
        if working_id == 1 then
            MSC_TRB_MERCANTE:stop()
        end
        if working_id == 2 then
            MSC_TRB_GUERRERA:stop()
        end
    end

    function self.draw()

        love.graphics.clear(0.6,0.6,0.6)
        love.graphics.setColor(1,1,1)

        local zoom = 1

        love.graphics.push()

        love.graphics.translate(self.cam_x,0)

        --love.graphics.setShader(GAUSIAN_BLURS)
        
        love.graphics.setColor(1,1,1)
            love.graphics.draw(rey_img,
                1920*1.4-(rey_img:getWidth()/2)*0.8,
                1080*1.25-(rey_img:getHeight())*0.8,
                0,-0.8,0.8)
        
        love.graphics.draw(back_ground,0,0,0,(1920/back_ground:getWidth()),(1080/back_ground:getHeight())  )
        --love.graphics.setShader()

        love.graphics.setColor(1,0,1)
        --love.graphics.print('Escoge una aldea para hacer algo...')
        if state == 2 then
            love.graphics.setColor(0,0,0)
            --love.graphics.print('¿Qué quieres hacer?',1920*1.6,150)
            love.graphics.setColor(1,1,1)

            if TRIBUS[working_id]==0 then
                boton_atacar.setPointerPos(globalX, globalY)
                boton_atacar.draw()

                boton_diplom.setPointerPos(globalX, globalY)
                boton_diplom.draw()
            end
            if TRIBUS[working_id]==1 then
                love.graphics.printf(DIAL[LANG].gui_tribus[working_id].btl_won,
                    1920*1.5,1080*0.26,1920*0.45,'center')
            end
            if TRIBUS[working_id]==2 then
                love.graphics.printf(DIAL[LANG].gui_tribus[working_id].btl_lost,
                    1920*1.5,1080*0.26,1920*0.45,'center')
            end
            if TRIBUS[working_id]==3 then
                love.graphics.printf(DIAL[LANG].gui_tribus[working_id].diag_won,
                    1920*1.5,1080*0.26,1920*0.45,'center')
            end
            if TRIBUS[working_id]==4 then
                love.graphics.printf(DIAL[LANG].gui_tribus[working_id].diag_lost,
                    1920*1.5,1080*0.26,1920*0.45,'center')
            end

            boton_go_back.setPointerPos(globalX, globalY)
            boton_go_back.draw()


            if show_tip then
                love.graphics.setColor(1,0,1)
                --love.graphics.print(tip_text,1920*1.5,850)
                love.graphics.setColor(0,0,0)
                --love.graphics.print(tip_text,1920*1.5-2,850)
            end

        end
        --love.graphics.scale(2,2)

        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)

        if state <= 3 then
            local i = 0
            while aldea_list[i] do
                aldea_list[i].setPointerPos(globalX, globalY)
                aldea_list[i].draw()
                i=i+1
            end
            -- working id goes here
            if kings_list[working_id] then
                love.graphics.draw(kings_list[working_id],
                    1920*1.35-(kings_list[working_id]:getWidth()/2)*0.75,0,0,0.75,0.75  )
            end
            
            love.graphics.setColor(1,1,1)
            love.graphics.draw(rey_img,
                1920*0.77-(rey_img:getWidth()/2)*0.15,
                1080*0.35-(rey_img:getHeight())*0.15,
                0,0.15,0.15)
        end
        
        
        
        
        if state >= 4 then

            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(scroll_ima,
                1920/2-(scroll_ima:getWidth()/2)*2.6,
                1080/2-(scroll_ima:getHeight()/2)*2.30,0,2.6,2.3)

            love.graphics.setColor(0.2,0.2,0)

            love.graphics.push()
            love.graphics.translate(3,3)
            tale_box.draw()
            love.graphics.pop()

            love.graphics.setColor(0,0,0)
            tale_box.draw()

            boton_go_back_end.setPointerPos(globalX, globalY)
            boton_go_back_end.draw()

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
                    MSC_MAP_MENU:play()
                    if working_id == 0 then
                        MSC_TRB_PACIFICA:stop()
                    end
                    if working_id == 1 then
                        MSC_TRB_MERCANTE:stop()
                    end
                    if working_id == 2 then
                        MSC_TRB_GUERRERA:stop()
                    end
                    working_id = -1
                    state = 1
                end
            end
        end
        if state >= 4 then
            tale_box.update(dt)
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
                        MSC_MAP_MENU:pause()
                        if working_id == 0 then
                            MSC_TRB_PACIFICA:play()
                        end
                        if working_id == 1 then
                            MSC_TRB_MERCANTE:play()
                        end
                        if working_id == 2 then
                            MSC_TRB_GUERRERA:play()
                        end
                        --state = 2
                        break
                    end
                    i=i+1
                end
            end
            if state == 2 then
                if boton_go_back.isPointerInside() then
                    aldea_list[working_id].goBack()
                    flux.to(self,1,{cam_x = 0})
                    state = 3
                end
                if boton_diplom.isPointerInside() then
                    self.goToDiplomMini()
                end
                if boton_atacar.isPointerInside() then
                    self.goToAtaqueMini()
                end
                --boton_atacar.isPointerInside()
            end
            if state >= 4 then
                if boton_go_back_end.isPointerInside() then
                    self.goToMainMenu()
                end
                --boton_atacar.isPointerInside()
            end
        end
    end

    function  self.goToMainMenu()
        local sim_scene =  love.filesystem.load("scenes/main_menu.lua")()
        MSC_DERROTA:stop()
        MSC_EXITO:stop()
        MSC_MAP_MENU:stop()
        
        TRIBUS = {}
        TRIBUS[0]=0
        TRIBUS[1]=0
        TRIBUS[2]=0
        
        SCENA_MANAGER.replace(sim_scene)
        
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
