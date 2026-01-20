import AppKit
import SwiftUI

class Menu: NSObject {
    var statusItem: NSStatusItem!
    var popover = NSPopover()

    func setup() {
        NSLog("--- [MENU] Entrée dans setup() ---")
        
        // Création de l'item dans la barre système
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            NSLog("--- [MENU] Bouton statusItem trouvé, application de l'icône ---")
            button.image = NSImage(systemSymbolName: "bolt.slash.fill", accessibilityDescription: "WireGuard")
            button.action = #selector(togglePopover)
            button.target = self
        } else {
            NSLog("--- [ERROR] Impossible de créer le bouton dans la barre de menu ---")
        }

        NSLog("--- [MENU] Configuration du Popover ---")
        popover.contentSize = NSSize(width: 280, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: WireGuardMenuView())
        
        NSLog("--- [MENU] Setup terminé ---")
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        NSLog("--- [UI] Clic sur l'icône de la barre de menu ---")
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
