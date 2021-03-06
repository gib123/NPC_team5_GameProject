local composer = require( "composer" )
local scene = composer.newScene()

-- 배경 이미지 흰 바탕으로 대체
local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
background:setFillColor(1)

local menuButton = display.newImage("image/component/menu_button.png")
menuButton.x, menuButton.y = display.contentWidth*0.92, display.contentHeight*0.1

-- 퀘스트 박스 이미지 및 내용 흰 상자에 텍스트로 대체
local quest1 = display.newImageRect("image/quest1.png", 400, 100)
quest1.x, quest1.y = display.contentWidth/2, display.contentHeight/2


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )