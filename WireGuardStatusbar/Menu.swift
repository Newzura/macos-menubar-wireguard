import AppKit
import SwiftUI

class Menu: NSObject {
    var statusItem: NSStatusItem!
    var popover = NSPopover()

    func setup() {
        // Crée l'icône dans la barre de menu
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Icône Éclair SF Symbol (natif macOS)
            button.image = NSImage(systemSymbolName: "bolt.slash.fill", accessibilityDescription: "WireGuard")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Configure le panneau (Popover)
        popover.contentSize = NSSize(width: 280, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: WireGuardMenuView())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    // Fonction pour mettre à jour l'icône dynamiquement
    func updateIcon(isConnected: Bool) {
        guard let button = statusItem.button else { return }
        button.image = NSImage(systemSymbolName: isConnected ? "bolt.fill" : "bolt.slash.fill", accessibilityDescription: nil)
        button.contentTintColor = isConnected ? .systemGreen : nil
    }
}
