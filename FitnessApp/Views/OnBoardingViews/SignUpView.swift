import SwiftUI

struct SignUpView: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var loggedUserName: String = ""
    @State private var isSignUpSuccessful = false
    @State private var isSignIn = false
    @State private var isHomeViewActive = false
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        ZStack {
            VStack {
                Text("Sign UP")
                    .font(.title)

                CustomTextField(title: "Email", placeholder: "Enter an email", text: $emailText, isSecure: false)

                CustomTextField(title: "Password", placeholder: "Enter a password", text: $passwordText, isSecure: true)

                signUpButton

                LineTextLine(text: "Or")
                
                UniversalButton(title: "Sign In") {
                    isSignIn = true
                }

                socialMediaButtons
                navigationLinks
            }
            .padding(.horizontal, 20)
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
    }
}

extension SignUpView {
    
    private var navigationLinks : some View{
        Group{
            
            NavigationLink(destination: SignInView(email: emailText, password: passwordText, loggedUserName: loggedUserName).environmentObject(manager), isActive: $isSignUpSuccessful) {
                EmptyView()
            }
            
            NavigationLink(destination:SignInView(email: "", password: "", loggedUserName: "").environmentObject(manager) , isActive: $isSignIn) {
                EmptyView()
            }
            
            NavigationLink(destination: HomeView( loggedUserName:loggedUserName).environmentObject(manager), isActive: $isHomeViewActive) {
                EmptyView()
            }
            
        }
    }

    private var signUpButton: some View {
        UniversalButton(title: "Sign Up") {
            if #available(iOS 15.0, *) {
                Task {
                    await signUpAction()
                }
            } else {
                // Fallback for older iOS versions
            }
        }
    }

    private var socialMediaButtons: some View {
        HStack {
            CircularImageButton(imageName: "Apple") {
                if #available(iOS 15.0, *) {
                    Task {
                        await appleSignUpAction()
                    }
                } else {
                    // Fallback for older iOS versions
                }
            }

            CircularImageButton(imageName: "Google") {
                if #available(iOS 15.0, *) {
                    Task {
                        await googleSignUpAction()
                    }
                } else {
                    // Fallback for older iOS versions
                }
            }
        }
    }

    @available(iOS 15.0, *)
    private func signUpAction() async {
        do {
            try await AuthManager.shared.signUpWithEmail(email: emailText, password: passwordText)
            DispatchQueue.main.async {
                isSignUpSuccessful = true
            }
        } catch {
            print("Failed to sign up: \(error.localizedDescription)")
        }
    }

    @available(iOS 15.0, *)
    private func appleSignUpAction() async {
        do {
            let appleSignInHelper = AppleSignInAuthHelper()
            try await appleSignInHelper.appleSignIn()
            DispatchQueue.main.async {
                self.isHomeViewActive = true
            }
        } catch {
            print("Failed to apple signIn: \(error.localizedDescription)")
        }
    }

    @available(iOS 15.0, *)
    private func googleSignUpAction() async {
        do {
            let googleSignInHelper = GoogleSignInAuthHelper()
            try await googleSignInHelper.GogleSignIn { name in
                if let name = name {
                    self.isHomeViewActive = true
                    self.loggedUserName = name
                    self.manager.startHealthDataFetching()
                }
            }
        } catch {
            print("Failed to google signIn: \(error.localizedDescription)")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let healthManager = HealthManager()
        SignUpView().environmentObject(healthManager)
    }
}
