import SwiftUI

struct StatCard: View {
    let activity: ActivityModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            mainTitleAndIcon
            switch activity.title {
            case "Calories", "Walk":
                CircularProgressView(progress: progressValue(), unit: activity.unit, value: activity.amount, tintColor: activity.tintColor)
            case "Sleep", "Training", "Water", "Heart":
                if activity.title == "Water" || activity.title == "Heart" {
                    waterHeartImage
                }
                valueAndUnit
            default:
                Text("Unknown activity")
            }
        }
        .padding()
        .frame(height: cardHeight())
        .background(activity.bgColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
}

extension StatCard {
    private func cardHeight() -> CGFloat {
        return (activity.title == "Calories" || activity.title == "Walk" || activity.title == "Water" || activity.title == "Heart") ? 200 : 120
    }
  
    private func progressValue() -> Double {
        
        guard let amountValue = Double(activity.amount) else {
            return 0.0
        }
        
        if activity.title ==  "Calories"{
            let maxValue: Double = 3000
            return min(amountValue / maxValue, 1.0)
        } else if activity.title ==  "Walk" {
            let maxValue: Double = 10000
            return min(amountValue / maxValue, 1.0)
        }else{
            return 0.0
        }
        
    
    }
    
    private var mainTitleAndIcon: some View {
        HStack {
            Image(systemName: activity.image)
                .foregroundColor(activity.tintColor)
            Text(activity.title)
                .font(.headline)
                .foregroundColor(activity.tintColor)
        }
    }
    
    private var valueAndUnit: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(activity.amount)
                Text(activity.unit)
            }
            Image(systemName: "sleep.circle.fill")
                .font(.title)
                .opacity(activity.title == "Sleep" ? 1.0 : 0.0)
        }
    }
    
    private var waterHeartImage: some View {
        Image(activity.title == "Water" ? "Water" : "Heart")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 50)
    }
}
