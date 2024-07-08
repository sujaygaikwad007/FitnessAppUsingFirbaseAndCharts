import Foundation
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import KeychainAccess

struct AppleSignInResultModel {
    let token: String
    let nonce: String
}

@available(iOS 15.0, *)
final class AppleSignInAuthHelper: NSObject, ObservableObject {

    private var currentNonce: String?
    @Published var didSignWithApple: Bool = false

    private let keychain = Keychain(service: "Reapmind.FitnessApp")

    @MainActor
    func appleSignIn() async throws {
        startSignInWithAppleFlow()
    }

    @MainActor
    func startSignInWithAppleFlow() {
        guard let topVc = Utilities.topViewController() else {
            return
        }

        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVc
        authorizationController.performRequests()
    }

    // Nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 15, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

@available(iOS 15.0, *)
extension AppleSignInAuthHelper: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce else
        {
            print("Error")
            return
        }

        let tokens = AppleSignInResultModel(token: idTokenString, nonce: nonce)

        Task {
            do {
                try await AuthManager.shared.signInWithApple(tokens: tokens)
                
                // Store user data in Keychain
                try storeUserData(appleIDCredential: appleIDCredential)

                self.didSignWithApple = true
            } catch {
                print("Error signing in with Apple: \(error)")
            }
        }

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

    private func storeUserData(appleIDCredential: ASAuthorizationAppleIDCredential) throws {
        if let fullName = appleIDCredential.fullName {
            let fullNameString = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
            print("Fullname apple---", fullNameString)
            try keychain.set(fullNameString, key: "userFullName")
        }
        if let email = appleIDCredential.email {
            try keychain.set(email, key: "userEmail")
        }
        try keychain.set(appleIDCredential.identityToken!, key: "appleIDToken")
    }
}
