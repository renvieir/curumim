
--takes away the display bar at the top of the screen
display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
local widget = require("widget")

local scene = storyboard.newScene()

local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight * 0.5

local background = nil

local btnPlay = nil

local btnScore = nil

local btnQuit = nil



local function handlerButtonPlay( event)
    
    if (event.phase == "ended") then
        storyboard.gotoScene("game", "crossFade", 1000)
    end
    
end

local function handlerButtonScore( event)
    
    if (event.phase == "ended") then
       storyboard.gotoScene("score", "crossFade", 500)
    end
    
end

local function handlerButtonQuit( event)
    
    if (event.phase == "ended") then
        os.exit()
    end
    
end



local options_play = {   
    label = "Play",
    font = native.systemFontBold,
    fontSize = 16,
    onEvent = handlerButtonPlay
    
}

local options_score = {   
    label = "Score",
    font = native.systemFontBold,
    fontSize = 16,
    onEvent = handlerButtonScore
}

local options_quit = {   
    label = "Quit",
    font = native.systemFontBold,
    fontSize = 16,
    onEvent = handlerButtonQuit
}


function scene:createScene( event )
	local group = self.view
                 
        background = display.newImage("images/Forest.png")
        
        background.x = background.x - 30
        
        background.y = 170
        btnPlay = widget.newButton(options_play) 
        btnPlay.x = halfW 
        btnPlay.y = halfH - 75 
        
        btnScore = widget.newButton(options_score) 
        btnScore.x = halfW
        btnScore.y = halfH
        
        btnQuit = widget.newButton(options_quit) 
        btnQuit.x = halfW
        btnQuit.y = halfH + 75
               
        group:insert(background)               
        group:insert(btnPlay)
        group:insert(btnScore)
        group:insert(btnQuit)
	
end

function scene:destroyScene( event )
	local group = self.view
		
end



    



--btnPlay:addEventListener("touch", onPlayclick) 
scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )
return scene

