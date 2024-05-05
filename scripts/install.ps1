$SCRIPT_INSTALL_DIR = ($PSScriptRoot)
$APP_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$SCRIPT_INSTALL_DIR\vendor\powershell-utils"

# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

# VAR DEPENDS LIBS
$INSTALL_DIR = "$OTHER_APPS_DIR\$APP_NAME"

function exitSuccess() {
    oklog "Done."
    exit 0
}

function directoryExists($directory) {
    if (Test-Path -Path "$directory") {
        RETURN $true
    }
    RETURN $false
}

function createDirectory($directory) {
    if (!(directoryexists "$directory")) {
        mkdir "$directory" | Out-Null
    }
}

function install() {
    createDirectory "$INSTALL_DIR"
    Copy-Item "$SCRIPT_INSTALL_DIR\*" -Destination "$INSTALL_DIR" -Recurse -Force
    create_script_to_run_cmd_hidden "$INSTALL_DIR\$APP_NAME" "$INSTALL_DIR\${APP_NAME}.exe"
    create_shortcut_file -name "Win Clipboard History" -target "$INSTALL_DIR\${APP_NAME}.vbs" -icon "$INSTALL_DIR\icon.ico"
}

function main() {
    if ((directoryexists "$INSTALL_DIR")) {
        warnlog "Please, uninstall $APP_NAME first."
        exit 1
    }
    infolog "Install Win Clipboard History..."
    install
    exitSuccess
}
main
