-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

-------------------유저 정보 로드---------------------------------------------------------------------------------
	local loadsave = require( "loadsave" )

	local userSettings = loadsave.loadTable("userSettings.json")

	userSettings.presentScene = "story_ruins_3"
	loadsave.saveTable(userSettings, "userSettings.json")
	-------------------------------------------------------------
	-- 임시 배경 --
	local background = display.newImageRect("image/background/ruins.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentWidth*0.5, display.contentHeight*0.5
	sceneGroup:insert(background)

	--플레이어 그림--
	local player = display.newImage("image/component/evy.png")
	player.x, player.y = display.contentCenterX, display.contentCenterY*1.5
	player:scale(1.2, 1.2)
	player.alpha = 0
	sceneGroup:insert(player)

	--대사창 그림--
	dialogueBox = display.newImage("image/component/story_box.png") --local 빼기 수정
	dialogueBox.x, dialogueBox.y = display.contentCenterX, display.contentCenterY*1.6

	--대사창 위 이름칸 그림--
	local nameBox = display.newImage("image/component/story_name.png")
	nameBox.x, nameBox.y = display.contentCenterX*0.35, display.contentCenterY*1.333

	--대사창 위 이름--
	local name = display.newText("이비", display.contentCenterX*0.35, display.contentCenterY*1.333, "fonts/GowunBatang-Bold.ttf", 30)

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


	--이름 그룹--
	local nameGroup = display.newGroup()
	nameGroup:insert(nameBox)
	nameGroup:insert(name)
	nameGroup.isVisible = false
	sceneGroup:insert(nameGroup)


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

  	local scripts = {
		"『정보 공인 대-안드로이드 연구소』가 있던 자리로 겨우겨우 발걸음을 하면, 그 위치엔 거대한 잔해가 가득합니다.", -- 1: 연구소 파트 시작
		"규모가 큰 시설이었으나 대부분 무너진 듯해요. 그래도 아주 작은 건물 하나는 남아있는 듯합니다.", -- 2 (options1)
		"잔해를 피해 조심조심 작은 건물로 다가가보면, 너덜너덜한 문짝이 겨우 붙어있다는 것을 알아차릴 수 있습니다.", -- 3
		"문을 기울여 열어젖히니... 아, 긴 복도 끝에 탕비실이라 적힌 푯말이 보입니다. 누가 봐도 좁아터진 방이에요.", -- 4
		"연구소로 들어가지 않고, 그 주위를 배회하기로 마음을 먹습니다.", -- 5
		"비좁습니다. 먼지 가득한 탕비실이에요. 나무 탁자는 다리 넷이 모두 부러졌고, 커피와 차를 보관하고 있던 곳에선 옅은 악취가 풍겨옵니다.", -- 6: 탕비실 시작(options2)
		"흙먼지가 나풀댑니다. 시멘트 조각과 케케묵은 냄새가 가득합니다. 그 위를 벌레가 슬슬 지나갑니다.", -- 7
		"벌레가 지나간 곳 아래에는 종이 하나가 놓여있습니다.", 
		"종이는 낡았지만, 모두 오래되어 상한 장소에서 서류만큼은 최근의 것이라 생각하기 족할 정도로 멀쩡합니다.", 
		"최근에 누군가가 이곳에 와서 두고 간 것일지도 모르겠어요.", 
		"종이를 흘겨보니 그 위엔 안드로이드에 관한 내용으로 가득하다는 사실을 알 수 있습니다. 출력물인 듯해요.", -- 11 (options3)
		"안드로이드 신체 구조에 관한 내용이 적혀있어요. 가정용 모델을 주로 적은 듯한데, 체내에 정수 기능과 공기 청정 기능이 있다는 내용인 듯하네요.", -- 12
		"그 아래에는 연구소의 과거에 대한 이야기가 있는데, 적자가 나서 망했다는 문장만 가득해요.", -- 13 (options4)
 		"이 거대한 잔해들 사이에서 터벅터벅 발소리를 내며 걸어보니, 많은 종이들이 찢겨 나풀댄다는 사실을 마주할 수 있었습니다.", -- 14
 		"무너진 콘크리트 위에는 연구, 안드로이드, 개발, 멸망의 전조... 어딘가 석연찮은 단어가 가득한 자료만이 가득합니다.", 
 		"걷고, 또 걷습니다.", 
 		"선생님의 흔적을 찾고자 연구소에 오게 된 건데, 어째 이런 세상이 다가온 이유만을 알아버린 듯합니다.", 
 		"미약한 허탈함을 품고 계속해서 걸어갑니다.", 
 		"...... 오두막으로 다시 돌아가는 게 좋겠죠. 더 나아가다가는 돌아갈 길을 잃어버릴지도 모르겠어요."
 	}
 	
 	local options1 = {
 		"들어간다.", 
 		"들어가지 않는다."
 	}

 	local options2 = {
 		"『나무 탁자』 주위로 다가가본다."
 	}

 	local options3 = {
 		"『종이』를 확인한다."
 	}

 	local options4 = {
 		"『연구소 탕비실』을 나간다."
 	}

    local curScript = {}
    local curScriptGroup = display.newGroup() --대사배열그룹 작성 추가
    local curScriptNum = 1
 	for i = 1, #scripts, 1 do
 		curScript[i] = display.newText(curScriptGroup, scripts[i], display.contentCenterX, display.contentCenterY*1.6, 1000, 0, "fonts/GowunBatang-Bold.ttf", 27)
		curScript[i].alpha = 0
	end
	curScript[1].alpha = 1
	sceneGroup:insert(curScriptGroup)

	--클릭으로 대사 전환--
	local fastforward_state = 0 --빨리감기상태 0꺼짐 1켜짐 추가

	local playerTime = 400 --플레이어와 이름창 페이드인 시간 추가
	local dialogueFadeInTime = 400 --대사 페이드인과 배경 전환 시간 추가
	local dialogueFadeOutTime = 200 --대사와 이름창 페이드아웃 시간 추가

	function changeCharAndBack()	
		if curScriptNum == 14 then
			transition.fadeIn(player, { time = playerTime })
		end
		-- 캐릭터 변화
		-- if curScriptNum == 34 or curScriptNum == 8 then
		-- 	nameGroup.isVisible = true
		-- 	-- player.isVisible = true
		-- end
		-- if curScriptNum == 36 or curScriptNum == 10 then
		-- 	nameGroup.isVisible = false
		-- end
	end
	
	-- 저장 load시 캐릭터와 배경 상태 setting
	function setCharAndBack()
		changeCharAndBack()
		if curScriptNum > 3 and curScriptNum ~= 5 then
			player.alpha = 1
		end
	end

	local loadOption =
	{
	    effect = "fade",
	    time = 400,
	}

	function nextScript(event) --local 빼기 수정
		print(#scripts)
		print("curScriptNum: ", curScriptNum)
		-- 선택지로 이동
		if curScriptNum == 2 then
			if fastforward_state == 1 then --선택지에서 빨리감기종료 추가
				stopFastForward()
			end

			composer.setVariable("options", options1)
			composer.showOverlay("choiceScene", overlayOption)
		elseif curScriptNum == 6 then
			if fastforward_state == 1 then --선택지에서 빨리감기종료 추가
				stopFastForward()
			end

			composer.setVariable("options", options2)
			composer.showOverlay("choiceScene", overlayOption)
		elseif curScriptNum == 11 then
			if fastforward_state == 1 then --선택지에서 빨리감기종료 추가
				stopFastForward()
			end

			composer.setVariable("options", options3)
			composer.showOverlay("choiceScene", overlayOption)
		elseif curScriptNum == 13 then
			if fastforward_state == 1 then --선택지에서 빨리감기종료 추가
				stopFastForward()
			end

			composer.setVariable("options", options4)
			composer.showOverlay("choiceScene", overlayOption)
		elseif curScriptNum < #scripts then
			if curScriptNum ~= 0 then
				curScript[curScriptNum].alpha = 0
			end

			--빨리감기상태따른 text 전환 수정--
			if(fastforward_state == 0) then
				curScript[curScriptNum].alpha = 0
				-- 선택지 끝나서 공통으로 모임
				if curScriptNum == 4 then
					curScriptNum = 6
				elseif curScriptNum == 5 then
					curScriptNum = 14
				-- 디폴트
				else
					curScriptNum = curScriptNum + 1
				end
				curScript[curScriptNum].alpha = 1

				playerTime = 200
			else
				transition.fadeOut(curScript[curScriptNum], { time = dialogueFadeOutTime })
				-- 선택지 끝나서 공통으로 모임
				if curScriptNum == 4 then
					curScriptNum = 6
				elseif curScriptNum == 5 then
					curScriptNum = 14
				-- 디폴트
				else
					curScriptNum = curScriptNum + 1
				end
				transition.fadeIn(curScript[curScriptNum], { time = dialogueFadeInTime })
			end

			changeCharAndBack()
		elseif curScriptNum == #scripts then
			if(fastforward_state == 1) then
				stopFastForward()
			end
			composer.gotoScene("story_forest2_1", loadOption)
		end
	end

	dialogueBox:addEventListener("tap", nextScript) --dialogueBoxGroup -> dialogueBox 수정

	local playerTime = 400 --플레이어와 이름창 페이드인 시간

	function scene:resumeGame()
		if curScriptNum == 2 then
			local selectedOption = composer.getVariable("selectedOption")
			print(selectedOption)
			curScript[curScriptNum].alpha = 0
			if selectedOption == 1 then
				curScriptNum = 3
				transition.fadeIn(player, { time = playerTime })
			elseif selectedOption == 2 then
				curScriptNum = 5
			end

		elseif curScriptNum == 6 or curScriptNum == 11 or curScriptNum == 13 then
			curScript[curScriptNum].alpha = 0
			curScriptNum = curScriptNum + 1
		end

		print("curScriptNum: ", curScriptNum)
		curScript[curScriptNum].alpha = 1
	end

	--빨리감기기능(추가)--
	local function scriptFastForward()
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

	--빨리감기종료함수 추가--
	function stopFastForward()
		fastforward_state = 0
		dialogueBox:addEventListener("tap", nextScript)
		skipButton:addEventListener("tap", skip)
		timer.pause(timer1)
	end

	--스킵기능(추가)--
	function skip(event)	
		audio.play( buttonSound )

		curScript[curScriptNum].alpha = 0
		if(curScriptNum <= 2) then
			curScriptNum = 2
		elseif(curScriptNum == 3 or curScriptNum == 4 or curScriptNum == 6) then
			curScriptNum = 6
		elseif(curScriptNum >= 7 and curScriptNum <= 11) then
			curScriptNum = 11
		elseif(curScriptNum >= 12 and curScriptNum <= 13) then
			curScriptNum = 13
		elseif((curScriptNum >= 14 and curScriptNum <= 19) or curScriptNum == 5) then
			curScriptNum = #scripts
		end
		curScript[curScriptNum].alpha = 1
		
		print("curScriptNum: ", curScriptNum)
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
			      	composer.setVariable("scriptNum", curScriptNum)
			      	composer.setVariable("userSettings", userSettings)
		  			composer.showOverlay("menuScene", overlayOption)
				end	
			end
	    end	
  	end
  	menuButton:addEventListener("touch", menuOpen)

	--메뉴의 시작화면으로 버튼 클릭시 현재 장면 닫고 타이틀화면으로 이동 (추가)--
	function scene:closeScene()
		composer.removeScene("story_forest1_2")
		-- composer.gotoScene("scene1")
	end

	-- scriptNum를 params으로 받은 경우: 저장을 load한 경우이므로 특정 대사로 이동
    if event.params then
    	if event.params.scriptNum then
			curScriptNum = event.params.scriptNum
			curScript[1].alpha = 0
			curScript[curScriptNum].alpha = 1
			setCharAndBack()
		end
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
		composer.removeScene("story_ruins_3")
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