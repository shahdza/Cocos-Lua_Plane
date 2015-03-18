
OptionsScene = class("OptionsScene", function()
    return cc.Layer:create()
end)


function OptionsScene:ctor()

end


function OptionsScene:create()
    local layer = OptionsScene.new()
    layer:init()
    return layer
end


function OptionsScene:createScene()
    local scene = cc.Scene:create()
    local layer = OptionsScene:create()
    scene:addChild(layer)
    return scene
end


function OptionsScene:init()
    -- 背景
    local bg = cc.Sprite:create("loading.png")
    bg:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
    self:addChild(bg, 0, 1)
    
    -- 标题
    local title = cc.Sprite:create("menuTitle.png", cc.rect(0, 0, 134, 34))
    title:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height - 60))
    self:addChild(title)

    -- 音乐设置
    local function setMusic()
        self:setOptions()
    end
    -- 标签
    local lb = cc.MenuItemFont:create("Sound")
    lb:setEnabled(false)
    -- 开关按钮
    local on = cc.MenuItemFont:create("ON")
    local off = cc.MenuItemFont:create("OFF")
    local toggle = cc.MenuItemToggle:create(off, on)
    if Global:getInstance():getAudioState() == false then
        toggle:setSelectedIndex(0)
    else 
        toggle:setSelectedIndex(1)
    end
    toggle:registerScriptTapHandler(setMusic)

    -- 返回菜单
    local function turnToLoadingScene()
        local loadingScene = LoadingScene:createScene()
        local tt = cc.TransitionPageTurn:create(0.5, loadingScene, true)
        cc.Director:getInstance():replaceScene(tt)
    end
    
    local backlb = cc.Label:createWithBMFont("Font/bitmapFontTest.fnt", "Go Back")
    local pback = cc.MenuItemLabel:create(backlb)
    pback:setScale(0.6)
    pback:registerScriptTapHandler(turnToLoadingScene)

    -- 创建菜单
    local pmenu = cc.Menu:create(lb, toggle, pback)
    pmenu:setAnchorPoint(cc.p(0, 0))
    pmenu:alignItemsInColumns(2, 1)
    self:addChild(pmenu)

    -- 设置goback的位置
    local pt = cc.p(pback:getPositionX(), pback:getPositionY())
    pt.y = pt.y - 100
    pback:setPosition(pt)
    

    -- 按钮闪动Action
    local fadeIn = cc.FadeTo:create(1.0, 255)
    local delay = cc.DelayTime:create(0.5)
    local fadeOut = cc.FadeTo:create(1.0, 50)
    local seq = cc.Sequence:create(fadeIn, delay, fadeOut)
    local act = cc.RepeatForever:create(seq)
    pback:runAction(act)
end


--设置音乐
function OptionsScene:setOptions()
    if Global:getInstance():getAudioState() == true then
        Global:getInstance():setAudioState(false)
        cc.SimpleAudioEngine:getInstance():pauseAllEffects()
        -- pauseMusic
        cc.SimpleAudioEngine:getInstance():pauseMusic()
    else
        Global:getInstance():setAudioState(true)
        cc.SimpleAudioEngine:getInstance():resumeAllEffects()
        -- resumeMusic
        cc.SimpleAudioEngine:getInstance():resumeMusic()
    end
end



