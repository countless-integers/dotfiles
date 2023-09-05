Plug 'reedes/vim-thematic'
Plug 'flazz/vim-colorschemes'

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
\ }

if has("gui_running")
  let g:thematic#theme_name = 'material'
else
  let g:thematic#theme_name = 'material'
endif
