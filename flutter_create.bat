@echo off

echo Creating Flutter Project...

cd "C:\Directory" >nul

set org=com.mycompany>nul
set /p project_folder=Project folder:
:: Project Name must be in lowercase and without spaces
set /p project_name=Project name:
set /p project_description=Project description:
:: Project App by default
set /p is_game=Is a game? [t/f]:

if %is_game% == t (
    set org=%org%.game>nul
    echo Game project selected.
) else (
    set org=%org%.app>nul
    echo App project selected.
)

mkdir "%project_folder%" >nul
cd "%project_folder%" >nul

call flutter create %project_name% --description="%project_description%" -e --platforms="android,web,windows" --org=%org% >nul
echo Flutter project created.
cd %project_name% >nul
del README.md >nul
del .gitignore >nul

echo Adding common flutter packages...
call flutter pub add flutter_launcher_icons --dev >nul
echo flutter_launcher_icons added.
call flutter pub add flutter_native_splash --dev >nul
echo flutter_native_splash added.
call flutter pub add gap >nul
echo gap added.
call flutter pub add get >nul
echo get added.

mkdir assets >nul
mkdir assets\icons >nul
echo assets folder created.

mkdir lib\app >nul
mkdir lib\app\modules >nul
mkdir lib\app\routes >nul
mkdir lib\app\widgets >nul
echo lib folder structured.

(
    echo   assets:
    echo     - assets/icons/
    echo.
    echo flutter_launcher_icons:
    echo   android: "launcher_icon"
    echo   image_path: "assets/icons/launch-icon.png"
    echo   web:
    echo     generate: true
    echo     image_path: "assets/icons/launch-icon.png"
    echo   windows:
    echo     generate: true
    echo     image_path: "assets/icons/launch-icon.png"
    echo.
    echo flutter_native_splash:
    echo   color: "#ffffff"
    echo   image: "assets/icons/splash-icon.png"
    echo   android: true
    echo   web: true
    echo   android_12:
    echo     color: "#ffffff"
    echo     image: "assets/icons/splash-icon.png"
) >> pubspec.yaml
call flutter pub get >nul
echo pubspec.yaml structured.
echo execute dart run flutter_launcher_icons when you add the launch-icon.
echo execute dart run flutter_native_splash:create when you add the splash-icon.

cd .. >nul

(
    echo # %project_folder%
    echo ## Description
    echo %project_description%
) > README.md
echo README.md created.

(
    echo **/.idea/
    echo **/*.iml
    echo.
    echo # Android Studio will place build artifacts here
    echo **/android/app/debug
    echo **/android/app/profile
    echo **/android/app/release
    echo # Flutter/Dart/Pub related
    echo **/**/doc/api/
    echo **/**/ios/Flutter/.last_build_id
    echo **/.dart_tool/
    echo **/.flutter-plugins
    echo **/.flutter-plugins-dependencies
    echo **/.packages
    echo **/.pub-cache/
    echo **/.pub/
    echo **/build/
    echo.
    echo # This files must exists in the root directory
    echo # but when execute flutter pub get, they will be created inside
    echo %project_name%/.vscode/
    echo %project_name%/.gitignore
    echo %project_name%/README.md
) > .gitignore
echo .gitignore created.

echo All ready, click to open the project...
pause
code . >nul
