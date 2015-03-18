-- FileUtils
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
cc.FileUtils:getInstance():addSearchPath("res/Font")
cc.FileUtils:getInstance():addSearchPath("res/Music")


-- addSpriteFramesWithFile -> addSpriteFrames
cc.SpriteFrameCache:getInstance():addSpriteFrames("bullet.plist")
cc.SpriteFrameCache:getInstance():addSpriteFrames("Enemy.plist")
cc.SpriteFrameCache:getInstance():addSpriteFrames("explosion.plist")


-- Require
require("Cocos2d")

require("src/AboutScene")
require("src/Bullet")
require("src/Effect")
require("src/EnemyInfo")
require("src/EnemyManager")
require("src/EnemySprite")
require("src/GameLayer")
require("src/GameOverScene")
require("src/GameScene")
require("src/Global")
require("src/HelloScene")
require("src/Helper")
require("src/LoadingScene")
require("src/OptionsScene")
require("src/PauseLayer")
require("src/PlaneSprite")
require("src/PhysicsTest")

