$SCRIPT_DIR = ($PSScriptRoot)
$BINARY_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$SCRIPT_DIR\vendor\powershell-utils"


# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

del_boot_application -name "$BINARY_NAME"