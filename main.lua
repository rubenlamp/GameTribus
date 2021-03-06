io.stdout:setvbuf("no")

love.filesystem.load("libs/mini_core.lua")()
love.filesystem.load("libs/escena.lua")()
love.filesystem.load("libs/utf8.lua")()
love.filesystem.load('libs/ayowoki.lua')()
love.filesystem.load('libs/delepanto.lua')()
love.filesystem.load('libs/boton.lua')()
love.filesystem.load('libs/dialogo.lua')() --el dialogo requiere que definan una imagen para SCROLL_TOP_IMA, y SCROLL_BG_IMA abajo
flux = require "libs/flux"
ayo = Ayouwoki()

love.filesystem.load('libs/delepanto.lua')()

love.filesystem.load('textos.lua')()

love.window.setTitle("Before Losing")
love.window.setMode(1920/2,1080/2,{resizable=true}) --debug
--love.window.setMode(1920,1080,{resizable=true})
--love.graphics.setDefaultFilter( 'nearest', 'nearest', 1 )
--love.mouse.setVisible(false)

FULL_SCREEN = false --debug
--FULL_SCREEN = true
CANVAS = nil

local base_win_size_w =  1920
local base_win_size_h= 1080
--
SIZE_B_WIN_W = base_win_size_w
SIZE_B_WIN_H = base_win_size_h

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
TRIBU_1_NAME = 'Kukao'
TRIBU_2_NAME = 'Pizu'
TRIBU_3_NAME = 'Walla'

--[[
ESTADOS TRIBUS 
0 - no se ha hecho nada
1 - se ha ganado el ataque
2 - se perdio el ataque
3 - se gano diplomacia
4 - se perdio diplomacia 
]]

TRIBUS = {}
TRIBUS[0]=0
TRIBUS[1]=0
TRIBUS[2]=0

MSC_MAIN_MENU = nil
MSC_MAP_MENU = nil
MSC_ATACK = nil
MSC_DERROTA = nil
MSC_EXITO = nil
MSC_TRB_MERCANTE = nil
MSC_TRB_GUERRERA = nil
MSC_TRB_PACIFICA = nil 
GAUSIAN_BLURS = nil

FONT_BIG = nil
FONT = nil
FONT_SMALL = nil
FONT_SCROLL = nil

SCROLL_TOP_IMA = nil
SCROLL_BG_IMA = nil
KINGS_IMG_LIST = {}
KING_IMG = nil

VIDEO_CREDITS = nil

--- Black ink on paper!!!
function BlackBehaviour(char_dpl,font)
    --set the start values
    char_dpl.font_id_name = font
    char_dpl.alpha = 0
    char_dpl.scale = 1.0
    char_dpl.cred = 0
    char_dpl.cblue = 0
    char_dpl.cgreen = 0
	
	local easing_intro = nil
    local easing_wait = nil
	
    char_dpl.awake = function ()
        char_dpl.alpha = 0.5
        char_dpl.x = -1
        char_dpl.y = -1
        char_dpl.scale = 0.1-- 3
        
        char_dpl.intro()
    end
    
    char_dpl.intro = function()
        --ayo.new(char_dpl,0.5,{alpha=1,x=0,y=0}).setEasing('outSine')
        --ayo.new(char_dpl,0.075,{scale=1}).setEasing('inQuad').onWait(char_dpl.wait)
        easing_intro = ayo.new(char_dpl,0.05,{alpha=1, scale=1.2}).onEnd(char_dpl.wait)
    end
    
   char_dpl.wait = function()
        --print('call next')
        char_dpl.scale = 1
        char_dpl.alpha = 1
        char_dpl.x = 0
        char_dpl.y = 0
        char_dpl.callNextTrue()
        easing_wait = ayo.new(char_dpl,0.5,{scale = 0.92}).setEasing('outSine').chain(0.3,{scale=1, alpha=0.8}).setEasing('inQuad')
    end
	
	char_dpl.outro = function()
		if easing_intro then
			easing_intro.cancel()
		end
		if easing_wait then
			easing_wait.cancel()
		end
        ayo.new(char_dpl,0.2,{alpha=0,scale= 0.1})
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
    --love.graphics.setDefaultFilter("nearest", "nearest")
    CANVAS = love.graphics.newCanvas(base_win_size_w,base_win_size_h)
    --CANVAS:setFilter("nearest", "nearest")
	
	FONT_SCROLL = love.graphics.newFont('/rcs/fonts/Old Story Bold.ttf',80)
	FONT_SCROLL_SMALL = love.graphics.newFont('/rcs/fonts/Old Story Bold.ttf',60)
	FONT_SCROLL_SMALL:setLineHeight(0.75)
	FONT_SMALL = love.graphics.setNewFont(45)
	FONT = love.graphics.setNewFont(60)
	FONT_BIG = love.graphics.setNewFont(70)
	love.graphics.setFont(FONT)
	
	loadNewFontDLP('regular','/rcs/fonts/Old Story Bold.ttf',60,BlackBehaviour)
	setFontFallback('regular')

    --CURSOR = Cursor()
	MSC_MAIN_MENU = love.audio.newSource('/rcs/music/menu.mp3','stream', true)
	MSC_MAP_MENU = love.audio.newSource('/rcs/music/mapa.mp3','stream', true)
	MSC_ATACK = love.audio.newSource('/rcs/music/ataque.mp3','stream', true)
	MSC_DIPLOMACIA = love.audio.newSource('/rcs/music/diplomacia.mp3','stream', true)
	MSC_DERROTA = love.audio.newSource('/rcs/music/derrota.mp3','stream', true)
	MSC_EXITO = love.audio.newSource('/rcs/music/victoria_final.mp3','stream', true)
	MSC_TRB_MERCANTE = love.audio.newSource('/rcs/music/tribu_mercante.mp3','stream', true)
	MSC_TRB_GUERRERA = love.audio.newSource('/rcs/music/tribu_guerrera.mp3','stream', true)
	MSC_TRB_PACIFICA = love.audio.newSource('/rcs/music/tribu_pacifica.mp3','stream', true)
	
	MSC_MAIN_MENU:setLooping(true)
	MSC_MAP_MENU:setLooping(true)
	MSC_ATACK:setLooping(true)
	MSC_DIPLOMACIA:setLooping(true)
	MSC_DERROTA:setLooping(true)
	MSC_EXITO:setLooping(true)
	MSC_TRB_MERCANTE:setLooping(true)
	MSC_TRB_GUERRERA:setLooping(true)
	MSC_TRB_PACIFICA:setLooping(true)
	
	SCROLL_TOP_IMA = love.graphics.newImage("/rcs/img/scroll_head.png")
	SCROLL_BG_IMA = love.graphics.newImage("/rcs/img/scroll_body.png")
	MINIGAME_BG_IMA = love.graphics.newImage('/rcs/img/minijuego_background.png')
	KINGS_IMG_LIST[0] = love.graphics.newImage("/rcs/img/rey_circulo.png")
    KINGS_IMG_LIST[1] = love.graphics.newImage("/rcs/img/rey_cuadrado.png")
    KINGS_IMG_LIST[2] = love.graphics.newImage("/rcs/img/rey_triangulo.png")
    KING_IMG = love.graphics.newImage("/rcs/img/rey_jugador.png")

	VIDEO_CREDITS = love.graphics.newVideo("/rcs/video/making_of.ogg")
	
	
	GAUSIAN_BLURS = love.graphics.newShader[[
	// This is a reimplementation of some code I found in shadertoy   
	float Pi = 6.28318530718; // Pi*2
	extern float Size = 2.0; // BLUR SIZE (Radius)
	
    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords){
		float Directions = 8.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
		float Quality = 4.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
		
		vec2 Radius = vec2(Size/1920.0f,Size/1080.0f);
		
		vec4 texturecolor = Texel(tex, uv);
		
		for( float d=0.0; d<Pi; d+=Pi/Directions)
		{
			for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
			{
				texturecolor += Texel(tex, uv+vec2(cos(d),sin(d))*Radius*i);		
			}
		}
		
		texturecolor /= Quality * Directions - 7.0;
		texturecolor /= 1.2;
		return texturecolor*color;
	}
  ]]
   local init_scene =  love.filesystem.load("scenes/main_menu.lua")()
   --local init_scene =  love.filesystem.load("scenes/intro.lua")()
   --local init_scene =  love.filesystem.load("scenes/min_atack.lua")()   
   SCENA_MANAGER.push(init_scene,{1})
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
        love.window.setFullscreen( FULL_SCREEN  )
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
