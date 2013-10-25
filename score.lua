display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

local widget = require("widget")

local database = require "databaseHelper"



local function handlerButtonBack( event)
    
    if (event.phase == "ended") then
       storyboard.gotoScene("menu", "crossFade", 500)
    end
    
end


local options_back = {   
    label = "Back",
    font = native.systemFontBold,
    fontSize = 16,
    onEvent = handlerButtonBack
    
}


function scene:createScene( event )
       local group = self.view
        
       local db = database:getDb()
       local y = 20
        
       local player_name = display.newText("PLAYER", 20, 10  , native.systemFontBold, 30)
       local player_score = display.newText("SCORE", display.contentWidth * 0.5, 10  , native.systemFontBold, 30)
       group:insert(player_name)
       group:insert(player_score) 
       for row in db:nrows("SELECT * FROM score ORDER BY score.score DESC") do
           y = y + 20
           if (y > 220) then
               break
           end
           local playerText = display.newText(row.player, 20, y , native.systemFontBold, 20)
           local scoreText = display.newText(row.score, display.contentWidth * 0.5, y , native.systemFontBold, 20)
           group:insert(playerText)
           group:insert(scoreText)
           print(row.score)
       end
       
        local btnBack = widget.newButton(options_back) 
        btnBack.x = display.contentWidth * 0.5 
        btnBack.y = display.contentHeight - 50

        group:insert(btnBack)
end

function scene:destroyScene( event )
	local group = self.view
		
end



scene:addEventListener( "createScene", scene )
  

scene:addEventListener( "destroyScene", scene )

return scene



