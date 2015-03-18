
Bullet = class("Bullet", function()
    return cc.Sprite:create()
end)
Bullet.active = nil
Bullet.HP = nil
Bullet.power = nil
Bullet.vx = nil
Bullet.vy = nil
Bullet.attackmode = nil


function Bullet:ctor()

end


function Bullet:create(speed, weapon, attackMode, type)
    local bullet = Bullet.new()
    bullet:init(speed, weapon, attackMode, type)
    return bullet
end


function Bullet:init(speed, weapon, attackMode, type)
    
    self.active = true
    self.HP = 1
    self.power = 0.5    -- 战力大小

    self.vx = 0
    self.vy = -speed

    self.attackmode = attackMode
    
    -- 设置子弹图片
    -- 通过精灵帧设置
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(weapon)
    self:setSpriteFrame(frame)

    -- 混合模式
    self:setBlendFunc(GL_SRC_ALPHA, GL_ONE)
    
    -- 射击子弹
    local function shoot(dt)
        self:shoot(dt) 
    end
    self:scheduleUpdateWithPriorityLua(shoot,0)
    
    self:setPhysicsBody(cc.PhysicsBody:createCircle(3, cc.PhysicsMaterial(0.1, 1, 0), cc.p(0, 16)))
    if type == PLANE_BULLET_TYPE then   -- 玩家子弹
        self:getPhysicsBody():setCategoryBitmask(PLANE_BULLET_CATEGORY_MASK)
        self:getPhysicsBody():setCollisionBitmask(PLANE_COLLISION_MASK)
        self:getPhysicsBody():setContactTestBitmask(PLANE_CONTACTTEST_MASK)
    else    -- 敌人子弹
        self:getPhysicsBody():setCategoryBitmask(ENEMY_BULLET_CATEGORY_MASK)
        self:getPhysicsBody():setCollisionBitmask(ENEMY_BULLET_COLLISION_MASK)
        self:getPhysicsBody():setContactTestBitmask(ENEMY_BULLET_CONTACTTEST_MASK)        
    end
end


-- 射击子弹
function Bullet:shoot(dt)
    if self.HP <= 0 then
        self.active = false
    end

    local pos = cc.p(self:getPosition())
    pos.x = pos.x - self.vx * dt
    pos.y = pos.y - self.vy * dt
    self:setPosition(pos)
    
    if pos.y < -10 or pos.y > WIN_SIZE.height + 10 then
        self:unscheduleUpdate()
        self:destroy()
    end
end


--销毁
function Bullet:destroy()
    if play_bullet == nil and enemy_bullet == nil then
    	return
    end
    
    -- 击中飞机特效
    Effect:getInstance():hit( self:getParent() , cc.p(self:getPosition()) )

    -- 移除
    for _,v in pairs(play_bullet) do
        if v == self then
            table.remove(play_bullet, _)
        end
    end
    for _,v in pairs(enemy_bullet) do
        if v == self then
            table.remove(enemy_bullet, _)
        end
    end
    self:removeFromParent()
end


-- 受伤
function Bullet:hurt(damageValue)
    self.HP = self.HP - damageValue
    if self.HP <= 0 then
        self.active = false
    end
end


-- 是否活跃
function Bullet:isActive()
    return self.active
end

