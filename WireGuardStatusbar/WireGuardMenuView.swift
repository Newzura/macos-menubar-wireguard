import SwiftUI

struct WireGuardMenuView: View {
    @State var isConnected = false
    @State var statusText = "Vérification..."
    @State var peerCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // --- HEADER STATUT ---
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isConnected ? Color.green.opacity(0.2) : Color.secondary.opacity(0.2))
                        .frame(width: 32, height: 32)
                    Image(systemName: isConnected ? "bolt.fill" : "bolt.slash.fill")
                        .foregroundColor(isConnected ? .green : .secondary)
                        .font(.system(size: 16, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(isConnected ? "Tunnel Actif" : "Déconnecté")
                        .font(.system(size: 13, weight: .bold))
                    Text(isConnected ? "172.16.0.2 • \(peerCount) pairs" : "Prêt à se connecter")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 4)

            Divider()

            // --- ACTIONS ---
            VStack(spacing: 8) {
                Button(action: { AppXPC.shared.remoteObjectProxy().up { _ in refresh() } }) {
                    Label("Se connecter", systemImage: "play.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(isConnected)
                .controlSize(.large)

                Button(action: { AppXPC.shared.remoteObjectProxy().down { _ in refresh() } }) {
                    Label("Déconnecter", systemImage: "power")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .disabled(!isConnected)
                .controlSize(.large)
            }

            Divider()

            // --- CONFIGURATION ---
            VStack(alignment: .leading, spacing: 10) {
                Text("CONFIGURATION")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                
                Button(action: { editConf() }) {
                    Label("Modifier wgsclient.conf", systemImage: "doc.text.fill")
                }.buttonStyle(.plain)

                Button(action: { editJSON() }) {
                    Label("Modifier JSON Perso", systemImage: "curlybraces")
                }.buttonStyle(.plain)

                Button(action: { openFolder() }) {
                    Label("Ouvrir le dossier /etc", systemImage: "folder.fill")
                }.buttonStyle(.plain)
            }
            .font(.system(size: 12))

            Divider()

            // --- QUIT ---
            Button(role: .destructive, action: { NSApplication.shared.terminate(nil) }) {
                Label("Quitter l'application", systemImage: "xmark.circle")
                    .foregroundColor(.red.opacity(0.8))
            }
            .buttonStyle(.plain)
            .font(.system(size: 12))
        }
        .padding(20)
        .frame(width: 280)
        .onAppear { refresh() }
    }

    func refresh() {
        AppXPC.shared.remoteObjectProxy().status { s in
            DispatchQueue.main.async {
                self.isConnected = s?.isConnected ?? false
                self.peerCount = s?.peerCount ?? 0
            }
        }
    }
    
    func editConf() {
        AppXPC.shared.remoteObjectProxy().ensureFilesExist { _ in
            NSWorkspace.shared.open(URL(fileURLWithPath: "/usr/local/etc/wireguard/wgsclient.conf"))
        }
    }
    
    func editJSON() {
        let path = "/Users/\(NSUserName())/.wg-menu-config.json"
        AppXPC.shared.remoteObjectProxy().ensureFilesExist { _ in
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    }
    
    func openFolder() {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/usr/local/etc/wireguard"))
    }
}
