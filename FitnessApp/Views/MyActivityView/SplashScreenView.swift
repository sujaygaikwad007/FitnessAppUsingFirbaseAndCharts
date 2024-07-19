import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var manager: HealthManager
    @State var isNavigateHome = false
    @State var isNavigateWelcome = false

    var body: some View {
        ZStack {
            VStack {
                Text("iWellness")
                    .font(.custom("Impact", size: 44))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            NavigationLink(destination: HomeView().environmentObject(manager), isActive: $isNavigateHome, label: { EmptyView() })
            NavigationLink(destination: WelcomeView().environmentObject(manager), isActive: $isNavigateWelcome, label: { EmptyView() })
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .background(
            Image("introScreen")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .aspectRatio(contentMode: .fit)
        )
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if UserDefaults.standard.string(forKey: "accessToken") != nil {
                    isNavigateHome = true
                } else {
                    isNavigateWelcome = true
                }
            }
        }
    }
}
