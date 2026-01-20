import Foundation

class AppXPC {
    static let shared = AppXPC()
    private var connection: NSXPCConnection?

    func remoteObjectProxy() -> HelperXPC {
        if connection == nil {
            connection = NSXPCConnection(machServiceName: "WireGuardStatusbarHelper", options: .privileged)
            connection?.remoteObjectInterface = NSXPCInterface(with: HelperXPC.self)
            connection?.resume()
        }
        return connection!.remoteObjectProxy() as! HelperXPC
    }
}
