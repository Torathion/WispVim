# WispVim

A neovim configuration to look and feel like VSCode, without learning vim shortcuts.

This project was created out of my annoyance of vscode's telemetry, resource hogging and graphical errors.

## Prerequisits

Make sure everything is installed and correctly set up.

1. Make sure neovim (0.10.0 and up) can read the `init.lua` file. (It should work out of box)
2. This config is set up for TypeScript, Python and Lua development. So you need up-to-date versions of:

- Node.JS
- Python3
- Lua
- Luarocks
- Pyright
- npm or pnpm
- `rustup` with the `nightly` package
- Cargo
- Git
- xclip for "copy to clipboard"

## Keybinds

Neovim has far different keybinds to vscode or other modern IDEs, so this configuration tries to mimic VSCode's features
by also having the same keybinds and features.

## More Quality of Life advancements.

Due to the neovim community being so big and entirely open source, there are a lot of projects and quality of life plugins
easily and readily available to transform neovim to a full-blown IDE.

## Installation

Clone this project into ~/.config/nvim

## Further configuration

You can easily add and adjust the configuration of this project as you install the entire project in your nvim folder.
Each aspect of configuration is split into it's own lua file. Feel free to adjust it as much as you want.
