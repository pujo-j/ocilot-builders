local log = require("log")
local source = "docker.pkg.github.com/pujo-j/ocilot-builders/python-base:latest"

log.info("Args", { args = args })
local cachePrefix= args[1]
local dest = args[2]
local module = args[3]

local source_img = pull(source)
log.info("Loaded image", { image = source_img:__tostring() })

log.info("Cloning image")
local new = source_img:clone(dest)

log.info("Loading requirements.txt")
local reqs = read("/deploy/requirements.txt")
local reqs_key = hash(reqs)

log.info("Requirements hash:" .. reqs_key)
local sh = shell("/bin/sh", "-c")

applyCached(new, cachePrefix, reqs_key, function()
    log.info("Collecting requirements")
    local beforePip = snapshot("/venv")
    sh.exec("pip install -r /deploy/requirements.txt")
    local afterPip = snapshot("/venv")
    local diff = beforePip:diff(afterPip)
    local pip_layer = diff:asLayer("/tmp/pip.tar")
    return { pip_layer }
end)

log.info("Collecting app packages")
sh.exec("mkdir -p /app_module/")
sh.exec("cp -r /deploy/* /app_module/")
local app_layer = snapshot("/app_module/"):asLayer("/tmp/app.tar")
new:append(app_layer)
local config = new:config()
config["Cmd"] = { "/venv/bin/python", "-m", module }
log.info("Updating image config", { config = config })
new:setConfig(config)

log.info("Pushing image", { destination = destination })
new:push()

