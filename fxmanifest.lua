fx_version 'adamant'
game 'gta5'

name 'fc_schwarzmarkt'
author 'fledi'
description "Schwarzmarkt für FiveCity"
version '1.1.0'

ui_page 'html/index.html'

client_scripts {
    "config.lua",
    'client/client.lua'
} 

server_scripts {
    "config.lua",
    "server/server.lua",
}

files {
    'html/index.html',
    'html/style.css',
    "html/jquery.min.js",
    'html/ui.js',
    "html/img/weapon_carbinerifle.png",
    "html/img/weapon_mg.png",
    "html/img/weapon_grenadelauncher.png",
    "html/img/weapon_smg.png",
    "html/img/weapon_knuckle.png",
    "html/img/weapon_microsmg.png",
    "html/img/weapon_machete.png"
}