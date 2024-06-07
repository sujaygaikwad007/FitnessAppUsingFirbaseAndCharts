import SwiftUI

@main
struct FitnessAppApp: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                WelcomeView()
                    .environmentObject(manager)
                    .navigationBarHidden(true)
            }
        }
    }
}
