import Foundation

@objc(WireGuardStatus)
public class WireGuardStatus: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    public let isConnected: Bool
    public let peerCount: Int
    init(isConnected: Bool, peerCount: Int) {
        self.isConnected = isConnected
        self.peerCount = peerCount
    }
    public func encode(with coder: NSCoder) {
        coder.encode(isConnected, forKey: "isConnected")
        coder.encode(Int32(peerCount), forKey: "peerCount")
    }
    public required init?(coder: NSCoder) {
        isConnected = coder.decodeBool(forKey: "isConnected")
        peerCount = Int(coder.decodeInt32(forKey: "peerCount"))
    }
}

@objc protocol HelperXPC {
    func status(completion: @escaping (WireGuardStatus?) -> Void)
    func up(completion: @escaping (Bool) -> Void)
    func down(completion: @escaping (Bool) -> Void)
    func ensureFilesExist(completion: @escaping (Bool) -> Void)
}
