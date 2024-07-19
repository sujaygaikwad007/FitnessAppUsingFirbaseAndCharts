import SwiftUI

struct NavTitleView: View {
    @State var navTitle = ""
    @State var imageName = ""
    
    var body: some View {
        HStack {
            Text(navTitle)
                .font(.largeTitle)
                .bold()
                //.foregroundColor(Color.primaryTextColor)
            Spacer()
            Image(systemName: "\(imageName)")
                .font(.title2)
                //.foregroundColor(Color.primaryTextColor)
        }
        .padding()
        
    }
}

struct NavTitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavTitleView(navTitle:"Demo",imageName: "xmark")
    }
}
