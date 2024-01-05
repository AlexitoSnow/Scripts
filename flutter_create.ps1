Write-Host "Creating Flutter Project..."

Set-Location "C:\Projects Directory"

$org = "com.my_company"
$project_folder = Read-Host "Project folder"
$project_name = ""
do {
    $project_name = Read-Host "Project name"
    if ($project_name -match "\s" -or $project_name -cne $project_name.ToLower()) {
        Write-Host "Project name should not contain spaces or uppercase letters. Please try again."
    }
} while ($project_name -match "\s" -or $project_name -cne $project_name.ToLower())
$project_description = Read-Host "Project description"
$is_game = Read-Host "Is a game? [t/f]"

if ($is_game -eq "t") {
    $org = "$org.game"
    Write-Host "Game project selected."
} else {
    $org = "$org.app"
    Write-Host "App project selected."
}

New-Item -ItemType Directory -Path $project_folder -Force | Out-Null
Set-Location $project_folder

& flutter create $project_name --description="$project_description" -e --platforms="android,web,windows" --org=$org | Out-Null
Write-Host "Flutter project created."
Set-Location $project_name
Remove-Item README.md -ErrorAction SilentlyContinue
Remove-Item .gitignore -ErrorAction SilentlyContinue

Write-Host "Adding common flutter packages..."
& flutter pub add flutter_launcher_icons --dev | Out-Null
Write-Host "flutter_launcher_icons added."
& flutter pub add flutter_native_splash --dev | Out-Null
Write-Host "flutter_native_splash added."
& flutter pub add gap | Out-Null
Write-Host "gap added."

$dict = @{
    "1" = "get"
    "2" = "provider"
    "3" = "flutter_bloc"
    "4" = "mobx"
    "5" = "riverpod"
}
$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&get", "&provider", "&flutter_bloc", "&mobx", "&riverpod")

$prompt = "Select a state manager"
$state_manager = $host.ui.PromptForChoice("", $prompt, $options, 0)

# Ahora, $state_manager contendrá el índice de la opción seleccionada (0 para la primera opción, 1 para la segunda, etc.)
# Puedes usar este índice para acceder al valor correspondiente en tu "diccionario":
$selected_manager = $dict[($state_manager + 1).ToString()]
if ($selected_manager -eq "mobx") {
    & flutter pub add mobx | Out-Null
    & flutter pub add flutter_mobx | Out-Null
    & flutter pub add dev:build_runner | Out-Null
    & flutter pub add dev:mobx_codegen | Out-Null
} elseif ($selected_manager -eq "riverpod") {
    & flutter pub add flutter_riverpod | Out-Null
    & flutter pub add riverpod_annotation | Out-Null
    & flutter pub add dev:riverpod_generator | Out-Null
    & flutter pub add dev:build_runner | Out-Null
    & flutter pub add dev:custom_lint | Out-Null
    & flutter pub add dev:riverpod_lint | Out-Null
} else {
    # Instalar solo el paquete seleccionado
    & flutter pub add $selected_manager | Out-Null
}
Write-Host "$selected_manager added."

New-Item -ItemType Directory -Path assets, "assets\icons", "lib\app", "lib\app\modules", "lib\app\routes", "lib\app\widgets" -Force | Out-Null
Write-Host "assets folder structured."
Write-Host "lib folder structured."

@"
  assets:
    - assets/icons/

flutter_launcher_icons:
  android: "launcher_icon"
  image_path: "assets/icons/launch-icon.png"
  web:
    generate: true
    image_path: "assets/icons/launch-icon.png"
  windows:
    generate: true
    image_path: "assets/icons/launch-icon.png"

flutter_native_splash:
  color: "#ffffff"
  image: "assets/icons/splash-icon.png"
  android: true
  web: true
  android_12:
    color: "#ffffff"
    image: "assets/icons/splash-icon.png"
"@ | Out-File -Append -Encoding utf8 pubspec.yaml

& flutter pub get | Out-Null
Write-Host "pubspec.yaml structured."
Write-Host "execute dart run flutter_launcher_icons when you add the launch-icon."
Write-Host "execute dart run flutter_native_splash:create when you add the splash-icon."

Set-Location ..

@"
# $project_folder
## Description
$project_description
"@ | Out-File README.md
Write-Host "README.md created."

@"
**/.idea/
**/*.iml

# Android Studio will place build artifacts here
**/android/app/debug
**/android/app/profile
**/android/app/release
# Flutter/Dart/Pub related
**/**/doc/api/
**/**/ios/Flutter/.last_build_id
**/.dart_tool/
**/.flutter-plugins
**/.flutter-plugins-dependencies
**/.packages
**/.pub-cache/
**/.pub/
**/build/

# This files must exists in the root directory
# but when execute flutter pub get, they will be created inside
$project_name/.vscode/
$project_name/.gitignore
$project_name/README.md
"@ | Out-File .gitignore
Write-Host ".gitignore created."

Read-Host "All ready, press any key to open the project..."
& code . | Out-Null