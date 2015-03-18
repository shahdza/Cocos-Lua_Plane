
GameScene = class("GameScene", function()
    return cc.Scene:createWithPhysics()
end)


function GameScene:createScene()
    local scene = GameScene.new()
    local gameLayer = GameLayer:create()
    scene:getPhysicsWorld():setGravity(cc.p(0, 0))
    -- scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    scene:addChild(gameLayer)
    return scene
end

