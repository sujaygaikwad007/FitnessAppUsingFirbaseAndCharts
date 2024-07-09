import SwiftUI

struct SecureViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SecureViewController {
        return SecureViewController()
    }
    
    func updateUIViewController(_ uiViewController: SecureViewController, context: Context) {
        // No updates needed
    }
}
