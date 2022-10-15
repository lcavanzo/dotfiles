local db = require "dashboard"
db.session_directory = "/Users/lcavanzo/.config/nvim/data/sessions"
db.preview_file_height = 10
db.preview_file_width = 70

db.custom_header = {
        [[                               ]],
        [[                               ]],
        [[                               ]],
        [[                               ]],
        [[                               ]],
        [[   ▄████▄              ▒▒▒▒▒   ]],
        [[  ███▄█▀              ▒ ▄▒ ▄▒  ]],
        [[ ▐████     █  █  █   ▒▒▒▒▒▒▒▒▒ ]],
        [[  █████▄             ▒▒▒▒▒▒▒▒▒ ]],
        [[   ▀████▀            ▒ ▒ ▒ ▒ ▒ ]],
        [[                               ]],
        [[                               ]],
        [[                               ]],
        [[                               ]],
}

db.custom_center = {
        {icon = '  ',
                desc = 'New File',
                action =  'DashboardNewFile',
        },
        {icon = '  ',
                desc = 'KeyMaps',
                --action =  'Telescope opened ~/.config/nvim/notes.txt',
                action = 'edit ~/.config/nvim/notes.txt',
        },
        {icon = '  ',
                desc = 'Recently opened files',
                action =  'Telescope oldfiles',
        },
        {icon = '  ',
                desc = 'Find  File',
                action = 'Telescope find_files find_command=rg,--hidden,--files',
        },
        {icon = '  ',
                desc ='File Browser',
                action =  'Telescope file_browser',
        },
        {icon = '  ',
                desc = 'Find  word',
                action = 'Telescope live_grep',
        },
        {icon = ' ',
                desc = 'Recently latest session',
                action =  'SessionLoad',
        },
}


db.custom_footer = {
        'Fortis Fortuna Adiuvat'
}

db.header_pad = 3
db.center_pad = 3
db.footer_pad = 3
