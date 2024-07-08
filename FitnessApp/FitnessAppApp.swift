//Reapmind.FitnessApp
//com.andconnection.live
import SwiftUI
import Firebase
import GoogleSignIn

@main
struct FitnessAppApp: App {
    @StateObject var manager = HealthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Firebase Success!!")

    return true
  }
}

