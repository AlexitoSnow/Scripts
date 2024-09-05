$SUCCESS_CODE = "Green"
$INFO_CODE = "Blue"
Write-Host "Creating Flutter Project..." -ForegroundColor $INFO_CODE

Set-Location "D:\"

$org = "com.snow"
do {
Write-Host -NoNewline "Project name: " -ForegroundColor $INFO_CODE
    $project_name = Read-Host
    if ($project_name -match "\s" -or $project_name -cne $project_name.ToLower()) {
        Write-Host "Project name should not contain spaces or uppercase letters. Please try again." -ForegroundColor "Red"
    }
} while ($project_name -match "\s" -or $project_name -cne $project_name.ToLower())

Write-Host -NoNewline "Project Description: " -ForegroundColor $INFO_CODE
$project_description = Read-Host
if ($project_description -eq "") {
    $project_description = "A new Flutter project."
}

Write-Host -NoNewline "Is a game? [t/f]" -ForegroundColor $INFO_CODE
$is_game = Read-Host

if ($is_game -eq "t") {
    $org = "$org.game"
    Write-Host "Game project selected." -ForegroundColor $INFO_CODE
} else {
    $org = "$org.app"
    Write-Host "App project selected." -ForegroundColor $INFO_CODE
}

& flutter create $project_name --description="$project_description" -e --org=$org | Out-Null
Write-Host "Flutter project created." -ForegroundColor $SUCCESS_CODE
Set-Location $project_name
Remove-Item README.md -ErrorAction SilentlyContinue

Write-Host "Adding common flutter packages..." -ForegroundColor $INFO_CODE
& flutter pub add flutter_launcher_icons flutter_native_splash --dev | Out-Null
Write-Host "flutter_launcher_icons added." -ForegroundColor $SUCCESS_CODE
Write-Host "flutter_native_splash added." -ForegroundColor $SUCCESS_CODE
& flutter pub add logger go_router | Out-Null
Write-Host "logger added." -ForegroundColor $SUCCESS_CODE
Write-Host "go_router added." -ForegroundColor $SUCCESS_CODE

Write-Host -NoNewline "Is a firebase project? [t/f]" -ForegroundColor $INFO_CODE
$is_firebase = Read-Host
if ($is_firebase -eq "t") {
    & flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage | Out-Null
    Write-Host "firebase_core, firebase_auth, cloud_firestore, firebase_storage packages added." -ForegroundColor $SUCCESS_CODE
}

$dict = @{
    "1" = "native"
    "2" = "get"
    "3" = "provider"
    "4" = "flutter_bloc"
    "5" = "mobx"
    "6" = "riverpod"
}
$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&native", "&get", "&provider", "&flutter_bloc", "&mobx", "&riverpod")

$prompt = "Select a state manager"
$state_manager = $host.ui.PromptForChoice("", $prompt, $options, 0)

# Ahora, $state_manager contendrá el índice de la opción seleccionada (0 para la primera opción, 1 para la segunda, etc.)
# Puedes usar este índice para acceder al valor correspondiente en tu "diccionario":
$selected_manager = $dict[($state_manager + 1).ToString()]
if ($selected_manager -eq "native") {
    Write-Host "Native state manager selected." -ForegroundColor $SUCCESS_CODE
} else {
    if ($selected_manager -eq "mobx") {
        & flutter pub add mobx flutter_mobx | Out-Null

        & flutter pub add dev:build_runner | Out-Null
        & flutter pub add dev:mobx_codegen | Out-Null
    } elseif ($selected_manager -eq "riverpod") {
        & flutter pub add flutter_riverpod riverpod_annotation | Out-Null

        & flutter pub add dev:build_runner | Out-Null
        & flutter pub add dev:custom_lint | Out-Null
        & flutter pub add dev:riverpod_generator | Out-Null
        & flutter pub add dev:riverpod_lint | Out-Null
    } else {
        # Instalar solo el paquete seleccionado
        & flutter pub add $selected_manager | Out-Null
    }
    Write-Host "$selected_manager added." -ForegroundColor $SUCCESS_CODE
}

New-Item -ItemType Directory -Path assets, "assets\icons", "assets\images", "assets\fonts" -Force | Out-Null
Write-Host "assets folder structured." -ForegroundColor $INFO_CODE
New-Item -ItemType Directory -Path assets, "lib\models", "lib\screens", "lib\providers", "lib\services", "lib\styles", "lib\widgets" -Force | Out-Null
Write-Host "lib folder structured." -ForegroundColor $INFO_CODE

if ($is_firebase -eq "t") {
@"
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
    final FirebaseFirestore _firestore;

    DatabaseService() : _firestore = FirebaseFirestore.instance;

    // Add your database service methods here

}
"@ | Out-File -Encoding utf8 "lib/services/database_service.dart"
    Write-Host "database_service.dart created."

@"
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
    final FirebaseStorage _storage;

    CloudStorageService() : _storage = FirebaseStorage.instance;

    // Add your cloud storage service methods here

}
"@ | Out-File -Encoding utf8 "lib/services/cloud_storage_service.dart"
    Write-Host "cloud_storage_service.dart created."
}

@"
  assets:
    - assets/icons/
    - assets/images/

#dart run flutter_launcher_icons
flutter_launcher_icons:
  android: "launcher_icon"
  image_path: "assets/icons/launch-icon.png"
  web:
    generate: true
    image_path: "assets/icons/launch-icon.png"
  windows:
    generate: true
    image_path: "assets/icons/launch-icon.png"

#dart run flutter_native_splash:create
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
Write-Host "pubspec.yaml structured." -ForegroundColor $INFO_CODE

@"
# $project_name
## Description
$project_description
"@ | Out-File README.md
Write-Host "README.md created."

& git init | Out-Null

Write-Host -NoNewline "All ready, press any key to open the project..." -ForegroundColor $SUCCESS_CODE
Read-Host
& code . | Out-Null