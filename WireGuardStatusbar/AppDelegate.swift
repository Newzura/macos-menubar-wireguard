import AppKit
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuController: Menu?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("--- [INIT] AppDelegate lancé ---")
        NSApp.setActivationPolicy(.accessory)

        let helperID = "WireGuardStatusbarHelper"
        var error: Unmanaged<CFError>?
        
        if SMJobBless(kSMDomainSystemLaunchd, helperID as CFString, nil, &error) {
            NSLog("--- [HELPER] SMJobBless SUCCÈS ---")
        } else {
            let blessError = error?.takeRetainedValue()
            NSLog("--- [HELPER] SMJobBless ÉCHEC: \(blessError.debugDescription) ---")
        }

        self.menuController = Menu()
        self.menuController?.setup()
    }
}
