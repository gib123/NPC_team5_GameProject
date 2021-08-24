+-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	-- 임시 배경 --
	local background = display.newImageRect("image/background/forest임시배경.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentWidth*0.5, display.contentHeight*0.5
	sceneGroup:insert(background)

	--플레이어 그림--
	local player = display.newImage("image/component/evy.png")
	player.x, player.y = display.contentCenterX, display.contentCenterY*1.3
	player.isVisible = false
	sceneGroup:insert(player)

	--대사창 그림--
	local dialogueBox = display.newImage("image/component/story_box.png")
	dialogueBox.x, dialogueBox.y = display.contentCenterX, display.contentCenterY*1.6

	--대사창 위 이름칸 그림--
	local nameBox = display.newImage("image/component/story_name.png")
	nameBox.x, nameBox.y = display.contentCenterX*0.35, display.contentCenterY*1.333

	--대사창 위 이름--
	local name = display.newText("이비", display.contentCenterX*0.35, display.contentCenterY*1.333, "fonts/GowunBatang-Bold.ttf", 36)

	--대사창 위 스킵버튼 그림--
	local skipButton = display.newImage("image/component/story_skip.png")
	skipButton.x, skipButton.y = display.contentCenterX*1.75, display.contentCenterY*1.33

	--대사창 위 빨리가기 버튼 그림--
	local fastforwardButton = display.newImage("image/component/story_fast.png")
	fastforwardButton.x, fastforwardButton.y = display.contentCenterX*1.63, display.contentCenterY*1.33

	--대사창 그룹--
	local dialogueBoxGroup = display.newGroup()
	dialogueBoxGroup:insert(dialogueBox)
	dialogueBoxGroup:insert(nameBox)
	dialogueBoxGroup:insert(skipButton)
	dialogueBoxGroup:insert(fastforwardButton)

	--이름 그룹--
	local nameGroup = display.newGroup()
	nameGroup:insert(nameBox)
	nameGroup:insert(name)
	nameGroup.isVisible = false

	--메뉴버튼 그림--
	local menuButton = display.newImage("image/component/menu_button.png")
  	menuButton.x, menuButton.y = display.contentWidth*0.92, display.contentHeight*0.1

  	local function changeCursorShape(event)

  	end
  	--메뉴열기--
  	local function menuOpen(event)
  		if(event.phase == "began") then
  			composer.showOverlay("menuScene")
  		end
  	end
  	menuButton:addEventListener("touch", menuOpen)

  	local scripts = {
        "나무 그늘 아래를 둘러보고, 개울 위까지 살펴보러 떠나봅시다.",					
        "선생님은 대체 어디에 계신 걸까요? 살랑살랑 흩날리던 선생님의 머리칼이 그리워져요!",				
        "늘상 평온한 날이 이어질 것이라 생각했으나, 오늘은 무슨 일이 생기려는 걸까요.",				
        "푹신한 이끼를 밟으며 걸어가면 분명 언젠가 선생님을 찾을 수 있겠지.......",			
        "당신은 걷고, 또 걷습니다. 검은 나뭇잎이 하늘을 가릴 쯤에 무릎에서 끽끽 소리가 흘러나와요.",			
        "묘하게 삐그덕거리는 게, 아무래도 무리해서 돌아다닌 것 같아요.",
        "조금 쉬어보는 게 어때요?",				
        "차가운 공기가 비강을 비집고 들어옵니다.",
        "신선한 공기인 것을 단번에 알아차립니다.",
        "숲 밖의 지역도 이렇게 상쾌한 공기가 가득할까요?",
        "목이 말랐는데, 다행히 개울이 있네요.",
        "선생님께 배웠던 물 정화 마법으로 갈증을 해소합니다.",
        "휴식을 취하니 힘이 생기는 것 같네.",
        "선생님은 숲 밖으로 외출하신 것일 수도 있겠네요.",
        "이렇게까지 꽁꽁 숨어버리시면 찾는 제자가 고생이라니까요.",
        "그렇다고 숲을 나가기엔 선생님께서 절대 안 된다고 말리셨으니까요......",
        "다시 선생님을 찾아다니는 것도 괜찮을 것 같아요."
 	}

 	local options1 = {
 		"이끼에 앉아 숨을 들이켜보자.", 
 		"개울가에 다가가 목을 축여보자."
 	}

 	local options2 = {
 		"이끼에 앉아 숨을 들이켜보자."
 	}

    local curScript = {}
    local curScriptNum = 0
 	for i = 1, #scripts, 1 do
 		curScript[i] = display.newText(scripts[i], display.contentCenterX, display.contentCenterY*1.6, 1000, 0, "fonts/GowunBatang-Bold.ttf", 30)
		curScript[i].alpha = 0
	end


	local overlayOption =
	{
	    isModal = true
	}

	local function nextScript(event)
		print(#scripts)
		print("curScriptNum: ", curScriptNum)
		if curScriptNum == 7 then
			composer.setVariable("options", options1)
			composer.showOverlay("choiceScene", overlayOption)
		elseif curScriptNum == 12 then
			composer.setVariable("options", options2)
			composer.showOverlay("choiceScene_oneOption", overlayOption)
		elseif curScriptNum < #scripts then
			if curScriptNum ~= 0 then
				curScript[curScriptNum].alpha = 0
			end

			if curScriptNum == 10 then
				curScriptNum = 13
			else
				curScriptNum = curScriptNum + 1
			end

			curScript[curScriptNum].alpha = 1

			if curScriptNum == 4 or curScriptNum == 13 then
				nameGroup.isVisible = true
				player.isVisible = true
			end
			if curScriptNum == 5 or curScriptNum == 14 or curScriptNum == 15 or
               curScriptNum == 16 or curScriptNum ==17 then
				nameGroup.isVisible = false
			end
		end
	end

	dialogueBoxGroup:addEventListener("tap", nextScript)

	function scene:resumeGame()
		if curScriptNum == 7 then
			local selectedOption = composer.getVariable("selectedOption")
			print(selectedOption)
			curScript[curScriptNum].alpha = 0
			if selectedOption == 1 then
				curScriptNum = 8
			elseif selectedOption == 2 then
				curScriptNum = 11
			end
		elseif curScriptNum == 12 then
			curScript[curScriptNum].alpha = 0
				curScriptNum = 13
		end

		print("curScriptNum: ", curScriptNum)
		curScript[curScriptNum].alpha = 1
	end

	-- composer.loadScene("choiceScene")
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	print("show")
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene