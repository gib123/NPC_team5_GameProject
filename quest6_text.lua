local composer = require( "composer" )
local scene = composer.newScene()

-- 배경 이미지 흰 바탕으로 대체
local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
background:setFillColor(1)

local menuButton = display.newImage("image/component/menu_button.png")
menuButton.x, menuButton.y = display.contentWidth*0.92, display.contentHeight*0.1

-- 퀘스트 박스 이미지 area.png로 대체
local quest1 = display.newImageRect("image/component/area.png", 850, 300)
quest1.x, quest1.y = display.contentCenterX, display.contentCenterY

local options = 
{
    text = "선생님의 방에서 약도를 찾았다.\n\n선생님 동료들의 무덤가가 있는 장소인 듯하다.\n\n일단 가보는 것이 좋겠지...\n\n선생님의 말씀을 되새겨보며 가보도록 하자.",
    x = display.contentCenterX,
    y = display.contentCenterY,
    font = "fonts/GowunBatang-Bold.ttf",
    fontSize = 20,
    align = "center"
}

local myText = display.newText( options )
myText:setFillColor( 1 )

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene