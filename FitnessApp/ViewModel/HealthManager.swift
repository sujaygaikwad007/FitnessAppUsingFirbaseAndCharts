import Foundation
import SwiftUI

class HealthManager: ObservableObject {
    private let healthService = HealthService()
    
    @Published var activityData: [ActivityModel] = []
    @Published var activities: [String : ActivityModel] = [:]
    
    init() {
        requestAuthorizationAndFetchData()
    }
    
    private func requestAuthorizationAndFetchData() {
        healthService.requestAuthorization { [weak self] result in
            switch result {
            case .success:
                print("Authorization successful")
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
                for (dataType, value) in healthData {
                    switch dataType {
                    case .walk:
                        let activity = ActivityModel(id: 3, title: "Walk", image: "figure.walk", unit: "Steps", amount: "\(Int(value))", tintColor: .black, bgColor: .white)
                        self?.activities["todayStep"] = activity
                        print("Total steps: \(Int(value))")
                    case .calories:
                        let activity = ActivityModel(id: 0, title: "Calories", image: "flame", unit: "Kcal", amount: "\(value.formattedString() ?? "0")", tintColor: .white, bgColor: Color.theme.accent)
                        self?.activities["todayCalory"] = activity
                        print("Total Calories: \(value.formattedString() ?? "0")")
                    case .heartRate:
                        let activity = ActivityModel(id: 5, title: "Heart", image: "heart", unit: "Score", amount: "\(value.formattedString() ?? "0")", tintColor: .black, bgColor: .white)
                        self?.activities["heartRate"] = activity
                        print("Average Heart Rate: \(value.formattedString() ?? "0") bpm")
                    case .waterIntake:
                        let activity = ActivityModel(id: 2, title: "Water", image: "drop", unit: "Liters'", amount: "\(value.formattedString() ?? "0")", tintColor: .black, bgColor: .white)
                        self?.activities["water"] = activity
                        print("Total Water Intake: \(value.formattedString() ?? "0") liters")
                    case .sleep:
                        let hours = Int(value) / 60
                        let minutes = Int(value) % 60
                        let activity = ActivityModel(id: 1, title: "Sleep", image: "moon", unit: "", amount: "\(hours)h \(minutes)m", tintColor: .black, bgColor: .white)
                        self?.activities["sleep"] = activity
                        print("Total Sleep: \(hours) hours and \(minutes) minutes")
                    }
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
            }
        }
    }
}
