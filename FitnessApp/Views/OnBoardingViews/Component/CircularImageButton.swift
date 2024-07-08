import SwiftUI

struct CircularImageButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .padding(22)
                .background(Color.white)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }
}

struct CircularImageButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularImageButton(imageName: "Apple") {
            print("Button tapped")
        }
    }
}
