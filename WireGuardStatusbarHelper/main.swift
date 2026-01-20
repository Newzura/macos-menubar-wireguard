//

import Foundation

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: HelperXPC.self)
        newConnection.exportedObject = Helper()
        newConnection.resume()
        return true
    }
}

// Doit correspondre EXACTEMENT au Bundle ID du Helper
let listener = NSXPCListener(machServiceName: "WireGuardStatusbarHelper")
let delegate = ServiceDelegate()
listener.delegate = delegate
listener.resume()
RunLoop.main.run()
