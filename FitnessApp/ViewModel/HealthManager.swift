import Foundation
import HealthKit

enum HealthDataType {
    case steps
    case calories
    case heartRate
    case waterIntake
    case sleep
}

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    init() {
        requestAuthorizationAndFetchData()
    }
    
    private func requestAuthorizationAndFetchData() {
        guard let healthTypes = getHealthTypes() else {
            print("Unable to create health data types")
            return
        }
        
        if #available(iOS 15.0, *) {
            Task {
                do {
                    try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                    print("Authorization successful")
                    fetchAllHealthData()
                    fetchCurrentWeekWorkoutsStats()
                } catch {
                    print("Error requesting authorization: \(error.localizedDescription)")
                }
            }
        } else {
            print("iOS version not supported")
        }
    }
    
    private func getHealthTypes() -> Set<HKSampleType>? {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let waterIntakeType = HKQuantityType.quantityType(forIdentifier: .dietaryWater),
              let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return nil
        }
        
        let workoutType = HKObjectType.workoutType()
        return [stepsType, caloriesType, heartRateType, waterIntakeType, sleepType, workoutType]
    }
    
    private func fetchAllHealthData() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let dataTypes: [(HKSampleType, HKStatisticsOptions, HealthDataType)] = [
            (HKQuantityType.quantityType(forIdentifier: .stepCount)!, .cumulativeSum, .steps),
            (HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, .cumulativeSum, .calories),
            (HKQuantityType.quantityType(forIdentifier: .heartRate)!, .discreteAverage, .heartRate),
            (HKQuantityType.quantityType(forIdentifier: .dietaryWater)!, .cumulativeSum, .waterIntake),
            (HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!, .cumulativeSum, .sleep)
        ]
        
        for (sampleType, options, dataType) in dataTypes {
            if let quantityType = sampleType as? HKQuantityType {
                executeStatisticsQuery(for: quantityType, options: options, predicate: predicate, dataType: dataType)
            } else if let categoryType = sampleType as? HKCategoryType {
                executeSampleQuery(for: categoryType, predicate: predicate, dataType: dataType)
            }
        }
    }
    
    private func executeStatisticsQuery(for quantityType: HKQuantityType, options: HKStatisticsOptions, predicate: NSPredicate, dataType: HealthDataType) {
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching \(dataType) data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                switch dataType {
                case .steps:
                    if let quantity = result.sumQuantity() {
                        let stepCount = quantity.doubleValue(for: HKUnit.count())
                        print("Total steps: \(stepCount.formattedString() ?? "0")")
                    }
                case .calories:
                    if let quantity = result.sumQuantity() {
                        let totalCalories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        print("Total Calories: \(totalCalories.formattedString() ?? "0")")
                    }
                case .heartRate:
                    if let quantity = result.averageQuantity() {
                        let heartRate = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                        print("Average Heart Rate: \(heartRate.formattedString() ?? "0") bpm")
                    }
                case .waterIntake:
                    if let quantity = result.sumQuantity() {
                        let waterIntake = quantity.doubleValue(for: HKUnit.liter())
                        print("Total Water Intake: \(waterIntake) liters")
                    }
                default:
                    break
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func executeSampleQuery(for categoryType: HKCategoryType, predicate: NSPredicate, dataType: HealthDataType) {
        let query = HKSampleQuery(sampleType: categoryType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let results = results as? [HKCategorySample], error == nil else {
                print("Error fetching \(dataType) data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                let totalSleepMinutes = results.reduce(0) { $0 + Int($1.endDate.timeIntervalSince($1.startDate)) / 60 }
                print("Total Sleep: \(totalSleepMinutes) minutes")
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchCurrentWeekWorkoutsStats() {
        let workoutType = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: Date.startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts data: \(String(describing: error))")
                return
            }
            
            let totalTimeRunning = workouts.reduce(0) { $0 + Int($1.duration) / 60 }
            
            DispatchQueue.main.async {
                print("Total Running Time: \(totalTimeRunning) minutes")
            }
        }
        healthStore.execute(query)
    }
}

