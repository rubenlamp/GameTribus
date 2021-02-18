
function Main()
    local self = Escena()
    
    local background = nil
    local STATE = 0
	
    local limpiar_fondo = false
	
    self.size = 8
	
    local current_text = 1
    local ocupado_texto = false
	local started_exit = false
	local user_exit = false
    
    local dialog = nil
	local dialog_list = {}
    local alphas = {}
	alphas.a = 0
	alphas.b = 0
	alphas.dummi = 0

    function limpiaFondo()
        if not limpiar_fondo then
            flux.to(self,2,{size=0}):ease("quadout"):oncomplete(changeState)
            limpiar_fondo = true
        end
    end
	
	function changeState()
		STATE = 1
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
	
	function startEndDialog()
		--print('startEndDialog')
		dialog.startEndDialog()
		alphas.dummi = 0
		ocupado_texto = false
	end
	
	function startDialog()
		print('start Dialog')
		dialog.start()
	end

    function self.load(settings)
        
        background = {
            love.graphics.newImage("/rcs/img/mapa.png"),
            love.graphics.newImage("/rcs/scenes/rey_buscando.png")
        }

        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        MSC_MAIN_MENU:play()
        
        limpiaFondo()
        
		local positions = {
			{0.25,0.05},
			{0.75,0.8},
			{0.25,0.8},
			{0.75,0.05},
			{0.5,0.3},
			{0.25,0.2},
			{0.75,0.6}
			}
		for k, v in ipairs(DIAL[LANG].tale_intro) do
			current_text = 1
			dialog_list[k] = DialogBox(nil,v, 500, positions[k][1], positions[k][2])
		end
		
		ayo.new(alphas,1,{a=1}).setEasing('inSine').onEnd(startDialog)
		
        dialog = dialog_list[current_text]
    end

    function self.draw()

        love.graphics.clear(0,0,0)
        love.graphics.setColor(1,1,1)

        local zoom = 1
        love.graphics.push()
        
        love.graphics.setShader(GAUSIAN_BLURS)
        
		love.graphics.setColor(1,1,1,alphas.a)
        love.graphics.draw(background[1],0,0,0,
            (1920/background[1]:getWidth()),(1080/background[1]:getHeight())  )
		love.graphics.setColor(1,1,1,alphas.b)
		love.graphics.draw(background[2],0,0,0,
            (1920/background[2]:getWidth()),(1080/background[1]:getHeight())  )
		
        love.graphics.setShader()
		
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
		
		if dialog then
			dialog.draw() 
        end
		
        love.graphics.pop()
    end

    function self.update(dt)
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
		
        
		if dialog then
			dialog.update(dt)
			
			if dialog.isEnded() and not  ocupado_texto then
				dialog = nil
				if dialog_list[current_text + 1] then
					current_text = current_text + 1 
					dialog = dialog_list[current_text]
					if current_text == 6 then
						ayo.new(alphas,1,{a=0,b=1}).setEasing('inSine').onEnd(startDialog)
					else
						dialog.start()
					end
				end
			end
			if dialog and dialog.is_over and not ocupado_texto then
				ayo.new(alphas,1,{dummi=1}).setEasing('inSine').onEnd(startEndDialog)
				ocupado_texto = true
			end
		end
		
		if not dialog and not dialog_list[current_text+1] and not started_exit then
			print('go out')
			ayo.new(alphas,1,{b=0}).setEasing('inSine').onEnd(loadNewGame)
			started_exit = true
		end
		
	end

    function self.mousepressed(x, y, button)

    end

    function self.keyreleased( key, scancode )

    end

    function self.keypressed(key,scancode)
		if key == 'space' and not started_exit then
			startEndDialog()
			ayo.new(alphas,1.5,{a=0,b=0}).setEasing('inSine').onEnd(loadNewGame)
			started_exit = true
		end
        --mi_menu.keypressed(scancode)
    end

    function self.mousemoved(x, y, dx, dy, istouch)

    end

    function self.mousereleased(x, y, buttom)

    end


    return self
end

return Main()
