

--takes away the display bar at the top of the screen
display.setStatusBar(display.HiddenStatusBar)
local database = require "databaseHelper"  
local sprite = require("sprite")
local storyboard = require( "storyboard" )
local widget = require "widget"

local scene = storyboard.newScene()

local blocks = nil
local ghosts = nil
local spikes = nil
local blasts = nil

local isSceneOn = nil

--these 2 variables will be the checks that control our event system.
local inEvent = nil
local eventRun = nil


local score = nil

local scoreText = nil

local backbackground = nil

local backbackground2 =  nil

local gameOver = nil


local groundMin = nil
local groundMax = nil
local groundLevel = nil
local speed = nil

local spriteSheet = nil

local heroSet = nil

local hero = nil

local collisionRect = nil

local bgm = nil

local blast_sound = nil

local bgm_channel = nil

local damage_sound = nil

local gameover_sound = nil

local gameover_channel = nil

local damage_sound2 = nil

local hero_damage_sound = nil

local loadingSCR = nil
local loadingSCRTXT = nil

local animated_splash = nil

local pause_button = nil

local ispause = nil

local restart_button = nil

local resume_button = nil

local quit_button = nil

local function handlerButtonPause( event)
    
    if (event.phase == "ended") then
        pausegame()
    end
    
end

local options_pause = {  
    label = "Pause",
    font = native.systemFontBold,
    fontSize = 16,
    default = "images/blast.png",
    width = 75,
    height = 50,
    onEvent = handlerButtonPause
    
}

local function handlerButtonResume( event)
    
    if (event.phase == "ended") then
        resumegame()
    end
    
end

local options_resume = {   
    label = "Resume",
    font = native.systemFontBold,
    fontSize = 16,
    width = 100,
    height = 50,
    onEvent = handlerButtonResume
    
}

local function handlerButtonRestart( event)
    
    if (event.phase == "ended") then
        restartGame()
    end
    
end

local options_restart = {   
    label = "Restart",
    font = native.systemFontBold,
    fontSize = 16,
    width = 100,
    height = 50,
    default = "images/blast.png",
    over = "images/pause_button.png",
    onEvent = handlerButtonRestart
    
}

local function handlerButtonQuit( event)
    
    if (event.phase == "ended") then
        quitgame()
    end
    
end

local options_quit = {   
    label = "Quit",
    font = native.systemFontBold,
    fontSize = 16,
    default = "images/pause_button.png",
    over = "images/pause_button.png",
    width = 100,
    height = 50,
    onEvent = handlerButtonQuit
    
}


function inicializar()
    speed = 5
    isSceneOn = true
    ispause = false
    inEvent = 0
    eventRun = 0
    
    inicializarGrupos()
    prepararBackground()
    prepararTelaGameOver()
    inicializarPontuacao()
    iniciarPiso()
    iniciarInimigos()
    iniciarObstaculos()
    iniciarTiros()  
    iniciarHeroi()
    inicializarPauseButton()
    inicializarPauseMenu()
    iniciarCollisionRect()
    
    
end

function inicializarPauseMenu()
    resume_button = widget.newButton(options_resume)
    restart_button = widget.newButton(options_restart)
    quit_button = widget.newButton(options_quit)
    
    resume_button.x = 800
    resume_button.y = 500
    
    restart_button.x = 800
    restart_button.y = 500
    
    quit_button.x = 800
    quit_button.y = 500
    
end
    

function inicializarPauseButton()
     pause_button = widget.newButton(options_pause)
     pause_button.x = display.contentWidth - 50
     pause_button.y = 20
        
end

function inicializarAudio(group)
    bgm = audio.loadSound("audios/Field1.ogg", { loops=0 })
    blast_sound = audio.loadSound("audios/Crossbow.ogg")
    damage_sound = audio.loadSound("audios/Fire1.ogg")
    damage_sound2 =  audio.loadSound("audios/Explosion1.ogg")
    gameover_sound = audio.loadSound("audios/Gameover1.ogg")
    hero_damage_sound = audio.loadSound("audios/Damage2.ogg")
    bgm_channel = audio.play(bgm)
    
    timer.performWithDelay(2000,dismissLoadScreen(group) ,1)  
end

function finalizarAudios()
    audio.stop(bgm_channel)
    audio.stop(gameover_channel)
end

function inicializarGrupos()
    blocks = display.newGroup()
    ghosts = display.newGroup()
    spikes = display.newGroup()
    blasts = display.newGroup()
end



function prepararTelaGameOver()
    gameOver = display.newImage("images/gameOver.png")
    gameOver.name = "gameOver"
    gameOver.x = 0
    gameOver.y = 500
end

function prepararBackground()
     backbackground = display.newImage("images/florest_background.png")
    backbackground.x = 0
    backbackground.y = 130

    backbackground2 = display.newImage("images/florest_background.png")
    backbackground2.x = 1152
    backbackground2.y = 130 
end

function inicializarPontuacao()
score = 0

scoreText = display.newText("score: " .. score, 0, 0, "BorisBlackBloxx", 50)
scoreText.text = "score: " .. score
scoreText:setReferencePoint(display.CenterLeftReferencePoint)
scoreText.x = 0
scoreText.y = 30
end

function iniciarPiso()
    
    groundMin = 400
    groundMax = 340
    groundLevel = groundMin
    
    for a = 1, 8, 1 do
        isDone = false
        --get a random number between 1 and 2, this is what we will use to decide which
        --texture to use for our ground sprites. Doing this will give us random ground
        --pieces so it seems like the ground goes on forever. You can have as many different
        --textures as you want. The more you have the more random it will be, just remember to
        --up the number in math.random(x) to however many textures you have.
        numGen = math.random(2)
        local newBlock
        print (numGen)
        if(numGen == 1 and isDone == false) then
        newBlock = display.newImage("images/ground_green_1.png", 100)
        isDone = true
        end
        if(numGen == 2 and isDone == false) then
        newBlock = display.newImage("images/ground_green_1.png")
        isDone = true
        end
        --now that we have the right image for the block we are going
        --to give it some member variables that will help us keep track
        --of each block as well as position them where we want them.
        newBlock.name = ("block" .. a)
        newBlock.id = a
        --because a is a variable that is being changed each run we can assign
        --values to the block based on a. In this case we want the x position to
        --be positioned the width of a block apart.
        newBlock.x = (a * 79) - 79
        newBlock.y = groundLevel
        blocks:insert(newBlock)
    end
end

function iniciarObstaculos()
    for a = 1, 3, 1 do
        spike = display.newImage("images/spikeBlock.png")
        spike.name = ("spike" .. a)
        spike.id = a
        spike.x = 900
        spike.y = 500
        spike.isAlive = false
        spikes:insert(spike)
    end
end


function iniciarInimigos()
    for a = 1, 3, 1 do
        ghost = display.newImage("images/spider.png")
        ghost.name = ("ghost" .. a)
        ghost.id = a
        ghost.x = 800
        ghost.y = 600
        ghost.speed = 0
            --variable used to determine if they are in play or not
        ghost.isAlive = false
            --make the ghosts transparent and more... ghostlike!
        ghost.alpha = .5
        ghosts:insert(ghost)
    end
end

function iniciarTiros()
     
    for a=1, 2, 1 do
        blast = display.newImage("images/lan_02.png", 170,58)
        blast.name = ("blast" .. a)
        blast.id = a
        blast.x = 800
        blast.y = 500
        blast.isAlive = false

        blasts:insert(blast)
    end
end

function iniciarHeroi()
    spriteSheet = sprite.newSpriteSheet("images/curumin_02_sprite.png", 164.33, 80)
   -- spriteSheet = sprite.newSpriteSheet("images/curumin_sprite_1.png", 274, 135)
    heroSet = sprite.newSpriteSet(spriteSheet, 1, 6)
    --next we make animations from our sprite sets. To do this simply tell the
    --function which sprite set to us, next name the animation, give the starting
    --frame and the number of frames in the animation, the number of milliseconds
    --we want 1 animation to take, and finally the number of times we want the
    --animation to run for. 0 will make it run until we tell the animtion to stop
    sprite.add(heroSet, "running", 1, 4, 1000, 0)
    sprite.add(heroSet, "jumping",5,1, 1000, -6)
    hero = sprite.newSprite(heroSet)

    --a boolean variable that shows which direction we are moving
    
    hero.x = 100
    hero.y = 200

    hero.gravity = -6
    hero.accel = 0
    hero.isAlive = true

   -- hero:scale(0.6, 0.6)
    
    correr()

end


function splashScreenAnimated()
     animated_splash = sprite.newSprite(heroSet)

    --a boolean variable that shows which direction we are moving
    
    animated_splash.x = display.contentWidth *0.5
    animated_splash.y = display.contentHeight *0.5

    animated_splash:scale(0.6, 0.6)
    animated_splash:prepare("running")
    animated_splash:play()
    
end


function correr()
    hero:prepare("running")
    hero:play()
end

function iniciarCollisionRect()
    collisionRect = display.newRect(hero.x + 36, hero.y, 1, 70)
    collisionRect.strokeWidth = 1
    collisionRect:setFillColor(140, 140, 140)
    collisionRect:setStrokeColor(180, 180, 180)
    collisionRect.alpha = 0
end

function scene:createScene( event )
	local group = self.view
        
        timer.performWithDelay(500, inicializar(), 1)
        database:createDataBase()
        showLoadScreen()
        group:insert(backbackground)
        group:insert(backbackground2)
        group:insert(blocks)
        group:insert(hero)
        group:insert(collisionRect)
        group:insert(spikes)
        group:insert(blasts)
        group:insert(ghosts)
        group:insert(scoreText)
        group:insert(gameOver)
        group:insert(loadingSCR)
        group:insert(animated_splash)
        group:insert(loadingSCRTXT)
        group:insert(pause_button)
        group:insert(resume_button)
        group:insert(restart_button)
        group:insert(quit_button)
        
       -- dismissLoadScreen()
end

function scene:enterScene(event)
    local group = self.view
    timer.performWithDelay(500, inicializarAudio(group), 1)
    --inicializarAudio()
    --group:remove(loadingSCR)
  --  group:remove(loadingSCRTXT)
end

function showLoadScreen()
    loadingSCR = display.newRect(-50, -50, display.contentWidth + 100, display.contentHeight + 100)
    loadingSCR:setFillColor(0,0,0)
    loadingSCRTXT = display.newText("Loading... ", display.contentWidth/2, display.contentHeight/2, nil, 20)
    splashScreenAnimated()
end


function dismissLoadScreen(group)
    group:remove(loadingSCR)
    group:remove(animated_splash)
    group:remove(loadingSCRTXT)
end

function scene:exitScene( event )
    isSceneOn = false   
    finalizarAudios()
end

function scene:destroyScene( event )
	local group = self.view
        isSceneOn = false
end

scene:addEventListener( "createScene", scene )
scene:addEventListener("enterScene", scene)
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "exitScene", scene )


function pausegame()
    ispause = true
    hero:pause()
    showPauseMenu()
    audio.pause()
end

function resumegame()
    ispause = false
    hero:play()
    dismissPauseMenu()
    audio.resume()
end

function quitgame()
    storyboard.gotoScene("menu", "crossFade", 500)
end

function showPauseMenu()
    
    resume_button.x = display.contentWidth * 0.5
    resume_button.y = display.contentHeight * 0.5 - 75
    
    restart_button.x = display.contentWidth * 0.5
    restart_button.y = display.contentHeight * 0.5
    
    quit_button.x = display.contentWidth * 0.5
    quit_button.y = display.contentHeight * 0.5 + 75
    
end

function dismissPauseMenu()
    resume_button.x = 800
    resume_button.y = 500
    
    restart_button.x = 800
    restart_button.y = 500
    
    quit_button.x = 800
    quit_button.y = 500
end





local function update( event )
   if (isSceneOn and (ispause == false)) then
        updateBackgrounds()
        updateSpeed()
        updateMonster()
        updateBlocks()
        checkCollisions()
        updateBlasts()
        updateGhosts()
        updateSpikes()
   end
end

function updateSpeed()
    
    if (hero.isAlive) then
        speed = speed + .005
    end
    
    
	
end

function updateBlocks()
    for a = 1, blocks.numChildren, 1 do
        if(a > 1) then
            newX = (blocks[a - 1]).x + 99
        else
            newX = (blocks[8]).x + 99 - speed
        end
            if((blocks[a]).x < -99) then
                score = score + 1
                scoreText.text = "score: " .. score
                scoreText:setReferencePoint(display.CenterLeftReferencePoint)
                scoreText.x = 0
                scoreText.y = 30
                if(inEvent == 11) then
                    (blocks[a]).x, (blocks[a]).y = newX, 600
                else
                    (blocks[a]).x, (blocks[a]).y = newX, groundLevel
                end
                checkEvent()
            else
                (blocks[a]):translate(speed * -0.5, 0)
        end
    end
end

function updateBackgrounds()

    backbackground.x = backbackground.x - (speed/10) 

    if(backbackground.x <= -1151)then 
       backbackground.x = 1151 
    end
    
    backbackground2.x = backbackground2.x - (speed/10) 

    if(backbackground2.x <= -1151)then 
       backbackground2.x = 1151
  
    end

  --  backgroundnear1.x = backgroundnear1.x - (speed/5)
    --if the sprite has moved off the screen move it back to the
    --other side so it will move back on
   -- if(backgroundnear1.x <= -544) then
    --   backgroundnear1.x = 544
    --end
    --backgroundnear2.x = backgroundnear2.x - (speed/5)
    --if(backgroundnear2.x <= -544) then
      --  backgroundnear2.x = 544
    --end
end

function checkCollisions()
        --boolean variable so we know if we were on the ground in the last frame
	wasOnGround = onGround

	--checks to see if the collisionRect has collided with anything. This is why it is lifted off of the ground
	--a little bit, if it hits something we will want our monster to do something... like die! This is why we don't want it
        --hitting the ground, it wouldn't make sense for the monster to die everything he touched the ground. We check this by cycling through
	--all of the ground pieces in the blocks group and comparing their x and y coordinates to that of the collisionRect
	for a = 1, blocks.numChildren, 1 do
		if(collisionRect.y - 170> blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
                        
                        killHero()
		end
	end
        
        
        --stop the game if the monster runs into a spike wall
        for a = 1, spikes.numChildren, 1 do
            if(spikes[a].isAlive == true) then
                if(collisionRect.y - 10> spikes[a].y - 170 and spikes[a].x - 40 < collisionRect.x and spikes[a].x + 40 > collisionRect.x) then
                    print("spike collision")
                    killHero()
                end
            end
        end

        --make sure the player didn't get hit by a ghost!
        for a = 1, ghosts.numChildren, 1 do
            if(ghosts[a].isAlive == true) then
                if(((  ((hero.y-ghosts[a].y))<70) and ((hero.y - ghosts[a].y) > -70)) and (ghosts[a].x - 40 < collisionRect.x and ghosts[a].x + 40 > collisionRect.x)) then
                     print("ghost collision")
                    killHero()
                end
            end
        end

	--this is where we check to see if the monster is on the ground or in the air, if he is in the air then he can't jump(sorry no double
	--jumping for our little monster, however if you did want him to be able to double jump like Mario then you would just need
	--to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
	--true once the double jump has been made. That way he is limited to 2 hops per jump.
	--Again we cycle through the blocks group and compare the x and y values of each.
	for a = 1, blocks.numChildren, 1 do
		if(hero.y >= blocks[a].y - 126 and blocks[a].x < hero.x + 70 and blocks[a].x > hero.x - 70) then
			hero.y = blocks[a].y - 126
			onGround = true
			break
		else
			onGround = false
		end
	end
end

function playSoundGameOver()
    audio.play(hero_damage_sound)
    audio.stop(bgm_channel)
    gameover_channel = audio.play(gameover_sound)
end

function killHero()
    if (hero.isAlive) then
                
        playSoundGameOver()
        print("killzombie")
        speed = 0
        hero.isAlive = false
        gameOver.x = display.contentWidth*.65
        gameOver.y = display.contentHeight/2
        hero:pause()
        database.ponto = score
        database:insertScore()
    end
end

function updateMonster()
	--if our monster is jumping then switch to the jumping animation
	--if not keep playing the running animation
        
        if (hero.isAlive) then
                 
            if(onGround) then
                    if(wasOnGround == false) then
                        hero:prepare("running")
                        hero:play()
                                              
                    end
           else
                  
                        hero:prepare("jumping")
                         hero:play()
                                           
                   
                    
            end

            if(hero.accel > 0) then
                    hero.accel = hero.accel - 1
            end

            --update the monsters position, accel is used for our jump and
            --gravity keeps the monster coming down. You can play with those 2 variables
            --to make lots of interesting combinations of gameplay like 'low gravity' situations
            hero.y = hero.y - hero.accel
            hero.y = hero.y - hero.gravity
        else
            hero:rotate(5)
        end    
	--update the collisionRect to stay in front of the monster
	collisionRect.y = hero.y
end

function touched( event )
    
    if (isSceneOn == false) then
        return nil
    end
    
    if(event.x < gameOver.x + 150 and event.x > gameOver.x - 150 and event.y < gameOver.y + 95 and event.y > gameOver.y - 95) then
         restartGame()
         --storyboard.gotoScene("menu", "crossFade",500)
    else
        if (hero.isAlive) then
            if(event.phase == "began") then
                    if(event.x < 241) then
                            if(onGround) then
                                    hero.accel = hero.accel + 25
                            end
                        else
                           for a=1, blasts.numChildren, 1 do
                                if(blasts[a].isAlive == false) then
                                    audio.play(blast_sound)
                                    blasts[a].isAlive = true
                                    blasts[a].x = hero.x + 50
                                    blasts[a].y = hero.y
                                    break
                                end
                           end 
                        end    
            end
        end    
    end    
end

function checkEvent()
     --first check to see if we are already in an event, we only want 1 event going on at a time
     if(eventRun > 0) then
          --if we are in an event decrease eventRun. eventRun is a variable that tells us how
          --much longer the event is going to take place. Everytime we check we need to decrement
          --it. Then if at this point eventRun is 0 then the event has ended so we set inEvent back
          --to 0.
          eventRun = eventRun - 1
          if(eventRun == 0) then
               inEvent = 0
          end
     end
     --if we are in an event then do nothing
     if(inEvent > 0 and eventRun > 0) then
          --Do nothing
     else
          --if we are not in an event check to see if we are going to start a new event. To do this
          --we generate a random number between 1 and 100. We then check to see if our 'check' is
          --going to start an event. We are using 100 here in the example because it is easy to determine
          --the likelihood that an event will fire(We could just as easilt chosen 10 or 1000).
          --For example, if we decide that an event is going to
          --start everytime check is over 80 then we know that everytime a block is reset there is a 20%
          --chance that an event will start. So one in every five blocks should start a new event. This
          --is where you will have to fit the needs of your game.
          check = math.random(100)
          --this first event is going to cause the elevation of the ground to change. For this game we
          --only want the elevation to change 1 block at a time so we don't get long runs of changing
          --elevation that is impossible to pass so we set eventRun to 1.
          if(check > 80 and check < 99) then
               --since we are in an event we need to decide what we want to do. By making inEvent another
               --random number we can now randomly choose which direction we want the elevation to change.
               inEvent = math.random(10)
               eventRun = 1
          end
          
          if(check > 98) then
            inEvent = 11
            eventRun = 2
          end
          
          if(check > 72 and check < 81) then
            inEvent = 12
            eventRun = 1
          end
          
          --ghost event
            if(check > 60 and check < 73) then
               inEvent = 13
               eventRun = 1
            end
          
     end
     --if we are in an event call runEvent to figure out if anything special needs to be done
     if(inEvent > 0) then
          runEvent()
     end
end
--this function is pretty simple it just checks to see what event should be happening, then
--updates the appropriate items. Notice that we check to make sure the ground is within a
--certain range, we don't want the ground to spawn above or below whats visible on the screen.
function runEvent()
     if(inEvent < 6) then
          groundLevel = groundLevel + 40
     end
     if(inEvent > 5 and inEvent < 11) then
          groundLevel = groundLevel - 40
     end
     if(groundLevel < groundMax) then
          groundLevel = groundMax
     end
     if(groundLevel > groundMin) then
          groundLevel = groundMin
     end
     
     if(inEvent == 12) then
        for a=1, spikes.numChildren, 1 do
                if(spikes[a].isAlive == true) then
                --do nothing
                else
                spikes[a].isAlive = true
                spikes[a].y = groundLevel - 200
                spikes[a].x = newX
                break
            end
        end
     end
     
     if(inEvent == 13) then
        for a=1, ghosts.numChildren, 1 do
        if(ghosts[a].isAlive == false) then
            ghosts[a].isAlive = true
            ghosts[a].x = 500
            ghosts[a].y = math.random(-50, 400)
            ghosts[a].speed = math.random(2,4)
            break
                end
        end
     end
     
end

function updateBlasts()
        --for each blast that we instantiated check to see what it is doing
    for a = 1, blasts.numChildren, 1 do
                --if that blast is not in play we don't need to check anything else
        if(blasts[a].isAlive == true) then
            (blasts[a]):translate(5, 0)
           -- blasts[a]:rotate(10)
                        --if the blast has moved off of the screen, then kill it and return it to its original place
            if(blasts[a].x > 550) then
                    blasts[a].x = 800
                blasts[a].y = 500
                blasts[a].isAlive = false
            end
        end
                --check for collisions between the blasts and the spikes
        for b = 1, spikes.numChildren, 1 do
            if(spikes[b].isAlive == true) then
                if(blasts[a].y - 25 > spikes[b].y - 120 and blasts[a].y + 25 < spikes[b].y + 120 and spikes[b].x - 40 < blasts[a].x + 25 and spikes[b].x + 40 > blasts[a].x - 25) then
                        audio.play(damage_sound2)
                        blasts[a].x = 800
                        blasts[a].y = 500
                        blasts[a].isAlive = false
                        spikes[b].x = 900
                        spikes[b].y = 500
                        spikes[b].isAlive = false
                                end
            end
        end
                --check for collisions between the blasts and the ghosts
                for b = 1, ghosts.numChildren, 1 do
            if(ghosts[b].isAlive == true) then
                if(blasts[a].y - 25 > ghosts[b].y - 120 and blasts[a].y + 25 < ghosts[b].y + 120 and ghosts[b].x - 40 < blasts[a].x + 25 and ghosts[b].x + 40 > blasts[a].x - 25) then
                     audio.play(damage_sound)
                    blasts[a].x = 800
                    blasts[a].y = 500
                    blasts[a].isAlive = false
                    ghosts[b].x = 800
                    ghosts[b].y = 600
                    ghosts[b].isAlive = false
                    ghosts[b].speed = 0
                end
            end
        end
    end
end

--check to see if the spikes are alive or not, if they are
--then update them appropriately
function updateSpikes()
    for a = 1, spikes.numChildren, 1 do
        if(spikes[a].isAlive == true) then
            (spikes[a]):translate(speed * -1, 0)
            if(spikes[a].x < -80) then
                spikes[a].x = 900
                spikes[a].y = 500
                spikes[a].isAlive = false
            end
        end
        end
end

--update the ghosts if they are alive
function updateGhosts()
        for a = 1, ghosts.numChildren, 1 do
            if(ghosts[a].isAlive == true) then
                (ghosts[a]):translate(speed * -1, 0)
                if(ghosts[a].y > hero.y) then
                    ghosts[a].y = ghosts[a].y - 1
                end
                if(ghosts[a].y < hero.y) then
                    ghosts[a].y = ghosts[a].y + 1
                end
                if(ghosts[a].x < -80) then
                    ghosts[a].x = 800
                    ghosts[a].y = 600
                    ghosts[a].speed = 0
                    ghosts[a].isAlive = false;
                end
                end
    end
end


function restartGame()
       
     --move menu
     gameOver.x = 0
     gameOver.y = 500
     --reset the score
     score = 0
     --reset the game speed
     speed = 5
     --reset the monster
     hero.isAlive = true
     hero.x = 110
     hero.y = 200
     hero:prepare("running")
     hero:play()
     hero.rotation = 0
     --reset the groundLevel
     groundLevel = groundMin
     for a = 1, blocks.numChildren, 1 do
          blocks[a].x = (a * 79) - 79
          blocks[a].y = groundLevel
     end
     --reset the ghosts
     for a = 1, ghosts.numChildren, 1 do
          ghosts[a].x = 800
          ghosts[a].y = 600
     end
     --reset the spikes
     for a = 1, spikes.numChildren, 1 do
          spikes[a].x = 900
          spikes[a].y = 500
     end
     --reset the blasts
     for a = 1, blasts.numChildren, 1 do
          blasts[a].x = 800
          blasts[a].y = 500
     end
     --reset the backgrounds
     
     backbackground.x = 0
     backbackground.y = 130 
     
     backbackground2.x = 1152
     backbackground2.y = 130 
     
     
     if (ispause) then
         ispause = false
         dismissPauseMenu()
         audio.resume()
     else
         finalizarAudios()
         bgm_channel = audio.play(bgm)
     end    
     
end



--call the update function
Runtime:addEventListener("enterFrame", update)


Runtime:addEventListener("touch", touched, -1)

return scene
