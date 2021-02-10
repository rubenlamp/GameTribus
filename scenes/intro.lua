
function DialogBox(char_name, says, box_with, px,py, stx, sty, endx, endy )
    local current_w, h = SIZE_B_WIN_W, SIZE_B_WIN_H
    local offset_y = 0
    
    local padding = 5
    local text = nil
    local current_text = 1
    print('On dialog box : ', says)
    if type(says) == 'string' then
        text = says
    else
        text = says[current_text]
    end
    
    local prc_x = px-((box_with/current_w)/2)
    local prc_y = py
    
	print(prc_x,prc_y)
	
    local scroll_bg = SCROLL_BG_IMA
	local scroll_top = SCROLL_TOP_IMA
    scroll_bg:setWrap('clampzero','repeat')
	
	local quad_scroll = love.graphics.newQuad(0,0, scroll_bg:getWidth(), scroll_bg:getHeight(), scroll_bg:getWidth(), scroll_bg:getHeight())
	
    local self = BoxTextDLP(text,prc_x*current_w,prc_y*h,box_with)
	--print('created')
    self.setAling('center')
	self.setMode('normal','static')
    local rect = {}
    local dialog_end = false 
    local end_dialog_started = false
    
    local delepanto_font_list = getFontListDLP()
    local char_name_font = delepanto_font_list['regular'].font
    local char_name_w  = char_name_font:getWidth(char_name or '')+10
    local char_name_h = char_name_font:getHeight()
    
	
	
	local end_px = prc_x
	local end_py = prc_y
	
	rect.x = prc_x 
	rect.y = prc_y
    rect.w = 0
    rect.h = 0
	
	if stx then
		rect.x = stx-((box_with/current_w)/2)--this are not pixels, put percents %
	end
	if sty then
		rect.y = sty
	end
	if endx then
		end_px = endx-((box_with/current_w)/2)
	end
	if endy then
		end_py = endy
	end
	
	rect.offset_bottom = 0.72
	
	
    self.draw_text = self.draw --the one hynereted by Box text
    self.startDialogText = self.start --
    self.isTextEnded = self.isEnded

    local start_char_dialog = false

    function self.endDialog()
        dialog_end = true
    end
    
    function self.startNextDialog()
        if type(says) == 'string' then
            --the dialog is over, send the next
            self.startEndDialog()
        else
            if says[current_text+1] then
                current_text = current_text+1
                text = says[current_text]
                self.resetText(text)
                self.startDialogText()
            else
                self.startEndDialog()
            end
        end
    end
    
    function self.startEndDialog()
        if not end_dialog_started then
            ayo.new(rect, 1, {offset_bottom = ((113)/math.floor(self.last_y+self.line_height)), w=0, h=0, x=end_px, y=end_py }).setEasing('outQuint').onEnd(self.endDialog)
            end_dialog_started = true
        end
    end
    
    function self.startAllText()
        start_char_dialog = true
        self.startDialogText()
    end
    
    function self.isEnded()
        return dialog_end
    end
    
    local old_update = self.update
    function self.update(dt)
        old_update(dt)
    end
    
    function self.start()
        ayo.new(rect,1,{x=prc_x,y=prc_y,w=(box_with/current_w),h=1}).setEasing('inQuint').chain(0.5,{offset_bottom=1}).setEasing('outExpo').onEnd(self.startAllText)
    end
    
    function self.isPointInside(px,py)
        local area = {}
        local w, h = getGUICanvasSize()
        local x1 = rect.x*w
        local y1 = (rect.y+offset_y)*h
        local x2 = x1 + w
        local y2 = y1 + rect.h*h
        print(px, py)
        print(x1, y1, x2, y2)
        return ((px > x1 and px < x2) and (py > y1 and py < y2))
    end
    
    function self.draw()
        local w, h = SIZE_B_WIN_W, SIZE_B_WIN_H
        local x = rect.x*w
        local y = (rect.y+offset_y)*h
        local b = h*0.2
        local box_h =  rect.h*b
        
        if char_name and start_char_dialog and not end_dialog_started then
            local nx = x+padding
            local nw = char_name_w+padding*2
            love.graphics.setColor(1,1,1)
			love.graphics.rectangle('fill', x, y-char_name_h-padding, nw, 20)
            love.graphics.print(char_name,nx, y-char_name_h-5 )
        end
        
        
        local scroll_scale_x = (( (rect.w+0.08)*w )/scroll_bg:getWidth())
        local scroll_scale_y = ((self.last_y)/scroll_bg:getHeight())
        local scroll_x = (rect.x-0.04)*w + rect.w-(rect.w/2)*w + ((box_with/current_w)/2)*w
        local scroll_y = y
        --love.graphics.setColor(1,0,1)
		
		quad_scroll:setViewport(0,0, scroll_bg:getWidth(), math.floor(self.last_y)*rect.offset_bottom, scroll_bg:getWidth(),scroll_bg:getHeight())
		--local xq, yq, wq, hq = quad_scroll:getViewport()
		
        --love.graphics.rectangle('fill',scroll_x,scroll_y, wq, hq)
        --love.graphics.draw(scroll_bg,scroll_x,scroll_y,0, scroll_scale_x,scroll_scale_y)
		
        love.graphics.setColor(1,1,1,rect.h)
		
		love.graphics.draw(scroll_bg,quad_scroll,scroll_x,scroll_y,0,scroll_scale_x,1)

        if not end_dialog_started then
            --self.next_element if from the base DLP
            self.draw_text()
        end
		
		love.graphics.setColor(1,1,1,rect.h)
		love.graphics.draw(scroll_top,scroll_x,scroll_y+math.floor(self.last_y+self.line_height)*rect.offset_bottom,0,scroll_scale_x,-1)
		love.graphics.draw(scroll_top,scroll_x,scroll_y-(scroll_top:getHeight()*0.7),0,scroll_scale_x,1)
	end
    
    return self
end

function Main()
    local self = Escena()
    
    local background = nil
    local STATE = 0
	
    local limpiar_fondo = false
	local started_exit = false
    self.size = 8
	
    local current_text = 1
    local ocupado_texto = false
    
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
        --mi_menu.keypressed(scancode)
    end

    function self.mousemoved(x, y, dx, dy, istouch)

    end

    function self.mousereleased(x, y, buttom)

    end


    return self
end

return Main()
