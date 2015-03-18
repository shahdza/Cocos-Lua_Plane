
AboutScene = class("AboutScene", function()
    return cc.Layer:create()
end)


function AboutScene:ctor()

end


function AboutScene:create()
    local layer = AboutScene.new()
    layer:init()
    return layer
end


function AboutScene:createScene()
    local scene = cc.Scene:create()
    local layer = AboutScene:create()
    scene:addChild(layer)
    return scene
end


function AboutScene:init()

    -- 背景
    local bg = cc.Sprite:create("loading.png")
    bg:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
    self:addChild(bg, 0, 1)

    -- 标题
    local title = cc.Sprite:create("menuTitle.png", cc.rect(0, 36, 100, 34))
    title:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height-60))
    self:addChild(title)

    -- 内容
    local about = cc.Label:createWithSystemFont(
        "游戏名：     Plane\n\n\n开发者：    钱瑞彬\n\n\n\n浙江大学软件学院", 
        "Arial", 18, cc.size(WIN_SIZE.width, 320), 
        cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    about:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
    self:addChild(about)


    -- 返回菜单
    local function turnToLoadingScene()
        self:turnToLoadingScene()
    end

    local backlb = cc.Label:createWithBMFont("Font/bitmapFontTest.fnt", "Go Back")
    local pback = cc.MenuItemLabel:create(backlb)
    pback:setScale(0.6)
    pback:registerScriptTapHandler(turnToLoadingScene)

    local pmenu = cc.Menu:create(pback)
    pmenu:setPosition(WIN_SIZE.width/2, 50)
    self:addChild(pmenu)

    -- 按钮闪动Action
    local fadeIn = cc.FadeTo:create(1.0, 255)
    local delay = cc.DelayTime:create(0.5)
    local fadeOut = cc.FadeTo:create(1.0, 50)
    local seq = cc.Sequence:create(fadeIn, delay, fadeOut)
    local act = cc.RepeatForever:create(seq)
    pback:runAction(act)
end


-- 返回菜单
function AboutScene:turnToLoadingScene()
    local loadingScene = LoadingScene:createScene()
    local tt = cc.TransitionPageTurn:create(0.5, loadingScene, true)
    cc.Director:getInstance():replaceScene(tt)
end

