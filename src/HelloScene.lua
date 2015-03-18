
HelloScene = class("HelloScene", function ()
	return cc.Layer:create()
end)


function HelloScene:create()
    local layer = HelloScene.new()
    layer:init()
    return layer
end


function HelloScene:createScene()
	local scene = cc.Scene:create()
	local layer = HelloScene:create()
	scene:addChild(layer)
	return scene
end


function HelloScene:init()
    local function turnToLoadingScene(node, tab)
        local loadingScene = LoadingScene:createScene()
        local tt = cc.TransitionFade:create(0.1, loadingScene)
        cc.Director:getInstance():replaceScene(loadingScene)
    end

    local sp = cc.Sprite:create("HelloWorld.png")
    sp:setPosition(WIN_SIZE.width/2, WIN_SIZE.height/2)
    self:addChild(sp)
    
    local acin = cc.FadeIn:create(0.5)
    local acout = cc.FadeOut:create(0.5)
    local turn = cc.CallFunc:create(turnToLoadingScene, {x = 1, y = 1})
    local act = cc.Sequence:create(acin,acout,turn)
    sp:runAction(act)
end

