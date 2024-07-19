//Validation
import Foundation

extension String {
    
    var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isPasswordValid: Bool {
        let passwordRegEx = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}")
        return passwordRegEx.evaluate(with: self)
    }
    

}
//Custom Toast
import SwiftUI

// ToastView definition
struct ToastView: View {
    let text: String
    let backgroundColor: Color
    var alignment: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 10)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: alignment)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment == true ? .center : .bottom)
        .padding()
    }
}

// ToastManager definition
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var text = ""
    @Published var backgroundColor = Color.blue

    private init() {}

    func showToast(text: String, backgroundColor: Color) {
        
        DispatchQueue.main.async {
            self.text = text
            self.backgroundColor = backgroundColor
            self.isShowing = true
        }
        
        // Hide the toast after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isShowing = false
        }
    }
}
