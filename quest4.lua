local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
local sceneGroup = self.view

--배경--
local background = display.newImageRect("image/background/퀘스트.png", display.contentWidth, display.contentHeight)
background.x, background.y = display.contentWidth*0.5, display.contentHeight*0.5

--메뉴--
local menuButton = display.newImage("image/component/menu_button.png")
menuButton.x, menuButton.y = display.contentWidth*0.92, display.contentHeight*0.1

-- 퀘스트 제시 박스--
local quest = display.newImageRect("image/component/퀘스트제시(수정).png", 700, 600)
quest.x, quest.y = display.contentCenterX, display.contentCenterY

--퀘스트 내용--
local options = 
{
    text = "선생님이 풍기던 기름 냄새를 뒤쫓자.\n\n정말로 저곳에 선생님이 계실까?\n\n역시 잘 모르겠다만, 선생님은 늘 연장을 들고 계셨으니까.\n\n늘 숲에서 찾기 어려운 물품을 갖고 계시지 않았나.",
    x = display.contentCenterX,
    y = display.contentCenterY+25,
    font = "fonts/GowunBatang-Bold.ttf",
    fontSize = 24,
    align = "center"
}

local myText = display.newText( options )
myText:setFillColor( 1 )

local inventoryBox = display.newImage("image/component/inventory_box.png")
inventoryBox.x, inventoryBox.y = display.contentWidth*0.365, display.contentHeight*0.58
inventoryBox.isVisible = false
sceneGroup:insert(inventoryBox)

local scrollbar = display.newImage("image/component/inventory_scroll.png")
scrollbar.x, scrollbar.y = display.contentWidth*0.6736, display.contentHeight*0.35
scrollbar.isVisible = false
sceneGroup:insert(scrollbar)

local function fitImage( displayObject, fitWidth, fitHeight, enlarge )

local scaleFactor = fitHeight / displayObject.height 
local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	displayObject:scale( scaleFactor, scaleFactor )
end

local closeButton = display.newImage("image/component/menu_close.png")
fitImage( closeButton, 50, 50, true )
closeButton.x, closeButton.y = display.contentWidth*0.6736, display.contentHeight*0.24
closeButton.isVisible = false
sceneGroup:insert(closeButton)

--메뉴열기--
local function menuOpen(event)
  	if(event.phase == "began") then
  		composer.setVariable("sceneName", home)
  		composer.showOverlay("menuScene")
  	end
end
menuButton:addEventListener("touch", menuOpen)

--메뉴 시작화면으로 버튼 클릭시 장면 닫고 타이틀화면으로 이동--
function scene:closeScene()
	composer.removeScene("homeScene") --현재 장면 이름 넣기 ex)storyScene
	composer.gotoScene("scene1")
end
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
	composer.removeScene("home")

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

return scene