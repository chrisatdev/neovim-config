# Neovim Configuration

Configuración de Neovim moderna con LazyVim-inspired structure.

## Estructura

```
nvim/
├── init.lua                 # Entry point, bootstrap lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua     # Opciones de Neovim
│   │   ├── keymaps.lua     # Keymaps globales
│   │   └── autocmds.lua    # Autocommands
│   └── plugins/
│       ├── colorscheme.lua  # Kanagawa Dragon theme
│       ├── lsp.lua          # LSP + Mason + Conform
│       ├── treesitter.lua   # Treesitter
│       ├── editor.lua       # oil, telescope, toggle-vterm, opencode
│       ├── git.lua          # Git integration
│       ├── code.lua         # Snippets, autopairs, etc.
│       ├── ui.lua           # UI plugins
│       ├── mini.lua         # mini.bufremove, mini.surround, etc.
│       └── markdown.lua     # Markdown preview
```

## Requisitos

- **Neovim 0.10+** (0.11+ recomendado)
- **Git**
- **Ripgrep** (`rg`) — para Telescope
- **Lsof** — para opencode.nvim

## Instalación

```bash
# Clonar este repo en ~/.config/nvim
git clone https://github.com/tu-usuario/nvim-config ~/.config/nvim

# Instalar dependencias del sistema
# Arch Linux
sudo pacman -S ripgrep lsof

# Ubuntu/Debian
sudo apt install ripper lsof

# macOS (ya viene incluido)
brew install ripgrep
```

Luego abrir Neovim y ejecutar `:LazySync` para instalar plugins.

## Atajos de Teclado

### General

| Atajo | Descripción |
|-------|-------------|
| `<Space>` | Leader key |
| `jk` | Salir de insert mode |
| `<leader>w` | Guardar archivo |
| `<leader>q` | Salir de Neovim |
| `<leader>c` | Cerrar buffer |
| `<leader>n` | Nuevo archivo |
| `<Esc>` | Limpiar highlight de búsqueda |

### Navegación

| Atajo | Descripción |
|-------|-------------|
| `<C-h/j/k/l>` | Moverse entre splits |
| `<S-h/S-l>` | Buffer anterior/siguiente |
| `<C-d/C-u>` | Scroll centrado |
| `n/N` | siguiente/anterior match centrado |
| `]]/[[` | Ir a siguiente/anterior referencia (illuminate) |

### Archivos

| Atajo | Descripción |
|-------|-------------|
| `<leader>e` | Explorador de archivos (Oil) |
| `-` | Abrir directorio padre |

### Terminal

| Atajo | Descripción |
|-------|-------------|
| `<leader>th` | Terminal horizontal |
| `<leader>tv` | Terminal vertical |
| `<C-q>` | Modo normal (en terminal) |

### Telescope

| Atajo | Descripción |
|-------|-------------|
| `<leader>ff` | Buscar archivos |
| `<leader>fg` | Grep live |
| `<leader>fb` | Buffers |
| `<leader>fr` | Archivos recientes |
| `<leader>fh` | Help tags |
| `<leader>fw` | Grep palabra actual |
| `<leader>fd` | Diagnostics |
| `<leader>fs` | Símbolos LSP |
| `<leader>gc` | Commits git |
| `<leader>gs` | Status git |

### OpenCode (AI)

| Atajo | Descripción |
|-------|-------------|
| `<leader>to` | Toggle OpenCode |
| `<leader>ta` | Ask OpenCode (selección) |
| `<leader>ts` | Seleccionar acción |

### LSP

| Atajo | Descripción |
|-------|-------------|
| `gd` | Ir a definición |
| `gD` | Ir a declaración |
| `gr` | Referencias |
| `gi` | Implementaciones |
| `K` | Hover |
| `<leader>rn` | Renombrar |
| `<leader>ca` | Acciones de código |
| `]d` | Diagnostic siguiente |
| `[d` | Diagnostic anterior |

### Git

| Atajo | Descripción |
|-------|-------------|
| `<leader>gg` | Toggle Fugitive |
| `<leader>gs` | Git status (Telescope) |
| `<leader>gc` | Git commits (Telescope) |

### Comentarios TODO

| Atajo | Descripción |
|-------|-------------|
| `<leader>ft` | Buscar todos |
| `]t` | Siguiente TODO |
| `[t` | Anterior TODO |

## Plugins Incluidos

### UI & Theme
- **kanagawa.nvim** — Tema oscuro (dragon)
- **mini.bufremove** — Borrado de buffers sin cerrar ventanas

### Navegación
- **oil.nvim** — Explorador de archivos como buffer
- **telescope.nvim** — Fuzzy finder con fzf
- **vim-illuminate** — Highlight de palabras bajo cursor

### LSP & Completado
- **mason.nvim** — Instalador de LSP/formatters
- **nvim-lspconfig** — Configuraciones LSP
- **nvim-cmp** — Autocompletado
- **conform.nvim** — Formateo al guardar

### Treesitter
- **nvim-treesitter** — Syntax highlighting avanzado

### Git
- **vim-fugitive** — Comandos git
- **gitsigns.nvim** — Signos en gutter

### AI
- **opencode.nvim** — Integración con OpenCode AI

### Terminal
- **toggle-vterm** — Terminales flotantes

### Utilidades
- **nvim-ts-autotag** — Auto-close tags HTML/JSX
- **todo-comments.nvim** — Resaltar TODOs, FIXMEs, etc.
- **markdown-preview.nvim** — Previsualizar Markdown

## Configuración de Lenguajes

Los LSP se instalan automáticamente via Mason al abrir un archivo. Lenguajes soportados:

- PHP (intelephense)
- Python (pyright)
- Go (gopls)
- Rust (rust-analyzer)
- Lua (lua-language-server)
- JavaScript/TypeScript
- SQL (sqls)
- HTML/CSS/JSON/YAML
- Bash/Shell

## Solución de Problemas

### Error "module not found: lazy.nvim"
```bash
rm -rf ~/.local/share/nvim/lazy
nvim
:LazySync
```

### Instalar manualmente LSP
```bash
nvim
:Mason
```

### Actualizar plugins
```bash
nvim
:Lazy
```

## Inspiración

- LazyVim
- ThePrimeagen
- Craftzdog
