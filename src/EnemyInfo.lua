
-- 敌人信息
EnemyInfo = class("EnemyInfo","")
EnemyInfo.showType = "Repeat"   -- 是否重复出现
EnemyInfo.showTime = 0          -- 出现时间间隔
EnemyInfo.types = {}            -- 每次出现3种类型的敌人


-- 敌人类型信息
EnemyType = class("EnemyType","")
EnemyType.type = 0           -- 敌机类型
EnemyType.power = 0          -- 战力大小
EnemyType.textureName = ""   -- 图片名称
EnemyType.bulletType = ""    -- 子弹类型
EnemyType.HP = 0             -- 血量
EnemyType.moveType = 0       -- 移动方式
EnemyType.scoreValue = 0     -- 获得分数

