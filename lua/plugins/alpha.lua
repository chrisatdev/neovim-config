return {
	[[goolord/alpha-nvim]],
	dependencies = {
		[[nvim-tree/nvim-web-devicons]],
	},

	config = function()
		local alpha = require([[alpha]])
		local dashboard = require([[alpha.themes.dashboard]])

		dashboard.section.header.val = {
			[[                                       ]],
			[[                                       ]],
			[[⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣶⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀ ]],
			[[⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⡟⠁⠀⠀⠀⠈⢻⣿⣿⣿⠀⠀⠀⠀⠀⠀ ]],
			[[⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠛⠛⠛⠛⠛⠛⢛⣿⣮⣿⣿⣿⠀⠀⠀⠀⠀⠀⢈⣿⣿⡟⠀⠀⠀⠀⠀⠀ ]],
			[[⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⠟⠉⠻⣿⣿⣿⣿⣶⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣠⣷⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠛⠋⠛⠙⠛⠙⠛⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			[[                                       ]],
			[[                                       ]],

			-- [[                                                                         ]],
			-- [[                               :                                         ]],
			-- [[ L.                     ,;    t#,                                        ]],
			-- [[ EW:        ,ft       f#i    ;##W.              t                        ]],
			-- [[ E##;       t#E     .E#t    :#L:WE              Ej            ..       : ]],
			-- [[ E###t      t#E    i#W,    .KG  ,#D  t      .DD.E#,          ,W,     .Et ]],
			-- [[ E#fE#f     t#E   L#D.     EE    ;#f EK:   ,WK. E#t         t##,    ,W#t ]],
			-- [[ E#t D#G    t#E :K#Wfff;  f#.     t#iE#t  i#D   E#t        L###,   j###t ]],
			-- [[ E#t  f#E.  t#E i##WLLLLt :#G     GK E#t j#f    E#t      .E#j##,  G#fE#t ]],
			-- [[ E#t   t#K: t#E  .E#L      ;#L   LW. E#tL#i     E#t     ;WW; ##,:K#i E#t ]],
			-- [[ E#t    ;#W,t#E    f#E:     t#f f#:  E#WW,      E#t    j#E.  ##f#W,  E#t ]],
			-- [[ E#t     :K#D#E     ,WW;     f#D#;   E#K:       E#t  .D#L    ###K:   E#t ]],
			-- [[ E#t      .E##E      .D#;     G#t    ED.        E#t :K#t     ##D.    E#t ]],
			-- [[ ..         G#E        tt      t     t          E#t ...      #G      ..  ]],
			-- [[             fE                                 ,;.          j           ]],
			-- [[              ,                                                          ]],
			-- [[                                                                         ]],

			-- [[                                                                       ]],
			-- [[                                                                       ]],
			-- [[                                                                       ]],
			-- [[  ██████   █████                   █████   █████  ███                  ]],
			-- [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
			-- [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
			-- [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
			-- [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
			-- [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
			-- [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
			-- [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
			-- [[                                                                       ]],
			-- [[                                                                       ]],
			-- [[                                                                       ]],
		}

		dashboard.section.header.opts.hl = [[Type]]
		dashboard.section.header.opts.position = [[center]]

		dashboard.section.buttons.val = {
			dashboard.button("e", "  Nuevo archivo", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Buscar archivo", ":Telescope find_files<CR>"),
			dashboard.button("r", "  Archivos recientes", ":Telescope oldfiles<CR>"),
			dashboard.button("c", "  Configuración", ":e ~/.config/nvim/init.lua<CR>"),
			dashboard.button("q", "  Salir", ":qa<CR>"),
		}

		dashboard.section.buttons.opts.hl = [[Keyword]]
		dashboard.section.buttons.opts.position = [[center]]

		alpha.setup(dashboard.opts)
	end,
}
