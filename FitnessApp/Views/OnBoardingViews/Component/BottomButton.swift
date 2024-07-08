import SwiftUI

struct BottomButton: View {
    @Binding var currentIndex: Int
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        Group {
            //HomeView().environmentObject(manager) 
            if currentIndex == sliderItems.count - 1 {
                NavigationLink(destination: SignUpView().environmentObject(manager)  ) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color("btnBg"))
                                .shadow(radius: 5)
                        )
                }
            } else {
                Button(action: {
                    currentIndex = (currentIndex + 1) % sliderItems.count
                }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color("btnBg"))
                                .shadow(radius: 5)
                        )
                }
            }
        }
    }
}


struct BottomButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomButton(currentIndex: .constant(1))
    }
}
