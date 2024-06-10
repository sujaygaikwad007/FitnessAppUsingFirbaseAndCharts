import Foundation
import HealthKit

enum HealthDataType {
    case walk
    case calories
    case heartRate
    case waterIntake
    case sleep
}

class HealthService {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let healthTypes = getHealthTypes() else {
            completion(.failure(NSError(domain: "HealthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create health data types"])))
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { (success, error) in
            if let error = error {
                completion(.failure(error))
            } else if success {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "HealthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Authorization failed"])))
            }
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
    
    func fetchAllHealthData(completion: @escaping ([HealthDataType: Double]) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let dataTypes: [(HKSampleType, HKStatisticsOptions, HealthDataType)] = [
            (HKQuantityType.quantityType(forIdentifier: .stepCount)!, .cumulativeSum, .walk),
            (HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, .cumulativeSum, .calories),
            (HKQuantityType.quantityType(forIdentifier: .heartRate)!, .discreteAverage, .heartRate),
            (HKQuantityType.quantityType(forIdentifier: .dietaryWater)!, .cumulativeSum, .waterIntake),
            (HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!, .cumulativeSum, .sleep)
        ]
        
        var healthData: [HealthDataType: Double] = [:]
        
        let group = DispatchGroup()
        
        for (sampleType, options, dataType) in dataTypes {
            group.enter()
            if let quantityType = sampleType as? HKQuantityType {
                executeStatisticsQuery(for: quantityType, options: options, predicate: predicate, dataType: dataType) { value in
                    healthData[dataType] = value
                    group.leave()
                }
            } else if let categoryType = sampleType as? HKCategoryType {
                executeSampleQuery(for: categoryType, predicate: predicate, dataType: dataType) { value in
                    healthData[dataType] = value
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(healthData)
        }
    }
    
    private func executeStatisticsQuery(for quantityType: HKQuantityType, options: HKStatisticsOptions, predicate: NSPredicate, dataType: HealthDataType, completion: @escaping (Double) -> Void) {
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching \(dataType) data: \(error?.localizedDescription ?? "Unknown error")")
                completion(0)
                return
            }
            
            DispatchQueue.main.async {
                switch dataType {
                case .walk:
                    if let quantity = result.sumQuantity() {
                        let stepCount = quantity.doubleValue(for: .count())
                        completion(stepCount)
                    }
                case .calories:
                    if let quantity = result.sumQuantity() {
                        let totalCalories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        completion(totalCalories)
                    }
                case .heartRate:
                    if let quantity = result.averageQuantity() {
                        let heartRate = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                        completion(heartRate)
                    }
                case .waterIntake:
                    if let quantity = result.sumQuantity() {
                        let waterIntake = quantity.doubleValue(for: HKUnit.liter())
                        completion(waterIntake)
                    }
                default:
                    completion(0)
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func executeSampleQuery(for categoryType: HKCategoryType, predicate: NSPredicate, dataType: HealthDataType, completion: @escaping (Double) -> Void) {
        let query = HKSampleQuery(sampleType: categoryType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let results = results as? [HKCategorySample], error == nil else {
                print("Error fetching \(dataType) data: \(error?.localizedDescription ?? "Unknown error")")
                completion(0)
                return
            }
            
            DispatchQueue.main.async {
                let totalSleepMinutes = results.reduce(0) { $0 + Int($1.endDate.timeIntervalSince($1.startDate)) / 60 }
                let hours = totalSleepMinutes / 60
                let minutes = totalSleepMinutes % 60
                completion(Double(totalSleepMinutes))
            }
        }
        healthStore.execute(query)
    }

    func fetchCurrentWeekWorkoutsStats(completion: @escaping (Int) -> Void) {
        let workoutType = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts data: \(String(describing: error))")
                completion(0)
                return
            }
            
            let totalTimeRunning = workouts.reduce(0) { $0 + Int($1.duration) / 60 }
            completion(totalTimeRunning)
        }
        healthStore.execute(query)
    }
}
