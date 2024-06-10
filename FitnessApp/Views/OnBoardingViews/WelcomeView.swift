import SwiftUI

struct WelcomeView: View {
    @State var currentIndex = 0
    @State private var navigateToNextView = false
    

    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            VStack {
                ImageSlider(currentIndex: $currentIndex, navigateToNextView: $navigateToNextView)
                    .frame(height: 600)
                
                Spacer()
                
                BottomButton(currentIndex: $currentIndex)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
