$WIN_CLIPBOARD_HISTORY_ROOT_DIR = ($PSScriptRoot)
$APP_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\vendor\powershell-utils"

# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

function exitSuccess() {
    oklog "Done."
    exit 0
}

function uninstall {
    Invoke-Expression "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\delete-boot.ps1"
    del_shortcut_file "Win Clipboard History"
}

function main() {
    infolog "Uninstall Win Clipboard History..."
    uninstall
    exitSuccess
}
main
