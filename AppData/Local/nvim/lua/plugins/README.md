
# Plugin Configuration

This folder contains all Neovim plugin setup files.

Each `.lua` file configures a specific plugin or feature.  
All files inside this directory are automatically loaded by `lazy.nvim`.

This is done from `init.lua` using:

```lua
require("lazy").setup("plugins")
```

---

## **Directory Structure**

```bash
plugins/
├── autocompletion.lua
├── color-scheme.lua
├── comments.lua
├── debugger.lua
├── flash.lua
├── fzf-lua.lua
├── image.lua
├── img-clip.lua
├── lsp-config.lua
├── lualine.lua
├── multicursors.lua
├── neo-tree.lua
├── none-ls.lua
├── snacks.lua
├── tabout.lua
├── telescope.lua
├── treesitter.lua
├── whichkey.lua
└── yazi.lua
```

---

## **File Overview**

### 📄 `autocompletion.lua`
```bash
Sets up autocompletion engine and completion sources (e.g., nvim-cmp).
```

### 📄 `color-scheme.lua`
```bash
Configures colorscheme and theme behavior (e.g., catppuccin, tokyonight).
```

### 📄 `comments.lua`
```bash
Comment toggling with Comment.nvim (e.g., gc, gcc, Ctrl+/).
```

### 📄 `debugger.lua`
```bash
Debug Adapter Protocol (DAP) configuration for debugging.
```

### 📄 `flash.lua`
```bash
Flash navigation for jumping to labels, treesitter nodes, or search matches.
```

### 📄 `fzf-lua.lua`
```bash
Fuzzy finder setup using fzf-lua.
```

### 📄 `image.lua`
```bash
Enables image rendering inside Neovim (e.g., for markdown preview).
```

### 📄 `img-clip.lua`
```bash
Allows pasting images directly from the clipboard into markdown files.
```

### 📄 `lsp-config.lua`
```bash
Language Server Protocol setup and configuration.
```

### 📄 `lualine.lua`
```bash
Statusline configuration (e.g., powerline-style status bar).
```

### 📄 `multicursors.lua`
```bash
Multiple cursor support for simultaneous editing.
```

### 📄 `neo-tree.lua`
```bash
File explorer setup and customization.
```

### 📄 `none-ls.lua`
```bash
Formatter and linter integration using none-ls.nvim (null-ls replacement).
```

### 📄 `snacks.lua`
```bash
UI utilities, notifications, and terminal enhancements (e.g., Snacks.terminal).
```

### 📄 `tabout.lua`
```bash
Smart tab key for jumping out of parentheses, quotes, and brackets.
```

### 📄 `telescope.lua`
```bash
Fuzzy finder setup using Telescope.nvim.
```

### 📄 `treesitter.lua`
```bash
Syntax highlighting, parsing, and treesitter-based features.
```

### 📄 `whichkey.lua`
```bash
Keybinding helper that shows available mappings with descriptions.
```

### 📄 `yazi.lua`
```bash
File manager integration with Yazi for browsing files.
```

---

## **Managing Plugins**

This setup uses `lazy.nvim`.

On first launch, plugins install automatically.

If needed, you can manually manage plugins using:

```vim
:Lazy            " Open Lazy UI
:Lazy sync       " Install / update / clean plugins
:Lazy update     " Update plugins
:Lazy restore    " Restore from lazy-lock.json
```

After cloning the repository, run:

```vim
:Lazy sync
```

