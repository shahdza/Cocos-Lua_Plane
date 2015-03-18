
PlaneSprite = class("PlaneSprite", function()
    return cc.Sprite:create()
end)
PlaneSprite.active = nil
PlaneSprite.canBeAttack = nil
PlaneSprite.HP = nil
PlaneSprite.power = nil
PlaneSprite.speed = nil
PlaneSprite.bulleSpeed = nil
PlaneSprite.bulletPowerValue = nil
PlaneSprite.delayTime = nil
PlaneSprite.size = nil


function PlaneSprite:ctor()
    self.active = true
    self.canBeAttack = false
    self.HP = 10
    self.power = 1.0
    self.speed = 220
    self.bulleSpeed = 900
    self.bulletPowerValue = 1
    self.delayTime = 0.1
end


function PlaneSprite:create()
    local plane = PlaneSprite.new()
    plane:init()
    return plane
end


function PlaneSprite:init()
	-- 飞机图片
	-- 继承自Sprite后，设置自身的图片纹理
    local texture = cc.Director:getInstance():getTextureCache():addImage("ship01.png")
    local sp0 = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 60, 38))
    self:setSpriteFrame(sp0)
    self:setPosition(cc.p(WIN_SIZE.width/2, 60))
    self.size = self:getContentSize()

    -- 飞机射击子弹动作
    local animation = cc.Animation:create()
    local sp1 = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 60, 38))
    local sp2 = cc.SpriteFrame:createWithTexture(texture, cc.rect(60, 0, 60, 38))
    animation:setDelayPerUnit(0.1)
    animation:setRestoreOriginalFrame(true)
    animation:addSpriteFrame(sp1)
    animation:addSpriteFrame(sp2)
    self:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    
    -- 初始闪烁不死光环
    self.canBeAttack = false
    local ghostShip = cc.Sprite:create("ship01.png", cc.rect(0, 45, 60, 38))
    ghostShip:setPosition(cc.p(self.size.width/2, 12))
    self:addChild(ghostShip, 10, 999)
    
    ghostShip:setScale(8)
    ghostShip:runAction(cc.ScaleTo:create(0.5, 1))
    
    -- 混合模式
    ghostShip:setBlendFunc(GL_SRC_ALPHA, GL_ONE)
   
    local function canAttack(node, tab)
        self.canBeAttack = true
        self:removeChildByTag(999)   
    end

    local blink = cc.Blink:create(2, 6)
    local func = cc.CallFunc:create(canAttack)
    self:runAction(cc.Sequence:create(blink, func))
    
    --射击子弹
    local function shoot()
        self:shoot()
    end
    schedule(self, shoot, self.delayTime)
    
    self:setPhysicsBody(cc.PhysicsBody:createCircle(self:getContentSize().width/2))
    self:getPhysicsBody():setCategoryBitmask(PLANE_CATEGORY_MASK)
    self:getPhysicsBody():setCollisionBitmask(PLANE_COLLISION_MASK)
    self:getPhysicsBody():setContactTestBitmask(PLANE_CONTACTTEST_MASK)
end


-- 射出子弹
function PlaneSprite:shoot()
    local pos = cc.p(self:getPosition())
    local size = self.size
    
    -- 左子弹
    local bullet_a = Bullet:create(self.bulleSpeed, "W1.png", 1, PLANE_BULLET_TYPE)
    if nil ~= bullet_a then
        table.insert(play_bullet,bullet_a)
        self:getParent():addChild(bullet_a, 2, 901)
        bullet_a:setPosition(cc.p(pos.x - 13, pos.y + 5 + size.height * 0.3))
    end
    -- 右子弹
    local bullet_b = Bullet:create(self.bulleSpeed, "W1.png", 1, PLANE_BULLET_TYPE)
    if nil ~= bullet_b then
        table.insert(play_bullet,bullet_b)
        self:getParent():addChild(bullet_b, 2, 901)
        bullet_b:setPosition(cc.p(pos.x + 13, pos.y + 5 + size.height * 0.3));
    end
end


function PlaneSprite:destroy()
    -- 播放音效
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect("Music/shipDestroyEffect.mp3")
    end

    -- 爆炸特效
    Effect:getInstance():explode(self:getParent(), cc.p(self:getPosition()), self.power)

    -- 更新生命值
    Global:getInstance():setLifeCount()

    -- 移除
    self:removeFromParent()
end
 

-- 扣血
function PlaneSprite:hurt(damageValue)
    if self.canBeAttack == true then
        self.HP = self.HP - damageValue
        if self.HP <= 0 then
            self.active = false
        end
    end   
end


-- 是否可以攻击
function PlaneSprite:isCanAttack()
    return self.canBeAttack
end


-- 是否活着
function PlaneSprite:isActive()
    return self.active
end


