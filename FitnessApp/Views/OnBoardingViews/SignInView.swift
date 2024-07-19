import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isSignInSuccessful = false
    @State private var isGotoSigUp = false
    @State private var loggedUserName: String = ""
    @State var emailTFcolor = Color.gray
    @State var PasswordTFcolor = Color.gray
//    @EnvironmentObject var manager: HealthManager
    @ObservedObject var toastManager = ToastManager.shared
    init(email: String, password: String, loggedUserName: String) {
        self._emailText = State(initialValue: email)
        self._passwordText = State(initialValue: password)
        self._loggedUserName = State(initialValue: loggedUserName)
    }

    var body: some View {
        ZStack {
            Color.primaryBG.opacity(0.5)
            VStack{
                Text("iWellness")
                    .font(Font.Montserrat_Bold40px)
                        .padding(.top,120)
                
                CustomTextField(title: "Email", placeholder: "Enter an email", text: $emailText, isSecure: false, color: $emailTFcolor)
                        .padding(.top,120)
                
                CustomTextField(title: "Password", placeholder: "Enter a password", text: $passwordText, isSecure: true, color: $PasswordTFcolor)
                        .padding(.top,10)
                HStack{
                    Spacer()
                    Button(action: {}, label: {
                        Text("Forgot Password?")
                            .font(.Montserrat_Regular16px)
                            .foregroundColor(.primaryTextColor)
                    })
                }
                .padding(.top,4)
                UniversalButton(title: "Sign In") {
                    if #available(iOS 15.0, *) {
                        Task {
                            await signInAction()
                        }
                    } else {
                        // Fallback for older iOS versions
                    }
                }
                .padding(.top,40)
                
                HStack{
                    Text("Don’t have an account?")
                        .font(.Montserrat_Regular15px)
                        .foregroundColor(.primaryTextColor)
                    Button(action: {
                        isGotoSigUp = false
                        isGotoSigUp.toggle()
                    }, label: {
                        Text("Sign up")
                            .font(.Montserrat_SemiBold16px)
                            .foregroundColor(.primaryTextColor)
                    })
                }
                .padding(.top,50)
                
            }
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.top)
            .padding(.horizontal, 20)
            .navigationBarHidden(true)
            
            NavigationLink(destination: SplashScreenView().environmentObject(HealthManager()), isActive: $isSignInSuccessful) {
                               EmptyView()
                           } 
            NavigationLink(destination: SignUpView().environmentObject(HealthManager()), isActive: $isGotoSigUp) {
                               EmptyView()
                           }
            
            if toastManager.isShowing {
                           ToastView(text: toastManager.text, backgroundColor: toastManager.backgroundColor)
                       }
        }
        .edgesIgnoringSafeArea(.all)
        .background(
        Image("BgImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.topLeading)
        )
        //.background(Color.primaryBG)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        
        .onAppear(perform: {
            if (UserDefaults.standard.string(forKey: "accessToken") != nil){
                isSignInSuccessful = false
                isSignInSuccessful.toggle()
            }
        })
        .onChange(of: emailText, perform: { value in
            emailTFcolor = .gray
        })
        .onChange(of: passwordText, perform: { value in
            PasswordTFcolor = .gray
        })
    }
}

extension SignInView {

    @available(iOS 15.0.0, *)
    private func signInAction() async {
        
        guard !emailText.isEmpty else {
            emailTFcolor = .red
            toastManager.showToast(text: "Please enter email", backgroundColor: .red)
            return
        }
        
        guard !passwordText.isEmpty else {
            PasswordTFcolor = .red
            toastManager.showToast(text: "Please enter password", backgroundColor: .red)
            return
        }
        
        guard emailText.isEmailValid else {
            emailTFcolor = .red
            toastManager.showToast(text: "Invalid email format.", backgroundColor: .red)
            return
        }
        
        guard passwordText.isPasswordValid else {
            PasswordTFcolor = .red
            toastManager.showToast(text: "Password must be 8-15 characters long and include at least one special character.", backgroundColor: .red)
            return
        }
        
        do {
            let accessToken = try await AuthManager.shared.signInWithEmail(email: emailText, password: passwordText)
            print("Access token received: \(accessToken)")
            let user = Auth.auth().currentUser
            let displayName = user?.displayName ?? "Unknown"
            DispatchQueue.main.async {
                HealthManager().startHealthDataFetching()
                UserDefaults.standard.set(accessToken.uid, forKey: "accessToken")
                UserDefaults.standard.set(displayName,forKey: "Fname")
                isSignInSuccessful = false
                isSignInSuccessful.toggle()
                
            }
        } catch {
            toastManager.showToast(text: "Failed to sign in: \(error.localizedDescription)", backgroundColor: .red)
        }
        
        
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(email: "", password: "", loggedUserName: "")
    }
}
