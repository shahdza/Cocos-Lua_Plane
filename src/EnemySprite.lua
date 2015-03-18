
EnemySprite = class("EnemySprite", function()
    return cc.Sprite:create()
end)
EnemySprite.HP = nil           -- 血量
EnemySprite.power = nil        -- 战力大小
EnemySprite.moveType = nil     -- 移动方式
EnemySprite.scoreValue = nil   -- 获得分数
EnemySprite.bulletType = nil   -- 子弹类型
EnemySprite.textureName = nil  -- 敌人图片资源
EnemySprite.active = nil
EnemySprite.speed = nil
EnemySprite.bulletSpeed = nil
EnemySprite.bulletPowerValue = nil
EnemySprite.delayTime = nil    -- 射击延迟
EnemySprite.size = nil


function EnemySprite:create(enemytype)
    local enemySprite = EnemySprite.new()
    enemySprite:init(enemytype)
    return enemySprite
end


function EnemySprite:init(enemytype)
    self.HP = enemytype.HP                      -- 血量
    self.power = enemytype.power                -- 战力大小
    self.moveType = enemytype.moveType          -- 移动方式
    self.scoreValue = enemytype.scoreValue      -- 获得分数
    self.bulletType = enemytype.bulletType      -- 子弹类型
    self.textureName = enemytype.textureName    -- 敌人图片资源

    self.active = true
    self.speed = 220
    self.bulletSpeed = -200
    self.bulletPowerValue = 1
    self.delayTime = 1 + 1.2 * math.random()    -- 射击延迟

    -- 加载敌机图片
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.textureName)
    self:setSpriteFrame(frame)
    
    self.size = self:getContentSize()
    
    -- 射击子弹
    local function shoot()
         self:shoot()
    end
    schedule(self, shoot, self.delayTime)
    
    self:setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize()))
    self:getPhysicsBody():setCategoryBitmask(ENEMY_CATEGORY_MASK)
    self:getPhysicsBody():setCollisionBitmask(ENEMY_COLLISION_MASK)
    self:getPhysicsBody():setContactTestBitmask(ENEMY_CONTACTTEST_MASK)
end


-- 射击子弹
function EnemySprite:shoot()   
    if enemy_bullet == nil then
        return
    end
    
    local pos = cc.p(self:getPosition())
    local bullet = Bullet:create(self.bulletSpeed,self.bulletType,1, ENEMY_BULLET_TYPE)
    
    table.insert(enemy_bullet,bullet)
    self:getParent():addChild(bullet, 5, 902)
    bullet:setPosition(cc.p(pos.x, pos.y - self.size.height * 0.2))
end


-- 销毁
function EnemySprite:destroy()
    -- 播放音效
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect("Music/explodeEffect.mp3")
    end

    -- 爆炸+闪烁特效
    Effect:getInstance():explode(self:getParent(), cc.p(self:getPosition()), self.power)
    Effect:getInstance():spark(self:getParent(), cc.p(self:getPosition()), self.power*3.0, 0.7)

    -- 得分
    Global:getInstance():setScore(self.scoreValue)

    -- 移除
    for _, v in pairs(enemy_items) do
        if v == self then
            table.remove(enemy_items, _)
        end
    end
    self:removeFromParent()
end


-- 受伤
function EnemySprite:hurt(damageValue)
    self.HP = self.HP - damageValue
    if self.HP <= 0 then
        self.active = false
    end
end


-- 是否活跃
function EnemySprite:isActive()
    return self.active
end

