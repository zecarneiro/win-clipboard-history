$IS_TEST = $env:FOR_TEST
$SCRIPT_DIR = ($PSScriptRoot)
$BINARY_NAME = "win-clipboard-history"
$SCRIPT_SHELL_VENDOR_DIR = "$SCRIPT_DIR\vendor\powershell-utils"

if ($IS_TEST -eq 1) {
    $SCRIPT_DIR = "$SCRIPT_DIR\release"
}
$BINARY = "$SCRIPT_DIR\${BINARY_NAME}.exe"


# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

add_boot_application -name "$BINARY_NAME" -command "$BINARY" -hidden