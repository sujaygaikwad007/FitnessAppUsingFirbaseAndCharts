//Apple sign In auth
import Foundation
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import KeychainAccess

struct AppleSignInResultModel {
    let token: String
    let nonce: String
    let name: String?
    let surname: String?
}

@available(iOS 15.0, *)
final class AppleSignInAuthHelper: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    private var currentNonce: String?
    @Published var didSignWithApple: Bool = false

    private let keychain = Keychain(service: "Reapmind.FitnessApp")

    @MainActor
    func appleSignIn(completion: @escaping (String?) -> Void) async throws {
        startSignInWithAppleFlow(completion: completion)
    }

    @MainActor
    private func startSignInWithAppleFlow(completion: @escaping (String?) -> Void) {
        guard let topVc = Utilities.topViewController() else {
            completion(nil)
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
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        // Save completion handler for later use
        self.completionHandler = completion
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

    // Added to store completion handler
    private var completionHandler: ((String?) -> Void)?

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce else
        {
            print("Error")
            self.completionHandler?(nil)
            return
        }

        let name = appleIDCredential.fullName?.givenName
        let surname = appleIDCredential.fullName?.familyName
        
        let tokens = AppleSignInResultModel(token: idTokenString, nonce: nonce, name: name, surname: surname)

        Task {
            do {
                try await AuthManager.shared.signInWithApple(tokens: tokens)
                
                // Store user data in Keychain
                try storeUserData(appleIDCredential: appleIDCredential)

                self.didSignWithApple = true
                
                self.completionHandler?(name)
                
            } catch {
                print("Error signing in with Apple: \(error)")
                self.completionHandler?(nil)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
        self.completionHandler?(nil)
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

    // Conform to ASAuthorizationControllerPresentationContextProviding
    @MainActor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let topVc = Utilities.topViewController() else {
            fatalError("Unable to find top view controller")
        }
        return topVc.view.window!
    }
}

