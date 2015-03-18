require("src/Require")

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- 屏幕适配
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(320, 480, cc.ResolutionPolicy.FIXED_WIDTH) 

    -- 帧率信息
    cc.Director:getInstance():setAnimationInterval(1.0 / 60)
    cc.Director:getInstance():setDisplayStats(false)
    
    -- 获取尺寸大小 
    ORIGIN = cc.Director:getInstance():getVisibleOrigin()
    VISIBLE_SIZE = cc.Director:getInstance():getVisibleSize()
    WIN_SIZE = cc.Director:getInstance():getWinSize()
     
    --create scene 
    local scene = HelloScene:createScene()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
    
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

