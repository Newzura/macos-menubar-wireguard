import Foundation

class AppXPC {
    static let shared = AppXPC()
    private var connection: NSXPCConnection?

    func remoteObjectProxy() -> HelperXPC {
        if connection == nil {
            // Doit être identique au machServiceName du main.swift
            connection = NSXPCConnection(machServiceName: "WireGuardStatusbarHelper", options: .privileged)
            connection?.remoteObjectInterface = NSXPCInterface(with: HelperXPC.self)
            connection?.resume()
        }
        return connection!.remoteObjectProxy() as! HelperXPC
    }
}
