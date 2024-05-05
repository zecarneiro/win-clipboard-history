$SCRIPT_UNINSTALL_DIR = ($PSScriptRoot)
$APP_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$SCRIPT_UNINSTALL_DIR\vendor\powershell-utils"

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

function validateProcessRunning() {
    if ((Get-Process -ProcessName $APP_NAME -ErrorAction SilentlyContinue)) {
        warnlog "Please, close $APP_NAME, before continue."
        exit 1
    }
}

function uninstall {
    if ((directoryExists "$INSTALL_DIR")) {
        Invoke-Expression "$INSTALL_DIR\delete-boot.ps1"
        Remove-Item "$INSTALL_DIR" -Recurse -Force
    }
}

function main() {
    infolog "Uninstall Win Clipboard History..."
    validateProcessRunning
    uninstall
    exitSuccess
}
main
