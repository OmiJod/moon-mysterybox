fx_version 'cerulean'
game 'gta5'

description 'QBOX - Mystery Box Script'
author 'your_name_here'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'utils.lua'
}

dependencies {
    'ox_lib',
}

lua54 'yes'