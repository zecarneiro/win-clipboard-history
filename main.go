package main

import (
	"jnoronhautils"
	"jnoronhautils/entities"
	"jnoronhautils/enums"
	"os"
	"strings"
	"time"

	"github.com/energye/systray"
	"github.com/micmonay/keybd_event"
)

type menuItems struct {
	quitItem        *systray.MenuItem
	enableAutoStart *systray.MenuItem
}

const (
	APP_NAME = "win-clipboard-history"
)

var (
	menuItem          menuItems
	executableDir string
)

func validatePlatform() {
	jnoronhautils.ValidateSystem()
	if !jnoronhautils.IsWindows() {
		jnoronhautils.ErrorLog(enums.INVALID_PLATFORM_MSG, false)
		os.Exit(1)
	}
}

func main() {
	menuItem = menuItems{}
	executableDir = jnoronhautils.GetExecutableDir()
	systray.Run(onReady, onQuit)
}

func openClipboard() {
	kb, err := keybd_event.NewKeyBonding()
	if err != nil {
		panic(err)
	}
	// Set WinSuper+V
	kb.SetKeys(keybd_event.VK_V)
	kb.HasSuper(true)

	// Press the selected keys
	err = kb.Launching() 
	if err != nil {
		panic(err)
	}
	
	// Or you can use Press and Release
	kb.Press()
	time.Sleep(10 * time.Millisecond)
	kb.Release()
}

func getIcon() []byte {
	return jnoronhautils.ReadFileInByte(executableDir + "\\icon.ico")
}

func processEnableAutoStart() {
	cmdInfo := entities.CommandInfo{
		Cmd: "powershell.exe -File " + executableDir,
		UsePowerShell: false,
		Verbose: false,
		EnvVars: os.Environ(),
	}
	if menuItem.enableAutoStart.Checked() {
		cmdInfo.Cmd = cmdInfo.Cmd + "\\delete-boot.ps1"
		menuItem.enableAutoStart.Uncheck()
	} else {
		cmdInfo.Cmd = cmdInfo.Cmd + "\\add-boot.ps1"
		menuItem.enableAutoStart.Check()
	}
	if strings.Contains(executableDir, "\\release\\") {
		cmdInfo.EnvVars = append(cmdInfo.EnvVars, "FOR_TEST=1") 
	}
	jnoronhautils.ExecRealTime(cmdInfo)
}

func isAutoStartEnabled() bool {
	fileName := jnoronhautils.SystemInfo().HomeDir + "\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\win-clipboard-history.lnk"
	return jnoronhautils.FileExist(fileName)
}

func buildMenu() {
	menuItem.enableAutoStart = systray.AddMenuItemCheckbox("Autostart", "Enable auto-start with system", isAutoStartEnabled())
	menuItem.quitItem = systray.AddMenuItem("Quit", "Exit of Windows Clipboard History tray indicator")
	menuItem.enableAutoStart.Click(func() {
		processEnableAutoStart()
	})
	menuItem.quitItem.Click(func() {
		systray.Quit()
	})
}

func onReady() {
	systray.SetIcon(getIcon())
	systray.SetTitle("Open Windows Clipboard")
	systray.SetTooltip("Open Windows Clipboard")
	buildMenu()
	systray.SetOnClick(func(menu systray.IMenu) {
		openClipboard()
	})
	systray.SetOnRClick(func(menu systray.IMenu) {
		menu.ShowMenu()
	})
}

func onQuit() {
	// TODO: Not implemented yet
}
