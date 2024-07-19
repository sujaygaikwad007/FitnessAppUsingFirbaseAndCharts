import SwiftUI

struct ImageSlider: View {
    @Binding var currentIndex: Int
    @Binding var navigateToNextView: Bool
    @EnvironmentObject var manager: HealthManager


    var body: some View {
        
        TabView(selection: $currentIndex) {
            ForEach(sliderItems.indices, id: \.self) { index in
                VStack {
                    Image(sliderItems[index].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .background(
                            Circle()
                                .fill(Color(sliderItems[index].bgColor))
                                .frame(width: 200, height: 200)
                        )
                    
                    VStack(spacing: 20) {
                        Text(sliderItems[index].title)
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                        
                        Text(sliderItems[index].description)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .background(
            //HomeView().environmentObject(manager)
            NavigationLink(destination: SignUpView().environmentObject(manager), isActive: $navigateToNextView) {
                EmptyView()
            }
        )
    }
}




