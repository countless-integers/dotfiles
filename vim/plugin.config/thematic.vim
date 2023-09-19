Plug 'flazz/vim-colorschemes'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'

Plug 'reedes/vim-thematic'

let g:thematic#themes = {
\ 'jellybeans': {'laststatus': 2,
\                'ruler': 1,
\                'background': 'dark',
\                'airline-theme': 'badwolf',
\               },
\ 'codeschool': {'colorscheme': 'codeschool',
\                'laststatus': 2,
\                'ruler': 1,
\                'airline-theme': 'luna',
\                'background': 'dark',
\               },
\ 'pencil_dark': {'colorscheme': 'pencil',
\                 'background': 'dark',
\                 'airline-theme': 'badwolf',
\                 'ruler': 1,
\                },
\ 'badwolf': {'colorscheme': 'badwolf',
\             'background': 'dark',
\             'airline-theme': 'badwolf',
\             'ruler': 1,
\            },
\ 'material': {'colorscheme': 'hybrid',
\             'background': 'dark',
\             'airline-theme': 'hybrid',
\             'ruler': 1,
\            },
\ 'papercolor': {'colorscheme': 'PaperColor',
\             'background': 'dark',
\             'airline-theme': 'badwolf',
\             'ruler': 1,
\            },
\ 'monokai-chris': {'colorscheme': 'monokai-chris',
\             'background': 'dark',
\             'airline-theme': 'molokai',
\             'ruler': 1,
\            },
\ 'catppuccin-macchiato': {'colorscheme': 'catppuccin_macchiato',
\             'background': 'dark',
\             'airline-theme': 'catppuccin_macchiato',
\             'ruler': 1,
\            },
\ 'catppuccin-mocha': {'colorscheme': 'catpuccin_mocha',
\             'background': 'dark',
\             'airline-theme': 'catppuccin_mocha',
\             'ruler': 1,
\            },
\ 'catppuccin-latte': {'colorscheme': 'catpuccin_latte',
\             'background': 'light',
\             'airline-theme': 'catppuccin_latte',
\             'ruler': 1,
\            },
\ 'catppuccin-frappe': {'colorscheme': 'catpuccin_frappe',
\             'background': 'dark',
\             'airline-theme': 'catppuccin_frappe',
\             'ruler': 1,
\            },
\ }

if has("gui_running")
  let g:thematic#theme_name = 'catppuccin-macchiato'
else
  let g:thematic#theme_name = 'catppuccin-macchiato'
endif
