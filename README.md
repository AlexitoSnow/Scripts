# Scripts
Custom scripts for various functions

## Flutter
### flutter_create
#### Description:
1. Creates a flutter project with the given values:
- Project folder
- Project name
- Project type (app, game)
- Project description

2. Default packages will be added:
- Flutter Launcher Icons
- Flutter Native Splash
- Gap
- Rename App [Only for `PowerShell` version]
- Get* See [State Management](#state-management)

3. Structure the project folder.

4. Adding a format to the pubspec.yaml file with the needed to add the launcher icons and splash screen.

5. Finally, creates default `README.me` and `.gitignore` files and the project will be opened in VSCode.

#### Folder structure (show only relevant folders):
```
project_folder
├── project_name
│   ├── assets
|   |   ├── icons
│   ├── lib
│   │   ├── app
│   │   │   ├── modules
│   │   │   ├── routes
│   │   │   ├── widgets
├── README.md
├── .gitignore
├── .git
```



#### State Management
If you choose the `PowerShell` version, you will be able to choose the `State Management` package.

- GetX
- Provider
- Bloc
- MobX
- Riverpod

#### Notes

- Execute `dart run flutter_launcher_icons` only when you add the launch-icon.

- Execute `dart run flutter_native_splash:create` only when you add the splash-icon.