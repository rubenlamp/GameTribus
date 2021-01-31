EXIT_TO =  nil

function flip_v_magic(om)
    local nm = {}
    nm[1] = om[13]
    nm[2] = om[14]
    nm[3] = om[15]
    nm[4] = om[16]
    
    nm[5] = om[9]
    nm[6] = om[10]
    nm[7] = om[11]
    nm[8] = om[12]
    
    nm[9] =  om[5]
    nm[10] = om[6]
    nm[11] = om[7]
    nm[12] = om[8]
    
    nm[13] = om[1]
    nm[14] = om[2]
    nm[15] = om[3]
    nm[16] = om[4]
    
    return nm
end

function flip_h_magic(om)
    local nm = {}
    nm[1] = om[4]
    nm[2] = om[3]
    nm[3] = om[2]
    nm[4] = om[1]
    
    nm[5] = om[8]
    nm[6] = om[7]
    nm[7] = om[6]
    nm[8] = om[5]
    
    nm[9] =  om[12]
    nm[10] = om[11]
    nm[11] = om[10]
    nm[12] = om[9]
    
    nm[13] = om[16]
    nm[14] = om[15]
    nm[15] = om[14]
    nm[16] = om[13]
    
    return nm
end


function rotate_magic_90l(om)
    -- 4 8 12 16 3 7 11 15 2 6 10 14 1 5 9 13
    local nm = {}
    nm[1] = om[4]
    nm[2] = om[8]
    nm[3] = om[12]
    nm[4] = om[16]
    
    nm[5] = om[3]
    nm[6] = om[7]
    nm[7] = om[11]
    nm[8] = om[15]
    
    nm[9] = om[2]
    nm[10] = om[6]
    nm[11] = om[10]
    nm[12] = om[14]
    
    nm[13] = om[1]
    nm[14] = om[5]
    nm[15] = om[9]
    nm[16] = om[13]
    
    return nm
end

function rotate_magic_90r(om)
    -- 13 9 5 1 14 10 6 2 15 11 7 3 16 12 8 4
    local nm = {}
    nm[1] = om[13]
    nm[2] = om[9]
    nm[3] = om[5]
    nm[4] = om[1]
    
    nm[5] = om[14]
    nm[6] = om[10]
    nm[7] = om[6]
    nm[8] = om[2]
    
    nm[9] = om[15]
    nm[10] = om[11]
    nm[11] = om[7]
    nm[12] = om[3]
    
    nm[13] = om[16]
    nm[14] = om[12]
    nm[15] = om[8]
    nm[16] = om[4]
    
    return nm
end


--- genera un cuadrado magico de 4x4
function magicCuadro()
    local mn = {}
    local n = love.math.random(34,50) 
    -- 1  2  3  4
    -- 5  6  7  8
    -- 9  10 11 12
    -- 13 14 15 16
    mn[ 1] = n-20
    mn[ 2] = 1
    mn[ 3] = 12
    mn[ 4] = 7
    mn[ 5] = 11
    mn[ 6] = 8
    mn[ 7] = n-21
    mn[ 8] = 2
    mn[ 9] = 5
    mn[10] = 10
    mn[11] = 3
    mn[12] = n-18
    mn[13] = 4
    mn[14] = n-19
    mn[15] = 6
    mn[16] = 9

    local max = love.math.random(0,10)
    local i = 0
    while i < max do -- una opración al azar en el cuadro maxico
        local hacer = love.math.random(0,3)
        if hacer == 0 then
            mn = flip_v_magic(mn)
        end
        if hacer == 1 then
            mn = flip_h_magic(mn)
        end
        if hacer == 2 then
            mn = rotate_magic_90l(mn)
        end
        if hacer == 3 then
            mn = rotate_magic_90r(mn)
        end
        i=i+1
    end
    
    if testMagicBit(mn, n) == 255 then
        return mn , n
    else
        return magicCuadro(), n
    end
    
end

--El cubo magico si es magico.
function testMagicPrint(mc,n)
    print('Todos deben sumar... ',n)
    --horizontal test
    local number = 0
    while number < 4 do
        local i = number*4+1
        local top = number*4+5
        local sum = 0
        while i < top do
            local st = string.format('[%4d]',mc[i])
            io.write(st)
            sum = sum + mc[i]
            i=i+1
        end
        io.write(' = '..tostring(sum)..'\n')
        number= number+1
    end
    
    local sum = mc[13]+mc[9]+mc[5]+mc[1]
    local st = string.format(' %4d ',sum)
    io.write(st)
    sum = mc[14]+mc[10]+mc[6]+mc[2]
    
    st = string.format(' %4d ',sum)
    io.write(st)
    sum = mc[15]+mc[11]+mc[7]+mc[3]
    
    st = string.format(' %4d ',sum)
    io.write(st)
    sum = mc[16]+mc[12]+mc[8]+mc[4]
    
    st = string.format(' %4d ',sum)
    io.write(st)
    print()
end


-- igual que test magic, pero regresa un entero que dice si pasamos o no y donde
function testMagicBit(mc,n)
    local bitsum = 0
    
    local sum = mc[1]+mc[2]+mc[3]+mc[4]
    if sum == n then bitsum = bit.bor(bitsum,1) end
    
    sum = mc[5]+mc[6]+mc[7]+mc[8]
    if sum == n then bitsum = bit.bor(bitsum,2) end
    
    sum = mc[9]+mc[10]+mc[11]+mc[12]
    if sum == n then bitsum = bit.bor(bitsum,4) end
    
    sum = mc[13]+mc[14]+mc[15]+mc[16]
    if sum == n then bitsum = bit.bor(bitsum,8) end
    
    sum = mc[13]+mc[9]+mc[5]+mc[1]
    if sum == n then bitsum = bit.bor(bitsum,16) end
    
    sum = mc[14]+mc[10]+mc[6]+mc[2]
    if sum == n then bitsum = bit.bor(bitsum,32) end
    
    sum = mc[15]+mc[11]+mc[7]+mc[3]
    if sum == n then bitsum = bit.bor(bitsum,64) end
    
    sum = mc[16]+mc[12]+mc[8]+mc[4]
    if sum == n then bitsum = bit.bor(bitsum,128) end
    
    return bitsum
end

function BotonDrawAndDrop(text,x,y,w,h)
    local self = Boton(text,x,y,w,h)
    
    self.original_pos_x = x
    self.original_pos_y = y
    
    function self.returnToPos()
        --self.pos.x = self.original_pos_x
        --self.pos.y = self.original_pos_y
        flux.to(self.pos,0.25,{x=self.original_pos_x,y=self.original_pos_y}):ease("expoout")
    end
    
    self.rgba_text = {1,1,1,1}
    self.rgba = {0,0,0,1}
    
    self.rgba_hover = {0.25,0.25,0.25,0.5}
    self.rgba_text_hover = {0.1,1,1,1}
    
    return self
end

-- x, y, posicion central de la cuadricula
-- cw ch, tamaño horizontal y vertical de cada celda
function Cuadricula(x,y,cw,ch,magico,suma)
    local self = {}
    local rx = x-cw*2
    local ry = y-ch*2
    local rw = cw*4
    local rh = ch*4
    
    local mx = 0
    local my = 0
    
    local lista_huecos = {}
    local i = 1
    while magico[i] do
        if magico[i] == 0 then
            local desc = {}
            lista_huecos[i] = 0
        end
        i=i+1
    end
    
    print('bitsum es ', testMagicBit(magico,suma))
    
    function checkCuadro()
        
    end
    
    function self.setMousePos(x,y)
        mx = x-rx
        my = y-ry
    end
    
    local function getIndex()
        local x = math.floor(mx/cw)
        local y = math.floor(my/ch)
        if x >= 0 and x < 4  and y >= 0 and y < 4 then
            return (x + ( y * 4)+1)
        end
        return nil
    end
    
    function self.clearPlace()
        local index = getIndex()
        if index then
            if lista_huecos[index] then
                if lista_huecos[index] >= 0 then
                    magico[index] = 0
                    lista_huecos[index] = 0
                end
            end
        end
    end
    
    function self.putValueOnPlace(px,py,value, button_index)
        local x = math.floor((px-rx)/cw)
        local y = math.floor((py-ry)/ch)
        --print('put value on...', x,y)
        if x >= 0 and x < 4  and y >= 0 and y < 4 then
            local index = (x + ( y * 4)+1)
            magico[index] = value
            lista_huecos[index] = button_index
        end
    end
    
    function self.canPutInPlace(number, button_index)
        local index = getIndex()
        local x = math.floor(mx/cw)
        local y = math.floor(my/ch)
        if index then
            if lista_huecos[index] then -- ¿existe?
                magico[index] = number
                local old_in_place = lista_huecos[index] 
                lista_huecos[index] = button_index
                if old_in_place == 0 then -- no esta ocupado?
                    return (rx + cw*x + cw/2), (ry + ch*y + ch/2), old_in_place
                else
                    --este es el lugar, pero intercambialo por este de aqui..
                    -- y no olvides tambien poner el valor que tiene en el otro indece...
                    return (rx + cw*x + cw/2), (ry + ch*y + ch/2), old_in_place
                end
            end
        end
        return nil
    end
    
    function self.isCompletado()
        return (testMagicBit(magico,suma) == 255)
    end
    
    function self.drawStandBy()
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle('fill',rx,ry,rw,rh,35,35,8)
        
        local i = 0
        while i < 4 do
            love.graphics.printf('*', rx+rw, ry+ch*i+ch*0.2,cw,'center')
            love.graphics.printf('*', rx-cw, ry+ch*i+ch*0.2,cw,'center')
            love.graphics.printf('*', rx+cw*i, ry+rh+ch*0.2,cw,'center')
            i=i+1
        end
    end
    
    function self.draw()
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle('fill',rx,ry,rw,rh,35,35,8)
        love.graphics.setColor(1,1,1,1)
        local x = math.floor(mx/cw)
        local y = math.floor(my/ch)
        love.graphics.printf(DIAL[LANG].gui_dial_sum..' '..tostring(suma),0,0,1920,'center')
        local bitsum = testMagicBit(magico,suma)
        -- filas horizontales
        
        local num = 0
        love.graphics.setColor(1,0,0,0.3)
        while num < 8 do
            local numcheck  = math.pow(2,num)
            if bit.band(bitsum,numcheck) ~= numcheck then
                if num < 4 then --dibuja las lineas verticales
                    love.graphics.rectangle('fill',rx,ry+ch*num,rw,cw,35,35,8)
                else -- dibuja las horizontales
                    love.graphics.rectangle('fill',rx+cw*(num-4),ry,cw,rh,35,35,8)
                end
            end
            num=num+1
        end
        
        love.graphics.setColor(1,1,1,1)
        local i = 1
        local count = 0
        local sum = 0
        while magico[i] do
            local x = math.fmod(i-1,4)
            local y = math.floor((i-1)/4)
            local ms_str = ''
            if not lista_huecos[i] then
                ms_str = tostring(magico[i])
            else
                love.graphics.setColor(0,0,0,0.5)
                love.graphics.rectangle('fill',rx+cw*x, ry+ch*y,cw,ch,35,35,8)
            end
            love.graphics.setColor(1,1,1,1)
            love.graphics.printf(ms_str, rx+cw*x, ry+ch*y+ch*0.2,cw,'center')
            sum = sum+magico[i]
            count = count+1
            if count == 4 then
                love.graphics.setColor(1,0,0,1)
                if sum == suma then
                    love.graphics.setColor(1,1,0,1)
                end
                love.graphics.printf(tostring(sum), rx+rw, ry+ch*y+ch*0.2,cw,'center')
                love.graphics.printf(tostring(sum), rx-cw, ry+ch*y+ch*0.2,cw,'center')
                sum = 0
                count = 0
            end
            i=i+1
        end
        
        i = 0
        while i < 4 do
            local sum = magico[13+i]+magico[9+i]+magico[5+i]+magico[1+i]
            love.graphics.setColor(1,0,0,1)
            if sum == suma then
                love.graphics.setColor(1,1,0,1)
            end
            love.graphics.printf(tostring(sum), rx+cw*i, ry+rh+ch*0.2,cw,'center')
            i=i+1
        end
    end
    
    return self
end

local function getTwoDiffNum()
    local num_1 = love.math.random(0,3)
    local num_2 = love.math.random(0,3)
    local diferente = num_1 ~= num_2
    while not diferente do
        num_2 = love.math.random(0,3)
        diferente = num_1 ~= num_2
    end
    return num_1, num_2
end

local function has_value(list, val)
    for _, value in ipairs(list) do
        if value == val then
            return true
        end
    end
    return false
end


local function ponHuecos(mc)
    local numeros_faltantes = {}
    
    local columnas = {1,2,3,4}
    local column_list = {}

    local filas = {1,2,3,4}
    local filas_list = {}
    
    while columnas[1] do
        local index = love.math.random(1,#columnas)
        table.insert(column_list,columnas[index])
        table.remove(columnas,index)
    end
    
    while filas[1] do
        local index = love.math.random(1,#filas)
        table.insert(filas_list,filas[index])
        table.remove(filas,index)
    end
    
    local i = 1
    local min = 1000
    local max = 0
    while filas_list[i] do
        local index_1 = column_list[i] + ((filas_list[i]-1) * 4)
        print(column_list[i], filas_list[i], index_1, mc[index_1])
        min = math.min(mc[index_1],min)
        max = math.max(mc[index_1],max)
        table.insert(numeros_faltantes,mc[index_1])
        mc[index_1] = 0
        i=i+1
    end
    
    --agregamos un numero al azar, nos aseguramos que no este repetido
    local number =  love.math.random(min,max+5)
    while has_value(numeros_faltantes,number) do
        number =  love.math.random(min,max+5)
    end
    
    table.insert(numeros_faltantes,number)
    
    return mc, numeros_faltantes
end


function MuestraTiempo(tiempo)
    local self = {}
    
    self.x = (1920/2)- 400
    self.y = 1080*0.08
    
    self.w = 800
    self.h = 30
    
    self.sub_w = 800
    
    local tween = nil
    
    function self.start()
        tween = flux.to(self,tiempo,{sub_w=0}):ease("sineout")
    end
    
    function self.stop()
        tween:stop()
    end
    
    function self.draw()
        love.graphics.setColor(0,1,1,1)
        if self.sub_w > 5 then
            love.graphics.rectangle('fill',self.x+1,self.y+1,self.sub_w-2,self.h-2,9,9,5)
        end
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle('line',self.x,self.y,self.w,self.h,10,10,5)
    end
    
    return self
end

function Main()
    local self = Escena()
    local screen_ima = nil  
    
    local newbutton = nil
    local go_back_button = nil
    local cuadrado = nil
    
    local botones_huecos = {}
    local active_hueco = 0
    local last_active_x = 0
    local last_active_y = 0
    
    local mtiempo = nil
    
    self.size = 64
    
    local STATE = 0 -- No gastarted 
    
    local function goToHub()
        local sim_scene =  love.filesystem.load("scenes/juego.lua")()
        SCENA_MANAGER.replace(sim_scene,{FILENAME})
    end
    
    local function irAIniciarElJuego()
        flux.to(self,0.5,{size=0}):ease("expoout"):oncomplete(mtiempo.start)
        STATE = 1
    end

    function self.load(settings)
        newbutton = Boton(DIAL[LANG].gui_ready,1920/2,1080*0.92,
                    love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        go_back_button = Boton(DIAL[LANG].gui_return,1920/2,1080*0.92,
                    love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25)
        
        local magico, sum = magicCuadro()
        --cambial al azar dos numero
        --testMagicPrint(magico, sum)
        magico, huecos = ponHuecos(magico)
        
        local size_cube = 120
        cuadrado = Cuadricula(1920/2,1080*0.35,size_cube,size_cube, magico, sum)
        
        local i = 1
        local spacing = 40
        local x = 1920/2 - (size_cube+spacing)*(#huecos/2.0) + size_cube*0.25
        while huecos[i] do
            botones_huecos[i] = BotonDrawAndDrop(tostring(huecos[i]),x,1080*0.75,size_cube,size_cube)
            x = x+(spacing+150)
            i=i+1
        end
        
        mtiempo = MuestraTiempo(25) -- 45 segundos
    end
    
    function self.draw()
       
        love.graphics.clear(0.6,0.6,0.6)
        love.graphics.setColor(1,1,1)
        love.graphics.push()
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
        
            love.graphics.setShader(GAUSIAN_BLURS)
            love.graphics.setColor(1,1,1)
            mtiempo.draw()
            
            love.graphics.setColor(1,1,1)
            
            cuadrado.setMousePos(globalX, globalY)
            cuadrado.draw()
            
            local i = 1
            while huecos[i] do
                botones_huecos[i].setPointerPos(globalX, globalY)
                if STATE > 1 then
                    if botones_huecos[i].pos.y ~= botones_huecos[i].original_pos_y then
                        botones_huecos[i].draw()
                    end
                else
                    botones_huecos[i].draw()
                end
                i=i+1
            end
            
            love.graphics.setShader()
            
            if STATE == 0 then
                --love.graphics.setShader(GAUSIAN_BLURS)
                --cuadrado.drawStandBy()
                --love.graphics.setShader()
                newbutton.setPointerPos(globalX, globalY)
                newbutton.draw()
            end
            
            love.graphics.setColor(0,0,0)
            if STATE == 3 then
                love.graphics.printf(DIAL[LANG].gui_dial_is_fail,0,1080*0.65,1920,'center')
                go_back_button.setPointerPos(globalX, globalY)
                go_back_button.draw()
            end
            if STATE == 4 then
                love.graphics.printf(DIAL[LANG].gui_dial_is_susses,0,1080*0.65,1920,'center')
                go_back_button.setPointerPos(globalX, globalY)
                go_back_button.draw()
            end
            
        love.graphics.pop()
    end
    
    function self.update(dt)
        if self.size > 0 and STATE == 0 then
            GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        end
        if cuadrado.isCompletado() and STATE == 1 then
            mtiempo.stop()
            STATE = 4
        end
        if mtiempo.sub_w <= 3 and STATE == 1 then
            STATE = 3
            flux.to(self,2,{size=8}):ease("expoin")
            print('Perdiste')
        end
        
    end
    
    function self.mousepressed(x, y, button)
        if newbutton.isPointerInside() and STATE == 0 then
            --loadNewGame()
            irAIniciarElJuego()
        end
        if STATE == 3 or STATE == 4 then
            if go_back_button.isPointerInside() then
                goToHub()
            end
        end
        
        if STATE == 1 then
            cuadrado.clearPlace()
            local i = 1
            while botones_huecos[i] do
                if botones_huecos[i].isPointerInside() then
                    last_active_x = botones_huecos[i].pos.x
                    last_active_y = botones_huecos[i].pos.y
                    active_hueco = i
                    break
                end
                i=i+1
            end
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
        
    end
    
    function self.mousemoved(x, y, dx, dy, istouch)
        if botones_huecos[active_hueco] then
            botones_huecos[active_hueco].pos.x = globalX
            botones_huecos[active_hueco].pos.y = globalY
        end
    end

    function self.mousereleased(x, y, buttom)
        if STATE == 1 then
            if botones_huecos[active_hueco] then
                --check the index on the cuadro
                local nx, ny, last = cuadrado.canPutInPlace(tonumber(botones_huecos[active_hueco].text), active_hueco)
                --print(nx,ny,last)
                if nx ~= nil then
                    --botones_huecos[active_hueco].pos.x = nx
                    --botones_huecos[active_hueco].pos.y = ny
                    flux.to(botones_huecos[active_hueco].pos,0.25,{x=nx,y=ny}):ease("expoout")
                    -- paso un intercambio dentro del cuadrado
                    if last and last > 0 then -- no hay un numero en en lugar? 
                        --print('try to enter change from ', active_hueco, ' to ', last)
                        --botones_huecos[last].pos.x = last_active_x 
                        --botones_huecos[last].pos.y = last_active_y
                        flux.to(botones_huecos[last].pos,0.25,{x=last_active_x,y=last_active_y}):ease("expoout")
                        cuadrado.putValueOnPlace(last_active_x,last_active_y,tonumber(botones_huecos[last].text), last)
                    end
                else
                    botones_huecos[active_hueco].returnToPos()
                end
                active_hueco = -1
            end
        end
    end

    
    return self
end

return Main()
