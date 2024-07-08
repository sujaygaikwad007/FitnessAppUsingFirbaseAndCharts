import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding()
                    .clipShape(Capsule())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.caption)
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .clipShape(Capsule())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        CustomTextField(title: "Email", placeholder: "Enter your email", text: $text, isSecure: true)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
