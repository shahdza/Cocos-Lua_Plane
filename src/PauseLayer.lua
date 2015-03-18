
PauseLayer = class("PauseLayer", function()
    return cc.LayerColor:create(cc.c4b(162,162,162,128))
end)


function PauseLayer:ctor()

end


function PauseLayer:create()
    local layer = PauseLayer.new()
    layer:init()
    return layer
end


function PauseLayer:init()
    self:addBtn()
    self:addTouch()
end


function PauseLayer:addBtn()
    local function resumeGame()
        self:resumeGame()
    end
    -- 继续按钮
    local play = cc.MenuItemImage:create("play.png", "play.png")
    play:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2 ) )
    play:registerScriptTapHandler(resumeGame)
    local menu = cc.Menu:create(play)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu, 1, 10)
end


function PauseLayer:addTouch()
    local function onTouchBegan()
        return true
    end
    
    -- 注册单点触摸
    local dispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
 
 
-- 继续游戏
function PauseLayer:resumeGame()
    self:getParent():resumeGame()
    self:removeFromParent()
end


