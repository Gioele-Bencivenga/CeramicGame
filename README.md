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

1) Grab yourself the following files: [main.js](https://gist.github.com/Jarrio/1f2e000ebad675db7004b0f97574db8a) and [preload.js](https://gist.github.com/Jarrio/e6da74e7ef46c58bf9ca7c219ee2b415)
2) Place these files in `.../projectroot/project/web`
3) Next grab [launch.json](https://gist.github.com/Jarrio/c8c89f9146f046b7933cd155cebddb00) and place this in your `.../projectroot/.vscode` folder
4) At the bottom of the vscode window change the build task to `clay / Build Web`
5) Now when you go to the debug tab, select `Electron: All`
6) Wait for all adapters to connect, it will take a little bit of time on the first launch. A drop down list will appear when completed
7) When the dropdown list has appeared, select `Electron: Renderer`
8) Now when you hit your `Restart debug` shortcut or button it will just reload inside of the window, rather than relaunch the entire electron instance
