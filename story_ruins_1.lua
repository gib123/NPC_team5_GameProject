-----------------------------------------------------------------------------------------
--
-- 스토리 폐허 파트 상.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view
	

-------------------유저 정보 로드---------------------------------------------------------------------------------
	local loadsave = require( "loadsave" )

	local userSettings = loadsave.loadTable("userSettings.json")

	userSettings.presentScene = "story_ruins_1"
	loadsave.saveTable(userSettings, "userSettings.json")
-------------------변수-------------------------------------------------------------------------------

	--배경 그림--
	local background = display.newImage("image/background/ruins.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentCenterX, display.contentCenterY
	sceneGroup:insert(background)

	--플레이어 그림--
	local player = display.newImage("image/component/evy.png")
	player.x, player.y = display.contentCenterX, display.contentCenterY*1.5
	player:scale(1.2, 1.2)
	player.alpha = 0
	sceneGroup:insert(player)

	--대사창 그림--
	dialogueBox = display.newImage("image/component/story_box.png")
	dialogueBox.x, dialogueBox.y = display.contentCenterX, display.contentCenterY*1.6

	--대사창 위 이름칸 그림--
	local nameBox = display.newImage("image/component/story_name.png")
	nameBox.x, nameBox.y = display.contentCenterX*0.35, display.contentCenterY*1.333

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
	sceneGroup:insert(dialogueBoxGroup)

	--메뉴버튼 그림--
	local menuButton = display.newImage("image/component/menu_button.png")
  	menuButton.x, menuButton.y = display.contentWidth*0.92, display.contentHeight*0.1
	sceneGroup:insert(menuButton)
  
	--sound
	local buttonSound = audio.loadSound( "sound/buttonSound.mp3" )

  	--overlayOption: overlay 화면의 액션 이 씬에 전달 X
	local overlayOption =
	{
	    isModal = true
	}


-------------------텍스트---------------------------------------------------------------------------------

  	--내래이션과 대사--
  	local dialogue = {" ", "얼마나 오래 걸었을까요? 숲을 가득 채우던 나무가 하나씩 시야에서 사라지고 있어요.",
  				"은근한 흙먼지 향내가 코끝에 감돌고, 지내온 숲과는 다른 풍경이 당신 앞에 펼쳐집니다.", --3
  				"어째 점점 황량한 배경이 이어지는 것 같아요.",
  				"숲과 멀어지면... 건물의 잔해와 이끼가 뒤엉켜 바스라진 광경이 눈에 들어옵니다.",
  				"이게 바로 시멘트라는 걸까요?\n건물의 벽을 이루고 있었던 시멘트덩이 사이를 잡초가 비집고 들어간 것 같네요.", --6
  				"우뚝 솟은 잡초들이 시들시들해 보여요.", --7
  				"숲 밖은 모두 이렇게 생명의 흔적이 사라지고 있는 걸까요.",
  				"... 아무도 없는 건가? 주위를 둘러봐도 사람이 없네.",
  				"생각해보면, 선생님께서는 다른 사람들에 대한 이야기를 당신께 일절 하지 않았습니다.	", --10
  				"목소리를 높여 사람들을 불러봐도 메아리만 칠 뿐, 아무도 당신 곁에 다가오질 않아요.",
  				"사람이 없다는 것이 더 정확한 표현이겠죠.",
  				"이상합니다. 더 살펴보는 게 좋겠어요." --13
  			}

	--대사 구성--
	local showDialogue = {}
	local showDialogueGroup = display.newGroup()
	for i = 1, #dialogue do
		showDialogue[i] = display.newText(showDialogueGroup, dialogue[i], dialogueBox.x, dialogueBox.y, 1000, 0, "fonts/GowunBatang-Bold.ttf", 27)
		showDialogue[i]:setFillColor(1)
		showDialogue[i].alpha = 0
	end
	sceneGroup:insert(showDialogueGroup)

	--이름창 글자--
	local name = "이비"
	local showName = display.newText(name, nameBox.x, nameBox.y*0.993, "fonts/GowunBatang-Bold.ttf", 30)

	--이름창+이름글자 그룹--
	local nameGroup = display.newGroup()
	nameGroup:insert(nameBox)
	nameGroup:insert(showName)
	nameGroup.alpha = 0
	sceneGroup:insert(nameGroup)

-------------------함수----------------------------------------------------------------------------------

	--클릭으로 대사 전환--
	local fastforward_state = 0 --빨리감기상태 0꺼짐 1켜짐

	local playerTime = 400 --플레이어와 이름창 페이드인 시간
	local dialogueFadeInTime = 400 --대사 페이드인과 배경 전환 시간
	local dialogueFadeOutTime = 200 --대사와 이름창 페이드아웃 시간

	i = 1

	function changeCharAndBack()
		if(i == 9) then
			transition.fadeIn(nameGroup, { time = playerTime })
			transition.fadeIn(player, { time = playerTime })
		elseif(i == 10) then
			transition.fadeOut(nameGroup, { time = dialogueFadeOutTime })
		end
	end

	-- 저장 load시 캐릭터와 배경 상태 setting
	function setCharAndBack()
		changeCharAndBack()
		if i > 9 then
			player.alpha = 1
		end
	end

	local loadOption =
	{
	    effect = "fade",
	    time = 400,
	}

	function nextScript(event)
		if(fastforward_state == 0) then
			showDialogue[i].alpha = 0
			if(i < #dialogue) then
				i = i + 1
			else
				composer.gotoScene("quest3", loadOption)
			end
			showDialogue[i].alpha = 1

			playerTime = 200
		else
			transition.fadeOut(showDialogue[i], { time = dialogueFadeOutTime })
			if i == #dialogue then
				stopFastForward()
				composer.gotoScene("quest3", loadOption)
			end
			if(i < #dialogue) then
				i = i + 1
			end
			transition.fadeIn(showDialogue[i], { time = dialogueFadeInTime })
		end

		changeCharAndBack()
	end
	dialogueBox:addEventListener("tap", nextScript)

	--빨리감기기능--
	local function scriptFastForward()
		print("i: ", i)
		nextScript()
	end

	function fastforward(event)	
		audio.play( buttonSound )

		if(fastforward_state == 0) then
			fastforward_state = 1
			dialogueBox:removeEventListener("tap", nextScript)
			skipButton:removeEventListener("tap", skip)
			timer1 = timer.performWithDelay(1000, scriptFastForward, 0, "sFF")
		else
			fastforward_state = 0
			dialogueBox:addEventListener("tap", nextScript)
			skipButton:addEventListener("tap", skip)
			timer.pause("sFF")
	
			return true
		end
	end
	fastforwardButton:addEventListener("tap", fastforward)

	--빨리감기종료함수--
	function stopFastForward()
		fastforward_state = 0
		dialogueBox:addEventListener("tap", nextScript)
		skipButton:addEventListener("tap", skip)
		timer.pause(timer1)
	end

	--스킵기능--
	function skip(event)	
		audio.play( buttonSound )

		if(player.alpha == 0) then
			transition.fadeIn(player, { time = playerTime })
		end
		if(nameGroup.alpha == 1) then
			transition.fadeOut(nameGroup, { time = dialogueFadeOutTime })
		end

		transition.fadeOut(showDialogue[i], { time = dialogueFadeOutTime })
		i = #dialogue
		transition.fadeIn(showDialogue[i], { time = dialogueFadeInTime })
		
		print("i: ", i)
	end
	skipButton:addEventListener("tap", skip)

	--메뉴열기--  	
	local bounds = menuButton.contentBounds
	local isOut
  	local function menuOpen(event)
  		if event.phase == "began" then
  			isOut = 0 	-- 이벤트 시작 시에는 이벤트가 버튼 안에 있음 (초기값)

  			display.getCurrentStage():setFocus( event.target )
    	    self.isFocus = true
    	    
    	    menuButton:scale(0.9, 0.9) 	-- 버튼 작아짐	
    	    audio.play( buttonSound )

    	elseif self.isFocus then
    		if event.phase == "moved" then
    			-- 1. 이벤트가 버튼 밖에 있지만 isOut == 0인 경우(방금까지 안에 있었을 경우)에만 수행 (처음 밖으로 나갈 때 한 번 수행)
    			if (event.x < bounds.xMin or event.x > bounds.xMax or event.y < bounds.yMin or event.y > bounds.yMax) and isOut == 0 then
    				menuButton:scale(1.1, 1.1)	-- 버튼 커짐
    				isOut = 1 	-- 이벤트가 버튼 밖에 있음을 상태로 저장

    			-- 2. 이벤트가 버튼 안에 있지만 isOut == 1인 경우(방금까지 밖에 있었을 경우)에만 수행 (처음 안으로 들어올 때 한 번 수행)
    			elseif (event.x >= bounds.xMin and event.x <= bounds.xMax and event.y >= bounds.yMin and event.y <= bounds.yMax) and isOut == 1 then
    				menuButton:scale(0.9, 0.9) 	-- 버튼 작아짐
    				isOut = 0 	-- 이벤트가 버튼 안에 있음을 상태로 저장
    			end
	        elseif event.phase == "ended" or event.phase == "cancelled" then
	            display.getCurrentStage():setFocus( nil )
	            self.isFocus = false

	        	-- 버튼 안에서 손을 뗐을 시에만 메뉴 실행
  				if event.x >= bounds.xMin and event.x <= bounds.xMax and event.y >= bounds.yMin and event.y <= bounds.yMax then
		        	menuButton:scale(1.1, 1.1)
		        	-- 여기부터가 실질적인 action에 해당
		        	if fastforward_state == 1 then --메뉴오픈시 빨리감기종료 추가
						stopFastForward()
					end
		      		-- dialogueBox:removeEventListener("tap", nextScript) --메뉴오픈시 탭 이벤트 제거 추가
		      		-- 현재 대사 위치 파라미터로 저장
			      	composer.setVariable("scriptNum", i)
			      	composer.setVariable("userSettings", userSettings)
		  			composer.showOverlay("menuScene", overlayOption)
				end	
			end
	    end	
  	end
  	menuButton:addEventListener("touch", menuOpen)

  	--메뉴 시작화면으로 버튼 클릭시 장면 닫고 타이틀화면으로 이동--
	function scene:closeScene()
		composer.removeScene("storyScene_ruins1")
		-- composer.gotoScene("scene1")
	end

	-- scriptNum를 params으로 받은 경우: 저장을 load한 경우이므로 특정 대사로 이동
    if event.params then
    	if event.params.scriptNum then
			i = event.params.scriptNum
			showDialogue[1].alpha = 0
			showDialogue[i].alpha = 1
			setCharAndBack()
		end
	end

	-- composer.loadScene("choiceScene")
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
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
		composer.removeScene("story_ruins_1")
		print("story_ruins_1: hide")
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