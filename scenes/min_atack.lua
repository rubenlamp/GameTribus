EXIT_TO =  nil

local function Control(x,y,w,h)
    local self = {}
    
    self.x = x-w/2
    self.y = y-h/2
    self.w = w
    self.h = h
    
    self.sub_w = w/2
    
    -- subdivimos la barra en 500 segmentos
    local max_segment = 500
    self.segment = w/max_segment
    self.current_segments = 250
    
    -- segmentos por click ganados cuantos segmentos de empuje extra ganas
    local segpcg = 5
    
    -- creamos un contador que espera un tiempo antes de
    -- emepezar a restar segmentos
    self.contador = Chrono()
    -- segmentos base perdidos por segundo una
    -- vez iniciado el contador
    local segbps = 20
    local aceleracion = 80 --aumentamos a +60 en un segundo
    
    self.iniciado_bajada = false
    self.lock = false
    
    function self.restartCounter()
        segbps = 20
        self.iniciado_bajada = false
        self.contador.iniciar()
        self.lock = false
    end
    
    -- reresa el minimo x, y el maximo
    function self.getRange()
        local  minx = self.x + self.sub_w-40
        local  maxx = minx + 80
        return minx, maxx
    end
    
    function self.addSegment()
        -- cada que das click, la cantidad de segmenos que subes 
        -- es un 75% mayor que el anterior
        if not self.lock then
            segpcg = segpcg + segpcg*0.75
            segpcg = math.min(segpcg,40)
            flux.to(self,0.1,
                {current_segments=math.min(self.current_segments+segpcg,max_segment)}
                ):ease('linear'):oncomplete(self.restartCounter)
            self.lock = true
        end
    end
    
    function self.update(dt)
        if self.contador.hanPasado(0.3) and not self.iniciado_bajada  then
            self.iniciado_bajada = true
            -- reiniciar los segmentos por click ganados
            segpcg = 2
            --print('han pasado 0.7 en espera')
        end
        
        if self.iniciado_bajada then
            if self.current_segments > 0 then
                -- pierde n segmentos por segundo
                self.current_segments =  self.current_segments - segbps*dt
                segbps = segbps + aceleracion*dt
                segbps = math.min(segbps, 120)
            end
        end
        
        self.sub_w = self.segment * self.current_segments
        self.sub_w = math.max(math.min(self.sub_w, self.w-2),5)
    end
    
    function self.draw()
        love.graphics.setColor(0.75,0.75,0.75,1)
        love.graphics.rectangle('fill',self.x+self.sub_w-40,self.y+1,80,self.h-2,9,9,5)
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle('line',self.x-36,self.y,self.w+73,self.h,10,10,5)
    end
    
    return self
end

local function Target(x,y,w,h, min, max)
    local self = {}
    
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    
    local easing_list = {'expoout','sineout','quadout','elasticout'}
    local state_battle = -1
    local is_in_range = true
    local detener = false
    
    local tween = nil
    
    function self.detenerMovimientos()
        detener = true
        tween:stop()
    end
    
    function self.move(time, destino,tipo, espera)
        tween = flux.to(self,time,{x=destino}):ease(tipo):delay(espera):oncomplete(self.getNewTargetPoint)
    end
    
    function self.getNewTargetPoint()
        if not detener then
            local half = (max-min)*0.3
            local quint = (max-min)/5
            local dt = love.math.random(quint,half)
            local time = 1.2-love.math.random()
            local espera = love.math.random(5,7)
            local easing = love.math.random(1,4)
            print('hay que mover...',dt)
            local dir = 1
            state_battle = 0
            if love.math.random(1,2) == 2 then
                dir = -1
                state_battle = 1
            end
            if self.x+dt*dir < min then
                self.move(time,self.x-dt*dir,easing_list[easing], espera)
                return 
            end
            if self.x+dt*dir > max then
                --target mover otro lado
                self.move(time,self.x-dt*dir,easing_list[easing], espera)
                return
            end
            self.move(time,self.x+dt*dir,easing_list[easing], espera)
            --solo muevelo
            return
        end
        --love.math.random()
    end
    
    function self.start()
        local half = (max-min)*0.45
        local quint = (max-min)/5
        local dt = love.math.random(quint,half)
        local time = love.math.random(1,2)
        local espera = 0
        local easing = 4
        local dir = 1
        state_battle = 0
        if love.math.random(1,2) == 2 then
            dir = -1
            state_battle = 1
        end
        if self.x+dt*dir < min then
            --target mover otro lado
            --, easing_list[easing]
            self.move(time,self.x-dt*dir,easing_list[easing], espera)
            return 
        end
        if self.x+dt*dir > max then
            --target mover otro lado
            self.move(time,self.x-dt*dir,easing_list[easing], espera)
            return
        end
        self.move(time,self.x+dt*dir,easing_list[easing], espera)
        --solo muevelo
        return
    end
    
    function self.isInRange(min, max)
        local  minx = self.x-self.w*0.5
        local  maxx = minx+self.w
        is_in_range = (minx >= min) and (maxx <= max)
        return is_in_range
    end
    
    function self.draw()
        love.graphics.setColor(1,1,1)
        if state_battle == -1 then
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(FONT_SCROLL_SMALL )
            love.graphics.printf(DIAL[LANG].gui_battle_gonna,0,self.y-100,1920,'center')
            love.graphics.setFont(FONT)
        end
        
        --love.graphics.rectangle('fill', self.x-self.w*0.5, self.y-self.h*0.5, self.w, self.h)
        love.graphics.setColor(1,0,0)
        if is_in_range then
            love.graphics.setColor(0,0.5,0.1)
        end
        
        love.graphics.circle('fill', self.x, self.y, self.w/2, 12)
    end
    
    return self
end


function AvanceBatalla(tiempo)
    local self = {}
    
    self.x = (1920/2)- 400
    self.y = 1080*0.5
    
    self.w = 800
    self.h = 30
    
    self.sub_w = 400
    
    local tween = nil
    
    function self.ganar(x)
        self.sub_w = self.sub_w + x
        self.sub_w = math.min(self.sub_w, 800)
    end
    
    function self.perder(x)
        self.sub_w = self.sub_w - x
        self.sub_w = math.max(self.sub_w, 0)
    end
    
    function self.esVictorioso()
        return self.sub_w > 780
    end
    
    function self.esDerrotado()
        return self.sub_w < 30
    end
    
    function self.draw()
        love.graphics.setColor(0.3,0,0)
        love.graphics.rectangle('fill',self.x+1,self.y+1,800,self.h-2,9,9,5)
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
    local background = nil
    local newbutton = nil
    local go_back_button = nil
    local target = nil
    local control = nil
    local estado_batalla = nil
    
    self.size = 64
    
    local STATE = 0 -- No gastarted 
    local tribu_id = 0
    
    local function goToHub()
        MSC_ATACK:stop()
        TRIBUS[tribu_id] = 1 --ganamos
        if STATE == 3 then
            MSC_DERROTA:stop()
            TRIBUS[tribu_id] = 2 -- perdimos
        end
        local sim_scene =  love.filesystem.load("scenes/juego.lua")()
        SCENA_MANAGER.replace(sim_scene)
    end
    
    local function irAIniciarElJuego()
        flux.to(self,0.5,{size=0}):ease("expoout"):oncomplete(target.start)
        control.contador.iniciar()
        STATE = 1
    end

    function self.load(settings)
        tribu_id = settings[1]
        
        newbutton = Boton('',1920/2,1080*0.92,
                    love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                    love.graphics.newImage("/rcs/gui/start.png"),
                    love.graphics.newImage("/rcs/gui/hover_start.png"))
        go_back_button = Boton('',1920*0.5,1080*0.92,
                    love.graphics.getWidth()*0.35,love.graphics.getHeight()*0.25,
                    love.graphics.newImage("/rcs/gui/back.png"),
                    love.graphics.newImage("/rcs/gui/hover_back.png"))
        
        background = love.graphics.newImage('/rcs/img/minijuego_background.png')
        
        -- pon lo a la mitad horizonta, a 40% vertical, 40x20 px, rango de 25% a 75% horizontal
        target = Target(1920/2,1080*0.4,40,20,1920*0.25,1920*0.75)
        control = Control(1920/2,1080*0.4,1920*0.5+40,48)
        estado_batalla = AvanceBatalla(500)
        MSC_ATACK:play()
    end
    
    function self.draw()
       
        love.graphics.clear(0.6,0.6,0.6)
        love.graphics.setColor(1,1,1)
        
        love.graphics.push()
        local x, y = getMouseOnCanvas()
        globalX, globalY = love.graphics.inverseTransformPoint(x,y)
        
            love.graphics.setShader(GAUSIAN_BLURS)
            love.graphics.setColor(1,1,1)
            love.graphics.draw(background)
            love.graphics.setShader()
            
            love.graphics.setColor(1,1,1)
            
            control.draw()
            target.draw()
            
            --love.graphics.setShader()
            
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(FONT_SCROLL_SMALL )
            love.graphics.printf(DIAL[LANG].gui_atk_inst,0,0,1920,'center')
            love.graphics.setFont(FONT )
            
            if STATE == 0 then
                --love.graphics.setShader(GAUSIAN_BLURS)
                --cuadrado.drawStandBy()
                --love.graphics.setShader()
                newbutton.setPointerPos(globalX, globalY)
                newbutton.draw()
            end
            
            if STATE == 1 then
                estado_batalla.draw()
            end
            
            love.graphics.setColor(0,0,0)
            if STATE == 3 then
                love.graphics.printf(DIAL[LANG].gui_atk_is_fail,0,1080*0.65,1920,'center')
                go_back_button.setPointerPos(globalX, globalY)
                go_back_button.draw()
            end
            if STATE == 4 then
                love.graphics.printf(DIAL[LANG].gui_atk_is_susses,0,1080*0.65,1920,'center')
                go_back_button.setPointerPos(globalX, globalY)
                go_back_button.draw()
            end
            
        love.graphics.pop()
    end
    
    function self.update(dt)
        if self.size > 0 then
            GAUSIAN_BLURS:send("Size", math.floor(self.size) )
        end
        if STATE == 1 then
            control.update(dt)
            
            local  min_x, max_y = control.getRange()
            if target.isInRange(min_x, max_y) then
                estado_batalla.ganar(80*dt)
            else
                estado_batalla.perder(75*dt)
            end
        end
        
        if estado_batalla.esVictorioso() and STATE == 1 then
            target.detenerMovimientos()
            STATE = 4
        end
        if estado_batalla.esDerrotado() and STATE == 1 then
            target.detenerMovimientos()
            MSC_ATACK:stop()
            MSC_DERROTA:play()
            STATE = 3
        end
        --]]
    end
    
    function self.mousepressed(x, y, button)
        
        if STATE == 1 then
            control.addSegment()
        end
        if newbutton.isPointerInside() and STATE == 0 then
            --loadNewGame()
            irAIniciarElJuego()
        end
        
        if STATE == 3 or STATE == 4 then
            if go_back_button.isPointerInside() then
                goToHub()
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
        
    end

    function self.mousereleased(x, y, buttom)
        if STATE == 1 then
            
        end
    end

    
    return self
end

return Main()
