
import Firebase
import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    private let healthService = HealthService()
    private var databaseRef: DatabaseReference!
    
    @Published var activityData: [ActivityModel] = []
    @Published var activities: [String: ActivityModel] = [:]
    @Published var fetchedData: [String: Any] = [:]
    
    init() {
        databaseRef = Database.database().reference()
    }
    
    func startHealthDataFetching() {
        requestAuthorizationAndFetchData()
    }
    
    private func requestAuthorizationAndFetchData() {
        healthService.requestAuthorization { [weak self] result in
            switch result {
            case .success:
                print("HealthManager Authorization successful")
                self?.fetchAllHealthData()
                self?.fetchCurrentWeekWorkoutsStats()
            case .failure(let error):
                print("Error requesting authorization: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchAllHealthData() {
        healthService.fetchAllHealthData { [weak self] healthData in
            DispatchQueue.main.async {
                var dataToUpload: [String: Any] = [:]
                
                for (dataType, value) in healthData {
                    var activity: ActivityModel
                    
                    switch dataType {
                    case .walk:
                        activity = ActivityModel(id: 1, title: "Walk", image: "figure.walk", unit: "Steps", amount: "\(Int(value))", IconBGcolor: .accentColor)
                        self?.activities["todayStep"] = activity
                        dataToUpload["Walk"] = Int(value)
                        print("Total steps: \(Int(value))")
                    case .calories:
                        activity = ActivityModel(id: 5, title: "Calories", image: "flame", unit: "Kcal", amount: "\(value.formattedString() ?? "0")", IconBGcolor: Color("OrangeBG"))
                        self?.activities["todayCalory"] = activity
                        dataToUpload["Calories"] = value
                        print("Total Calories: \(value.formattedString() ?? "0")")
                    case .heartRate:
                        activity = ActivityModel(id: 0, title: "Heart", image: "heart", unit: "bpm", amount: "\(value.formattedString() ?? "0")", IconBGcolor: Color("OrangeBG"))
                        self?.activities["heartRate"] = activity
                        dataToUpload["HeartRate"] = value
                        print("Average Heart Rate: \(value.formattedString() ?? "0") bpm")
                    case .waterIntake:
                        let waterIntake = value * 1000
                        activity = ActivityModel(id: 2, title: "Water", image: "drop", unit: "ml", amount: "\(waterIntake.formattedString() ?? "0")", IconBGcolor: Color.blue.opacity(0.8))
                        self?.activities["water"] = activity
                        dataToUpload["WaterIntake"] = waterIntake
                        print("Total Water Intake: \(value.formattedString() ?? "0") liters")
                    case .sleep:
                        let hours = Int(value) / 60
                        let minutes = Int(value) % 60
                        activity = ActivityModel(id: 3, title: "Sleep", image: "moon", unit: "", amount: "\(hours)h \(minutes)m", IconBGcolor: .yellow.opacity(0.8))
                        self?.activities["sleep"] = activity
                        
                        //dataToUpload["Sleep"] = ["hours": hours, "minutes": minutes]
                        dataToUpload["Sleep"] = hours * 60 + minutes

                        print("Total Sleep: \(hours) hours and \(minutes) minutes")
                    }
                }
                
                // Sending data to Firebase Realtime Database
                if let user = Auth.auth().currentUser {
                   let username = user.displayName ?? "unknown"
                    let userID = user.uid
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = dateFormatter.string(from: Date())
                    let loggedUserEmail = Auth.auth().currentUser?.email ?? ""
                    
                    dataToUpload["Email"] = loggedUserEmail
                    
                    print("Email of logged user----",Auth.auth().currentUser?.email ?? "")
                    
                    self?.databaseRef.child(todayDate).child(userID).child(username).setValue(dataToUpload) { error, _ in
                        if let error = error {
                            print("Error writing data to Firebase: \(error.localizedDescription)")
                        } else {
                            print("Data successfully written to Firebase")
                        }
                    }
                } else {
                    print("No authenticated user found.")
                }
            }
        }
    }
    
    //Fetch trianing data
    private func fetchCurrentWeekWorkoutsStats() {
        healthService.fetchCurrentWeekWorkoutsStats { [weak self] totalTimeRunning in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // Debug print
                print("Fetched totalTimeRunning: \(totalTimeRunning)")
                
                let activity = ActivityModel(id: 4, title: "Training", image: "stopwatch", unit: "Mins", amount: "\(totalTimeRunning)", IconBGcolor: .accentColor)
                self.activities["training"] = activity
                print("Total Running Time: \(totalTimeRunning) minutes")
                
                // Check if user is authenticated
                guard let user = Auth.auth().currentUser else {
                    print("No authenticated user found.")
                    return
                }
                let username = user.displayName ?? "Unknown"
                print("Authenticated user: \(username)")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = dateFormatter.string(from: Date())
                let userID = Auth.auth().currentUser?.uid ?? ""
                
                // Debug print
                print("Today's date: \(todayDate)")
                
                // Firebase path
                let path = self.databaseRef.child(todayDate).child(userID).child(username).child("Training")
                print("Firebase path: \(path)")
                
                // Check if the path already has data
                path.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        print("Path already has data: \(snapshot.value ?? "No data")")
                    } else {
                        print("Path has no data, proceeding to write.")
                    }
                    
                    // Sending workout stats to Firebase Realtime Database
                    path.setValue(totalTimeRunning) { error, _ in
                        if let error = error {
                            print("Error writing data to Firebase: \(error.localizedDescription)")
                        } else {
                            print("Training data successfully written to Firebase")
                        }
                    }
                } withCancel: { error in
                    print("Error observing path in Firebase: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //Fetch all data from firebase
    func fetchDataForDate(_ date: String, completion: @escaping ([String: Any]?) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user found.")
            completion(nil)
            return
        }
        let username = user.displayName ?? "Unknown"
        let userID = user.uid
        
        databaseRef.child(date).child(userID).child(username).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("No data found for the given date.")
                completion(nil)
                return
            }
            
            print("Data for \(date): \(value)")
            self.fetchedData = value
            completion(value)
        } withCancel: { error in
            print("Error fetching data from Firebase: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
}
