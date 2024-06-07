import SwiftUI

enum StatTitle: String {
    case calories = "Calories"
    case walk = "Walk"
    case sleep = "Sleep"
    case training = "Training"
    case water = "Water"
    case heart = "Heart"
}

struct StatCard: View {
    
    let icon: String
    let title: StatTitle
    let value: Any
    let unit: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            mainTitleAndIcon
            switch title {
            case .calories, .walk:
                CircularProgressView(progress: progressValue(), unit: unit, value: value)
            case .sleep, .training, .water, .heart:
                if title == .water || title == .heart {
                    waterHeartImage
                }
                valueAndUnit
            }
        }
        .padding()
        .frame(height: cardHeight())
        .background(title == .calories || title == .walk ? Color.theme.accent : Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    
}

extension StatCard{
    
    private func cardHeight() -> CGFloat {
        return (title == .calories || title == .walk || title == .water || title == .heart) ? 200 : 120
    }
    
    private func stringValue() -> String {
        if let intValue = value as? Int {
            return "\(intValue)"
        } else if let doubleValue = value as? Double {
            return String(format: "%.1f", doubleValue)
        } else {
            return ""
        }
    }
    
    private func progressValue() -> Double {
        if let intValue = value as? Int {
            let maxValue: Double = (title == .calories) ? 3000 : 10000
            return min(Double(intValue) / maxValue, 1.0)
        } else if let doubleValue = value as? Double, title == .walk {
            return min(doubleValue / 10000, 1.0)
        } else {
            return 0.0
        }
    }
    
    private var mainTitleAndIcon: some View{
        HStack {
            Image(systemName: icon)
                .foregroundColor(title == .calories || title == .walk ? .white : .black)
            Text(title.rawValue)
                .font(.headline)
                .foregroundColor(title == .calories || title == .walk ? .white : .black)
        }
    }
    
    
    private var valueAndUnit: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(stringValue())
                Text(unit)
            }
            Image(systemName: "sleep.circle.fill")
                .font(.largeTitle)
                .opacity(title == .sleep ? 1.0 : 0.0)
        }
    }
    
    private var waterHeartImage: some View {
        Image(title == .water ? "Water" : "Heart")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 50)
    }
}
