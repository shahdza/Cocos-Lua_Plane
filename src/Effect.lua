
Effect = class("Effect", function()
    return cc.Node:create()
end)


local _effect = Effect
_effect = nil
function Effect:getInstance()
    if nil == _effect then
        _effect = clone(Effect) -- 用clone() ，好像用.new()有问题
        _effect:init()
    end
    return _effect
end


-- 加载特效
function Effect:init()
    local arr = {}
    for i=1, 34 do
        local str = string.format("explosion_%02d.png" , i)
        -- getSpriteFrameByName -> getSpriteFrame
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
        table.insert(arr, frame)
    end

    local animation = cc.Animation:createWithSpriteFrames(arr, 0.02)
    cc.AnimationCache:getInstance():addAnimation(animation, "Explosion")
end


-- 进入游戏动画
-- 执行完后跳转到callback
function Effect:flareEffect(parent, callback)
    -- 播放音效    
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect("Music/buttonEffet.mp3")
    end
    
    -- 特效图片
    local flare = cc.Sprite:create("flare.jpg")

    -- 设置混合模式
    -- local cbl = {GL_SRC_ALPHA, GL_ONE}
    flare:setBlendFunc(GL_SRC_ALPHA, GL_ONE)

    -- 添加到父节点
    parent:addChild(flare,10)


    -- 设置初始位置
    flare:setPosition(cc.p(-30, WIN_SIZE.height - 130))
    local move = cc.MoveBy:create(1.5, cc.p(WIN_SIZE.width,0))
    local ac_move = cc.EaseSineOut:create(move)

    -- 设置初始透明度
    flare:setOpacity(0.0)
    local opacity1 = cc.FadeTo:create(0.5, 255.0)
    local opacity2 = cc.FadeTo:create(1.0, 240.0)
    local ac_opacity = cc.Sequence:create(opacity1, opacity2)

    -- 设置大小
    flare:setScale(0.1)
    local scale1 = cc.ScaleTo:create(0.5, 1.2)
    local scale2 = cc.ScaleTo:create(1.0, 1.0)
    local ac_scale = cc.Sequence:create(scale1, scale2)

    -- 设置初始角度
    local function killEffect(sender)
        self:killEffect(sender)
    end
    flare:setRotation(-120)
    local rotate = cc.RotateBy:create(2.0, 80)
    local ease_rotate = cc.EaseSineOut:create(rotate)
    local kill = cc.CallFunc:create(killEffect)
    local ac_rotate = cc.Sequence:create(ease_rotate, kill, callback)
    
    -- 执行动作
    flare:runAction(ac_move)
    flare:runAction(ac_opacity)
    flare:runAction(ac_scale)
    flare:runAction(ac_rotate)
end


-- 飞机爆炸动画
function Effect:explode(parent, pos, power) 
    local explosion = cc.Sprite:createWithSpriteFrameName("explosion_01.png")
    explosion:setPosition(pos)
    parent:addChild(explosion, 21)
    explosion:setScale(power)

    -- 爆炸动画
    local function killEffect(sender)
        self:killEffect(sender)
    end
    local animation = cc.AnimationCache:getInstance():getAnimation("Explosion")
    local func = cc.CallFunc:create(killEffect)

    explosion:runAction(cc.Sequence:create(cc.Animate:create(animation), func))
end


-- 敌机爆炸闪光动画
function Effect:spark(parent, pos, power, duration)
    local sp1 = cc.Sprite:create("explode1.jpg")
    local sp2 = cc.Sprite:create("explode2.jpg")
    local sp3 = cc.Sprite:create("explode3.jpg")
    sp1:setPosition(pos)
    sp2:setPosition(pos)
    sp3:setPosition(pos)
    parent:addChild(sp1, 31)
    parent:addChild(sp2, 32)
    parent:addChild(sp3, 33)

    -- 混合模式
    sp1:setBlendFunc(GL_SRC_ALPHA, GL_ONE)
    sp2:setBlendFunc(GL_SRC_ALPHA, GL_ONE)
    sp3:setBlendFunc(GL_SRC_ALPHA, GL_ONE)

    -- 闪光动画: 放大+消失
    sp1:setScale(0.5)
    sp2:setScale(0.5)
    sp3:setScale(0.5)
    sp3:setRotation(360 * math.random())
    
    local function killEffect(sender)
        self:killEffect(sender)
    end
    local scale = cc.ScaleTo:create(duration, power)
    local fadeout = cc.FadeOut:create(duration)
    local func = cc.CallFunc:create(killEffect)
    local act1 = cc.Sequence:create(scale, func)
    local act2 = cc.Sequence:create(clone(scale), clone(func))
    local act3 = cc.Sequence:create(clone(scale), clone(func))
    sp1:runAction(fadeout)
    sp2:runAction(clone(fadeout))
    sp3:runAction(clone(fadeout))
    sp1:runAction(act1)
    sp2:runAction(act2)
    sp3:runAction(act3)
end


-- 子弹击中飞机
function Effect:hit(parent, pos)
    local sp = cc.Sprite:create("hit.jpg")
    sp:setPosition(pos)
    parent:addChild(sp, 41)

    -- 混合模式
    sp:setBlendFunc(GL_SRC_ALPHA, GL_ONE)

    -- 击中动画: 放大+消失
    sp:setRotation(360 * math.random())
    sp:setScale(0.3)

    local function killEffect(sender)
        self:killEffect(sender)
    end
    local scale = cc.ScaleTo:create(0.3, 0.5)
    local fadeout = cc.FadeOut:create(0.3)
    local func = cc.CallFunc:create(killEffect)
    local spawn = cc.Spawn:create(fadeout, scale)
    local act = cc.Sequence:create(spawn, func)
    sp:runAction(act)
end


-- 移除动画
function Effect:killEffect(sender)
    sender:removeFromParent()
end

