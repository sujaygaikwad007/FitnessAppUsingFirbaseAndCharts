import Firebase
import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    private let healthService = HealthService()
    private var databaseRef: DatabaseReference!
    
    @Published var activityData: [ActivityModel] = []
    @Published var activities: [String: ActivityModel] = [:]
    
    init() {
        requestAuthorizationAndFetchData()
        databaseRef = Database.database().reference()
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
                        activity = ActivityModel(id: 3, title: "Walk", image: "figure.walk", unit: "Steps", amount: "\(Int(value))", tintColor: .black, bgColor: .white)
                        self?.activities["todayStep"] = activity
                        dataToUpload["Walk"] = Int(value)
                        print("Total steps: \(Int(value))")
                    case .calories:
                        activity = ActivityModel(id: 0, title: "Calories", image: "flame", unit: "Kcal", amount: "\(value.formattedString() ?? "0")", tintColor: .white, bgColor: Color.theme.accent)
                        self?.activities["todayCalory"] = activity
                        dataToUpload["Calories"] = value
                        print("Total Calories: \(value.formattedString() ?? "0")")
                    case .heartRate:
                        activity = ActivityModel(id: 5, title: "Heart", image: "heart", unit: "Score", amount: "\(value.formattedString() ?? "0")", tintColor: .black, bgColor: .white)
                        self?.activities["heartRate"] = activity
                        dataToUpload["HeartRate"] = value
                        print("Average Heart Rate: \(value.formattedString() ?? "0") bpm")
                    case .waterIntake:
                        activity = ActivityModel(id: 2, title: "Water", image: "drop", unit: "Liters'", amount: "\(value.formattedString() ?? "0")", tintColor: .black, bgColor: .white)
                        self?.activities["water"] = activity
                        dataToUpload["WaterIntake"] = value
                        print("Total Water Intake: \(value.formattedString() ?? "0") liters")
                    case .sleep:
                        let hours = Int(value) / 60
                        let minutes = Int(value) % 60
                        activity = ActivityModel(id: 1, title: "Sleep", image: "moon", unit: "", amount: "\(hours)h \(minutes)m", tintColor: .black, bgColor: .white)
                        self?.activities["sleep"] = activity
                        dataToUpload["Sleep"] = ["hours": hours, "minutes": minutes]
                        print("Total Sleep: \(hours) hours and \(minutes) minutes")
                    }
                }
                
                // Sending data to Firebase Realtime Database
                if let username = Auth.auth().currentUser?.displayName {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = dateFormatter.string(from: Date())
                    
                    self?.databaseRef.child(todayDate).child(username).setValue(dataToUpload) { error, _ in
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
    
    private func fetchCurrentWeekWorkoutsStats() {
        healthService.fetchCurrentWeekWorkoutsStats { [weak self] totalTimeRunning in
            DispatchQueue.main.async {
                let activity = ActivityModel(id: 4, title: "Training", image: "stopwatch", unit: "Mins", amount: "\(totalTimeRunning)", tintColor: .black, bgColor: .white)
                self?.activities["training"] = activity
                print("Total Running Time: \(totalTimeRunning) minutes")
                
                // Sending workout stats to Firebase Realtime Database
                if let username = Auth.auth().currentUser?.displayName {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = dateFormatter.string(from: Date())
                    
                    self?.databaseRef.child(todayDate).child(username).child("Training").setValue(totalTimeRunning) { error, _ in
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
}
