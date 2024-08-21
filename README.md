# Scripts
Custom scripts for various functions

## Flutter
### flutter_create
#### Description:
##### Basics

Creates a flutter project with the given values:

- Project name
- Project type (app, game)
- Project description

##### Default Packages

- Flutter Launcher Icons --dev dependency: Adds launcher icons to the project.
- Flutter Native Splash --dev dependency: Adds splash screen to the project.
- Logger: For logging purposes.
- Go Router: For routing purposes.

(Optional) if is a firebase project, the following common packages will be added:
- Firebase Core
- Firebase Auth
- Firebase Firestore
- Cloud Firestore

##### State Management

- GetX
- Provider
- Bloc
- MobX
- Riverpod
- Native (No state management package)

##### Project Structure

Adds the following folders to the project:

- `assets/icons`
- `assets/images`
- `assets/fonts`
- `lib/models`
- `lib/screens`
- `lib/providers`
- `lib/services`
- `lib/styles`
- `lib/widgets`

(Optional) if is a firebase project, the following files will be added:

- `lib/services/cloud_storage_service.dart`
- `lib/services/database_service.dart`

6. Finally, initializes a git repository in the project folder.

#### Notes

- Execute `dart run flutter_launcher_icons` only when you add the launch-icon.

- Execute `dart run flutter_native_splash:create` only when you add the splash-icon.