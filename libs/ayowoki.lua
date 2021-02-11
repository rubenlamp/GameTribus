-- Adapted from https://github.com/EmmanuelOga/easing. See LICENSE.txt for credits.
-- For all easing functions:
-- t = time == how much time has to pass for the tweening to complete
-- b = begin == starting property value
-- c = change == ending - beginning
-- d = 1

local pow, sin, cos, pi, sqrt, abs, asin = math.pow, math.sin, math.cos, math.pi, math.sqrt, math.abs, math.asin

local function aw_linear(p,i,e)  return (e-i) * p / 1 + i end



local function aw_inQuad(p,i,e)  return (e-i)*p*p + i; end
local function aw_outQuad(p,i,e) return -(e-i)*p*(p-2) + i; end

local function aw_inOutQuad(p,i,e)
  if p < 0.5 then return aw_inQuad(p * 2, i, (e-i) / 2) end
  return aw_outQuad((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInQuad(p,i,e)
  if p < 0.5 then return aw_outQuad(p * 2, i, (e-i) / 2) end
  return aw_inQuad((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_inCubic(p,i,e) return (e-i) * pow(p, 3) + i end
local function aw_outCubic(p,i,e) return (e-i) * (1+pow(p-1,3)) + i end

local function aw_inOutCubic(p,i,e)
  if p < 0.5 then return aw_inCubic(p * 2, i, (e-i) / 2) end
  return aw_outCubic((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInCubic(p,i,e)
  if p < 0.5 then return aw_outCubic(p * 2, i, (e-i) / 2) end
  return aw_inCubic((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_inQuart(p,i,e) return (e-i) * pow(p, 4) + i end
local function aw_outQuart(p,i,e) return -(e-i) * (pow(p-1, 4) - 1) + i end

local function aw_inOutQuart(p,i,e)
  if p < 0.5 then return aw_inQuart(p * 2, i, (e-i) / 2) end
  return aw_outQuart((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInQuart(p,i,e)
  if p < 0.5 then return aw_outQuart(p * 2, i, (e-i) / 2) end
  return aw_inQuart((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_inQuint(p,i,e) return (e-i) * pow(p, 5) + i end
local function aw_outQuint(p,i,e) return (e-i) * (pow(p - 1, 5) + 1) + i end


local function aw_inOutQuint(p,i,e)
  if p < 0.5 then return aw_inQuint(p * 2, i, (e-i) / 2) end
  return aw_outQuint((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInQuint(p,i,e)
  if p < 0.5 then return aw_outQuint(p * 2, i, (e-i) / 2) end
  return aw_inQuint((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_inExpo(p,i,e)
  if p == 0 then return i end
  return (e-i) * pow(2, 10 * (p - 1)) - e * 0.001
end
local function aw_outExpo(p,i,e)
  if p == 1 then return e end
  return (e-i) * 1.001 * (-pow(2, -10 * p) + 1) + i
end

local function aw_inOutExpo(p,i,e)
  if p <= 0.5 then return aw_inExpo(p * 2, i, (e-i) / 2) end
  return aw_outExpo((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInExpo(p,i,e)
  if p <= 0.5 then return aw_outExpo(p * 2, i, (e-i) / 2) end
  return (i+(e-i)/2)+aw_inExpo((p * 2) - 1, i + (e-i)/2,e)
end


local function aw_inCirc(p,i,e) return(-(e-i) * (sqrt(1 - pow(p, 2)) - 1) + i) end
local function aw_outCirc(p,i,e)  return((e-i) * sqrt(1 - pow(p - 1, 2)) + i) end

local function aw_inOutCirc(p,i,e)
  if p < 0.5 then return aw_inCirc(p * 2, i, (e-i) / 2) end
  return aw_outCirc((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInCirc(p,i,e)
  if p < 0.5 then return aw_outCirc(p * 2, i, (e-i) / 2) end
  return aw_inCirc((p * 2) - 1, i + (e-i)/2,e)
end


local function aw_inSine(p,i,e) return -(e-i) * cos(p*(pi / 2)) + e end
local function aw_outSine(p,i,e) return (e-i) * sin(p*(pi / 2)) + i end

local function aw_inOutSine(p,i,e)
  if p < 0.5 then return aw_inSine(p * 2, i, (e-i) / 2) end
  return aw_outSine((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInSine(p,i,e)
  if p < 0.5 then return aw_outSine(p * 2, i, (e-i) / 2) end
  return aw_inSine((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_inBack(p,i,e)
  return (e-i) * p * p * ((1.70158 + 1) * p - 1.70158) + i
end

local function aw_outBack(p,i,e)
  p = p - 1
  return (e-i) * (p * p * ((1.70158 + 1) * p + 1.70158) + 1) + i
end


local function aw_inOutBack(p,i,e)
  if p < 0.5 then return aw_inBack(p * 2, i, (e-i) / 2) end
  return aw_outBack((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInBack(p,i,e)
  if p < 0.5 then return aw_outBack(p * 2, i, (e-i) / 2) end
  return aw_inBack((p * 2) - 1, i + (e-i)/2,e)
end


local function aw_outBounce(p,i,e)
  if p < (1 / 2.75) then return (e-i) * (7.5625 * p* p) + i end
  if p < (2 / 2.75) then
    p = p - (1.5 / 2.75)
    return (e-i) * (7.5625 * p * p + 0.75) + i
  elseif p < 2.5 / 2.75 then
    p = p - (2.25 / 2.75)
    return (e-i) * (7.5625 * p * p + 0.9375) + i
  end
  p = p - (2.625 / 2.75)
  return (e-i) * (7.5625 * p * p + 0.984375) + i
end

local function aw_inBounce(p,i,e) return (e-i) - aw_outBounce(1 - p, 0,e) + i end

local function aw_inOutBounce(p,i,e)
  if p < 0.5 then return aw_inBounce(p * 2, i, (e-i) / 2) end
  return aw_outBounce((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInBounce(p,i,e)
  if p < 0.5 then return aw_outBounce(p * 2, i, (e-i) / 2) end
  return (i+(e-i)/2)+aw_inBounce((p * 2) - 1, i + (e-i)/2,e-(i+(e-i)/2))
end




-- elastic
-- PAS -> Period  Amplitud 
local function calculatePAS(p,a,c,d)
  p, a = p or d * 0.3, a or 0
  if a < abs(c) then return p, c, p / 4 end -- p, a, s
  return p, a, p / (2 * pi) * asin(c/a) -- p,a,s
end

local function aw_inElastic(p,i,e)
  local s
  if p == 0 then return i end
  if p == 1  then return e end
  per,amp,s = calculatePAS(0.3,0.3,(e-i),p)
  p = p - 1
  return -(amp * pow(2, 10 * p) * sin((p- s) * (2 * pi) / per)) + i
end
local function aw_outElastic(p,i,e)
  return (e-i) - aw_inElastic(1 - p,i,e) + i
end

local function aw_inOutElastic(p,i,e)
  if p < 0.5 then return aw_inElastic(p * 2, i, (e-i) / 2) end
  return (i+(e-i)/2)+aw_outElastic((p * 2) - 1, i + (e-i)/2,e)
end

local function aw_outInElastic(p,i,e)
  if p < 0.5 then return aw_outElastic(p * 2, i, (e-i) / 2) end
  return aw_inElastic((p * 2) - 1, i + (e-i)/2,e)
end



local ListEasingFunctions = {
  linear    = aw_linear,
  inQuad    = aw_inQuad,    outQuad    = aw_outQuad,    inOutQuad    = aw_inOutQuad,    outInQuad    = aw_outInQuad,
  inCubic   = aw_inCubic,   outCubic   = aw_outCubic,   inOutCubic   = aw_inOutCubic,   outInCubic   = aw_outInCubic,
  inQuart   = aw_inQuart,   outQuart   = aw_outQuart,   inOutQuart   = aw_inOutQuart,   outInQuart   = aw_outInQuart,
  inQuint   = aw_inQuint,   outQuint   = aw_outQuint,   inOutQuint   = aw_inOutQuint,   outInQuint   = aw_outInQuint,
  inSine    = aw_inSine,    outSine    = aw_outSine,    inOutSine    = aw_inOutSine,    outInSine    = aw_outInSine,
  inExpo    = aw_inExpo,    outExpo    = aw_outExpo,    inOutExpo    = aw_inOutExpo,    outInExpo    = aw_outInExpo,
  inCirc    = aw_inCirc,    outCirc    = aw_outCirc,    inOutCirc    = aw_inOutCirc,    outInCirc    = aw_outInCirc,
  inElastic = aw_inElastic, outElastic = aw_outElastic, inOutElastic = aw_inOutElastic, outInElastic = aw_outInElastic,
  inBack    = aw_inBack,    outBack    = aw_outBack,    inOutBack    = aw_inOutBack,    outInBack    = aw_outInBack,
  inBounce  = aw_inBounce,  outBounce  = aw_outBounce,  inOutBounce  = aw_inOutBounce,  outInBounce  = aw_outInBounce
}


--a twening handler
--We have a list of all handlers
--handlers destroy themselves once they end
--

function AyouwokiEvent(obj,time,end_values)
    local self = {}
    
    
    --a set of varibles to handle the self.states
    --[[
       delay -> start -> running -> stop -> wait -> goodbye
    --]]
    self.state = nil
    
    local easing = 'linear'
    local is_set_easing = false
    
    local int_value = 0 --start value
    local end_value = 0 --end value

    local int_time = 0       -- initial time
    local run_end_time = time   -- end time for the running self.state
    local delay_end_time = 0 -- end time for the delay self.state
    local wait_end_time = 0  -- end time for the wait self.state
    local current_clock = 0
    
    local callFuntionOnStart = nil
    local callFuntionOnStop = nil
    local callFuntionOnEnd = nil
    
    local next_event = nil
    local prev_event = nil
    
    self.list_init_values = nil
    --we should keep the initial values of the obj?
    local save_init_values = false
    local redoing_count = 0
    local max_redoing = nil
    
    local is_canceled = false
    
    --print('-----------')
    function self.setEasing(new_easing)
        if not is_set_easing then
            easing = new_easing
            is_set_easing = true
        else
            next_event.setEasing(new_easing)
        end
        return self
    end
    
    function self.getClock()
        return current_clock
    end
    
    function self.compereObj(nobj)
        return obj == nobj
    end
    
    function self.getChained()
      return next_event
    end
    
    function self.stateDelay(dt)
        current_clock = current_clock + dt
        if current_clock >= delay_end_time then
            --print('go in '..tostring(self))
            --print(self.stateStart)
            self.state = self.stateStart
        end
    end
    
    function self.stateStart(dt)
        current_clock = dt --do not lose a single frame
        --print('on start')
        if not self.list_init_values then 
            self.list_init_values = {}
            for k,v in pairs(end_values) do
                self.list_init_values[k] = obj[k]
            end
        else --is the redoing run...
            for k,v in pairs(self.list_init_values) do
                if type(v) == 'number' then
                    obj[k] = v
                else
                    obj[k] = v[1]
                end
            end
        end
        
        if callFuntionOnStart then
            callFuntionOnStart()
        end
        --print(self.stateRunning)
        self.state = self.stateRunning
    end
    
    function self.stateRunning(dt)
        current_clock = current_clock + dt
        -- [[
        
        for k,v in pairs(end_values) do
            local easing_type = easing
            local end_val = v
            local init_val = self.list_init_values[k]
            if type(v)=='table' then
                end_val = v[1]
                easing_type = v[2]
            end
            local val = ListEasingFunctions[easing_type](
              current_clock/run_end_time,
              0,
              1)
            local dif = end_val-init_val
            obj[k] = init_val + dif*val  
        end
        --]]
        if current_clock >= run_end_time then
            self.state = self.stateStop
        end
    end
    
    function self.stateStop(dt)
        current_clock = dt --do not lose a single frame
        for k,v in pairs(end_values) do
            if type(v) == 'number' then
                obj[k] = v
            else
                obj[k] = v[1]
            end
        end
        
        if callFuntionOnStop then
            callFuntionOnStop()
        end
        self.state = self.stateWait
    end
    
    function self.stateWait(dt)
        current_clock = current_clock + dt
        if current_clock >= wait_end_time then
            self.state = self.stateEnd
        end
    end
    
    function self.stateEnd(dt)
        current_clock = dt --do not lose a single frame
        if callFuntionOnEnd then
            callFuntionOnEnd()
        end
        self.state = nil
    end

    self.state = self.stateDelay
    
    function self.isAlive()
        return not(self.state == nil)
    end
    
    function self.update(dt)
        if self.state then
            self.state(dt)
        end
    end
    
    function self.cancel()
        self.state = nil
        is_canceled = true
        -- and just to be sure, cancel also all the chained
        if next_event then 
            next_event.cancel()
        end
    end
    
    function self.isCanceled()
        return is_canceled
    end

    function self.setPreviousEvent(prev)
        prev_event = prev
    end
    
    function self.chain(nobj,ntime,nargs)
        --return nil -- Ayouwoki Easin Funtion
        if next_event then --we already have a slot for a event, but is already on use...
            --...ask the next event.
            --the event with a empty place, is the last...
            next_event.chain(nobj,ntime,nargs)
        else
            local new = nil
            --we fake the overloading
            --if no object and nargs, then we only got 2 arguments
            --then, nobj is the time, and ntime is the args 
            if type(nobj)=='number' then
                new = AyouwokiEvent(obj,nobj,ntime)
            else --nobj is a table...
                if not nargs and not ntime then --we asume is another tween
                    new = nobj
                else --is a totally
                    new = AyouwokiEvent(nobj,ntime,nargs)
                end
            end
          --print(self)
          --print(new)
          next_event = new 
          next_event.setPreviousEvent(self)
        end
        return self
    end
    
    function self.delay(time)
        if delay_end_time == 0 then
            self.state = self.stateDelay
            delay_end_time = time
        else
            if next_event then
              next_event.delay(time)
            end
        end
        return self
    end
    
    function self.wait(time)
        if wait_end_time == 0 then
            wait_end_time = time
        else
            next_event.wait(time)
        end
        return self
    end
    
    function self.onStart(call_function)
        callFuntionOnStart = call_function
        return self
    end
    
    function self.onEnd(call_function)
        -- function is alwas passet to the deepest definend level
        if next_event then
            return next_event.onEnd(call_function)
        end
        
        if not callFuntionOnEnd then
            callFuntionOnEnd = call_function
        end
        
        return self
    end
    
    function self.onWait(call_function)
        callFuntionOnStop = call_function
        return self
    end
    
    function self.saveInitValues()
        save_init_values = true
    end
    
    function self.getFirstEvent()
        if prev_event then
            return prev_event.getFirstEvent()
        end
        return self --if we do not had one previus event, we are the first
    end
    
    function self.redoingEnabled()
        return save_init_values 
    end
    
    function self.getNextEvent()
        return next_event
    end
    
    function self.redoing(repeat_number)
        --we are goint to redoing
        if save_init_values and not prev_event then --not is the first run, and we are the first one
            --get a proper copy of the initial values, even if you do not use they!!!
            local the_next = next_event 
            while the_next do
                for k,v in pairs(the_next.list_init_values) do
                    if not self.list_init_values[k] then
                        if type(v)=='number' then
                            self.list_init_values[k] = v
                        else --is a table tipe value
                            self.list_init_values[k] = v[1]
                        end
                    end
                end
                the_next = the_next.getNextEvent()
            end
        end
        save_init_values = true
        if repeat_number then
            max_redoing = math.floor(repeat_number)
        end
        if max_redoing then
            if redoing_count == max_redoing then
                
                save_init_values = false
            end
            --print('max number='..tostring(max_redoing))
            --print('--> '..tostring(redoing_count))
            redoing_count = redoing_count+1
        end
        
        self.state = self.stateDelay
        current_clock = 0
        --tell the next one that to save their initial values on the first run!!!
        if next_event then
            next_event.redoing(max_redoing)
        end
    end
    
    return self
end

function Ayouwoki()
    self = {}
    local ListFuctions = {}
    
    function self.update(dt)
        local i = 1
        while ListFuctions[i] do
            ListFuctions[i].update(dt)
            if not ListFuctions[i].isAlive() then
                -- was canceled? 
                if ListFuctions[i].isCanceled() then
                    table.remove(ListFuctions,i)
                else
                    --is on reverse
                    local chained = ListFuctions[i].getChained()
                    if chained then
                        ListFuctions[i] = chained
                    else
                        --is the last one
                        if ListFuctions[i].redoingEnabled() then
                            ListFuctions[i] = ListFuctions[i].getFirstEvent()
                            ListFuctions[i].redoing()
                        else
                            table.remove(ListFuctions,i)
                        end
                    end
                end
            end
            i=i+1
        end
    end
    
    
    function  self.new(obj,time,args)
        --return nil -- Ayouwoki Easin Funtion
        --check if there is already a runing 
        
        local easing = AyouwokiEvent(obj,time,args)
        table.insert(ListFuctions,easing)
        return easing
    end
    
    return self
end