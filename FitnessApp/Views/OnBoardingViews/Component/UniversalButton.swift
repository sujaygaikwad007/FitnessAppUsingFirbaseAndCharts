import SwiftUI

struct UniversalButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(title)
                    .font(.Montserrat_Regular16px)
                    .foregroundColor(Color.black)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.PrimaryColor)
            .cornerRadius(16)
        })
    }
}

struct UniversalButton_Previews: PreviewProvider {
    static var previews: some View {
        UniversalButton(title: "Demo"){
            
        }
        
    }
}
