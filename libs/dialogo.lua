
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
	
    local self = BoxTextDLP(text,prc_x*current_w+box_with*0.05,prc_y*h,box_with*0.9)
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
			self.callOutro()
            ayo.new(rect,0.5, 
				{offset_bottom = ((108)/math.floor(self.last_y+self.line_height))})
				.setEasing('inQuint')
				.chain(0.2, { w=0, h=0, x=end_px, y=end_py}).setEasing('inSine').onEnd(self.endDialog)
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

        self.draw_text()
		
		love.graphics.setColor(1,1,1,rect.h)
		love.graphics.draw(scroll_top,scroll_x,scroll_y+math.floor(self.last_y+self.line_height)*rect.offset_bottom,0,scroll_scale_x,-1)
		love.graphics.draw(scroll_top,scroll_x,scroll_y-(scroll_top:getHeight()*0.7),0,scroll_scale_x,1)
	end
    
    return self
end
