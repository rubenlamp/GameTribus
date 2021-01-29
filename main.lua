io.stdout:setvbuf("no")

love.filesystem.load("libs/mini_core.lua")()
love.filesystem.load("libs/escena.lua")()
love.filesystem.load("libs/utf8.lua")()
love.filesystem.load('libs/ayowoki.lua')()
love.filesystem.load('libs/delepanto.lua')()
love.filesystem.load('libs/boton.lua')()
flux = require "libs/flux"
ayo = Ayouwoki()

love.filesystem.load('libs/delepanto.lua')()

love.window.setTitle("GGJ 2021")
love.window.setMode(1920/2,1080/2,{resizable=true}) --debug
--love.window.setMode(1920,1080,{resizable=true})
love.graphics.setDefaultFilter( 'nearest', 'nearest', 1 )
--love.mouse.setVisible(false)

FULL_SCREEN = false --debug
--FULL_SCREEN = true
CANVAS = nil

local base_win_size_w =  1920
local base_win_size_h= 1080
--current window size...
SIZE_WIN_W = love.graphics.getWidth()
SIZE_WIN_H = love.graphics.getHeight()

IS_CHANGED_RESOLUTION = false
local old_factor = SIZE_WIN_H/(base_win_size_h)



function love.resize(w, h)
  SIZE_WIN_H = h
  SIZE_WIN_W = w
end

function getCanvasScaleFactor()
    return SIZE_WIN_H/(base_win_size_h)
end

function getCanvasPadding()
    return (SIZE_WIN_W-getCanvasScaleFactor()*base_win_size_w)/2
end

function getMouseOnWindowDrawArea()
    local mx, my = love.mouse.getPosition()
    local nx = mx-getCanvasPadding()
    return nx, my
end

function getMouseOnCanvas()
    local factor = SIZE_WIN_H/(base_win_size_h)
    local x,y = getMouseOnWindowDrawArea()
    return x/factor, y/factor
end


--this are chronometers 
GARBAGE_TIMER = Chrono() -- one is used to call the garbaje collector
DRAW_TIMER = Chrono()    --this one if for drawing the canvas ad a fixed rate

--this is a scena manager
--the main menu and each one of the examples is treated like a scene
SCENA_MANAGER = EscenaManager()

---TRIBUS STATUS

TRIBU_1 = 0
TRIBU_2 = 0
TRIBU_3 = 0
TRIBU_4 = 0


function TitleBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.alpha = 0
    char_dpl.scale = 1.0
    char_dpl.cred = 0
    char_dpl.cblue = 0
    char_dpl.cgreen = 0
    
    char_dpl.awake = function ()
        char_dpl.alpha = 0.2
        char_dpl.x = 0 -- -10
        char_dpl.y = 0 -- 12
        char_dpl.scale = 2-- 3
        
        char_dpl.intro()
    end
    
    char_dpl.intro = function()
        ayo.new(char_dpl,0.5,{alpha=1,x=0,y=0}).setEasing('outSine')
        ayo.new(char_dpl,0.075,{scale=1}).setEasing('inQuad').onWait(char_dpl.wait)
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
    
    return char_dpl
end

function BlackBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.alpha = 0
    char_dpl.scale = 1.0
    char_dpl.cred = 0
    char_dpl.cblue = 0
    char_dpl.cgreen = 0
    
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
        ayo.new(char_dpl,0.05,{scale=1}).onWait(char_dpl.wait)
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
    
    return char_dpl
end

function GreenBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.alpha = 0
    char_dpl.cred = 0
    char_dpl.cblue = 0
    char_dpl.cgreen = 0.5
    
    char_dpl.awake = function ()
        char_dpl.alpha = 0.2
        char_dpl.x = 0 -- -10
        char_dpl.y = 0 -- 12
        char_dpl.scale = 2-- 3
        
        char_dpl.intro()
    end
    
    char_dpl.intro = function()
        --ayo.new(char_dpl,0.5,{alpha=1,x=0,y=0}).setEasing('outSine')
        --ayo.new(char_dpl,0.075,{scale=1}).setEasing('inQuad').onWait(char_dpl.wait)
        ayo.new(char_dpl,0.5,{alpha=1}).setEasing('outQuad')
        ayo.new(char_dpl,0.15,{scale=1}).setEasing('outBack').onWait(char_dpl.wait)
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
    
    return char_dpl
end

function YellowBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.alpha = 0
    char_dpl.scale = 1.0
    char_dpl.cred = 0.78
    char_dpl.cblue = 0
    char_dpl.cgreen = 0.7
    
    char_dpl.awake = function ()
        char_dpl.alpha = 0.5
        char_dpl.x = 0 -- -10
        char_dpl.y = 0 -- 12
        char_dpl.scale = 2-- 3
        
        char_dpl.intro()
    end
    
    char_dpl.intro = function()
        --ayo.new(char_dpl,0.5,{alpha=1,x=0,y=0}).setEasing('outSine')
        --ayo.new(char_dpl,0.075,{scale=1}).setEasing('inQuad').onWait(char_dpl.wait)
        ayo.new(char_dpl,0.5,{alpha=1}).setEasing('outQuad')
        ayo.new(char_dpl,0.15,{scale=1}).setEasing('outBack').onWait(char_dpl.wait)
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
    
    return char_dpl
end


function love.load()
    --we start here chronometers
    --"iniciar" is spanish for "start" 
    --Why is on spanish? 
    
    love.window.setFullscreen( FULL_SCREEN  )
    GARBAGE_TIMER.iniciar()
    DRAW_TIMER.iniciar()
    
    --we set the canvas size to be a quarter of the size of the window
    love.graphics.setDefaultFilter("nearest", "nearest")
    CANVAS = love.graphics.newCanvas(base_win_size_w,base_win_size_h)
    CANVAS:setFilter("nearest", "nearest")
	
	local font = love.graphics.setNewFont(60)
	love.graphics.setFont(font)


    --CURSOR = Cursor()
    
   -- NORMAL_SHADER = love.graphics.newShader("rcs/shaders/normal_maping.glsl") 
    local init_scene =  love.filesystem.load("scenes/main_menu.lua")()
   --local init_scene =  love.filesystem.load("scenes/endign.lua")()
    --local init_scene =  love.filesystem.load("scenes/area_sim.lua")()
   --local init_scene =  love.filesystem.load("scenes/tutorial_1.lua")()
    --local init_scene =  love.filesystem.load("scenes/creditos.lua")()
    --local init_scene =  love.filesystem.load("scenes/central_hub.lua")()
    --local init_scene =  love.filesystem.load("scenes/tale01.lua")()
    SCENA_MANAGER.push(init_scene,{'mask'})
    --SCENA_MANAGER.push(init_scene,{'tutorial/palenque'})
end



function love.update(dt)
    --this is used to handle the resolution. 
    IS_CHANGED_RESOLUTION = (old_factor ~= getCanvasScaleFactor())
    --loveframes.update(dt)
    --[[
    Here is some dark magic used to keep a consistent
    update dt indepentend of the used hardware and framerate
    as possible 
    --]]
    local accum = dt
	while accum > 0 do
		local dt = math.min( 1/45, accum )	
		accum = accum - dt
		SCENA_MANAGER.update(dt) --we update the scenes
        --loveframes.update(dt)    --update the gui
		flux.update(dt)
        ayo.update(dt)
        --check for changes on the size of the window
        if IS_CHANGED_RESOLUTION then
            old_factor = getCanvasScaleFactor()
            IS_CHANGED_RESOLUTION = false
        end
    end
    
    --collencting the garbage each 5 seconds
    if GARBAGE_TIMER.hanPasado(5) then
        --print('recolector')
        collectgarbage()
    end
    
    --love.audio.setVolume(0)
    --gooi.update(dt)
    
end


function love.draw()
    
    love.graphics.setCanvas{CANVAS,stencil=true}
    SCENA_MANAGER.draw()
    love.graphics.setCanvas()
    
    love.graphics.setColor(1,1,1)
    
    --we draw here the canvas scaled and draw 
    --to acount for the resize
    local factor = SIZE_WIN_H/(base_win_size_h)
    local x = (SIZE_WIN_W/2)-((base_win_size_w/2)*factor)
    local y = (SIZE_WIN_H/2)-((base_win_size_h/2)*factor)
    love.graphics.draw(CANVAS,x,y,0,factor,factor)
    
    --GUI is draw on top of everything
    --love.graphics.setColor(1,1,1,1)
    --love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    --loveframes.draw()
end

--[[
Input functions, we pass their values directly to the handler and gui. 
--]]
function love.mousepressed(x, y, button)
	--loveframes.mousepressed(x, y, button)
    --gooi.pressed()
    SCENA_MANAGER.mousepressed(x, y, button)
    --CURSOR.mousepressed()
end

function love.mousereleased(x, y, button)
	--loveframes.mousereleased(x, y, button)
    --gooi.released()
    SCENA_MANAGER.mousereleased(x, y, button)
    --CURSOR.mousereleased()
end

function love.wheelmoved(x, y)
	--loveframes.wheelmoved(x, y)
end

function love.keyreleased( key, scancode )
    --loveframes.keyreleased(key)
    SCENA_MANAGER.keyreleased(key,scancode)
end

function love.keypressed(key,scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    --loveframes.keypressed(key, isrepeat)
    SCENA_MANAGER.keypressed(key,scancode)
    
    if key == 'f11' then
        FULL_SCREEN  = not FULL_SCREEN
        --love.window.setFullscreen( FULL_SCREEN  )
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    SCENA_MANAGER.mousemoved(x, y, dx,dy)
end

function love.wheelmoved( dx, dy )
    SCENA_MANAGER.wheelmoved( dx, dy )
end

function love.textinput(text)
	--loveframes.textinput(text)
end


function love.focus(f)
    SCENA_MANAGER.focus(f)
end
