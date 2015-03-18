
PhysicsTest = class("PhysicsTest", function ()
    return cc.Layer:create()
end)


function PhysicsTest:create()
    local layer = PhysicsTest.new()
    layer:init()
    return layer
end


function PhysicsTest:createScene()
    local scene = cc.Scene:createWithPhysics()    
    scene:getPhysicsWorld():setGravity(cc.p(0,-100))
    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    local layer = PhysicsTest:create()
    scene:addChild(layer)
    return scene
end


function PhysicsTest:init()
    self:addTouch()
    self:addEdge()
    self:addContact()
end

function PhysicsTest:addEdge()
    local node = cc.Node:create()
    node:setPosition(WIN_SIZE.width/2, WIN_SIZE.height/2)
    node:setPhysicsBody(cc.PhysicsBody:createEdgeBox(WIN_SIZE,cc.PhysicsMaterial(0.1,1,0),5))
    node:getPhysicsBody():setCategoryBitmask(4)
    node:getPhysicsBody():setCollisionBitmask(3)
    node:getPhysicsBody():setContactTestBitmask(6)
    self:addChild(node)
end


function PhysicsTest:addTouch()
    local t = cc.Touch
    local function onTouchBegan(touch, event)
        print("touchBegan")
        t = touch
        local b1 = cc.Sprite:create("hint.png")
        b1:setPosition(t:getLocation())
        b1:setPhysicsBody(cc.PhysicsBody:createCircle(18))
        b1:getPhysicsBody():setCategoryBitmask(2)
        b1:getPhysicsBody():setCollisionBitmask(5)
        b1:getPhysicsBody():setContactTestBitmask(12)
        self:addChild(b1)
    end
    
    -- 注册单点触摸
    local dispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


function PhysicsTest:addContact()
    local function onContactBegin(contact)
        print("contactBegan")
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()
        print(a:getTag() .. " + " .. b:getTag())
        return true
    end

    local dispatcher = self:getEventDispatcher()
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    dispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
end
