# Scripts
Custom scripts for various functions

## Flutter
### flutter_create
Creates a flutter project with the given values:
- Project folder
- Project name
- Project type (app, game)
- Project description

Default packages will be added:
- Flutter Launcher Icons
- Flutter Native Splash
- Gap
- Get

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
```

Adding a format to the pubspec.yaml file with the needed to add the launcher icons and splash screen.

**Note:**

Execute `dart run flutter_launcher_icons` only when you add the launch-icon.

Execute `dart run flutter_native_splash:create` only when you add the splash-icon.

Finally, creates default `README.me` and `.gitignore` files and the project will be opened in VSCode.