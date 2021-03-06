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
    
    local bg_minigame = MINIGAME_BG_IMA

    local tip_text = nil

    local scroll_ima = nil
    
    local rey_img = nil
    
    local neutral_id = 1
    
    local alphas = {}
    alphas.a = 0
    alphas.b = 0
    alphas.c = 0
    
    local start_dialog = nil
    local king_dialog = nil
    
    local time_out_move = false

    function self.load(settings)
        -- gui_boton_opcion.png
        aldea_list[0] = Boton('',1530,820,500,500,love.graphics.newImage("/rcs/img/aldea_circulo_normal.png"))
        aldea_list[1] = Boton('',480,315,100,100,love.graphics.newImage("/rcs/img/aldea_cuadrado_normal.png"))
        aldea_list[2] = Boton('',370,730,500,500,love.graphics.newImage("/rcs/img/aldea_triangulo_normal.png"))

        kings_list = KINGS_IMG_LIST
        rey_img = KING_IMG        
        local boton_bg = nil -- love.graphics.newImage("/rcs/img/gui_boton_opcion.png")
        --[[
        DIAL[LANG].gui_opt_atk
        DIAL[LANG].gui_opt_dial
        DIAL[LANG].gui_opt_ret
        ]]
        boton_atacar =  Boton('', 1920*1.37,1080*0.65,0,0,
            love.graphics.newImage("/rcs/gui/attack.png"),love.graphics.newImage("/rcs/gui/hover_attack.png"))
        boton_diplom =  Boton('', 1920*1.63,1080*0.65,0,0,
            love.graphics.newImage("/rcs/gui/diplomacy.png"),love.graphics.newImage("/rcs/gui/hover_diplomacy.png"))

        local back_img = love.graphics.newImage("/rcs/gui/back.png")
        local back_img_hover = love.graphics.newImage("/rcs/gui/hover_back.png")
        boton_go_back = Boton('', 1920*1.5,1080*0.82,0,0,
            back_img,back_img_hover)

        MSC_MAP_MENU:play()
        
        
        if (TRIBUS[0] > 0) then neutral_id = neutral_id+1 end
        if (TRIBUS[1] > 0) then neutral_id = neutral_id+1 end
        if (TRIBUS[2] > 0) then neutral_id = neutral_id+1 end

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
                back_ground = love.graphics.newImage("/rcs/scenes/rey_victoria.png")
                --tale box esta un poco más abajo
				start_dialog = DialogBox(nil,tell,550,0.5,0.6)
				boton_go_back_end = Boton('', 1920*0.5,1080*0.92,0,0,
					back_img,back_img_hover)
            else
                state = 5 -- derrota
                MSC_DERROTA:play()
                tell = DIAL[LANG].gui_derrota_final
                back_ground = love.graphics.newImage("/rcs/scenes/rey_derrota.png")
				start_dialog = DialogBox(nil,tell,550,0.5,0.08)
				boton_go_back_end = Boton('', 1920*0.5,1080*0.35,0,
					back_img,back_img_hover)
            end
        else
			start_dialog = DialogBox(nil,DIAL[LANG].gui_choose_status[neutral_id],550,0.8,0.08)
            back_ground = love.graphics.newImage("/rcs/img/aldea_mapa.png")
        end
                
        start_dialog.start()
        
        ayo.new(alphas,1,{a=1}).setEasing('inQuint')
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

        love.graphics.clear(0,0,0)
        love.graphics.setColor(1,1,1)

        local zoom = 1

        love.graphics.push()

        love.graphics.translate(self.cam_x,0)

        --love.graphics.setShader(GAUSIAN_BLURS)
        
        love.graphics.setColor(1,1,1,alphas.a)
        love.graphics.draw(back_ground,0,0,0,(1920/back_ground:getWidth()),(1080/back_ground:getHeight())  )
        love.graphics.draw(bg_minigame,1920,0,0,(1920/back_ground:getWidth()),(1080/back_ground:getHeight())  )
        --love.graphics.setShader()

        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)

        -- Dibujar toda la pantalla donde vez al resto de los jefes de las tribus
        if state <= 3 then
            -- Dibujar al rey  
        	love.graphics.setColor(1,1,1)
            love.graphics.draw(rey_img,
                1920+(rey_img:getWidth())*0.75,0,0,-0.75,0.75)
 		    
            -- Aqui se dibujan los botones donde escoges con cual aldea interactuar
			local i = 0
            while aldea_list[i] do
                aldea_list[i].setPointerPos(globalX, globalY)
                aldea_list[i].setAlpha(alphas.a,alphas.a)
                aldea_list[i].draw()
                i=i+1
            end
             
            if kings_list[working_id] then
                love.graphics.draw(kings_list[working_id],
                    1920*1.86-(kings_list[working_id]:getWidth()/2)*0.85,0,0,0.85,0.85  )
            end
            
            
            if king_dialog then
                king_dialog.draw()
            end
		    
            -- Dibujar los botones de decision.
			if state == 2 then
			    love.graphics.setColor(1,1,1)
                -- El estado de estos botones depende si el jugador ya a interacutado con esta tribu			
                if TRIBUS[working_id]==0 then
                    boton_atacar.setPointerPos(globalX, globalY)
                    boton_atacar.draw()

                    boton_diplom.setPointerPos(globalX, globalY)
                    boton_diplom.draw() end
			
			    boton_go_back.setPointerPos(globalX, globalY)
			    boton_go_back.draw()
			end

        end

        --love.graphics.print('Escoge una aldea para hacer algo...')
       

        if state >= 4 then
            love.graphics.setColor(1,1,1,1)
			if start_dialog.is_over then
				boton_go_back_end.setPointerPos(globalX, globalY)
				boton_go_back_end.draw()
			end
        end
		
		start_dialog.draw()
		
        love.graphics.pop()
    end

    function self.update(dt)
        
        start_dialog.update(dt)
        
        if king_dialog then
            king_dialog.update(dt)
        end
        
        if working_id >= 0  then
            if state == 1 then
                if time_out_move then
                    state = 2
                end
            end
            if state == 3 then
                if time_out_move then
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
                    time_out_move = false
                end
            end
        end
    end
    
    local function endMove()
        time_out_move = true
    end

    function self.mousepressed(x, y, button)
        if button == 1 then
            if state == 1 then
                local i = 0
                while aldea_list[i] do
                    if aldea_list[i].isPointerInside() then
                        working_id = i
                        flux.to(self,1,{cam_x = -1920}):oncomplete(endMove)
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
                        
                        local king_dialog_text = ''
                        if TRIBUS[working_id] == 0 then
                            king_dialog_text = DIAL[LANG].gui_tribus[working_id].neutral[neutral_id]
                        end
                        if TRIBUS[working_id]==1  or TRIBUS[working_id]==2 then
                            king_dialog_text = DIAL[LANG].gui_tribus[working_id].btl_won
                        end
                        if TRIBUS[working_id]==3 or TRIBUS[working_id]==4 then
                            king_dialog_text = DIAL[LANG].gui_tribus[working_id].diag_won
                        end
                        
                        king_dialog = DialogBox(nil,king_dialog_text,550,1.5,0.08)
                        king_dialog.start()
                        --state = 2
                        break
                    end
                    i=i+1
                end
            end
            if state == 2 then
                if boton_go_back.isPointerInside() then
                    flux.to(self,1,{cam_x = 0}):oncomplete(function() state = 3 end)
                    if king_dialog then
                        king_dialog.startEndDialog()
                    end
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
