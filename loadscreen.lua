local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

function scene:createScene( event )
	local group = self.view
        
        loadingSCR = display.newRect(0, 0, 320, 480)
        loadingSCR:setFillColor(0,0,0)
        
        local loadingSCRTXT = display.newText("Loading.. ", display.contentWidth/2, display.contentHeight/2, nil, 20)
        
        group:insert(loadingSCR) 
        group:insert(loadingSCRTXT)
        
end

function scene:destroyScene( event )
	local group = self.view
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "destroyScene", scene )

function dismissLoadScreen()
    --loadingGRP:removeSelf()
    storyboard.gotoScene("game", "crossFade", 500)
end




timer.performWithDelay( 500, dismissLoadScreen(),1)
return scene
