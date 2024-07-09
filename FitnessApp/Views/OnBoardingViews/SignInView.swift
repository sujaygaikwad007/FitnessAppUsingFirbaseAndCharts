import SwiftUI

struct SignInView: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isSignInSuccessful = false
    @State private var loggedUserName: String = ""
    @EnvironmentObject var manager: HealthManager

    init(email: String, password: String, loggedUserName: String) {
        self._emailText = State(initialValue: email)
        self._passwordText = State(initialValue: password)
        self._loggedUserName = State(initialValue: loggedUserName)
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Sign In")
                    .font(.title)

                CustomTextField(title: "Email", placeholder: "Enter an email", text: $emailText, isSecure: false)

                CustomTextField(title: "Password", placeholder: "Enter a password", text: $passwordText, isSecure: true)

                UniversalButton(title: "Sign In") {
                    if #available(iOS 15.0, *) {
                        Task {
                            await signInAction()
                        }
                    } else {
                        // Fallback for older iOS versions
                    }
                }

                NavigationLink(destination: HomeView(loggedUserName: loggedUserName).environmentObject(manager), isActive: $isSignInSuccessful) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 20)
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
    }
}

extension SignInView {

    @available(iOS 15.0.0, *)
    private func signInAction() async {
        do {
            try await AuthManager.shared.signInWithEmail(email: emailText, password: passwordText)
            DispatchQueue.main.async {
                isSignInSuccessful = true
            }
        } catch {
            print("Failed to sign up: \(error.localizedDescription)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(email: "", password: "", loggedUserName: "")
    }
}
