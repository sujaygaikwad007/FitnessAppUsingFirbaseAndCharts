import SwiftUI
import Firebase
import GoogleSignIn

@main
struct FitnessAppApp: App {
    @StateObject var manager = HealthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    .environmentObject(manager)
                    .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase Success!!")
        return true
    }
    @available(iOS 9.0, *)
        func application(_ application: UIApplication, open url: URL,
                         options: [UIApplication.OpenURLOptionsKey: Any])
          -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
        }
}
