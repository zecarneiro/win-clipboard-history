$WIN_CLIPBOARD_HISTORY_ROOT_DIR = ($PSScriptRoot)
$APP_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\vendor\powershell-utils"

# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

function exitSuccess() {
    oklog "Done."
    exit 0
}

function install() {
    create_script_to_run_cmd_hidden "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\$APP_NAME" "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\${APP_NAME}.exe"
    create_shortcut_file -name "Win Clipboard History" -target "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\${APP_NAME}.vbs" -icon "$WIN_CLIPBOARD_HISTORY_ROOT_DIR\icon.ico"
}

function main() {
    infolog "Install Win Clipboard History..."
    install
    exitSuccess
}
main
