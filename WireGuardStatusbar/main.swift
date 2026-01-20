import AppKit

NSLog("--- [BOOT] Binaire App lancé ---")
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
