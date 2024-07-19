import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
   @Binding var color : Color
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.Montserrat_SemiBold14px)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.Montserrat_Regular14px)
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(Capsule())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color, lineWidth: 0.5)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.Montserrat_Regular14px)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .clipShape(Capsule())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color, lineWidth: 0.5)
                    )
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        CustomTextField(title: "Email", placeholder: "Enter your email", text: $text, isSecure: true, color: .constant(.gray))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
