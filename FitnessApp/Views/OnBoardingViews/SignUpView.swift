import SwiftUI
import FirebaseCore
import GoogleSignIn


struct SignUpView: View {
    @State  var fullNameText = ""
    @State  var emailText = ""
    @State  var passwordText = ""
    @State  var loggedUserName: String = ""
    @State  var isSignUpSuccessful = false
    @State  var isSignIn = false
    @State  var isHomeViewActive = false
    @EnvironmentObject var manager: HealthManager
    @ObservedObject var toastManager = ToastManager.shared
    @State var nameTFcolor = Color.gray
    @State var passwordTFcolor = Color.gray
    @State var emailTFcolor = Color.gray
    var body: some View {
        ZStack {
            Color.primaryBG.opacity(0.5)
            VStack {
                HStack{
                    Button(action: {
                        isSignIn = false
                        isSignIn.toggle()
                    }, label: {
                        Text("Sign in")
                            .font(.Montserrat_Regular15px)
                            .foregroundColor(.primaryTextColor)
                    })
                    Spacer()
                }
                .padding(.top,50)
                Text("iWellness")
                    .font(Font.Montserrat_Bold40px)
                    .padding(.top,50)
                
                CustomTextField(title: "Full Name", placeholder: "Enter a full name", text: $fullNameText, isSecure: false, color: $nameTFcolor)
                    .padding(.top,80)
                
                CustomTextField(title: "Email", placeholder: "Enter an email", text: $emailText, isSecure: false, color: $emailTFcolor)
                
                CustomTextField(title: "Password", placeholder: "Enter a password", text: $passwordText, isSecure: true, color: $passwordTFcolor)
                    .padding(.top,5)
                
                signUpButton
                    .padding(.top,70)
                HStack(spacing:5){
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 1)
                    Text("or")
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 1)
                }
                .padding(.horizontal,10)
                .padding(.top,30)
                
                socialMediaButtons
                    .padding(.top,10)
                
                navigationsLinks
                
 
            }
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.top)
            .padding(.horizontal, 20)
            .navigationBarHidden(true)
            
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
        .onChange(of: fullNameText, perform: { value in
            nameTFcolor = .gray
        })
        .onChange(of: emailText, perform: { value in
            emailTFcolor = .gray
        })
        .onChange(of: passwordText, perform: { value in
            passwordTFcolor = .gray
        })
    }
}

extension SignUpView {
    
    private var navigationsLinks: some View{
        Group{
            NavigationLink(destination: HomeView().environmentObject(manager), isActive: $isHomeViewActive) { EmptyView() }
                .navigationBarHidden(true)
            
            NavigationLink(destination: SignInView(email: emailText, password: passwordText, loggedUserName: loggedUserName).environmentObject(manager), isActive: $isSignUpSuccessful) {
                EmptyView()
            }
            
            NavigationLink(destination:SignInView(email: "", password: "", loggedUserName: "").environmentObject(manager) , isActive: $isSignIn) {
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
        HStack(spacing:40) {
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
        
        guard !fullNameText.isEmpty else {
            nameTFcolor = .red
            toastManager.showToast(text: "Please enter name", backgroundColor: .red)
            return
        }
        guard !emailText.isEmpty else {
            emailTFcolor = .red
            toastManager.showToast(text: "Please enter email", backgroundColor: .red)
            return
        }
        guard !passwordText.isEmpty else {
            passwordTFcolor = .red
            toastManager.showToast(text: "Please enter password", backgroundColor: .red)
            return
        }
        
        guard emailText.isEmailValid else {
            emailTFcolor = .red
            toastManager.showToast(text: "Invalid email format.", backgroundColor: .red)
            return
        }
        
        guard passwordText.isPasswordValid else {
            passwordTFcolor = .red
            toastManager.showToast(text: "Password must be 8-15 characters long and include at least one special character.", backgroundColor: .red)
            return
        }
        
        do {
            try await AuthManager.shared.signUpWithEmail(email: emailText, password: passwordText, displayName: fullNameText)
            DispatchQueue.main.async {
                self.isSignUpSuccessful.toggle()
                
            }
        } catch {
            toastManager.showToast(text: "\(error.localizedDescription)", backgroundColor: .red)
        }
    }
    
    @available(iOS 15.0, *)
    private func appleSignUpAction() async {
        do {
            let appleSignInHelper = AppleSignInAuthHelper()
            try await appleSignInHelper.appleSignIn { name in
                if let name = name {
                    self.isHomeViewActive.toggle()
                    self.loggedUserName = name
                    self.manager.startHealthDataFetching()
                }
            }
        } catch {
            toastManager.showToast(text: "\(error.localizedDescription)", backgroundColor: .red)
        }
    }
    
    
    @available(iOS 15.0, *)
    private func googleSignUpAction() async {
        do {
            let googleSignInHelper = GoogleSignInAuthHelper()
            try await googleSignInHelper.GogleSignIn { name in
                if let name = name {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        withAnimation {
                            self.isHomeViewActive = true
                            self.loggedUserName = name
                            self.manager.startHealthDataFetching()
                        }
                    })
                    
                }
            }
        } catch {
            toastManager.showToast(text: "\(error.localizedDescription)", backgroundColor: .red)
        }
    }
    
    
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        
        return root
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let healthManager = HealthManager()
        SignUpView().environmentObject(healthManager)
    }
}
