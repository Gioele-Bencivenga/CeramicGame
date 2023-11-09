# CeramicGame

Trying out ceramic by making a small game

## Running the Project

Without ceramic vscode extension:

```cmd
ceramic clay run web --setup --assets
```

With vscode extension:

`CTRL` + `Shift` + `B` (`CMD` + `Shift` + `B` on Mac)

### Debugging

From NotBilly's ceramic discord bot:
>This setup comes configured to allow full sys access, adjust if needed

1) make sure you have a global electron installation (`npm install -g electron` if you use npm)
2) grab the following files: [main.js](https://gist.github.com/Jarrio/1f2e000ebad675db7004b0f97574db8a) and [preload.js](https://gist.github.com/Jarrio/e6da74e7ef46c58bf9ca7c219ee2b415)
   1) place the files in `.../projectroot/project/web`
3) grab [launch.json](https://gist.github.com/Jarrio/c8c89f9146f046b7933cd155cebddb00)
   1) place it in your `.../projectroot/.vscode` folder
4) at the bottom of the vscode window
   1) change the build task to `clay / Build Web`
   2) change from `variant: Release` to `variant: Debug`
5) go to vscode's `Run and Debug` tab, select `Electron: All` from the dropdown
6) press `Start Debugging (F5)`, debugging controls will appear (play, pause, step into ecc)
7) wait for all adapters to connect, it will take a little bit of time on the first launch. A dropdown list will appear beside the controls when completed
8) when the dropdown list has appeared, select `Electron: Renderer`
9) now when you hit your `Restart debug` shortcut or button it will just reload inside of the window, rather than relaunch the entire electron instance
10) add this nice shortcut to vscode's keybindings (`File > Preferences > Keyboard Shortcuts > Open Keyboard Shortcuts (JSON)`) if you want

    ```json
    {
        "key": "ctrl+shift+b",
        "when": "!inDebugMode",
        "command": "workbench.action.tasks.build"
    },
    {
        "key": "ctrl+shift+b",
        "when": "inDebugMode",
        "command": "workbench.action.debug.restart"
    },
    ```
