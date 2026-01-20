import Foundation
import SystemConfiguration

class Helper: NSObject, HelperXPC {
    let interface = "wgsclient"

    func ensureFilesExist(completion: @escaping (Bool) -> Void) {
        let fm = FileManager.default
        let user = SCDynamicStoreCopyConsoleUser(nil, nil, nil) as String? ?? "root"
        try? fm.createDirectory(atPath: "/usr/local/etc/wireguard", withIntermediateDirectories: true)
        let conf = "/usr/local/etc/wireguard/wgsclient.conf"
        if !fm.fileExists(atPath: conf) {
            try? "[Interface]\nAddress = 172.16.0.2/32\n".write(toFile: conf, atomically: true, encoding: .utf8)
        }
        try? fm.setAttributes([.posixPermissions: 0o644], ofItemAtPath: conf)
        let json = "/Users/\(user)/.wg-menu-config.json"
        if !fm.fileExists(atPath: json) {
            try? "{\"gateway\": \"172.16.0.1\"}".write(toFile: json, atomically: true, encoding: .utf8)
        }
        try? fm.setAttributes([.posixPermissions: 0o644], ofItemAtPath: json)
        completion(true)
    }

    func status(completion: @escaping (WireGuardStatus?) -> Void) {
        let task = Process()
        task.launchPath = "/usr/local/bin/wg"
        task.arguments = ["show", interface, "dump"]
        let pipe = Pipe(); task.standardOutput = pipe
        try? task.run()
        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        if output.isEmpty {
            completion(WireGuardStatus(isConnected: false, peerCount: 0))
        } else {
            let lines = output.components(separatedBy: .newlines).filter { $0.contains("\t") }
            completion(WireGuardStatus(isConnected: true, peerCount: lines.count))
        }
    }

    func up(completion: @escaping (Bool) -> Void) {
        let p = Process(); p.launchPath = "/usr/local/bin/wg-quick"; p.arguments = ["up", interface]
        p.environment = ["PATH": "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin"]
        try? p.run(); p.waitUntilExit(); completion(p.terminationStatus == 0)
    }

    func down(completion: @escaping (Bool) -> Void) {
        let p = Process(); p.launchPath = "/usr/local/bin/wg-quick"; p.arguments = ["down", interface]
        try? p.run(); p.waitUntilExit(); completion(true)
    }
}
