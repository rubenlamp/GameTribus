
function DialogBox(char_name, says, px,py, box_with)
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
	
    local scroll_bg = love.graphics.newImage("/rcs/img/scroll_body.png")
	local scroll_top = love.graphics.newImage("/rcs/img/scroll_head.png")
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
    
    rect.x = 0.5 --this are not pixels, put percents % 
    rect.y = 1 
    rect.w = 0
    rect.h = 0
	
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
            ayo.new(
				rect,
				0.35,
				 {offset_bottom = ((113)/math.floor(self.last_y+self.line_height)) }
				).chain(0.35,{x=0.5,y=0.50,w=0,h=0}).setEasing('inQuint').onEnd(self.endDialog)
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
        offset_y = 0
        local nw, nh = SIZE_B_WIN_W, SIZE_B_WIN_H
        if nw ~= current_w then
            current_w = nw
            h = nh
            self.recalculate(padding, (rect.y+offset_y)*h, nw-padding*2)
        end
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
        --love.graphics.setColor(0,0,0)
        --love.graphics.rectangle('fill', x, y-1, rect.w*w, box_h)
        --self.setPos(rect.x*w ,rect.y*h)
        --love.graphics.setColor(0.5,0.5,0.5,1)
        --love.graphics.rectangle('line', x, y, rect.w*w-2, box_h)
        
        if char_name and start_char_dialog and not end_dialog_started then
            local nx = x+padding
            local nw = char_name_w+padding*2
            love.graphics.setColor(1,1,1)
			love.graphics.rectangle('fill', x, y-char_name_h-padding, nw, 20)
            love.graphics.print(char_name,nx, y-char_name_h-5 )
        end
        
        
        local scroll_scale_x = (( (rect.w+0.08)*w )/scroll_bg:getWidth())
        local scroll_scale_y = ((self.last_y)/scroll_bg:getHeight())
        local scroll_x = (rect.x-0.04)*w
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
		love.graphics.draw(scroll_top,scroll_x,scroll_y-(scroll_top:getHeight()*(2/3)),0,scroll_scale_x,1)
		love.graphics.print(tostring(rect.offset_bottom))
    end
    
    return self
end

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
    
    local dialog = nil
    
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
        tale_box =  BoxTextDLP('',1920/2-400,
                1080*0.3,800)
        tale_box.setAling('center')
        
        MSC_MAIN_MENU:play()
        
        limpiaFondo()
        
        dialog = DialogBox(nil,DIAL[LANG].tale_intro, 0.2, 0.5, 500)
        dialog.start()
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
            --love.graphics.draw(scroll_ima,scroll_x,scroll_y,0, scroll_scale_x,scroll_scale_y)
            
            if self.size == 0 then
                love.graphics.setColor(0,0,0)
                tale_box.draw()
            end

        
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
    
        dialog.draw() 
        
        love.graphics.pop()
    end

    function self.update(dt)
        GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        
        --[[
        tale_box.update(dt)
        if tale_box.isEnded() and not ocupado_texto then
            flux.to(self,1,{size= 8}):ease('quintout'):delay(2):oncomplete(increaseNumber):after(self,1,{size=0}):ease('quintin'):oncomplete(goNextText)
            ocupado_texto = true
        end
        ]]
        dialog.update(dt)
    end

    function self.mousepressed(x, y, button)
        if dialog.is_over then
            dialog.startEndDialog()
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
