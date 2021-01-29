--[[
Delepanto - Una libreria para manejar texto.
requires ayouwoki
ver: 20200304
]]
local DPL_FontList = {}
local CharBehaviour = nil

function loadDPL(regular,bold,italic,size)
    local size = size or 20
    loadNewFontDLP('regular',regular,size,CharBehaviour)
    loadNewFontDLP({'bold','*'},bold,size, CharBehaviour)
    loadNewFontDLP({'italic','_'},italic,size,CharBehaviour)
end

function loadNewFontDLP(font_name,font_dir,font_size,behaviour)
    local ok, loaded_font = pcall(love.graphics.newFont,font_dir,font_size)
    if not ok then
        loaded_font = love.graphics.getFont(font_size)
    end
    if type(font_name) == 'table' then
        for _,v in ipairs(font_name) do
            simpleLoadFontDPL(v,font_dir,font_size,behaviour,loaded_font)
        end
    else
        simpleLoadFontDPL(font_name,font_dir,font_size,behaviour,loaded_font)
    end
end

function simpleLoadFontDPL(font_name,font_dir,font_size,behaviour,loaded_font)
    DPL_FontList[font_name] = {}
    DPL_FontList[font_name].name = font_name
    DPL_FontList[font_name].rsc  = font_dir
    DPL_FontList[font_name].size = font_size
    DPL_FontList[font_name].bhvr = behaviour or CharBehaviour
    DPL_FontList[font_name].font = loaded_font
end

local function BaseCharDLP(char_type)
    local self = {}
    self.type_DLP = char_type --character
    self.text = '�'
    
    self.x = x or 0
    self.y = y or 0
    
    self.angle = 0
    self.scale = 1
    self.alpha = 1
    
    --color model
    --RGB
    self.color_model = 'rgb'
    self.cred = 1
    self.cgreen = 1
    self.cblue = 1
    
    self.call_next = false
    
    self.font_id_name = nil
    
    self.gx = 0
    self.gy = 0
    self.lx = 0
    self.ly = 0
    self.aling = 0
    
    function self.setGlobalPos(x,y)
        --is the position of the container...
        self.gx = x
        self.gy = y
    end
    
    function self.setLocalPos(x,y)
        --local pos is the position in the container
        self.lx = x
        self.ly = y
    end
    
    function self.setAlingPos(aling)
        self.aling = aling
    end
    
    function self.awake()
    end
    
    function self.intro()
    end
    
    function self.outro()
    end
    
    function self.wait()
    end

    function self.getWidth()
        return 0
    end
    
    function self.callNextTrue()
        self.call_next = true
    end
    
    function self.canCallNext()
        return self.call_next
    end
    
    function self.drawBG()
    
    end
    
    function self.drawFG()
    end
    
    function self.getWidth()
    end

    
    function self.draw()
    end
    
    return self
end

local function ControlCharacterDPL(control_type)
    local self = BaseCharDLP(control_type)
    
    function self.awake()
        self.callNextTrue()
    end
    
    function self.setArgs()
    end
    
    
    return self
end


local function ControlZeroDPL(font)
    local self = ControlCharacterDPL('z')
    self.font_id_name = font
    function self.getWidth()
        if self.font_id_name then
            return  DPL_FontList[self.font_id_name].font:getWidth(' ')*(-1)
        end
        return -1
    end
    
    return self
end

local function ControlBreakLineDPL(font)
    local self = ControlCharacterDPL('br')
    self.font_id_name = font
    function self.getWidth()
        return -1
    end
    
    return self
end


local function CharDLP(char)
    local self = BaseCharDLP('c')
    self.text = char or '�'
    
    function self.getWidth()
        local font = love.graphics.getFont()
        
        if self.font_id_name then
            return math.floor( DPL_FontList[self.font_id_name].font:getWidth(self.text))
        end
        
        return math.floor(font:getWidth(self.text))
    end

    
    function self.draw()
        
        
        local font = nil
        if self.font_id_name then
            love.graphics.setFont(DPL_FontList[self.font_id_name].font)
        end
        local w = math.floor( DPL_FontList[self.font_id_name].font:getWidth(self.text)/2)
        local h = math.floor( DPL_FontList[self.font_id_name].font:getAscent( )/2)
        local minus_h =  DPL_FontList[self.font_id_name].font:getDescent( )
        
        --self.drawBG()
        
        love.graphics.setColor(self.cred,self.cgreen,self.cblue,self.alpha)
        
        love.graphics.print(self.text,
            self.gx+self.lx+self.x+w-self.aling,self.gy+self.ly+self.y-h,
            self.angle,self.scale,self.scale,w,h)
        
        --[[
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle('line',self.gx+self.x,self.gy+self.y-h*2,w*2,h*2)
        
        love.graphics.setColor(0,1,0)
        love.graphics.circle('fill',self.gx+w,self.gy-h,2)
        
        love.graphics.setColor(0,0,1) 
        love.graphics.rectangle('line',self.gx+self.x,self.gy+self.y+h,w*2,minus_h)
        --]]
    end

    return self
end

--un objeto de tipo "decorator"
function CharBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.awake = function ()
        char_dpl.alpha = 0.2
        char_dpl.x = 0 -- -10
        char_dpl.y = 0 -- 12
        char_dpl.scale = 1.2-- 3
        
        char_dpl.intro()
    end
    
    char_dpl.intro = function()
        --ayo.new(char_dpl,0.5,{alpha=1,x=0,y=0}).setEasing('outSine')
        --ayo.new(char_dpl,0.075,{scale=1}).setEasing('inQuad').onWait(char_dpl.wait)
        ayo.new(char_dpl,0.5,{alpha=1}).setEasing('outSine')
        ayo.new(char_dpl,0.075,{scale=1}).onWait(char_dpl.wait)
    end
    
    
    
   char_dpl.wait = function()
        --print('call next')
        char_dpl.scale = 1
        char_dpl.alpha = 1
        char_dpl.x = 0
        char_dpl.y = 0
        char_dpl.callNextTrue()
        --ayo.new(char_dpl,0.1,{scale=0.90}).chain(0.3,{scale=1})
    end
    
    --string_element.scale = 0.2
    
    return char_dpl
end

local DPL_control_char_list = {}
DPL_control_char_list['z'] = ControlZeroDPL
DPL_control_char_list['br'] = ControlBreakLineDPL

--this parse the string and returns a 
--delepanto character list.
--#de momento | simboliza zero size space
function strToCharLst(my_string)
        local i = 1
        
        local buffer = ''
        local special_char_buffer = '' 
        local character_list = {}
        local word_list = {}
        local position_counter = 0
        local char_counter = 0
        local space_size = 0
        local space_count = 0
        local height_size = 0
        
        my_string = my_string..' '
        
        --simple to read names for the states
        local st_read_str_char = 1
        local st_change_to_ctrl = 2
        local st_read_ctrl_char = 3
        local st_interup_str_char = 4
        local st_change_to_ufnt = 5 --change to user font
        local st_read_user_fnt = 6 --read to user font
        
        local state = 1
        --the default font/beahavior of the text
        local font = 'regular'
        
        local font_stack = {}
        local last_on_font = 0
        
        while i <= my_string:utf8len() do
            local char = my_string:utf8sub(i,i)
            
            if state == st_change_to_ctrl then
                state = st_read_ctrl_char
            end
            
            if state == st_change_to_ufnt then
                state = st_read_ctrl_char --st_read_user_fnt
            end
            
            if state == st_interup_str_char then
                state = st_read_str_char
            end
            
            if char == '*' or char == '_' or char == '<' then

                local j = #font_stack 
                local is_over = false
                local simbol = char
                if char == '<' then
                    i=i+1
                    simbol = ''
                    local sub_char = ''
                    while i <= my_string:utf8len() do
                        sub_char =  my_string:utf8sub(i,i)
                        i=i+1
                        if sub_char == '>' then
                            break
                        end
                        simbol = simbol..sub_char
                    end
                    i=i-1
                    --char = my_string:utf8sub(i,i)
                end
                
                
                if j > 0 then --is not empty
                    --if the top of the stack is equal, this is the closure one.
                    if font_stack[j] == simbol then --remove 
                        table.remove(font_stack,j)
                        is_over = true
                    end
                end
                if not is_over then
                    --we add the char/simbol to the top
                    table.insert(font_stack,simbol)
                end
                
                j = #font_stack
                if j > 0 then
                    --take the last char on the top of the stack to set the font
                    --print('try font: ',font_stack[j])
                    font = DPL_FontList[ font_stack[j] ].name
                else
                    --is empty, set to default
                    font = 'regular'
                end
                
                state = st_interup_str_char
            end
            
            if state == st_read_str_char  then
                --io.write(char)
                if char == ' ' or char == '{'  then
                    --print(buffer)
                    if char_counter>0 then
                        space_count = space_count+1
                        space_size = space_size+( DPL_FontList[font].font:getWidth(' '))
                        height_size = math.max(height_size, DPL_FontList[font].font:getHeight())
                        local pixel_size = 0
                        local char_size = char_counter
                        while char_counter > 0 do
                            
                            pixel_size = pixel_size + character_list[position_counter-char_counter+1].getWidth()
                            char_counter=char_counter-1
                        end
                        
                        local n_table ={}
                        n_table[1] = pixel_size
                        n_table[2] = position_counter
                        n_table[3] = char_size
                        
                        table.insert(word_list,n_table)
                        buffer = ''
                    end
                    if char == '{' then
                        i=i+1
                        local sub_char = ''
                        local special_char = ''
                        while i <= my_string:utf8len() do
                            sub_char =  my_string:utf8sub(i,i)
                            i=i+1
                            if sub_char == '}' then
                                break
                            end
                            special_char = special_char..sub_char
                        end
                        i=i-1
                        
                        special_char=special_char:gsub('%=', ' ')
                        special_char=special_char:gsub('%,', ' ')
                        
                        
                        local num_args = 0
                        local tipe_control_char =nil
                        local args = {}
                        for word in special_char:gmatch("%S+") do
                            if num_args == 0 then
                                tipe_control_char = word
                            else
                                table.insert(args,word)
                            end
                            num_args = num_args+1
                        end
                        
                        local DPL_char_function = DPL_control_char_list[tipe_control_char]
                        if DPL_char_function then
                            local DPL_char = DPL_char_function(font)
                            DPL_char.setArgs(args)
                            local n_table ={}
                            position_counter = position_counter+1
                            n_table[1] = DPL_char.getWidth()
                            n_table[2] = position_counter
                            n_table[3] = -1

                            table.insert(word_list,n_table)
                            table.insert(character_list,DPL_char)
                        end
                        
                        
                        char = my_string:utf8sub(i,i)
                    end
                    
                elseif char == '%' then
                    local n_char = my_string:utf8sub(i+1,i+1)
                    --io.write(n_char)
                    if n_char ~= ' ' then
                        char_counter = char_counter+1
                        position_counter = position_counter+1
                        buffer = buffer..n_char
                        table.insert(character_list,DPL_FontList[font].bhvr(CharDLP(n_char),font) )
                        i=i+1
                    end
                else
                    char_counter = char_counter+1
                    position_counter = position_counter+1
                    buffer = buffer..char
                    table.insert(character_list,DPL_FontList[font].bhvr(CharDLP(char),font) )
                end
                --print()
            end
            --[[
            if state == st_read_ctrl_char then
                if char == '}' then
                    
                    --quita '=' y ',' 
                    special_char_buffer=special_char_buffer:gsub('%=', ' ')
                    special_char_buffer=special_char_buffer:gsub('%,', ' ')
                    local num_args = 0
                    local tipe_control_char =nil
                    local args = {}
                    for word in special_char_buffer:gmatch("%S+") do
                        if num_args == 0 then
                            tipe_control_char = word
                        else
                            table.insert(args,word)
                        end
                        num_args = num_args+1
                    end
                    
                    local DPL_char_function = DPL_control_char_list[tipe_control_char]
                    if DPL_char_function then
                        local DPL_char = DPL_char_function(font)
                        DPL_char.setArgs(args)
                        local n_table ={}
                        position_counter = position_counter+1
                        n_table[1] = DPL_char.getWidth()
                        n_table[2] = position_counter
                        n_table[3] = -1
                        
                        
                        table.insert(word_list,n_table)
                        table.insert(character_list,DPL_char)
                    end
                    
                    state = st_read_str_char
                    special_char_buffer = ''
                    --print('Control character -> '..tipe_control_char)
                else
                    special_char_buffer= special_char_buffer ..char
                end
            end
            ]]
            --print(buffer,#character_list, position_counter,char_counter,#word_list)
            i=i+1
            
        end
        
        space_size = math.floor(space_size/space_count)
        return word_list, character_list, space_size, height_size
end


function wordBreakBox(max_pixel_size,text)
        local max_size = max_pixel_size --en pixeles
        local final_result = {}
        local word_list, character_list, space_size, height_size = strToCharLst(text)
        local first
        i=1
        local line_len = 0
        local n =0 -- el numero de espacios para separar palabras
        local cbreak = 1
        while word_list[i] do
            local size = word_list[i][1]
            if size < 0 then
                if character_list[word_list[i][2]].type_DLP == 'br' then
                    if n> 0 and (max_size-val-n)> 0 then
                        size = max_size-val-(n*space_size)
                    else
                        size = 0
                    end
                end
            end
            --[[
            local j = 1
            local c = word_list[i][3]
            --print(word_list[i][2],c)
            while j <= c do
                io.write(character_list[word_list[i][2]-c+j].text)
                j=j+1
            end
            io.write(' ')
            --]]
            line_len = line_len+size
            
            
            if line_len > max_pixel_size+3 then
                n=0
                line_len = 0
                final_result[cbreak] = i
                cbreak = i
                i=i-1
            else
                --si no nos pasamos, agregamos el tamaño del espacio.
                line_len = line_len+(space_size)
            end
            
            n=n+1
            i=i+1
        end
        final_result[cbreak] = i

    return character_list, word_list, final_result, space_size, height_size
end

function wordBreakBallon(max_pixel_size,text)
        local max_size = max_pixel_size --en pixeles
        local tabla_valores = {}
        local word_list, character_list, space_size, height_size = strToCharLst(text)
        local first
        i=1
        while word_list[i] do
            local sub_table_values={}
            local j=i
            local val = 0
            local n =0 -- el numero de espacios para separar palabras
            while word_list[j] do
                local size = word_list[j][1]
                if size < 0 then
                    if character_list[word_list[j][2]].type_DLP == 'br' then
                        if n> 0 and (max_size-val-n)> 0 then
                            size = max_size-val-(n*space_size)
                        else
                            size = 0
                        end
                    end
                end
                
                val = val+size
                local dist = max_size-val-(n*space_size)
                n=n+1
                if dist < 0 then --cualquier valor donde nos pasemos del borde sera negativo
                    dist=dist*(-99)  --marcamos como  si fuera inaceptablemente grande el costo
                end
                --io.write(("%5d|"):format(dist))
                sub_table_values[j]=dist*dist --escribimos el costo 
                j=j+1
            end
            i=i+1
            table.insert(tabla_valores,sub_table_values)
        end
        
        local minimal_cost = {}
        for i=1, #tabla_valores do
          minimal_cost[i] = 0
        end
        local final_result = {}
        for i=1, #tabla_valores do
          final_result[i] = 0
        end
        i=#word_list
        while i>=1 do
            j= #word_list
            minimal_cost[i] = tabla_valores[i][j]
            final_result[i] = #word_list+1
            while j>i do
                local cost = tabla_valores[i][j-1]
                if cost then
                    if minimal_cost[i] > (minimal_cost[j]+cost) then
                        minimal_cost[i] = minimal_cost[j]+cost
                        final_result[i]=j
                    end
                end
                
                j=j-1
            end
            i=i-1
        end

    return character_list, word_list, final_result, space_size, height_size
end

DLP_ALING_MODES = {}
DLP_ALING_MODES['left'] = 0
DLP_ALING_MODES['center'] = 1
DLP_ALING_MODES['right'] = 2
DLP_ALING_MODES['justifid'] = 4
    
function BaseContainerDLP(user_string,x,y,size_w)
    local self = {}
    
    self.pos = {}
    self.pos.x = x or 0
    self.pos.y = y or 0
    
    self.list_elements = nil
    self.word_list = nil
    self.line_breaks = nil
    self.line_height = 0
    self.space_size = 0
    self.is_over = false
    
    self.repos = {}
    self.repos.x = 0
    self.repos.y = self.line_height
    self.last_y = self.repos.y+(self.line_height*0.5)
    self.last_x = 0
    
    self.next_element = 1
    self.word_count = 1
    self.cbreak_index = 1
    self.index_of_break = 1
    self.aling_mode = 0 --0 is left
    
    self.line_list = {}
    
    function self.setAling(mode)
        self.aling_mode = DLP_ALING_MODES[mode] or 0
    end
    
    function self.addNext()
        if self.list_elements[self.next_element] then
            if self.word_list[self.word_count][2]+1 == self.next_element then
                --io.write(' ')
                if self.list_elements[self.next_element].type_DLP == 'c' then
                    self.repos.x = self.repos.x + self.space_size
                    --io.write(' ')
                end 
                if self.list_elements[self.next_element].type_DLP == 'br' then
                    --pos_x = pos_x+list_elements[next_element].getWidth()
                end
                self.word_count = self.word_count+1
            end
            
            -- revisamos en la lista de break si alcanzamos el punto de quiebre
            -- si lo alcanzamos, entonces fijamos el proximo punto de quiebre
            -- en el valor guardado
            if (self.word_count) == self.line_breaks[self.cbreak_index] then
                self.cbreak_index = self.line_breaks[self.cbreak_index]
                self.repos.y = self.repos.y+self.line_height
                self.repos.x = 0
                self.index_of_break = self.next_element
            end
            --io.write(self.list_elements[self.next_element].text)
            
            self.list_elements[self.next_element].setGlobalPos(self.pos.x,self.pos.y)
            self.list_elements[self.next_element].setLocalPos(self.repos.x,self.repos.y)
            local nx = self.list_elements[self.next_element].getWidth() or 0
            self.repos.x = self.repos.x + nx
            
            self.list_elements[self.next_element].awake()
            self.next_element = self.next_element+1
            --aling center
            if self.aling_mode == 1 then
                --hay que centrar todas las que estan en la linea actual
                --conforme se agregan nuevas palabras
                local i = self.index_of_break
                while i < self.next_element do --<, we are before the increment
                    local npos = -((size_w/2)-(self.repos.x/2))
                    self.list_elements[i].setAlingPos(npos)
                    i=i+1
                end
            end
            --aling right
            if self.aling_mode == 2 then
                --hay que centrar todas las que estan en la linea actual
                --conforme se agregan nuevas palabras
                local i = self.index_of_break
                while i < self.next_element do --<, we are before the increment
                    local npos = self.repos.x-size_w
                    self.list_elements[i].setAlingPos(npos)
                    i=i+1
                end
            end
        else
            self.is_over = true
        end
    end
    
    
    --[[
    function self.recalculate()
        list_elements, word_list, break_list,space_size,height_size = wordBreakBallon(max_size,string)
        pos_x = 0
        pos_y = 0
        word_count = 1
        cbreak_index = 1
        local i = 1
        while i < next_element do
            list_elements[i].wait()
            
            if word_list[word_count][2]+1 == i then
                
                if list_elements[i].type_DLP == 'c' then
                    pos_x = pos_x + space_size
                    --io.write(' ')
                end 
                if list_elements[i].type_DLP == 'br' then
                    --pos_x = pos_x+list_elements[next_element].getWidth()
                    
                end
                word_count = word_count+1
            end
            
            if (word_count) == break_list[cbreak_index] then
                cbreak_index = break_list[cbreak_index]
                pos_y = pos_y+height_size
                pos_x = 0
            end
            --io.write(list_elements[next_element].type_DLP)
            --print(list_elements[next_element].type_DLP, word_count,word_list[word_count][1],word_list[word_count][2],word_list[word_count][3])
            list_elements[i].setGlobalPos(pos_x,pos_y)
            local nx = list_elements[i].getWidth() or 0
            pos_x = pos_x + nx
            
            i=i+1
        end
    end
    --]]
    
    
    function self.update(dt)
        
        
        local i = 1
        while self.list_elements[i] do
            if i == self.next_element-1 then
                if self.list_elements[i].canCallNext() then
                    self.addNext()
                else
                    break
                end
                
            end
            i=i+1
        end
        if self.last_y < self.repos.y+(self.line_height*0.5) then
            self.last_y = self.last_y+self.line_height*dt*5
        end
        if self.last_x < self.repos.x then
            self.last_x = self.last_x+(self.repos.x-self.last_x)
        end
    end
    
    function self.start()
        self.addNext()
    end
    
    function self.isEnded()
        return self.is_over
    end
    
    function self.draw()
        love.graphics.setColor(1,0,1)
        love.graphics.rectangle('line',self.pos.x,self.pos.y,size_w,100)

        i = 1
        while i < self.next_element do
            self.list_elements[i].draw()
            i=i+1
        end        
    end
    
    return self
end


function BoxTextDLP(user_string,x,y,size_w)
    local self = BaseContainerDLP(user_string,x,y,size_w)
    
    local max_size = size_w or 300
    --local string = 'Hola <toon> Taboo a<toon>a lol pala uko '
    local list_elements, word_list, break_list, space_size, height_size = wordBreakBox(max_size,user_string)
    self.list_elements = list_elements
    self.word_list = word_list
    self.line_breaks  = break_list
    self.space_size = space_size
    self.line_height = height_size
    
    self.repos.x = 0
    self.repos.y = self.line_height
    self.last_y = self.repos.y+(self.line_height*0.5)
    self.last_x = 0
    
    return self
end

function BallonTextDLP(user_string,x,y,size_w)
    local self = BaseContainerDLP(user_string,x,y,size_w)
    
    local max_size = size_w or 300
    --local string = 'Hola <toon> Taboo a<toon>a lol pala uko '
    local list_elements, word_list, break_list, space_size, height_size = wordBreakBallon(max_size,user_string)
    self.list_elements = list_elements
    self.word_list = word_list
    self.line_breaks  = break_list
    self.space_size = space_size
    self.line_height = height_size
    
    self.repos.x = 0
    self.repos.y = self.line_height
    self.last_y = self.repos.y+(self.line_height*0.5)
    self.last_x = 0
    
    return self
end