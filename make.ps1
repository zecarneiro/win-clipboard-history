param(
    [switch] $build,
    [switch] $run,
    [switch] $clean,
    [switch] $install,
    [switch] $uninstall,
    [switch] $release
)

$MAKE_SCRIPT_DIR = ($PSScriptRoot)
$RELEASE_DIR = "$MAKE_SCRIPT_DIR\release"
$BINARY_NAME = "win-clipboard-history"
$BINARY = "$RELEASE_DIR\${BINARY_NAME}.exe"
$SCRIPT_SHELL_VENDOR_DIR = "$MAKE_SCRIPT_DIR\vendor\powershell-utils"

# IMPORT LIBS
. "$SCRIPT_SHELL_VENDOR_DIR\MainUtils.ps1"

function exitSuccess() {
    oklog "Done."
    exit 0
}

function fileExists($file) {
    if (Test-Path -Path "$file" -PathType Leaf) {
        RETURN $true
    }
    RETURN $false
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

function copyFiles() {
    infolog "Copy necessary files..."
    $icon = "$MAKE_SCRIPT_DIR\icon.ico"
    $scriptShellRelease = "$RELEASE_DIR\vendor"
    Copy-Item "$icon" -Destination "$RELEASE_DIR" -Force
    if (!(directoryexists "$scriptShellRelease")) {
        createDirectory "$scriptShellRelease"
    }
    Copy-Item "$SCRIPT_SHELL_VENDOR_DIR" -Destination "$scriptShellRelease" -Recurse -Force
    Copy-Item "$MAKE_SCRIPT_DIR\scripts\add-boot.ps1" -Destination "$RELEASE_DIR" -Recurse -Force
    Copy-Item "$MAKE_SCRIPT_DIR\scripts\delete-boot.ps1" -Destination "$RELEASE_DIR" -Recurse -Force
    Copy-Item "$MAKE_SCRIPT_DIR\scripts\install.ps1" -Destination "$RELEASE_DIR" -Recurse -Force
    Copy-Item "$MAKE_SCRIPT_DIR\scripts\uninstall.ps1" -Destination "$RELEASE_DIR" -Recurse -Force
    Copy-Item "$MAKE_SCRIPT_DIR\README.md" -Destination "$RELEASE_DIR" -Recurse -Force
}

function install_go() {
	infolog "Verifiy if go is installed..."
	if ([string]::IsNullOrEmpty((Get-Command "go.exe" | Select-Object -ExpandProperty Definition))) {
		debuglog "Install golang!"
		winget install --id=GoLang.Go
	}    
}

function build() {
    install_go
	infolog "Build app..."
	go build -o "$BINARY" "$MAKE_SCRIPT_DIR\main.go"
}

function cleanClipboard() {
    if ((directoryexists "$RELEASE_DIR")) {
        Remove-Item "$RELEASE_DIR" -Force -Recurse
    }
    if ($clean) {
        exitSuccess
    }
}

function release() {
    $compress = @{
        Path = "$RELEASE_DIR\*"
        CompressionLevel = "Fastest"
        DestinationPath = "$MAKE_SCRIPT_DIR\$BINARY_NAME.zip"
    }
    Compress-Archive @compress -Force
}

function main() {
    if ($install) {
        powershell.exe -File "$RELEASE_DIR\install.ps1"
        exit 0
    }
    if ($uninstall) {
        powershell.exe -File "$RELEASE_DIR\uninstall.ps1"
        exit 0
    }
    if ($build -or $release) {
        cleanClipboard
        if (!(directoryexists "$RELEASE_DIR")) {
            createDirectory "$RELEASE_DIR"
        }
        build
        copyFiles
        if ($release) {
            release
        }
    }
    if ($run) {
        infolog "Run app..."
        if (!(fileExists "$BINARY")) {
            errorlog "Please, run build before run!"
            exit 1
        } else {
            Invoke-Expression "$BINARY"
            exitSuccess
        }
    }
    exitSuccess
}
main
